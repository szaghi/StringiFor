!< StringiFor, conversions between decimal and binary reals on 64 bit integers (internal module, not re-exported).
module stringifor_numbers
!< StringiFor, conversions between decimal and binary reals on 64 bit integers (internal module, not re-exported).
!<
!< Fortran has no unsigned integer, and a signed overflow is not allowed: the 64 bit words are handled as bit patterns,
!< and the arithmetic on them goes through 32 bit limbs that cannot overflow.
use penf, only : I4P, I8P, R4P, R8P
use stringifor_number_tables, only : POW5_TABLE

implicit none
private
public :: decimal_to_r4
public :: decimal_to_r8

integer(I8P), parameter :: LOW32 = 4294967295_I8P !< The low 32 bits.

contains
  elemental function decimal_to_r8(mantissa, exponent) result(number)
  !< Return the real nearest to mantissa * 10**exponent, ties to even (Eisel-Lemire). Mantissa not negative.
  integer(I8P), intent(in) :: mantissa !< Digits, as an integer.
  integer,      intent(in) :: exponent !< Decimal exponent.
  real(R8P)                :: number   !< The number.
  integer(I8P)             :: bits     !< Bits of the number.

  if (mantissa==0_I8P.or.exponent<-342) then
    bits = 0_I8P
  elseif (exponent>308) then
    bits = shiftl(2047_I8P, 52)
  else
    bits = eisel_lemire(mantissa, exponent, 52, 1023, 2047, -4, 23)
  endif
  number = transfer(bits, number)
  endfunction decimal_to_r8

  elemental function decimal_to_r4(mantissa, exponent) result(number)
  !< Return the real nearest to mantissa * 10**exponent, ties to even (Eisel-Lemire). Mantissa not negative.
  integer(I8P), intent(in) :: mantissa !< Digits, as an integer.
  integer,      intent(in) :: exponent !< Decimal exponent.
  real(R4P)                :: number   !< The number.
  integer(I8P)             :: bits     !< Bits of the number.

  if (mantissa==0_I8P.or.exponent<-65) then
    bits = 0_I8P
  elseif (exponent>38) then
    bits = shiftl(255_I8P, 23)
  else
    bits = eisel_lemire(mantissa, exponent, 23, 127, 255, -17, 10)
  endif
  number = transfer(int(bits, I4P), number)
  endfunction decimal_to_r4

  elemental function eisel_lemire(digits, q, mantissa_bits, bias, infinity, even_min, even_max) result(bits)
  !< Return the bits of the positive binary float nearest to digits * 10**q, of the format with those parameters.
  !<
  !< The 128 bits of the table are enough for every 64 bit `digits`, so this has no fallback (Mushtak, Lemire, Fast Number
  !< Parsing Without Fallback, 2023); the oracle checks it against exact arithmetic.
  integer(I8P), intent(in) :: digits        !< Decimal digits, not zero.
  integer,      intent(in) :: q             !< Decimal exponent, in the range of the table.
  integer,      intent(in) :: mantissa_bits !< Bits of the stored mantissa.
  integer,      intent(in) :: bias          !< Exponent bias.
  integer,      intent(in) :: infinity      !< Biased exponent of the infinity.
  integer,      intent(in) :: even_min      !< Lowest q where a product can be an exact tie.
  integer,      intent(in) :: even_max      !< Highest q where a product can be an exact tie.
  integer(I8P)             :: bits          !< The bits.
  integer(I8P)             :: w             !< Normalized digits.
  integer(I8P)             :: upper         !< High word of the product.
  integer(I8P)             :: lower         !< Low word of the product.
  integer(I8P)             :: upper2        !< High word of the second product.
  integer(I8P)             :: lower2        !< Low word of the second product.
  integer(I8P)             :: mantissa      !< Mantissa of the result.
  integer(I8P)             :: mask          !< The bits under the mantissa and the rounding bits.
  integer(I8P)             :: carry         !< Carry of an addition.
  integer                  :: lz            !< Leading zeros of the digits.
  integer                  :: top           !< Top bit of the product.
  integer                  :: power2        !< Biased binary exponent.
  integer                  :: shift         !< Shift of the product to the mantissa.

  lz = leadz(digits)
  w = shiftl(digits, lz)
  call multiply(w, POW5_TABLE(1, q), upper, lower)
  mask = shiftr(-1_I8P, mantissa_bits + 3)
  if (iand(upper, mask)==mask) then ! the low word of the power can change the rounding
    call multiply(w, POW5_TABLE(2, q), upper2, lower2)
    call add(lower, upper2, lower, carry)
    call add(upper, carry, upper, carry)
  endif
  top = int(shiftr(upper, 63))
  shift = top + 64 - mantissa_bits - 3
  mantissa = shiftr(upper, shift)
  power2 = shifta(217706 * q, 16) + 63 + top - lz + bias
  if (power2<=0) then ! subnormal, or zero
    if (1 - power2>=64) then
      bits = 0_I8P
      return
    endif
    mantissa = shiftr(mantissa, 1 - power2)
    mantissa = shiftr(mantissa + iand(mantissa, 1_I8P), 1)
    power2 = merge(0, 1, mantissa<shiftl(1_I8P, mantissa_bits))
    bits = ior(mantissa, shiftl(int(power2, I8P), mantissa_bits))
    return
  endif
  if ((lower==0_I8P.or.lower==1_I8P).and.q>=even_min.and.q<=even_max.and.iand(mantissa, 3_I8P)==1_I8P) then
    if (shiftl(mantissa, shift)==upper) mantissa = iand(mantissa, not(1_I8P)) ! an exact tie: to even
  endif
  mantissa = shiftr(mantissa + iand(mantissa, 1_I8P), 1)
  if (mantissa>=shiftl(2_I8P, mantissa_bits)) then
    mantissa = shiftl(1_I8P, mantissa_bits)
    power2 = power2 + 1
  endif
  mantissa = iand(mantissa, not(shiftl(1_I8P, mantissa_bits)))
  if (power2>=infinity) then
    power2 = infinity
    mantissa = 0_I8P
  endif
  bits = ior(mantissa, shiftl(int(power2, I8P), mantissa_bits))
  endfunction eisel_lemire

  elemental subroutine add(a, b, sum, carry)
  !< Add two words as unsigned integers.
  integer(I8P), intent(in)  :: a     !< First word.
  integer(I8P), intent(in)  :: b     !< Second word.
  integer(I8P), intent(out) :: sum   !< Low 64 bits of the sum.
  integer(I8P), intent(out) :: carry !< Carry, 0 or 1.
  integer(I8P)              :: low   !< Sum of the low limbs.
  integer(I8P)              :: high  !< Sum of the high limbs.

  low = iand(a, LOW32) + iand(b, LOW32)
  high = shiftr(a, 32) + shiftr(b, 32) + shiftr(low, 32)
  sum = ior(shiftl(high, 32), iand(low, LOW32))
  carry = shiftr(high, 32)
  endsubroutine add

  elemental subroutine multiply(a, b, high, low)
  !< Multiply two words as unsigned integers, 64 x 64 = 128 bits.
  integer(I8P), intent(in)  :: a    !< First word.
  integer(I8P), intent(in)  :: b    !< Second word.
  integer(I8P), intent(out) :: high !< High word.
  integer(I8P), intent(out) :: low  !< Low word.
  integer(I8P)              :: a0   !< Low limb of a.
  integer(I8P)              :: a1   !< High limb of a.
  integer(I8P)              :: b0   !< Low limb of b.
  integer(I8P)              :: b1   !< High limb of b.
  integer(I8P)              :: h00  !< High limb of a0*b0.
  integer(I8P)              :: l00  !< Low limb of a0*b0.
  integer(I8P)              :: h01  !< High limb of a0*b1.
  integer(I8P)              :: l01  !< Low limb of a0*b1.
  integer(I8P)              :: h10  !< High limb of a1*b0.
  integer(I8P)              :: l10  !< Low limb of a1*b0.
  integer(I8P)              :: h11  !< High limb of a1*b1.
  integer(I8P)              :: l11  !< Low limb of a1*b1.
  integer(I8P)              :: mid  !< Sum of the middle limbs.
  integer(I8P)              :: top  !< Sum of the upper limbs.

  a0 = iand(a, LOW32) ; a1 = shiftr(a, 32)
  b0 = iand(b, LOW32) ; b1 = shiftr(b, 32)
  call multiply32(a0, b0, h00, l00)
  call multiply32(a0, b1, h01, l01)
  call multiply32(a1, b0, h10, l10)
  call multiply32(a1, b1, h11, l11)
  mid = h00 + l01 + l10
  top = shiftr(mid, 32) + h01 + h10 + l11
  low = ior(shiftl(mid, 32), l00)
  high = ior(shiftl(shiftr(top, 32) + h11, 32), iand(top, LOW32))
  endsubroutine multiply

  elemental subroutine multiply32(a, b, high, low)
  !< Multiply two 32 bit limbs: a product of a limb and 16 bits fits in a signed word, a product of two limbs may not.
  integer(I8P), intent(in)  :: a      !< First limb.
  integer(I8P), intent(in)  :: b      !< Second limb.
  integer(I8P), intent(out) :: high   !< High limb.
  integer(I8P), intent(out) :: low    !< Low limb.
  integer(I8P)              :: part0  !< a times the low 16 bits of b.
  integer(I8P)              :: part1  !< a times the high 16 bits of b.
  integer(I8P)              :: sum    !< Low limb with its carry.

  part0 = a * iand(b, 65535_I8P)
  part1 = a * shiftr(b, 16)
  sum = iand(part0, LOW32) + shiftl(iand(part1, 65535_I8P), 16)
  low = iand(sum, LOW32)
  high = shiftr(part0, 32) + shiftr(part1, 16) + shiftr(sum, 32)
  endsubroutine multiply32
endmodule stringifor_numbers
