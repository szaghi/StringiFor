!< StringiFor, UTF-8 kernel: decoding, encoding and validation of raw bytes (internal module, not re-exported).
module stringifor_utf8
!< StringiFor, UTF-8 kernel: decoding, encoding and validation of raw bytes (internal module, not re-exported).
!<
!< A *unit* is either a well-formed UTF-8 sequence (Unicode Table 3-7: no overlong form, no surrogate, nothing above
!< U+10FFFF, no truncated sequence) or a single byte that is not part of one. Every procedure works on units, so
!< ill-formed input is never merged, dropped or rewritten unless a procedure says so.
use penf, only : I4P, I8P
use stringifor_unicode_tables, only : in_ranges, WHITE_SPACE_RANGES, WIDE_RANGES, ZERO_WIDTH_RANGES

implicit none
private
public :: REPLACEMENT_CHARACTER
public :: ascii_run
public :: is_ascii
public :: utf8_byte_pos
public :: utf8_char_pos
public :: utf8_decode
public :: utf8_encode
public :: utf8_encoded_len
public :: utf8_first_error
public :: utf8_in_set
public :: utf8_nth_unit
public :: utf8_unit_index
public :: utf8_scan
public :: utf8_space_len
public :: utf8_subpart_len
public :: utf8_unit_len
public :: utf8_units
public :: utf8_width
public :: utf8_unit_width
public :: utf8_white_space

