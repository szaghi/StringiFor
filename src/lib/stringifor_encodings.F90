!< StringiFor, text encodings: byte order marks, encoding names and conversion to UTF-8.
module stringifor_encodings
!< StringiFor, text encodings: byte order marks, encoding names and conversion to UTF-8.
!<
!< StringiFor works on UTF-8. Text in another encoding is converted on input by [[to_utf8]], which reads it in pieces
!< (an incomplete character at the end of a piece is carried to the next one), so a file can be converted in chunks.
!< The supported encodings are UTF-8, US-ASCII, ISO-8859-1 (Latin-1), windows-1252, UTF-16 and UTF-32 (little or big
!< endian); [[canonical_encoding]] folds their IANA names and aliases. [[bom_encoding]] and [[bom_length]] read a byte
!< order mark. An invalid sequence becomes a replacement (U+FFFD by default) and is reported by its position, as Python
!< `bytes.decode(encoding, errors='replace')` does.
use penf, only : I4P
use stringifor_utf8, only : REPLACEMENT_CHARACTER, ascii_run, utf8_encode

implicit none
private
public :: bom_encoding
public :: bom_length
public :: canonical_encoding
public :: to_utf8

integer, parameter :: ENC_UNKNOWN  = 0 !< Not supported.
integer, parameter :: ENC_UTF8     = 1 !< UTF-8.
integer, parameter :: ENC_ASCII    = 2 !< US-ASCII.
integer, parameter :: ENC_LATIN1   = 3 !< ISO-8859-1.
integer, parameter :: ENC_CP1252   = 4 !< windows-1252.
integer, parameter :: ENC_UTF16LE  = 5 !< UTF-16, little endian.
integer, parameter :: ENC_UTF16BE  = 6 !< UTF-16, big endian.
integer, parameter :: ENC_UTF32LE  = 7 !< UTF-32, little endian.
integer, parameter :: ENC_UTF32BE  = 8 !< UTF-32, big endian.
integer, parameter :: UNDEFINED    = -1 !< A windows-1252 byte without a character.
integer, parameter :: CP1252_HIGH(128:159) = [ &                                     !< windows-1252 0x80..0x9F.
   8364, UNDEFINED, 8218, 402, 8222, 8230, 8224, 8225, 710, 8240, 352, 8249, 338, UNDEFINED, 381, UNDEFINED, &
   UNDEFINED, 8216, 8217, 8220, 8221, 8226, 8211, 8212, 732, 8482, 353, 8250, 339, UNDEFINED, 382, 376]
character(len=*), parameter :: LOWER = 'abcdefghijklmnopqrstuvwxyz' !< Lowercase letters.
character(len=*), parameter :: UPPER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' !< Uppercase letters.

