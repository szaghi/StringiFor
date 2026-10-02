!as sf
!run quickstart-upper sf upper "hello, world"
!run quickstart-snake sf snake "The Quick Brown Fox"
!run quickstart-reverse sf reverse "the sky is blue"
!run quickstart-justify sf justify "StringiFor gives Fortran a string type with the methods you miss from Python."
!run quickstart-newer sf newer 1.10.0 1.9.3
!run quickstart-hex sf hex 255
!run quickstart-number sf number 6.02e23
!cast quickstart quickstart-upper quickstart-snake quickstart-reverse quickstart-justify quickstart-newer quickstart-hex quickstart-number
program sf
!< Quick start: a tiny command line tool, one StringiFor method for each command.
use stringifor
implicit none
type(string)              :: command, text, other
type(string), allocatable :: lines(:)
integer                   :: l

command = argument(1)
text = argument(2)
select case(command%chars())
case('upper')
  call show(text%upper()//'')
case('snake')
  call show(text%snakecase()//'')
case('reverse')
  call show(text%reverse_words()//'')
case('justify')
  call text%justify(lines=lines, width=34)
  do l = 1, size(lines)
    call show('|'//lines(l)//'|')
  enddo
case('newer')
  other = argument(3)
  call show(merge(text, other, text%compare_version(other) > 0)//'')
case('hex')
  call show('0x'//text%hex())
case('number')
  if (text%is_integer()) then
    call show('an integer')
  elseif (text%is_real()) then
    call show('a real')
  else
    call show('not a number')
  endif
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

  subroutine show(answer)
  !< Print an answer, in colour.
  character(*), intent(in) :: answer
  type(string)             :: coloured

  coloured = answer
  print '(A)', coloured%colorize(color_fg='cyan', style='bold_on')
  endsubroutine show
endprogram sf
