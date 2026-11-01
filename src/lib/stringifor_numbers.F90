!< StringiFor, conversions between decimal and binary reals on 64 bit integers (internal module, not re-exported).
module stringifor_numbers
!< StringiFor, conversions between decimal and binary reals on 64 bit integers (internal module, not re-exported).
!<
!< Fortran has no unsigned integer, and a signed overflow is not allowed: the 64 bit words are handled as bit patterns,
!< and the arithmetic on them goes through 32 bit limbs that cannot overflow.
use penf, only : I4P, I8P, R4P, R8P
use stringifor_number_tables, only : POW10_TABLE, POW5_TABLE

implicit none
private
public :: decimal_to_r4
public :: decimal_to_r8
public :: settle_r4
public :: settle_r8
public :: shortest_digits

integer(I8P), parameter :: LOW32 = 4294967295_I8P !< The low 32 bits.
integer(I8P), parameter :: LIMB = 1000000000_I8P  !< Base of the big integers of the exact comparison.

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

  elemental function settle_r8(raw, exponent, low) result(number)
  !< Return the real nearest to a number of more than 18 digits, when its first 18 digits leave two candidates.
  !<
  !< See [[settle]]. `raw` is a number accepted by the parser, `exponent` its exponent for the first 18 digits, `low` the
  !< real nearest to those 18 digits, the lower candidate.
  character(len=*), intent(in) :: raw      !< The number, as text.
  integer,          intent(in) :: exponent !< Decimal exponent of the first 18 digits.
  real(R8P),        intent(in) :: low      !< The lower candidate.
  real(R8P)                    :: number   !< The number.

  number = transfer(settle(raw, exponent, transfer(low, 1_I8P), 52, 1023), number)
  endfunction settle_r8

  elemental function settle_r4(raw, exponent, low) result(number)
  !< Return the real nearest to a number of more than 18 digits, when its first 18 digits leave two candidates.
  !<
  !< See [[settle]] and [[settle_r8]].
  character(len=*), intent(in) :: raw      !< The number, as text.
  integer,          intent(in) :: exponent !< Decimal exponent of the first 18 digits.
  real(R4P),        intent(in) :: low      !< The lower candidate.
  real(R4P)                    :: number   !< The number.

  number = transfer(int(settle(raw, exponent, int(transfer(low, 1_I4P), I8P), 23, 127), I4P), number)
  endfunction settle_r4

  pure function settle(raw, exponent, low, mantissa_bits, bias) result(bits)
  !< Return the bits of `low` or of the next float, comparing all the digits with the midpoint of the two, exactly.
  !<
  !< The digits D, times 10**q, against the midpoint (2m + 1) * 2**p: each side takes the factors that would be negative
  !< powers on the other, so both are integers. In base 10**9 a power of ten is mostly a shift of limbs, so the cost is
  !< linear in the digits.
  character(len=*), intent(in) :: raw           !< The number, as text.
  integer,          intent(in) :: exponent      !< Decimal exponent of the first 18 digits.
  integer(I8P),     intent(in) :: low           !< Bits of the lower candidate, sign clear.
  integer,          intent(in) :: mantissa_bits !< Bits of the stored mantissa.
  integer,          intent(in) :: bias          !< Exponent bias.
  integer(I8P)                 :: bits          !< The bits of the number.
  character(len=len(raw))      :: digits        !< Significant digits.
  integer(I8P), allocatable    :: left(:)       !< D * 10**max(q, 0) * 2**max(-p, 0).
  integer(I8P), allocatable    :: right(:)      !< (2m + 1) * 10**max(-q, 0) * 2**max(p, 0).
  integer(I8P)                 :: m             !< Integer mantissa of the lower candidate.
  integer                      :: n             !< Number of digits.
  integer                      :: q             !< Decimal exponent of all the digits.
  integer                      :: p             !< Binary exponent of the midpoint.
  integer                      :: biased        !< Biased exponent of the lower candidate.
  integer                      :: size_         !< Limbs of the big integers.
  integer                      :: order         !< Sign of left - right.

  call significant_digits(raw, digits, n)
  q = exponent - (n - 18)
  m = ibits(low, 0, mantissa_bits)
  biased = int(shiftr(low, mantissa_bits))
  if (biased==0) then
    p = 1 - bias - mantissa_bits - 1
  else
    m = ior(m, shiftl(1_I8P, mantissa_bits))
    p = biased - bias - mantissa_bits - 1
  endif
  size_ = (n + abs(q) + 400) / 9 + 4
  allocate(left(size_), right(size_))
  call load_digits(digits(1:n), left)
  call shift_decimal(left, max(q, 0))
  call shift_binary(left, max(-p, 0))
  right = 0_I8P
  right(1) = mod(2_I8P * m + 1_I8P, LIMB)
  right(2) = (2_I8P * m + 1_I8P) / LIMB
  call shift_decimal(right, max(-q, 0))
  call shift_binary(right, max(p, 0))
  order = compare(left, right)
  bits = low
  if (order>0.or.(order==0.and.iand(low, 1_I8P)==1_I8P)) bits = low + 1_I8P ! above, or a tie to even
  endfunction settle

  pure subroutine significant_digits(raw, digits, n)
  !< Return the digits of the mantissa of a number, without the leading zeros and the point.
  character(len=*), intent(in)  :: raw    !< The number, as text.
  character(len=*), intent(out) :: digits !< The digits.
  integer,          intent(out) :: n      !< Number of digits.
  integer                       :: c      !< Counter.

  n = 0
  do c=1, len(raw)
    select case(raw(c:c))
    case('0':'9')
      if (n>0.or.raw(c:c)/='0') then
        n = n + 1
        digits(n:n) = raw(c:c)
      endif
    case(' ', achar(9), '+', '.')
      if (n>0.and.raw(c:c)/='.') exit
    case('-')
      if (n>0) exit
    case default
      exit
    endselect
  enddo
  endsubroutine significant_digits

  pure subroutine load_digits(digits, big)
  !< Load decimal digits in a big integer, 9 digits per limb from the last.
  character(len=*), intent(in)  :: digits !< The digits.
  integer(I8P),     intent(out) :: big(:) !< The big integer, low limb first.
  integer                       :: last   !< Last digit of a limb.
  integer                       :: l      !< Limb counter.
  integer                       :: c      !< Digit counter.

  big = 0_I8P
  last = len(digits)
  l = 1
  do while (last>0)
    do c=max(1, last - 8), last
      big(l) = big(l) * 10_I8P + (iachar(digits(c:c)) - iachar('0'))
    enddo
    last = last - 9
    l = l + 1
  enddo
  endsubroutine load_digits

  pure subroutine shift_decimal(big, power)
  !< Multiply a big integer by 10**power.
  integer(I8P), intent(inout) :: big(:) !< The big integer.
  integer,      intent(in)    :: power  !< The power.
  integer                     :: limbs  !< Whole limbs of the shift.

  limbs = power / 9
  if (limbs>0) then
    big(limbs+1:size(big)) = big(1:size(big)-limbs)
    big(1:limbs) = 0_I8P
  endif
  call multiply_small(big, 10_I8P**mod(power, 9))
  endsubroutine shift_decimal

  pure subroutine shift_binary(big, power)
  !< Multiply a big integer by 2**power.
  integer(I8P), intent(inout) :: big(:) !< The big integer.
  integer,      intent(in)    :: power  !< The power.
  integer                     :: left   !< Power left.

  left = power
  do while (left>0)
    call multiply_small(big, shiftl(1_I8P, min(left, 29)))
    left = left - min(left, 29)
  enddo
  endsubroutine shift_binary

  pure subroutine multiply_small(big, factor)
  !< Multiply a big integer by a factor of at most 10**9: a limb times the factor stays far from the signed limit.
  integer(I8P), intent(inout) :: big(:) !< The big integer.
  integer(I8P), intent(in)    :: factor !< The factor.
  integer(I8P)                :: carry  !< The carry.
  integer(I8P)                :: value  !< A limb times the factor.
  integer                     :: l      !< Counter.

  if (factor==1_I8P) return
  carry = 0_I8P
  do l=1, size(big)
    value = big(l) * factor + carry
    big(l) = mod(value, LIMB)
    carry = value / LIMB
  enddo
  endsubroutine multiply_small

  pure function compare(a, b) result(order)
  !< Return the sign of a - b, two big integers of the same size.
  integer(I8P), intent(in) :: a(:)  !< First big integer.
  integer(I8P), intent(in) :: b(:)  !< Second big integer.
  integer                  :: order !< -1, 0 or 1.
  integer                  :: l     !< Counter.

  order = 0
  do l=size(a), 1, -1
    if (a(l)/=b(l)) then
      order = merge(1, -1, a(l)>b(l))
      return
    endif
  enddo
  endfunction compare

  elemental subroutine shortest_digits(fraction, biased, mantissa_bits, digits, exponent)
  !< Return the shortest decimal digits * 10**exponent that reads back as the binary float, the closest of them if more
  !< than one (Schubfach: Giulietti, The Schubfach way to render doubles, 2020). Finite and not zero; no trailing zeros.
  !<
  !< The float is given by its fields, so one kernel serves R4P and R8P: every step only relies on the 128 bits of the power.
  integer(I8P), intent(in)  :: fraction      !< Stored mantissa.
  integer,      intent(in)  :: biased        !< Biased exponent.
  integer,      intent(in)  :: mantissa_bits !< Bits of the stored mantissa.
  integer(I8P), intent(out) :: digits        !< Decimal digits.
  integer,      intent(out) :: exponent      !< Decimal exponent.
  integer(I8P)              :: c             !< Integer significand.
  integer(I8P)              :: cbl           !< 4 c of the lower bound of the rounding interval.
  integer(I8P)              :: cb            !< 4 c.
  integer(I8P)              :: cbr           !< 4 c of the upper bound of the rounding interval.
  integer(I8P)              :: vbl           !< Lower bound, scaled.
  integer(I8P)              :: vb            !< The number, scaled.
  integer(I8P)              :: vbr           !< Upper bound, scaled.
  integer(I8P)              :: lower         !< First value inside the interval.
  integer(I8P)              :: upper         !< Last value inside the interval.
  integer(I8P)              :: s             !< Candidate at the scale of 10**k.
  integer(I8P)              :: sp            !< Candidate at the scale of 10**(k+1).
  integer                   :: q             !< Binary exponent.
  integer                   :: k             !< Decimal scale.
  integer                   :: h             !< Shift of the bounds.
  logical                   :: closer        !< The lower bound is closer, at a power of 2.
  logical                   :: even          !< The bounds read back as the number.
  logical                   :: u_inside      !< The candidate below is inside.
  logical                   :: w_inside      !< The candidate above is inside.

  if (biased/=0) then
    c = ior(shiftl(1_I8P, mantissa_bits), fraction)
    q = biased - (2**(BIAS_BITS(mantissa_bits) - 1) - 1) - mantissa_bits
    if (q<=0.and.q>-mantissa_bits - 1) then ! a small integer: exactly itself
      if (iand(c, shiftl(1_I8P, -q) - 1_I8P)==0_I8P) then
        digits = shiftr(c, -q)
        exponent = 0
        call strip_zeros(digits, exponent)
        return
      endif
    endif
  else
    c = fraction
    q = 1 - (2**(BIAS_BITS(mantissa_bits) - 1) - 1) - mantissa_bits
  endif
  even = iand(c, 1_I8P)==0_I8P
  closer = fraction==0_I8P.and.biased>1
  cbl = 4 * c - 2 + merge(1_I8P, 0_I8P, closer)
  cb = 4 * c
  cbr = 4 * c + 2
  k = floor_shift(q * 1262611 - merge(524031, 0, closer), 22)
  h = q + floor_shift(-k * 1741647, 19) + 1
  vbl = round_to_odd(POW10_TABLE(1, -k), POW10_TABLE(2, -k), shiftl(cbl, h))
  vb = round_to_odd(POW10_TABLE(1, -k), POW10_TABLE(2, -k), shiftl(cb, h))
  vbr = round_to_odd(POW10_TABLE(1, -k), POW10_TABLE(2, -k), shiftl(cbr, h))
  lower = vbl + merge(0_I8P, 1_I8P, even)
  upper = vbr - merge(0_I8P, 1_I8P, even)
  s = vb / 4_I8P
  if (s>=10_I8P) then
    sp = s / 10_I8P
    u_inside = lower<=40_I8P * sp
    w_inside = 40_I8P * sp + 40_I8P<=upper
    if (u_inside.neqv.w_inside) then
      digits = sp + merge(1_I8P, 0_I8P, w_inside)
      exponent = k + 1
      call strip_zeros(digits, exponent)
      return
    endif
  endif
  u_inside = lower<=4_I8P * s
  w_inside = 4_I8P * s + 4_I8P<=upper
  if (u_inside.neqv.w_inside) then
    digits = s + merge(1_I8P, 0_I8P, w_inside)
  elseif (vb>4_I8P * s + 2_I8P.or.(vb==4_I8P * s + 2_I8P.and.iand(s, 1_I8P)/=0_I8P)) then
    digits = s + 1_I8P
  else
    digits = s
  endif
  exponent = k
  call strip_zeros(digits, exponent)
  endsubroutine shortest_digits

  elemental function floor_shift(value, bits) result(shifted)
  !< Return floor(value / 2**bits): nvfortran has no SHIFTA, and a right shift of a negative number needs the floor.
  integer, intent(in) :: value   !< The value.
  integer, intent(in) :: bits    !< The bits of the shift.
  integer             :: shifted !< The result.

  shifted = (value - modulo(value, 2**bits)) / 2**bits
  endfunction floor_shift

  elemental function BIAS_BITS(mantissa_bits) result(bits)
  !< Return the bits of the exponent field of a format.
  integer, intent(in) :: mantissa_bits !< Bits of the stored mantissa.
  integer             :: bits          !< Bits of the exponent.

  bits = merge(11, 8, mantissa_bits==52)
  endfunction BIAS_BITS

  elemental subroutine strip_zeros(digits, exponent)
  !< Move the trailing zeros of the digits to the exponent.
  integer(I8P), intent(inout) :: digits   !< Decimal digits, not zero.
  integer,      intent(inout) :: exponent !< Decimal exponent.

  do while (mod(digits, 10_I8P)==0_I8P)
    digits = digits / 10_I8P
    exponent = exponent + 1
  enddo
  endsubroutine strip_zeros

  elemental function round_to_odd(g_high, g_low, cp) result(rounded)
  !< Return the high word of g * cp (g of 128 bits) with its lowest bit set if any bit below is set.
  integer(I8P), intent(in) :: g_high  !< High word of g.
  integer(I8P), intent(in) :: g_low   !< Low word of g.
  integer(I8P), intent(in) :: cp      !< The multiplier.
  integer(I8P)             :: rounded !< Result.
  integer(I8P)             :: x_high  !< High word of g_low * cp.
  integer(I8P)             :: x_low   !< Low word of g_low * cp.
  integer(I8P)             :: y_high  !< High word of g_high * cp.
  integer(I8P)             :: y_low   !< Low word of g_high * cp.
  integer(I8P)             :: carry   !< Carry.

  call multiply(g_low, cp, x_high, x_low)
  call multiply(g_high, cp, y_high, y_low)
  call add(y_low, x_high, y_low, carry)
  call add(y_high, carry, y_high, carry)
  rounded = y_high
  if (ior(shiftr(y_low, 1), 0_I8P)/=0_I8P) rounded = ior(rounded, 1_I8P)
  endfunction round_to_odd

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
  power2 = floor_shift(217706 * q, 16) + 63 + top - lz + bias
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
