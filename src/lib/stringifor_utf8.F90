!< StringiFor, UTF-8 kernel: decoding, encoding and validation of raw bytes (internal module, not re-exported).
module stringifor_utf8
!< StringiFor, UTF-8 kernel: decoding, encoding and validation of raw bytes (internal module, not re-exported).
!<
!< A *unit* is either a well-formed UTF-8 sequence (Unicode Table 3-7: no overlong form, no surrogate, nothing above
!< U+10FFFF, no truncated sequence) or a single byte that is not part of one. Every procedure works on units, so
!< ill-formed input is never merged, dropped or rewritten unless a procedure says so.
use penf, only : I4P

implicit none
private
public :: REPLACEMENT_CHARACTER
public :: utf8_decode
public :: utf8_encode
public :: utf8_encoded_len
public :: utf8_first_error
public :: utf8_subpart_len
public :: utf8_unit_len
public :: utf8_units

character(len=*), parameter :: REPLACEMENT_CHARACTER = char(239)//char(191)//char(189) !< U+FFFD in UTF-8.

contains
   pure function utf8_unit_len(raw, i) result(n)
   !< Return the length in bytes of the unit starting at byte i: 2, 3 or 4 for a well-formed multibyte sequence, 1
   !< for an ASCII byte or a byte that does not start a well-formed sequence.
   character(len=*), intent(in) :: raw !< Bytes.
   integer,          intent(in) :: i   !< Position of the first byte, 1 <= i <= len(raw).
   integer                      :: n   !< Length of the unit.

   n = utf8_subpart_len(raw, i)
   if (n > 1) then
      if (n /= expected_len(byte(raw(i:i)))) n = 1 ! a truncated sequence: its first byte is a unit alone
   endif
   endfunction utf8_unit_len

   pure function utf8_subpart_len(raw, i) result(n)
   !< Return the length of the maximal subpart starting at byte i: the longest prefix of a well-formed sequence found
   !< there (Unicode 3.9, U+FFFD substitution of maximal subparts), at least 1. It is the unit length when the sequence
   !< is complete; a truncated sequence gives its valid prefix, replaced by one U+FFFD as a whole.
   character(len=*), intent(in) :: raw   !< Bytes.
   integer,          intent(in) :: i     !< Position of the first byte, 1 <= i <= len(raw).
   integer                      :: n     !< Length of the maximal subpart.
   integer                      :: lead  !< First byte.
   integer                      :: need  !< Length of the sequence the first byte starts.
   integer                      :: low   !< Lowest valid value of the second byte.
   integer                      :: high  !< Highest valid value of the second byte.
   integer                      :: b     !< Current byte.

   n = 1
   lead = byte(raw(i:i))
   need = expected_len(lead)
   if (need < 2) return
   ! valid range of the second byte (Table 3-7); the following ones are always 80..BF
   select case (lead)
   case (224)  ! E0
      low = 160 ; high = 191
   case (237)  ! ED
      low = 128 ; high = 159
   case (240)  ! F0
      low = 144 ; high = 191
   case (244)  ! F4
      low = 128 ; high = 143
   case default
      low = 128 ; high = 191
   endselect
   if (i + 1 > len(raw)) return
   b = byte(raw(i + 1:i + 1))
   if (b < low .or. b > high) return
   n = 2
   do while (n < need)
      if (i + n > len(raw)) return
      b = byte(raw(i + n:i + n))
      if (b < 128 .or. b > 191) return
      n = n + 1
   enddo
   endfunction utf8_subpart_len

   pure subroutine utf8_decode(raw, i, codepoint, n)
   !< Decode the unit starting at byte i: its codepoint, or minus the byte value for an ill-formed byte, and its length.
   character(len=*), intent(in)  :: raw       !< Bytes.
   integer,          intent(in)  :: i         !< Position of the first byte, 1 <= i <= len(raw).
   integer(I4P),     intent(out) :: codepoint !< Codepoint, or -byte (-255..-128) for an ill-formed byte.
   integer,          intent(out) :: n         !< Length of the unit in bytes.
   integer                       :: k         !< Counter.

   n = utf8_unit_len(raw, i)
   codepoint = byte(raw(i:i))
   select case (n)
   case (1)
      if (codepoint > 127) codepoint = -codepoint
   case (2)
      codepoint = iand(codepoint, 31)
   case (3)
      codepoint = iand(codepoint, 15)
   case (4)
      codepoint = iand(codepoint, 7)
   endselect
   do k = 1, n - 1
      codepoint = ior(ishft(codepoint, 6), iand(byte(raw(i + k:i + k)), 63))
   enddo
   endsubroutine utf8_decode

   pure function utf8_encoded_len(codepoint) result(n)
   !< Return the length of the UTF-8 encoding of a codepoint, 1 for an ill-formed byte (-255..-128), 3 (the length of
   !< U+FFFD) for any other value that is not a Unicode scalar value.
   integer(I4P), intent(in) :: codepoint !< Codepoint.
   integer                  :: n         !< Length in bytes.

   select case (codepoint)
   case (-255:-128, 0:127)
      n = 1
   case (128:2047)
      n = 2
   case (65536:1114111)
      n = 4
   case default ! 2048..65535 (surrogates encode as U+FFFD, also 3 bytes) and the invalid values (U+FFFD)
      n = 3
   endselect
   endfunction utf8_encoded_len

   pure function utf8_encode(codepoint) result(bytes)
   !< Return the UTF-8 encoding of a codepoint: the raw byte for -255..-128 (the ill-formed bytes of `utf8_decode`),
   !< U+FFFD for any other value that is not a Unicode scalar value.
   integer(I4P), intent(in)                    :: codepoint !< Codepoint.
   character(len=utf8_encoded_len(codepoint)) :: bytes     !< Encoding.

   select case (codepoint)
   case (-255:-128)
      bytes = char(-codepoint)
   case (0:127)
      bytes = char(codepoint)
   case (128:2047)
      bytes = char(ior(192, ishft(codepoint, -6)))//char(ior(128, iand(codepoint, 63)))
   case (2048:55295, 57344:65535)
      bytes = char(ior(224, ishft(codepoint, -12)))//char(ior(128, iand(ishft(codepoint, -6), 63)))// &
              char(ior(128, iand(codepoint, 63)))
   case (65536:1114111)
      bytes = char(ior(240, ishft(codepoint, -18)))//char(ior(128, iand(ishft(codepoint, -12), 63)))// &
              char(ior(128, iand(ishft(codepoint, -6), 63)))//char(ior(128, iand(codepoint, 63)))
   case default
      bytes = REPLACEMENT_CHARACTER
   endselect
   endfunction utf8_encode

   pure function utf8_first_error(raw) result(position)
   !< Return the byte position of the first byte that is not part of a well-formed sequence, 0 if there is none.
   character(len=*), intent(in) :: raw      !< Bytes.
   integer                      :: position !< Position of the first ill-formed byte, 0 if none.
   integer                      :: i        !< Byte position.
   integer                      :: n        !< Unit length.

   position = 0
   i = 1
   do while (i <= len(raw))
      if (byte(raw(i:i)) < 128) then ! ASCII fast path
         i = i + 1
         cycle
      endif
      n = utf8_unit_len(raw, i)
      if (n == 1) then
         position = i
         return
      endif
      i = i + n
   enddo
   endfunction utf8_first_error

   pure function utf8_units(raw) result(units)
   !< Return the number of units of the bytes.
   character(len=*), intent(in) :: raw   !< Bytes.
   integer                      :: units !< Number of units.
   integer                      :: i     !< Byte position.

   units = 0
   i = 1
   do while (i <= len(raw))
      if (byte(raw(i:i)) < 128) then
         i = i + 1
      else
         i = i + utf8_unit_len(raw, i)
      endif
      units = units + 1
   enddo
   endfunction utf8_units

   ! private
   elemental function byte(c) result(value)
   !< Return the value 0..255 of a byte (`ichar` may be signed above 127 on some processors).
   character(len=1), intent(in) :: c     !< Byte.
   integer                      :: value !< Value.

   value = iand(ichar(c), 255)
   endfunction byte

   pure function expected_len(lead) result(n)
   !< Return the length of the sequence a first byte starts: 1 for ASCII, 2..4 for a valid lead byte, 0 for a byte that
   !< cannot start a well-formed sequence (80..C1, F5..FF).
   integer, intent(in) :: lead !< First byte value.
   integer             :: n    !< Sequence length.

   select case (lead)
   case (0:127)
      n = 1
   case (194:223)
      n = 2
   case (224:239)
      n = 3
   case (240:244)
      n = 4
   case default
      n = 0
   endselect
   endfunction expected_len
endmodule stringifor_utf8
