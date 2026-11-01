!< Driver of the oracle harness of the UTF-8 work (issue #51, step 0.2), run by scripts/utf8/oracle.py.
!<
!< Reads the calls from the standard input, one per line: the operation and its arguments separated by a TAB, strings in
!< hexadecimal, integers in decimal. Writes one result per call: string in hexadecimal, integer in decimal, logical as T
!< or F, list of strings as its items in hexadecimal separated by commas ("[]" if empty). Exits with status 2 on an
!< unknown operation or a malformed line: the harness then stops instead of reporting mismatches.
!<
!< The driver does not use the methods under test to parse its input: lines, fields and hexadecimal are handled here.
program oracle_driver
use, intrinsic :: iso_fortran_env, only : error_unit, input_unit, int32, int64, output_unit, real32, real64
use stringifor, only : from_codepoints, I1P, I4P, I8P, regex, regex_match, scan, shortest, SF_CHARS, SF_COLUMNS, string, strless_natural, &
                       strless_nocase, strsort, verify
implicit none
character(len=:), allocatable :: line     !< Current line.
character(len=:), allocatable :: field(:) !< Fields of the line (padded).
integer,          allocatable :: lens(:)  !< Lengths of the fields.
type(string)                  :: s        !< First argument.
type(string)                  :: t        !< Second argument.
type(string),     allocatable :: tokens(:)!< List result.
type(string)                  :: parts(3) !< Partition result.
integer                       :: iostat   !< I/O status.
integer                       :: nfield   !< Number of fields.
integer(I4P),     allocatable :: codes(:) !< Codepoints.
integer(I4P),     allocatable :: widths(:)!< Widths.
integer                       :: k        !< Counter.
integer,          allocatable :: perm(:)  !< Permutation of a sort.
type(regex)                   :: re       !< A regex.
type(regex_match)             :: found    !< A match.
integer                       :: nsub     !< Number of replacements.
integer                       :: status   !< Status of a compilation.
real(real64)                  :: r8       !< A number.
integer(I1P)                  :: i1       !< A number.
integer(I4P)                  :: i4       !< A number.
integer(I8P)                  :: i8       !< A number.
character(len=16)             :: word     !< Bits of a number, in hexadecimal.
integer(int64)                :: bits8    !< Bits of a number.
integer(int32)                :: bits4    !< Bits of a number.
real(real32)                  :: r4       !< A number.

do
  call get_line(input_unit, line, iostat)
  if (iostat /= 0) exit
  call split_fields(line, field, lens, nfield)
  if (nfield < 2) call fail('malformed line: '//line)
  if (arg(1) /= 'from_codepoints'.and.arg(1) /= 'width_each'.and.index(arg(1), 'shortest') /= 1.and.arg(1) /= 'space_each'.and.index(arg(1), 'strsort') /= 1) &
    s = unhex(arg(2)) ! a list of integers, or of strings
  select case (arg(1))
  case ('to_r8')
    call s%read_number(r8, iostat=status)
    if (status /= 0) then
      write(output_unit, '(a)') 'E'
    elseif (r8 /= r8) then
      write(output_unit, '(a)') 'nan'
    else
      write(output_unit, '(z16.16)') transfer(r8, 1_int64)
    endif
  case ('to_r4')
    call s%read_number(r4, iostat=status)
    if (status /= 0) then
      write(output_unit, '(a)') 'E'
    elseif (r4 /= r4) then
      write(output_unit, '(a)') 'nan'
    else
      write(output_unit, '(z8.8)') transfer(r4, 1_int32)
    endif
  case ('shortest_r8')
    word = arg(2)
    read(word, '(z16)') bits8
    t = shortest(transfer(bits8, 1._real64))
    write(output_unit, '(a)') t%chars()
  case ('shortest_r4')
    word = arg(2)
    read(word, '(z8)') bits4
    t = shortest(transfer(bits4, 1._real32))
    write(output_unit, '(a)') t%chars()
  case ('edit_distance')
    call put_int(s%edit_distance(unhex(arg(3))))
  case ('edit_distance_chars')
    call put_int(s%edit_distance(unhex(arg(3)), by=SF_CHARS))
  case ('to_i1')
    call s%read_number(i1, iostat=status)
    call put_integer(int(i1, int64), status)
  case ('to_i4')
    call s%read_number(i4, iostat=status)
    call put_integer(int(i4, int64), status)
  case ('to_i8')
    call s%read_number(i8, iostat=status)
    call put_integer(i8, status)
  case ('is_integer')
    call put_logical(s%is_integer())
  case ('is_real')
    call put_logical(s%is_real())
  case ('is_number')
    call put_logical(s%is_number())
  case ('len')
    call put_int(s%len())
  case ('index')
    call put_int(s%index(unhex(arg(3))))
  case ('index_back')
    call put_int(s%index(unhex(arg(3)), back=.true.))
  case ('count')
    call put_int(s%count(unhex(arg(3))))
  case ('count_overlapping')
    call put_int(s%count(unhex(arg(3)), overlapping=.true.))
  case ('replace')
    t = s%replace(old=unhex(arg(3)), new=unhex(arg(4)))
    call put_str(t)
  case ('replace_count')
    t = s%replace(old=unhex(arg(3)), new=unhex(arg(4)), count=int_arg(5))
    call put_str(t)
  case ('split')
    call s%split(tokens=tokens, sep=unhex(arg(3)), keep_empty=.true.)
    call put_list(tokens)
  case ('split_collapse')
    call s%split(tokens=tokens, sep=unhex(arg(3)))
    call put_list(tokens)
  case ('split_chunked')
    call s%split_chunked(tokens=tokens, sep=unhex(arg(3)), chunks=int_arg(4))
    call put_list(tokens)
  case ('index_occurrence')
    call put_int(s%index(unhex(arg(3)), occurrence=int_arg(4)))
  case ('index_occurrence_back')
    call put_int(s%index(unhex(arg(3)), back=.true., occurrence=int_arg(4)))
  case ('partition')
    parts = s%partition(sep=unhex(arg(3)))
    call put_list(parts)
  case ('start_with')
    call put_logical(s%start_with(unhex(arg(3))))
  case ('end_with')
    call put_logical(s%end_with(unhex(arg(3))))
  case ('upper')
    call put_str(s%upper())
  case ('lower')
    call put_str(s%lower())
  case ('eq')
    t = unhex(arg(3))
    call put_logical(s == t)
  case ('lt')
    t = unhex(arg(3))
    call put_logical(s < t)
  case ('assign_substring') ! the right hand side is a part of the left hand side
    s = s%raw(int_arg(3):int_arg(4))
    call put_str(s)
  case ('concat')
    t = unhex(arg(3))
    write(output_unit, '(a)') hex(s//t)
  case ('is_utf8')
    call put_logical(s%is_utf8())
  case ('utf8_error')
    call put_int(s%utf8_error())
  case ('codepoints')
    call put_int_list(s%codepoints())
  case ('from_codepoints')
    t = from_codepoints(int_list(arg(2)))
    call put_str(t)
  case ('to_valid_utf8')
    call put_str(s%to_valid_utf8())
  case ('to_valid_utf8_with')
    call put_str(s%to_valid_utf8(replacement=unhex(arg(3))))
  case ('escape_c')
    call put_str(s%escape_c())
  case ('escape_c_utf8')
    call put_str(s%escape_c(ascii=.false.))
  case ('unescape_c')
    call put_str(s%unescape_c())
  case ('escapes_error')
    call put_int(s%escapes_error())
  case ('escape_roundtrip')
    t = s%escape_c()
    call put_str(t%unescape_c())
  case ('escape_roundtrip_utf8')
    t = s%escape_c(ascii=.false.)
    call put_str(t%unescape_c())
  case ('escape_xml')
    call put_str(s%escape_xml())
  case ('escape_xml_attribute')
    call put_str(s%escape_xml(attribute=.true.))
  case ('unescape_xml')
    call put_str(s%unescape_xml())
  case ('xml_error')
    call put_int(s%xml_error())
  case ('xml_roundtrip')
    t = s%escape_xml()
    call put_str(t%unescape_xml())
  case ('xml_roundtrip_attribute')
    t = s%escape_xml(attribute=.true.)
    call put_str(t%unescape_xml())
  case ('scan')
    call put_int(s%scan(unhex(arg(3))))
  case ('scan_back')
    call put_int(s%scan(unhex(arg(3)), back=.true.))
  case ('verify')
    call put_int(s%verify(unhex(arg(3))))
  case ('verify_back')
    call put_int(s%verify(unhex(arg(3)), back=.true.))
  case ('scan_overload')
    t = unhex(arg(3))
    call put_int(scan(unhex(arg(2)), t))
  case ('verify_overload')
    t = unhex(arg(3))
    call put_int(verify(unhex(arg(2)), t, back=.true.))
  case ('strip_remove')
    call put_str(s%strip(remove=unhex(arg(3))))
  case ('lstrip_remove')
    call put_str(s%lstrip(remove=unhex(arg(3))))
  case ('rstrip_remove')
    call put_str(s%rstrip(remove=unhex(arg(3))))
  case ('reverse')
    call put_str(s%reverse())
  case ('squeeze')
    call put_str(s%squeeze())
  case ('squeeze_set')
    call put_str(s%squeeze(set=unhex(arg(3))))
  case ('transliterate')
    call put_str(s%transliterate(unhex(arg(3)), unhex(arg(4))))
  case ('match')
    call put_logical(s%match(unhex(arg(3))))
  case ('len_chars')
    call put_int(s%len(by=SF_CHARS))
  case ('index_chars')
    call put_int(s%index(unhex(arg(3)), by=SF_CHARS))
  case ('index_back_chars')
    call put_int(s%index(unhex(arg(3)), back=.true., by=SF_CHARS))
  case ('index_occurrence_chars')
    call put_int(s%index(unhex(arg(3)), occurrence=int_arg(4), by=SF_CHARS))
  case ('scan_chars')
    call put_int(s%scan(unhex(arg(3)), by=SF_CHARS))
  case ('verify_back_chars')
    call put_int(s%verify(unhex(arg(3)), back=.true., by=SF_CHARS))
  case ('slice_chars')
    t = s%slice(first=int_arg(3), last=int_arg(4), stride=int_arg(5), by=SF_CHARS)
    call put_str(t)
  case ('insert_chars')
    call put_str(s%insert(unhex(arg(3)), int_arg(4), by=SF_CHARS))
  case ('len_last_word_chars')
    call put_int(s%len_last_word(sep=unhex(arg(3)), by=SF_CHARS))
  case ('center_chars')
    call put_str(s%center(int_arg(3), '*', by=SF_CHARS))
  case ('ljust_chars')
    call put_str(s%ljust(int_arg(3), '*', by=SF_CHARS))
  case ('rjust_chars')
    call put_str(s%rjust(int_arg(3), '*', by=SF_CHARS))
  case ('fill_chars')
    call put_str(s%fill(int_arg(3), right=int_arg(4)==1, by=SF_CHARS))
  case ('expand_tabs_chars')
    call put_str(s%expand_tabs(int_arg(3), by=SF_CHARS))
  case ('justify_chars')
    call s%justify(tokens, int_arg(3), by=SF_CHARS)
    call put_list(tokens)
  case ('byte_pos')
    call put_int(s%byte_pos(int_arg(3)))
  case ('char_pos')
    call put_int(s%char_pos(int_arg(3)))
  case ('width')
    call put_int(s%width())
  case ('center_columns')
    call put_str(s%center(int_arg(3), '*', by=SF_COLUMNS))
  case ('ljust_columns')
    call put_str(s%ljust(int_arg(3), '*', by=SF_COLUMNS))
  case ('rjust_columns')
    call put_str(s%rjust(int_arg(3), '*', by=SF_COLUMNS))
  case ('fill_columns')
    call put_str(s%fill(int_arg(3), by=SF_COLUMNS))
  case ('expand_tabs_columns')
    call put_str(s%expand_tabs(int_arg(3), by=SF_COLUMNS))
  case ('justify_columns')
    call s%justify(tokens, int_arg(3), by=SF_COLUMNS)
    call put_list(tokens)
  case ('is_space')
    call put_logical(s%is_space())
  case ('is_space_unicode')
    call put_logical(s%is_space(unicode=.true.))
  case ('strip_ws')
    call put_str(s%strip(whitespace=.true.))
  case ('lstrip_ws')
    call put_str(s%lstrip(whitespace=.true.))
  case ('rstrip_ws')
    call put_str(s%rstrip(whitespace=.true.))
  case ('strip_ws_unicode')
    call put_str(s%strip(whitespace=.true., unicode=.true.))
  case ('lstrip_ws_unicode')
    call put_str(s%lstrip(whitespace=.true., unicode=.true.))
  case ('rstrip_ws_unicode')
    call put_str(s%rstrip(whitespace=.true., unicode=.true.))
  case ('strip_unicode_alone')
    call put_str(s%strip(unicode=.true.))
  case ('strip_remove_ws_unicode')
    call put_str(s%strip(remove=unhex(arg(3)), whitespace=.true., unicode=.true.))
  case ('compact')
    call put_str(s%compact())
  case ('compact_unicode')
    call put_str(s%compact(unicode=.true.))
  case ('compact_sep_unicode')
    call put_str(s%compact(sep=unhex(arg(3)), unicode=.true.))
  case ('space_each')
    codes = int_list(arg(2))
    allocate(widths(size(codes)))
    do k = 1, size(codes)
      t = from_codepoints(codes(k:k))
      widths(k) = merge(1, 0, t%is_space(unicode=.true.))
    enddo
    call put_int_list(widths)
    deallocate(widths)
  case ('strsort')
    tokens = str_list(arg(2))
    call strsort(tokens)
    call put_list(tokens)
  case ('strsort_index')
    tokens = str_list(arg(2))
    allocate(perm(size(tokens)))
    call strsort(tokens, index=perm)
    call put_int_list(int(perm, I4P))
    deallocate(perm)
  case ('strsort_nocase')
    tokens = str_list(arg(2))
    call strsort(tokens, less=strless_nocase)
    call put_list(tokens)
  case ('strsort_natural')
    tokens = str_list(arg(2))
    call strsort(tokens, less=strless_natural)
    call put_list(tokens)
  case ('strsort_null')
    tokens = str_list(arg(2))
    call strsort(tokens)
    call put_null_list(tokens)
  case ('re_search', 're_match', 're_fullmatch') ! pattern, flags, subject, start
    call re%compile(raw(s), flags=unhex(arg(3)), iostat=status)
    if (status /= 0) then
      write(output_unit, '(a)') 'E'
      cycle
    endif
    t = unhex(arg(4))
    select case (arg(1))
    case ('re_search')
      found = re%search(t, start=int_arg(5))
    case ('re_match')
      found = re%match(t, start=int_arg(5))
    case default
      found = re%fullmatch(t, start=int_arg(5))
    endselect
    call put_match(found)
  case ('re_findall', 're_split', 're_sub', 're_subn') ! pattern, flags, subject, number[, template]
    call re%compile(raw(s), flags=unhex(arg(3)), iostat=status)
    if (status /= 0) then
      write(output_unit, '(a)') 'E'
      cycle
    endif
    t = unhex(arg(4))
    select case (arg(1))
    case ('re_findall')
      tokens = re%findall(t)
      call put_list(tokens)
    case ('re_split')
      tokens = re%split(t, maxsplit=int_arg(5))
      call put_null_list(tokens)
    case default
      t = re%sub(unhex(arg(6)), t, count=int_arg(5), nsub=nsub, iostat=status)
      if (status /= 0) then
        write(output_unit, '(a)') 'E'
      elseif (arg(1) == 're_sub') then
        call put_str(t)
      else
        call put_int(nsub)
      endif
    endselect
  case ('width_each')
    codes = int_list(arg(2))
    allocate(widths(size(codes)))
    do k = 1, size(codes)
      t = from_codepoints(codes(k:k))
      widths(k) = t%width()
    enddo
    call put_int_list(widths)
    deallocate(widths)
  case default
    call fail('unknown operation: '//arg(1))
  endselect
enddo

contains
  function arg(i) result(value)
  !< Return the field i, trimmed to its length.
  integer, intent(in)           :: i     !< Field number.
  character(len=:), allocatable :: value !< Field.

  if (i > nfield) call fail('missing argument in line: '//line)
  value = field(i)(1:lens(i))
  endfunction arg

  function int_arg(i) result(value)
  !< Return the field i as an integer.
  integer, intent(in)           :: i       !< Field number.
  integer                       :: value   !< Integer value.
  character(len=:), allocatable :: text    !< Field.
  integer                       :: iostat_ !< I/O status.

  text = arg(i)
  read(text, *, iostat=iostat_) value
  if (iostat_ /= 0) call fail('not an integer: '//arg(i))
  endfunction int_arg

  function int_list(text) result(values)
  !< Decode a list of integers: decimal values separated by commas, "[]" if empty.
  character(len=*), intent(in) :: text      !< Encoded list.
  integer(I4P), allocatable    :: values(:) !< Values.
  integer                      :: i         !< Counter.
  integer                      :: first     !< First character of the current value.
  integer                      :: k         !< Value counter.
  integer                      :: iostat_   !< I/O status.

  if (text == '[]') then
    allocate(values(0))
    return
  endif
  allocate(values(count([(text(i:i) == ',', i=1, len(text))]) + 1))
  first = 1
  k = 0
  do i = 1, len(text) + 1
    if (i > len(text)) then
      k = k + 1
      read(text(first:), *, iostat=iostat_) values(k)
    elseif (text(i:i) == ',') then
      k = k + 1
      read(text(first:i - 1), *, iostat=iostat_) values(k)
      first = i + 1
    else
      cycle
    endif
    if (iostat_ /= 0) call fail('bad integer list: '//text)
  enddo
  endfunction int_list

  subroutine put_int_list(values)
  !< Write a list of integers.
  integer(I4P), intent(in)      :: values(:) !< Result.
  character(len=:), allocatable :: text      !< Encoded list.
  character(len=16)             :: item      !< One value.
  integer                       :: i         !< Counter.

  if (size(values) == 0) then
    text = '[]'
  else
    text = ''
    do i = 1, size(values)
      write(item, '(i0)') values(i)
      text = text//trim(item)//merge(',', ' ', i < size(values))
    enddo
    text = trim(text)
  endif
  write(output_unit, '(a)') text
  endsubroutine put_int_list

  subroutine get_line(unit, line, iostat)
  !< Read a whole line of any length.
  integer,                       intent(in)  :: unit   !< Unit.
  character(len=:), allocatable, intent(out) :: line   !< Line.
  integer,                       intent(out) :: iostat !< I/O status (0, or end of file).
  character(len=4096)                        :: buffer !< Chunk.
  integer                                    :: nread  !< Characters read in the chunk.

  line = ''
  do
    read(unit, '(a)', advance='no', iostat=iostat, size=nread) buffer
    line = line//buffer(1:nread)
    if (is_iostat_eor(iostat)) then
      iostat = 0
      exit
    endif
    if (iostat /= 0) exit
  enddo
  endsubroutine get_line

  subroutine split_fields(line, field, lens, nfield)
  !< Split a line at the TABs.
  character(len=*),              intent(in)  :: line     !< Line.
  character(len=:), allocatable, intent(out) :: field(:) !< Fields, padded to the longest.
  integer,          allocatable, intent(out) :: lens(:)  !< Lengths of the fields.
  integer,                       intent(out) :: nfield   !< Number of fields.
  integer, allocatable                       :: starts(:)!< First character of each field.
  integer                                    :: i        !< Counter.

  nfield = count([(line(i:i) == achar(9), i=1, len(line))]) + 1
  allocate(starts(nfield + 1), lens(nfield))
  starts(1) = 1
  nfield = 1
  do i = 1, len(line)
    if (line(i:i) == achar(9)) then
      nfield = nfield + 1
      starts(nfield) = i + 1
    endif
  enddo
  starts(nfield + 1) = len(line) + 2
  lens = starts(2:nfield + 1) - starts(1:nfield) - 1
  allocate(character(len=max(1, maxval(lens))) :: field(nfield))
  do i = 1, nfield
    field(i) = line(starts(i):starts(i) + lens(i) - 1)
  enddo
  endsubroutine split_fields

  function unhex(text) result(bytes)
  !< Decode hexadecimal.
  character(len=*), intent(in)  :: text    !< Hexadecimal.
  character(len=:), allocatable :: bytes   !< Bytes.
  integer                       :: i       !< Counter.
  integer                       :: code    !< Byte value.
  integer                       :: iostat_ !< I/O status.

  if (mod(len(text), 2) /= 0) call fail('odd hexadecimal: '//text)
  allocate(character(len=len(text) / 2) :: bytes)
  do i = 1, len(bytes)
    read(text(2 * i - 1:2 * i), '(z2)', iostat=iostat_) code
    if (iostat_ /= 0) call fail('bad hexadecimal: '//text)
    bytes(i:i) = achar(code)
  enddo
  endfunction unhex

  function hex(bytes) result(text)
  !< Encode in lowercase hexadecimal.
  character(len=*), intent(in)  :: bytes  !< Bytes.
  character(len=:), allocatable :: text   !< Hexadecimal.
  character(len=*), parameter   :: digits = '0123456789abcdef' !< Digits.
  integer                       :: i      !< Counter.
  integer                       :: code   !< Byte value.

  allocate(character(len=2 * len(bytes)) :: text)
  do i = 1, len(bytes)
    code = iachar(bytes(i:i))
    text(2 * i - 1:2 * i) = digits(code / 16 + 1:code / 16 + 1)//digits(mod(code, 16) + 1:mod(code, 16) + 1)
  enddo
  endfunction hex

  function raw(astring) result(bytes)
  !< Return the bytes of a string, empty if it is not allocated.
  type(string), intent(in)      :: astring !< String.
  character(len=:), allocatable :: bytes   !< Bytes.

  if (allocated(astring%raw)) then
    bytes = astring%raw
  else
    bytes = ''
  endif
  endfunction raw

  subroutine put_str(astring)
  !< Write a string result.
  type(string), intent(in) :: astring !< Result.

  write(output_unit, '(a)') hex(raw(astring))
  endsubroutine put_str

  subroutine put_integer(value, status)
  !< Write an integer result, or E on a failure.
  integer(int64), intent(in) :: value  !< Result.
  integer,        intent(in) :: status !< I/O status.

  if (status /= 0) then
    write(output_unit, '(a)') 'E'
  else
    write(output_unit, '(i0)') value
  endif
  endsubroutine put_integer

  subroutine put_int(value)
  !< Write an integer result.
  integer, intent(in) :: value !< Result.

  write(output_unit, '(i0)') value
  endsubroutine put_int

  subroutine put_logical(value)
  !< Write a logical result.
  logical, intent(in) :: value !< Result.

  write(output_unit, '(l1)') value
  endsubroutine put_logical

  subroutine put_list(items)
  !< Write a list result.
  type(string), intent(in)      :: items(:) !< Result.
  character(len=:), allocatable :: text     !< Encoded list.
  integer                       :: i        !< Counter.

  if (size(items) == 0) then
    text = '[]'
  else
    text = hex(raw(items(1)))
    do i = 2, size(items)
      text = text//','//hex(raw(items(i)))
    enddo
  endif
  write(output_unit, '(a)') text
  endsubroutine put_list

  function str_list(text) result(items)
  !< Decode a list of strings: items in hexadecimal separated by commas, "[]" if empty, "-" for a not allocated string.
  character(len=*), intent(in) :: text     !< Encoded list.
  type(string), allocatable    :: items(:) !< Items.
  integer                      :: i        !< Counter.
  integer                      :: first    !< First character of the current item.
  integer                      :: k        !< Item counter.

  if (text == '[]') then
    allocate(items(0))
    return
  endif
  allocate(items(count([(text(i:i) == ',', i=1, len(text))]) + 1))
  first = 1
  k = 0
  do i = 1, len(text) + 1
    if (i <= len(text)) then
      if (text(i:i) /= ',') cycle
    endif
    k = k + 1
    if (text(first:i - 1) /= '-') items(k) = unhex(text(first:i - 1))
    first = i + 1
  enddo
  endfunction str_list

  subroutine put_null_list(items)
  !< Write a list result, "-" for a not allocated string.
  type(string), intent(in)      :: items(:) !< Result.
  character(len=:), allocatable :: text     !< Encoded list.
  integer                       :: i        !< Counter.

  text = ''
  do i = 1, size(items)
    if (i > 1) text = text//','
    if (allocated(items(i)%raw)) then
      text = text//hex(items(i)%raw)
    else
      text = text//'-'
    endif
  enddo
  if (size(items) == 0) text = '[]'
  write(output_unit, '(a)') text
  endsubroutine put_null_list

  subroutine put_match(found)
  !< Write a match: "-" if none, else the first and last byte of each group 0..n, separated by commas.
  type(regex_match), intent(in) :: found !< The match.
  integer                       :: g     !< Group counter.
  character(len=:), allocatable :: text  !< Encoded match.
  character(len=24)             :: pair  !< One group.

  if (.not.found%found) then
    write(output_unit, '(a)') '-'
    return
  endif
  text = ''
  do g = 0, ubound(found%spans, dim=2)
    write(pair, '(i0,",",i0)') found%spans(:, g)
    text = text//merge(',', ' ', g > 0)//trim(pair)
  enddo
  write(output_unit, '(a)') trim(adjustl(text))
  endsubroutine put_match

  subroutine fail(message)
  !< Stop with status 2.
  character(len=*), intent(in) :: message !< Reason.

  write(error_unit, '(a)') 'oracle_driver: '//message
  error stop 2
  endsubroutine fail
endprogram oracle_driver