contains
   pure function bom_encoding(bytes) result(encoding)
   !< Return the encoding named by the byte order mark that starts `bytes`: `UTF-8`, `UTF-16LE`, `UTF-16BE`,
   !< `UTF-32LE`, `UTF-32BE`, or an empty string if there is none.
   !<
   !< @note `FF FE 00 00` is read as the UTF-32LE mark (not as the UTF-16LE mark followed by U+0000).
   !<
   !<```fortran
   !< logical :: test_passed(4)
   !< test_passed(1) = bom_encoding(char(239)//char(187)//char(191)//'<a/>')=='UTF-8'
   !< test_passed(2) = bom_encoding(char(255)//char(254)//'<'//char(0))=='UTF-16LE'
   !< test_passed(3) = bom_encoding(char(0)//char(0)//char(254)//char(255))=='UTF-32BE'
   !< test_passed(4) = bom_encoding('<a/>')==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(len=*), intent(in)  :: bytes    !< Bytes, the first ones at least.
   character(len=:), allocatable :: encoding !< Encoding of the byte order mark, empty if there is none.

   select case (bom_kind(bytes))
   case (ENC_UTF8)
      encoding = 'UTF-8'
   case (ENC_UTF16LE)
      encoding = 'UTF-16LE'
   case (ENC_UTF16BE)
      encoding = 'UTF-16BE'
   case (ENC_UTF32LE)
      encoding = 'UTF-32LE'
   case (ENC_UTF32BE)
      encoding = 'UTF-32BE'
   case default
      encoding = ''
   endselect
   endfunction bom_encoding

   pure function bom_length(bytes) result(n)
   !< Return the length in bytes of the byte order mark that starts `bytes` (3 for UTF-8, 2 for UTF-16, 4 for UTF-32),
   !< 0 if there is none.
   !<
   !<```fortran
   !< logical :: test_passed(3)
   !< test_passed(1) = bom_length(char(239)//char(187)//char(191)//'x')==3
   !< test_passed(2) = bom_length(char(254)//char(255)//char(0)//'x')==2
   !< test_passed(3) = bom_length('x')==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(len=*), intent(in) :: bytes !< Bytes, the first ones at least.
   integer                      :: n     !< Length of the byte order mark.

   select case (bom_kind(bytes))
   case (ENC_UTF8)
      n = 3
   case (ENC_UTF16LE, ENC_UTF16BE)
      n = 2
   case (ENC_UTF32LE, ENC_UTF32BE)
      n = 4
   case default
      n = 0
   endselect
   endfunction bom_length

   pure function canonical_encoding(name) result(canonical)
   !< Return the canonical name of a supported encoding, given its name or one of its aliases (IANA character sets,
   !< case ignored, blanks around ignored), or an empty string if it is not supported.
   !<
   !< The canonical names are `UTF-8`, `US-ASCII`, `ISO-8859-1`, `windows-1252`, `UTF-16`, `UTF-16LE`, `UTF-16BE`,
   !< `UTF-32`, `UTF-32LE` and `UTF-32BE`.
   !<
   !<```fortran
   !< logical :: test_passed(5)
   !< test_passed(1) = canonical_encoding('utf8')=='UTF-8'
   !< test_passed(2) = canonical_encoding(' Latin1 ')=='ISO-8859-1'
   !< test_passed(3) = canonical_encoding('CP1252')=='windows-1252'
   !< test_passed(4) = canonical_encoding('ascii')=='US-ASCII'
   !< test_passed(5) = canonical_encoding('Shift_JIS')==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(len=*), intent(in)  :: name      !< Encoding name.
   character(len=:), allocatable :: canonical !< Canonical name, empty if the encoding is not supported.

   select case (lowered(trim(adjustl(name))))
   case ('utf-8', 'utf8', 'unicode-1-1-utf-8', 'csutf8')
      canonical = 'UTF-8'
   case ('us-ascii', 'ascii', 'ansi_x3.4-1968', 'ansi_x3.4-1986', 'iso-ir-6', 'iso_646.irv:1991', 'iso646-us', 'us', &
         'ibm367', 'cp367', 'csascii')
      canonical = 'US-ASCII'
   case ('iso-8859-1', 'iso_8859-1', 'iso_8859-1:1987', 'iso8859-1', 'iso-ir-100', 'latin1', 'latin-1', 'l1', 'ibm819', &
         'cp819', 'csisolatin1')
      canonical = 'ISO-8859-1'
   case ('windows-1252', 'cp1252', 'x-cp1252', 'cswindows1252')
      canonical = 'windows-1252'
   case ('utf-16', 'utf16', 'csutf16')
      canonical = 'UTF-16'
   case ('utf-16le', 'utf16le', 'csutf16le')
      canonical = 'UTF-16LE'
   case ('utf-16be', 'utf16be', 'csutf16be')
      canonical = 'UTF-16BE'
   case ('utf-32', 'utf32', 'csutf32')
      canonical = 'UTF-32'
   case ('utf-32le', 'utf32le', 'csutf32le')
      canonical = 'UTF-32LE'
   case ('utf-32be', 'utf32be', 'csutf32be')
      canonical = 'UTF-32BE'
   case default
      canonical = ''
   endselect
   endfunction canonical_encoding

   pure subroutine to_utf8(bytes, encoding, utf8, carry, is_last, replacement, iostat, iomsg)
   !< Convert `bytes` in `encoding` (a name or an alias of [[canonical_encoding]]) to UTF-8.
   !<
   !< + A source read in pieces passes `carry`: it is prepended to `bytes` and, unless `is_last`, receives the bytes of an
   !<   incomplete character at the end (a UTF-16 unit split, a surrogate pair split, a UTF-32 unit split). Without
   !<   `carry` (or with `is_last`, the default), an incomplete character at the end is invalid.
   !< + An invalid sequence becomes `replacement` (default U+FFFD): a US-ASCII byte above 127, one of the 5 windows-1252
   !<   bytes without a character, an unpaired UTF-16 surrogate (each unit), a UTF-32 unit that is not a Unicode scalar
   !<   value, an incomplete character at the end (as a whole). `iostat` is then the position of the first one in `carry`
   !<   followed by `bytes`, 0 if there is none.
   !< + `UTF-16` and `UTF-32` without an endianness are big endian (RFC 2781); a byte order mark is not removed (it
   !<   becomes U+FEFF): read it first with [[bom_encoding]] and [[bom_length]]. UTF-8 is returned as it is (check it
   !<   with `string%utf8_error`).
   !< + An encoding not supported gives an empty `utf8`, `iostat=-1` and `iomsg` saying so.
   !<
   !<```fortran
   !< character(len=:), allocatable :: utf8
   !< character(len=:), allocatable :: carry
   !< integer                       :: iostat
   !< logical                       :: test_passed(5)
   !< call to_utf8(bytes='caf'//char(233), encoding='latin1', utf8=utf8)
   !< test_passed(1) = utf8=='caf'//char(195)//char(169)
   !< call to_utf8(bytes=char(128)//'5', encoding='windows-1252', utf8=utf8)
   !< test_passed(2) = utf8==char(226)//char(130)//char(172)//'5'
   !< carry = ''
   !< call to_utf8(bytes='a'//char(0)//char(61), encoding='UTF-16LE', utf8=utf8, carry=carry, is_last=.false.)
   !< test_passed(3) = utf8=='a'.and.len(carry)==1
   !< call to_utf8(bytes=char(216)//char(0)//char(222), encoding='UTF-16LE', utf8=utf8, carry=carry, is_last=.true.)
   !< test_passed(4) = utf8==char(240)//char(159)//char(152)//char(128)
   !< call to_utf8(bytes='a'//char(0)//char(0)//char(220), encoding='UTF-16LE', utf8=utf8, iostat=iostat)
   !< test_passed(5) = utf8=='a'//char(239)//char(191)//char(189).and.iostat==3
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(len=*),              intent(in)              :: bytes       !< Bytes in the encoding.
   character(len=*),              intent(in)              :: encoding    !< Encoding name.
   character(len=:), allocatable, intent(out)             :: utf8        !< Bytes in UTF-8.
   character(len=:), allocatable, intent(inout), optional :: carry       !< Incomplete character between pieces.
   logical,                       intent(in),    optional :: is_last     !< The source ends with these bytes.
   character(len=*),              intent(in),    optional :: replacement !< Replacement of an invalid sequence.
   integer,                       intent(out),   optional :: iostat      !< Position of the first invalid sequence.
   character(len=*),              intent(inout), optional :: iomsg       !< Message of an error.
   character(len=:), allocatable                          :: input       !< Carry followed by bytes.
   character(len=:), allocatable                          :: rep         !< Replacement, local variable.
   character(len=:), allocatable                          :: buffer      !< Output buffer.
   logical                                                :: is_last_    !< The source ends with these bytes, local.
   integer                                                :: kind_       !< Encoding.
   integer                                                :: n           !< Output length.
   integer                                                :: first_error !< Position of the first invalid sequence.
   integer                                                :: tail        !< First byte of the incomplete character.
   character(len=:), allocatable                          :: carried     !< Incomplete character carried, local.

   if (present(iostat)) iostat = 0
   rep = REPLACEMENT_CHARACTER ; if (present(replacement)) rep = replacement
   is_last_ = .true. ; if (present(is_last)) is_last_ = is_last
   kind_ = encoding_kind(canonical_encoding(encoding))
   if (present(carry)) then
      if (.not.allocated(carry)) carry = ''
      input = carry//bytes
      carry = ''
   else
      input = bytes
   endif
   if (kind_==ENC_UNKNOWN) then
      utf8 = ''
      if (present(iostat)) iostat = -1
      if (present(iomsg)) iomsg = 'unsupported encoding "'//trim(adjustl(encoding))//'"'
      return
   endif
   first_error = 0
   tail = len(input) + 1
   carried = ''
   select case (kind_)
   case (ENC_UTF8)
      utf8 = input
   case (ENC_ASCII, ENC_LATIN1, ENC_CP1252)
      allocate(character(len=len(input)*max(3, len(rep))) :: buffer)
      call single_byte(input=input, kind_=kind_, rep=rep, buffer=buffer, n=n, first_error=first_error)
      utf8 = buffer(1:n)
   case (ENC_UTF16LE, ENC_UTF16BE)
      allocate(character(len=(len(input)/2+1)*max(4, len(rep))) :: buffer)
      call utf16(input=input, is_big=kind_==ENC_UTF16BE, rep=rep, buffer=buffer, n=n, first_error=first_error, tail=tail)
      call close_tail(input=input, tail=tail, is_carried=present(carry).and..not.is_last_, rep=rep, buffer=buffer, n=n, &
                      first_error=first_error, carried=carried)
      utf8 = buffer(1:n)
   case (ENC_UTF32LE, ENC_UTF32BE)
      allocate(character(len=(len(input)/4+1)*max(4, len(rep))) :: buffer)
      call utf32(input=input, is_big=kind_==ENC_UTF32BE, rep=rep, buffer=buffer, n=n, first_error=first_error, tail=tail)
      call close_tail(input=input, tail=tail, is_carried=present(carry).and..not.is_last_, rep=rep, buffer=buffer, n=n, &
                      first_error=first_error, carried=carried)
      utf8 = buffer(1:n)
   endselect
   if (present(carry)) carry = carried
   if (present(iostat)) iostat = first_error
   if (present(iomsg).and.first_error>0) iomsg = 'invalid '//canonical_encoding(encoding)//' sequence at byte '// &
                                                 trim(itoa(first_error))
   endsubroutine to_utf8

   ! private procedures
   pure subroutine close_tail(input, tail, is_carried, rep, buffer, n, first_error, carried)
   !< Carry the incomplete character at the end of the input (*is_carried*), or replace it.
   character(len=*),              intent(in)    :: input       !< Bytes.
   integer,                       intent(in)    :: tail        !< First byte of the incomplete character.
   logical,                       intent(in)    :: is_carried  !< The incomplete character is carried.
   character(len=*),              intent(in)    :: rep         !< Replacement.
   character(len=*),              intent(inout) :: buffer      !< Output buffer.
   integer,                       intent(inout) :: n           !< Output length.
   integer,                       intent(inout) :: first_error !< Position of the first invalid sequence.
   character(len=:), allocatable, intent(inout) :: carried     !< Incomplete character carried.

   if (tail>len(input)) return
   if (is_carried) then
      carried = input(tail:)
   else
      buffer(n+1:n+len(rep)) = rep
      n = n + len(rep)
      if (first_error==0) first_error = tail
   endif
   endsubroutine close_tail

   pure function bom_kind(bytes) result(kind_)
   !< Return the encoding of the byte order mark that starts `bytes`, ENC_UNKNOWN if there is none.
   character(len=*), intent(in) :: bytes !< Bytes.
   integer                      :: kind_ !< Encoding.

   kind_ = ENC_UNKNOWN
   if (len(bytes)>=4) then
      if (bytes(1:4)==char(255)//char(254)//char(0)//char(0)) then
         kind_ = ENC_UTF32LE
         return
      elseif (bytes(1:4)==char(0)//char(0)//char(254)//char(255)) then
         kind_ = ENC_UTF32BE
         return
      endif
   endif
   if (len(bytes)>=3) then
      if (bytes(1:3)==char(239)//char(187)//char(191)) then
         kind_ = ENC_UTF8
         return
      endif
   endif
   if (len(bytes)>=2) then
      if (bytes(1:2)==char(255)//char(254)) then
         kind_ = ENC_UTF16LE
      elseif (bytes(1:2)==char(254)//char(255)) then
         kind_ = ENC_UTF16BE
      endif
   endif
   endfunction bom_kind

   elemental function byte_value(c) result(value)
   !< Return the value 0..255 of a byte (`ichar` may be signed above 127 on some processors).
   character(len=1), intent(in) :: c     !< Byte.
   integer                      :: value !< Value.

   value = iand(ichar(c), 255)
   endfunction byte_value

   pure function encoding_kind(canonical) result(kind_)
   !< Return the encoding of a canonical name (see [[canonical_encoding]]), ENC_UNKNOWN for an empty one.
   character(len=*), intent(in) :: canonical !< Canonical name.
   integer                      :: kind_     !< Encoding.

   select case (canonical)
   case ('UTF-8')
      kind_ = ENC_UTF8
   case ('US-ASCII')
      kind_ = ENC_ASCII
   case ('ISO-8859-1')
      kind_ = ENC_LATIN1
   case ('windows-1252')
      kind_ = ENC_CP1252
   case ('UTF-16LE')
      kind_ = ENC_UTF16LE
   case ('UTF-16', 'UTF-16BE')
      kind_ = ENC_UTF16BE
   case ('UTF-32LE')
      kind_ = ENC_UTF32LE
   case ('UTF-32', 'UTF-32BE')
      kind_ = ENC_UTF32BE
   case default
      kind_ = ENC_UNKNOWN
   endselect
   endfunction encoding_kind

   pure function itoa(i) result(text)
   !< Return the decimal digits of a non negative integer.
   integer, intent(in)           :: i    !< Integer.
   character(len=:), allocatable :: text !< Digits.
   character(len=12)             :: buffer !< Buffer.

   write(buffer, '(I0)') i
   text = trim(buffer)
   endfunction itoa

   pure function lowered(text) result(lower_text)
   !< Return the text with its ASCII letters lowercased.
   character(len=*), intent(in) :: text       !< Text.
   character(len=len(text))     :: lower_text !< Lowercased text.
   integer                      :: i          !< Counter.
   integer                      :: k          !< Position of an uppercase letter.

   lower_text = text
   do i=1, len(text)
      k = index(UPPER, text(i:i))
      if (k>0) lower_text(i:i) = LOWER(k:k)
   enddo
   endfunction lowered

   pure subroutine put(buffer, n, codepoint)
   !< Append the UTF-8 encoding of a codepoint to the buffer.
   character(len=*), intent(inout) :: buffer    !< Output buffer.
   integer,          intent(inout) :: n         !< Output length.
   integer,          intent(in)    :: codepoint !< Codepoint (a Unicode scalar value).
   integer                         :: m         !< Encoding length.

   if (codepoint<128) then
      n = n + 1
      buffer(n:n) = char(codepoint)
   else
      m = len_trim_bytes(codepoint)
      buffer(n+1:n+m) = utf8_encode(int(codepoint, I4P))
      n = n + m
   endif
   endsubroutine put

   elemental function len_trim_bytes(codepoint) result(m)
   !< Return the UTF-8 length of a Unicode scalar value.
   integer, intent(in) :: codepoint !< Codepoint.
   integer             :: m         !< Length in bytes.

   if (codepoint<128) then
      m = 1
   elseif (codepoint<2048) then
      m = 2
   elseif (codepoint<65536) then
      m = 3
   else
      m = 4
   endif
   endfunction len_trim_bytes

   pure subroutine single_byte(input, kind_, rep, buffer, n, first_error)
   !< Convert a single byte encoding (US-ASCII, ISO-8859-1, windows-1252): ASCII runs are copied as they are.
   character(len=*), intent(in)    :: input       !< Bytes.
   integer,          intent(in)    :: kind_       !< Encoding.
   character(len=*), intent(in)    :: rep         !< Replacement.
   character(len=*), intent(inout) :: buffer      !< Output buffer.
   integer,          intent(out)   :: n           !< Output length.
   integer,          intent(inout) :: first_error !< Position of the first invalid byte.
   integer                         :: i           !< Current byte.
   integer                         :: j           !< End of an ASCII run.
   integer                         :: b           !< Byte value.
   integer                         :: codepoint   !< Codepoint.

   n = 0
   i = 1
   do while (i<=len(input))
      j = ascii_run(input, i)
      if (j>i) then
         buffer(n+1:n+j-i) = input(i:j-1)
         n = n + j - i
         i = j
         if (i>len(input)) exit
      endif
      b = byte_value(input(i:i))
      codepoint = b
      if (kind_==ENC_ASCII) then
         codepoint = UNDEFINED
      elseif (kind_==ENC_CP1252.and.b<160) then
         codepoint = CP1252_HIGH(b)
      endif
      if (codepoint==UNDEFINED) then
         buffer(n+1:n+len(rep)) = rep
         n = n + len(rep)
         if (first_error==0) first_error = i
      else
         call put(buffer, n, codepoint)
      endif
      i = i + 1
   enddo
   endsubroutine single_byte

   pure subroutine utf16(input, is_big, rep, buffer, n, first_error, tail)
   !< Convert UTF-16; *tail* is the first byte of an incomplete character at the end, len(input)+1 if there is none.
   character(len=*), intent(in)    :: input       !< Bytes.
   logical,          intent(in)    :: is_big      !< Big endian.
   character(len=*), intent(in)    :: rep         !< Replacement.
   character(len=*), intent(inout) :: buffer      !< Output buffer.
   integer,          intent(out)   :: n           !< Output length.
   integer,          intent(inout) :: first_error !< Position of the first invalid sequence.
   integer,          intent(out)   :: tail        !< First byte of the incomplete character at the end.
   integer                         :: i           !< Current byte.
   integer                         :: unit_       !< Current unit.
   integer                         :: low         !< Following unit.

   n = 0
   i = 1
   tail = len(input) + 1
   do while (i<=len(input))
      if (i+1>len(input)) then
         tail = i
         exit
      endif
      unit_ = unit16(input(i:i+1), is_big)
      if (unit_>=55296.and.unit_<=56319) then ! high surrogate
         if (i+3>len(input)) then
            tail = i
            exit
         endif
         low = unit16(input(i+2:i+3), is_big)
         if (low>=56320.and.low<=57343) then
            call put(buffer, n, 65536 + (unit_ - 55296) * 1024 + (low - 56320))
            i = i + 4
         else
            call replace_unit(rep, buffer, n, first_error, i)
            i = i + 2
         endif
      elseif (unit_>=56320.and.unit_<=57343) then ! low surrogate alone
         call replace_unit(rep, buffer, n, first_error, i)
         i = i + 2
      else
         call put(buffer, n, unit_)
         i = i + 2
      endif
   enddo
   endsubroutine utf16

   pure subroutine replace_unit(rep, buffer, n, first_error, at)
   !< Append the replacement of an invalid sequence at byte *at*.
   character(len=*), intent(in)    :: rep         !< Replacement.
   character(len=*), intent(inout) :: buffer      !< Output buffer.
   integer,          intent(inout) :: n           !< Output length.
   integer,          intent(inout) :: first_error !< Position of the first invalid sequence.
   integer,          intent(in)    :: at          !< Position of the sequence.

   buffer(n+1:n+len(rep)) = rep
   n = n + len(rep)
   if (first_error==0) first_error = at
   endsubroutine replace_unit

   pure subroutine utf32(input, is_big, rep, buffer, n, first_error, tail)
   !< Convert UTF-32; *tail* is the first byte of an incomplete unit at the end, len(input)+1 if there is none.
   character(len=*), intent(in)    :: input       !< Bytes.
   logical,          intent(in)    :: is_big      !< Big endian.
   character(len=*), intent(in)    :: rep         !< Replacement.
   character(len=*), intent(inout) :: buffer      !< Output buffer.
   integer,          intent(out)   :: n           !< Output length.
   integer,          intent(inout) :: first_error !< Position of the first invalid unit.
   integer,          intent(out)   :: tail        !< First byte of the incomplete unit at the end.
   integer                         :: i           !< Current byte.
   integer                         :: high        !< High half of the unit.
   integer                         :: low         !< Low half of the unit.

   n = 0
   i = 1
   tail = len(input) + 1
   do while (i<=len(input))
      if (i+3>len(input)) then
         tail = i
         exit
      endif
      if (is_big) then
         high = unit16(input(i:i+1), .true.)
         low = unit16(input(i+2:i+3), .true.)
      else
         low = unit16(input(i:i+1), .false.)
         high = unit16(input(i+2:i+3), .false.)
      endif
      if (high>16.or.(high==0.and.low>=55296.and.low<=57343)) then ! above U+10FFFF, or a surrogate
         buffer(n+1:n+len(rep)) = rep
         n = n + len(rep)
         if (first_error==0) first_error = i
      else
         call put(buffer, n, high * 65536 + low)
      endif
      i = i + 4
   enddo
   endsubroutine utf32

   pure function unit16(pair, is_big) result(value)
   !< Return the value of a 16-bit unit.
   character(len=2), intent(in) :: pair   !< Two bytes.
   logical,          intent(in) :: is_big !< Big endian.
   integer                      :: value  !< Unit value.

   if (is_big) then
      value = byte_value(pair(1:1)) * 256 + byte_value(pair(2:2))
   else
      value = byte_value(pair(2:2)) * 256 + byte_value(pair(1:1))
   endif
   endfunction unit16
endmodule stringifor_encodings
