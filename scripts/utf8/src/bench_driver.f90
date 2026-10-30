!< Benchmark driver of the UTF-8 work (issue #51, step 0.3), run by scripts/bench.sh.
!<
!< Times the methods the plan of #51 touches, on ASCII and on UTF-8 text, at the sizes given on the command line
!< (bytes; default 1000 10000 100000). Each timing is the best of 7 batches, a batch calling the method until 0.05 s
!< have passed: the result is the time of one call in seconds. Prints CSV: method,input,bytes,seconds.
program bench_driver
use, intrinsic :: iso_fortran_env, only : int64, output_unit, real64
use stringifor, only : string
implicit none
integer, parameter            :: nbatch = 7             !< Batches per timing.
real(real64), parameter       :: batch_time = 0.05_real64 !< Minimum duration of a batch (s).
integer, allocatable          :: sizes(:)               !< Sizes of the inputs (bytes).
character(len=32)             :: argument               !< Command line argument.
character(len=:), allocatable :: input_name             !< Name of the input kind.
type(string)                  :: text                   !< Input.
integer(int64)                :: sink                   !< Accumulates results, so no call is optimized away.
integer                       :: i                      !< Counter.
integer                       :: k                      !< Counter.

if (command_argument_count() == 0) then
  sizes = [1000, 10000, 100000]
else
  allocate(sizes(command_argument_count()))
  do i = 1, size(sizes)
    call get_command_argument(i, argument)
    read(argument, *) sizes(i)
  enddo
endif
sink = 0
write(output_unit, '(a)') 'method,input,bytes,seconds'
do k = 1, 2
  input_name = merge('ascii', 'utf8 ', k == 1)
  input_name = trim(input_name)
  do i = 1, size(sizes)
    text = make_input(input_name, sizes(i))
    call time_all(text, input_name, sizes(i))
  enddo
enddo
if (sink == -1) write(output_unit, '(i0)') sink ! never true; keeps sink alive

contains
  function make_input(kind_name, n) result(raw)
  !< Return n bytes of text, cut at a character boundary.
  character(len=*), intent(in)  :: kind_name !< 'ascii' or 'utf8'.
  integer,          intent(in)  :: n         !< Bytes.
  character(len=:), allocatable :: raw       !< Text.
  character(len=:), allocatable :: unit_text !< Repeated piece.
  integer                       :: last      !< Last byte kept.

  if (kind_name == 'ascii') then
    unit_text = 'The quick brown fox jumps over the lazy dog. '
  else ! Gruesse (u-umlaut, sharp s), CJK ni hao, an emoji, Greek alpha
    unit_text = 'Gr'//achar(195)//achar(188)//achar(195)//achar(159)//'e '// &
                achar(228)//achar(189)//achar(160)//achar(229)//achar(165)//achar(189)//' '// &
                achar(240)//achar(159)//achar(152)//achar(128)//' '//achar(206)//achar(177)//'bc fox. '
  endif
  raw = repeat(unit_text, n / len(unit_text) + 1)
  last = n
  do while (last > 0)
    if (iand(iachar(raw(last + 1:last + 1)), 192) /= 128) exit ! raw(last+1) starts a character
    last = last - 1
  enddo
  raw = raw(1:last)
  endfunction make_input

  subroutine time_all(text, input_name, n)
  !< Time every method on one input.
  type(string),     intent(in) :: text       !< Input.
  character(len=*), intent(in) :: input_name !< Input kind.
  integer,          intent(in) :: n          !< Bytes.
  character(len=*), parameter  :: methods(*) = [character(len=16) :: &
    'len', 'index', 'index_back', 'count', 'scan', 'verify', 'replace', 'split', 'upper', 'lower', 'reverse', &
    'match', 'strip_remove', 'squeeze', 'transliterate', 'slice', 'insert', 'center', 'ljust', 'rjust', 'fill', &
    'expand_tabs', 'is_space', 'compact', 'partition', 'is_utf8', 'utf8_error', 'codepoints', 'to_valid_utf8', &
    'escape_c', 'unescape_c', 'escape_xml', 'unescape_xml']
  integer :: m !< Counter.

  do m = 1, size(methods)
    write(output_unit, '(a,",",a,",",i0,",",es12.5)') trim(methods(m)), input_name, n, best_time(text, trim(methods(m)))
    flush(output_unit)
  enddo
  endsubroutine time_all

  function best_time(text, method) result(best)
  !< Best time of one call over the batches (s).
  type(string),     intent(in) :: text   !< Input.
  character(len=*), intent(in) :: method !< Method.
  real(real64)                 :: best   !< Time of one call (s).
  integer(int64)               :: t0     !< Start.
  integer(int64)               :: t1     !< End.
  integer(int64)               :: rate   !< Clock rate.
  integer                      :: b      !< Batch counter.
  integer                      :: calls  !< Calls in the batch.
  real(real64)                 :: elapsed!< Batch duration (s).

  call system_clock(count_rate=rate)
  best = huge(1._real64)
  do b = 1, nbatch
    calls = 0
    call system_clock(t0)
    do
      call call_method(text, method)
      calls = calls + 1
      call system_clock(t1)
      elapsed = real(t1 - t0, real64) / real(rate, real64)
      if (elapsed >= batch_time) exit
    enddo
    best = min(best, elapsed / calls)
  enddo
  endfunction best_time

  subroutine call_method(text, method)
  !< Call a method once, accumulating its result into sink.
  type(string),     intent(in) :: text      !< Input.
  character(len=*), intent(in) :: method    !< Method.
  type(string)                 :: result    !< String result.
  type(string), allocatable    :: tokens(:) !< List result.
  type(string)                 :: parts(3)  !< Partition result.
  integer                      :: width     !< Width argument.

  width = text%len() + 11
  select case (method)
  case ('len')
    sink = sink + text%len()
  case ('index')
    sink = sink + text%index('zq') ! a miss: the whole string is searched
  case ('index_back')
    sink = sink + text%index('zq', back=.true.)
  case ('count')
    sink = sink + text%count('o')
  case ('scan')
    sink = sink + text%scan('Zq')
  case ('verify')
    sink = sink + text%verify('The quick brown fox jumps over the lazy dog.Gbc ')
  case ('replace')
    result = text%replace('o', '00')
  case ('split')
    call text%split(tokens=tokens, sep=' ')
    sink = sink + size(tokens)
  case ('upper')
    result = text%upper()
  case ('lower')
    result = text%lower()
  case ('reverse')
    result = text%reverse()
  case ('match')
    sink = sink + merge(1, 0, text%match('*f?x.*zq*'))
  case ('strip_remove')
    result = text%strip(remove='T. ')
  case ('squeeze')
    result = text%squeeze(' ')
  case ('transliterate')
    result = text%transliterate('abc', 'xyz')
  case ('slice')
    result = text%slice(2, text%len() - 1)
  case ('insert')
    result = text%insert('abc', text%len() / 2)
  case ('center')
    result = text%center(width, '*')
  case ('ljust')
    result = text%ljust(width, '*')
  case ('rjust')
    result = text%rjust(width, '*')
  case ('fill')
    result = text%fill(width)
  case ('expand_tabs')
    result = text%expand_tabs()
  case ('is_space')
    sink = sink + merge(1, 0, text%is_space())
  case ('compact')
    result = text%compact()
  case ('partition')
    parts = text%partition(' zq')
    sink = sink + parts(1)%len()
  case ('is_utf8')
    sink = sink + merge(1, 0, text%is_utf8())
  case ('utf8_error')
    sink = sink + text%utf8_error()
  case ('codepoints')
    sink = sink + size(text%codepoints())
  case ('to_valid_utf8')
    result = text%to_valid_utf8()
  case ('escape_c')
    result = text%escape_c()
  case ('unescape_c')
    result = text%unescape_c()
  case ('escape_xml')
    result = text%escape_xml()
  case ('unescape_xml')
    result = text%unescape_xml()
  case default
    error stop 'bench_driver: unknown method '//method
  endselect
  if (allocated(result%raw)) sink = sink + len(result%raw)
  endsubroutine call_method
endprogram bench_driver
