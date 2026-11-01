program sfre
!< A tiny grep and sed: one regular expression method for each command.
use stringifor
implicit none
type(string)              :: command, pattern, subject, line
type(string), allocatable :: pieces(:)
type(regex)               :: re
type(regex_match)         :: m
character(len=99)         :: iomsg
integer                   :: iostat, i, bytes

command = argument(1)
pattern = argument(2)
call re%compile(pattern%chars(), iostat=iostat, iomsg=iomsg)
if (iostat /= 0) then
  print '(A,I0,2A)', 'bad pattern, byte ', iostat, ': ', trim(iomsg)
  stop
endif
select case(command%chars())
case('search')
  subject = argument(3)
  m = re%search(subject)
  print '(A,1X,A,2I4)', 'match:', m%group(0)//'', m%span(0)
  print '(4A)', 'user=', m%group('user')//'', ' host=', m%group('host')//''
case('findall')
  subject = argument(3)
  pieces = re%findall(subject)
  print '(*(A,:," | "))', (pieces(i)%chars(), i=1, size(pieces))
case('sub')
  subject = argument(4)
  line = argument(3)
  line = re%sub(line%chars(), subject)
  print '(A)', line%chars()
case('split')
  subject = argument(3)
  pieces = re%split(subject)
  print '(*(A,:," | "))', (pieces(i)%chars(), i=1, size(pieces))
case('stress') ! exponential for a backtracking engine, linear here
  line = argument(3)
  bytes = line%to_number(kind=1_I4P)
  m = re%search(repeat('a', bytes))
  print '(A,L2,A,I0,A)', 'found:', m%found, ' in ', bytes, ' bytes'
endselect

contains
  function argument(n) result(arg)
  !< The n-th command line argument, as a string.
  integer, intent(in)       :: n
  type(string)              :: arg
  character(:), allocatable :: buffer
  integer                   :: length

  call get_command_argument(n, length=length)
  allocate(character(length) :: buffer)
  call get_command_argument(n, value=buffer)
  arg = buffer
  endfunction argument
endprogram sfre