integer(I8P),     parameter :: HIGH_BITS = -9187201950435737472_I8P !< 8080808080808080: the high bit of 8 bytes.
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
      i = ascii_run(raw, i) ! skip the ASCII bytes
      if (i > len(raw)) return
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
   integer                      :: j     !< End of a run of ASCII bytes.

   units = 0
   i = 1
   do while (i <= len(raw))
      j = ascii_run(raw, i) ! an ASCII byte is a unit
      units = units + j - i
      i = j
      if (i > len(raw)) return
      i = i + utf8_unit_len(raw, i)
      units = units + 1
   enddo
   endfunction utf8_units

   pure function utf8_unit_index(raw, i, n, set) result(k)
   !< Return the ordinal of the first unit of set equal to the unit raw(i:i+n-1), 0 if there is none.
   character(len=*), intent(in) :: raw !< Bytes.
   integer,          intent(in) :: i   !< Position of the unit.
   integer,          intent(in) :: n   !< Length of the unit.
   character(len=*), intent(in) :: set !< Set of units.
   integer                      :: k   !< Ordinal of the unit in the set, 0 if absent.
   integer                      :: j   !< Byte position in the set.
   integer                      :: m   !< Length of a unit of the set.
   integer                      :: u   !< Unit counter.

   k = 0
   u = 0
   j = 1
   do while (j <= len(set))
      u = u + 1
      m = 1
      if (byte(set(j:j)) > 127) m = utf8_unit_len(set, j)
      if (m == n) then
         if (set(j:j+m-1) == raw(i:i+n-1)) then
            k = u
            return
         endif
      endif
      j = j + m
   enddo
   endfunction utf8_unit_index

   pure subroutine utf8_nth_unit(set, k, first, n)
   !< Return the position and the length of the k-th unit of set (of its last unit if it has less than k), n=0 if the
   !< set is empty.
   character(len=*), intent(in)  :: set   !< Set of units.
   integer,          intent(in)  :: k     !< Ordinal of the unit.
   integer,          intent(out) :: first !< Position of its first byte.
   integer,          intent(out) :: n     !< Its length, 0 if the set is empty.
   integer                       :: j     !< Byte position in the set.
   integer                       :: u     !< Unit counter.

   first = 1
   n = 0
   u = 0
   j = 1
   do while (j <= len(set) .and. u < k)
      u = u + 1
      first = j
      n = 1
      if (byte(set(j:j)) > 127) n = utf8_unit_len(set, j)
      j = j + n
   enddo
   endsubroutine utf8_nth_unit

   pure function utf8_in_set(raw, i, n, set) result(found)
   !< Return true if the unit raw(i:i+n-1) is one of the units of set.
   character(len=*), intent(in) :: raw   !< Bytes.
   integer,          intent(in) :: i     !< Position of the unit.
   integer,          intent(in) :: n     !< Length of the unit.
   character(len=*), intent(in) :: set   !< Set of units.
   logical                      :: found !< Result.
   integer                      :: j     !< Byte position in the set.
   integer                      :: m     !< Length of a unit of the set.

   found = .false.
   j = 1
   do while (j <= len(set))
      m = 1
      if (byte(set(j:j)) > 127) m = utf8_unit_len(set, j)
      if (m == n) then
         if (set(j:j+m-1) == raw(i:i+n-1)) then
            found = .true.
            return
         endif
      endif
      j = j + m
   enddo
   endfunction utf8_in_set

   pure function utf8_scan(raw, set, back, inside) result(position)
   !< Return the byte position of the first (last if back) unit that is in the set (not in the set if .not.inside),
   !< 0 if there is none: `scan` (inside) and `verify` (not inside) by units.
   !<
   !< With an ASCII set the intrinsic gives the answer, except a backward `verify` landing on a non-ASCII byte.
   character(len=*), intent(in)           :: raw      !< Bytes.
   character(len=*), intent(in)           :: set      !< Set of units.
   logical,          intent(in), optional :: back     !< Search from the end.
   logical,          intent(in)           :: inside   !< Search a unit in the set (scan) or not in the set (verify).
   integer                                :: position !< Position of the first byte of the unit found, 0 if none.
   logical                                :: back_    !< Search from the end, local variable.
   integer                                :: i        !< Byte position.
   integer                                :: n        !< Unit length.

   back_ = .false. ; if (present(back)) back_ = back
   if (is_ascii(set)) then
      if (inside) then
         position = scan(raw, set, back_)
         return
      endif
      position = verify(raw, set, back_)
      if (position == 0 .or. .not.back_) return ! forward: a unit start, all the bytes before being ASCII
      if (byte(raw(position:position)) < 128) return
   endif
   position = 0
   i = 1
   do while (i <= len(raw))
      n = 1
      if (byte(raw(i:i)) > 127) n = utf8_unit_len(raw, i)
      if (utf8_in_set(raw, i, n, set) .eqv. inside) then
         position = i
         if (.not.back_) return
      endif
      i = i + n
   enddo
   endfunction utf8_scan

   pure function utf8_unit_width(codepoint) result(columns)
   !< Return the display width, in terminal columns, of a unit given its codepoint (-byte for an ill-formed byte).
   !<
   !< 0 for the C0 and C1 controls and DEL, and for the zero-width characters (Mn, Me, Cf except U+00AD, the Hangul
   !< jamo medial vowels and final consonants); 2 for East_Asian_Width W and F; 1 otherwise, an ill-formed byte included.
   integer(I4P), intent(in) :: codepoint !< Codepoint, or -byte.
   integer                  :: columns   !< Display width.

   columns = 1
   if (codepoint < 0) return
   if (codepoint < 32 .or. (codepoint >= 127 .and. codepoint < 160)) then
      columns = 0
   elseif (codepoint < 768) then ! below U+0300 nothing is zero-width nor wide but U+00AD (one column)
      columns = 1
   elseif (in_ranges(codepoint, ZERO_WIDTH_RANGES)) then
      columns = 0
   elseif (in_ranges(codepoint, WIDE_RANGES)) then
      columns = 2
   endif
   endfunction utf8_unit_width

   pure function utf8_width(raw) result(columns)
   !< Return the display width of the bytes, in terminal columns: the sum of the widths of their units.
   character(len=*), intent(in) :: raw     !< Bytes.
   integer                      :: columns !< Display width.
   integer                      :: i       !< Byte position.
   integer                      :: j       !< End of a run of ASCII bytes.
   integer                      :: k       !< Byte counter.
   integer                      :: n       !< Unit length.
   integer(I4P)                 :: cp      !< Codepoint of a unit.

   columns = 0
   i = 1
   do while (i <= len(raw))
      j = ascii_run(raw, i)
      do k = i, j - 1 ! ASCII: one column, none for the controls
         if (byte(raw(k:k)) >= 32 .and. byte(raw(k:k)) /= 127) columns = columns + 1
      enddo
      i = j
      if (i > len(raw)) exit
      call utf8_decode(raw, i, cp, n)
      columns = columns + utf8_unit_width(cp)
      i = i + n
   enddo
   endfunction utf8_width

   pure function utf8_space_len(raw, i) result(n)
   !< Return the length in bytes of the unit starting at byte i if it has the Unicode White_Space property, 0 if not.
   !<
   !< White_Space (PropList.txt) is TAB, LF, VT, FF, CR, space, U+0085, U+00A0, U+1680, U+2000..U+200A, U+2028,
   !< U+2029, U+202F, U+205F and U+3000. An ill-formed byte is not whitespace.
   character(len=*), intent(in) :: raw !< Bytes.
   integer,          intent(in) :: i   !< Position of the first byte, 1 <= i <= len(raw).
   integer                      :: n   !< Length of the whitespace unit, 0 if the unit is not whitespace.
   integer(I4P)                 :: cp  !< Codepoint of the unit.

   n = 0
   select case (byte(raw(i:i)))
   case (9:13, 32)
      n = 1
   case (128:)
      call utf8_decode(raw, i, cp, n)
      if (cp < 0) then
         n = 0
      elseif (.not.in_ranges(cp, WHITE_SPACE_RANGES)) then
         n = 0
      endif
   endselect
   endfunction utf8_space_len

   pure function utf8_white_space() result(units)
   !< Return every character with the Unicode White_Space property, encoded in UTF-8 one after the other.
   character(len=:), allocatable :: units !< The whitespace characters.
   integer                       :: r     !< Range counter.
   integer(I4P)                  :: cp    !< Codepoint.

   units = ''
   do r = 1, size(WHITE_SPACE_RANGES, dim=2)
      do cp = WHITE_SPACE_RANGES(1, r), WHITE_SPACE_RANGES(2, r)
         units = units//utf8_encode(cp)
      enddo
   enddo
   endfunction utf8_white_space

   pure function utf8_byte_pos(raw, k) result(position)
   !< Return the byte position of the first byte of the k-th unit, len(raw)+1 for k one past the last unit, 0 for any
   !< other k out of range.
   character(len=*), intent(in) :: raw      !< Bytes.
   integer,          intent(in) :: k        !< Ordinal of the unit.
   integer                      :: position !< Byte position.
   integer                      :: i        !< Byte position.
   integer                      :: j        !< End of a run of ASCII bytes.
   integer                      :: u        !< Units before byte i.

   position = 0
   if (k < 1) return
   u = 0
   i = 1
   do while (i <= len(raw))
      j = ascii_run(raw, i) ! the ASCII bytes i..j-1 are the units u+1..u+j-i
      if (k <= u + j - i) then
         position = i + k - u - 1
         return
      endif
      u = u + j - i
      i = j
      if (i > len(raw)) exit
      u = u + 1
      if (u == k) then
         position = i
         return
      endif
      i = i + utf8_unit_len(raw, i)
   enddo
   if (k == u + 1) position = len(raw) + 1
   endfunction utf8_byte_pos

   pure function utf8_char_pos(raw, b) result(k)
   !< Return the ordinal of the unit holding byte b, the number of units + 1 for b = len(raw)+1, 0 for any other b out
   !< of range.
   character(len=*), intent(in) :: raw !< Bytes.
   integer,          intent(in) :: b   !< Byte position.
   integer                      :: k   !< Ordinal of the unit.
   integer                      :: i   !< Byte position.
   integer                      :: j   !< End of a run of ASCII bytes.
   integer                      :: n   !< Unit length.

   k = 0
   if (b < 1 .or. b > len(raw) + 1) return
   i = 1
   do while (i <= len(raw))
      j = ascii_run(raw, i)
      if (b < j) then
         k = k + b - i + 1
         return
      endif
      k = k + j - i
      i = j
      if (i > len(raw)) exit
      n = utf8_unit_len(raw, i)
      k = k + 1
      if (b < i + n) return
      i = i + n
   enddo
   k = k + 1 ! b = len(raw) + 1
   endfunction utf8_char_pos

   pure function ascii_run(raw, i) result(j)
   !< Return the position of the first non-ASCII byte at or after byte i, len(raw)+1 if there is none.
   !<
   !< Eight bytes are tested at a time, their high bits masked in one 64-bit integer.
   character(len=*), intent(in) :: raw !< Bytes.
   integer,          intent(in) :: i   !< First byte tested.
   integer                      :: j   !< Position of the first non-ASCII byte.

   j = i
   do while (j + 7 <= len(raw))
      if (iand(transfer(raw(j:j+7), 0_I8P), HIGH_BITS) /= 0_I8P) exit
      j = j + 8
   enddo
   do while (j <= len(raw))
      if (byte(raw(j:j)) > 127) return
      j = j + 1
   enddo
   endfunction ascii_run

   pure function is_ascii(text) result(ascii)
   !< Return true if every byte of text is ASCII.
   character(len=*), intent(in) :: text  !< Bytes.
   logical                      :: ascii !< Result.

   ascii = ascii_run(text, 1) > len(text)
   endfunction is_ascii

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
