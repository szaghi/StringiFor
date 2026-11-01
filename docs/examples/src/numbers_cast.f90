!as sfn
!run numbers_cast-is sfn is 42 3.14 6.02e23 abc
!run numbers_cast-cast sfn cast 3.4e2
!run numbers_cast-read sfn read 1e3 n/a
!run numbers_cast-from sfn from
!run numbers_cast-hex sfn hex 255
!run numbers_cast-sum sfn sum 'dt = 1.5, steps: 20, tol -0.5'
!cast numbers_cast numbers_cast-is numbers_cast-cast numbers_cast-read numbers_cast-from numbers_cast-hex numbers_cast-sum
program sfn
!< Numbers in and out of strings: check, cast, read with a status, assign, hexadecimal.
use stringifor
implicit none
type(string)              :: command, text
type(string), allocatable :: numbers(:)
real(R8P)                 :: value
integer                   :: i, iostat
character(len=99)         :: iomsg

command = argument(1)
text = argument(2)
select case(command%chars())
case('is')
  do i = 2, command_argument_count()
    text = argument(i)
    print '(A,": integer",L2,", real",L2,", number",L2)', text%chars(), text%is_integer(), text%is_real(), text%is_number()
  enddo
case('cast')
  print '(F0.1,1X,I0)', text%to_number(kind=1._R8P), int(text%to_number(kind=1._R8P))
case('read')
  do i = 2, command_argument_count()
    text = argument(i)
    call text%read_number(value, iostat=iostat, iomsg=iomsg)
    if (iostat == 0) then
      print '(2A,F0.1)', text%chars(), ' -> ', value
    else
      print '(3A)', text%chars(), ' -> error: ', trim(iomsg)
    endif
  enddo
case('from')
  text = 42_I4P
  print '(2A)', 'an integer: ', text%chars()
  text = 2.5_R8P
  print '(2A)', 'a real:     ', text%chars()
case('hex')
  print '(A)', '0x'//text%hex()
case('sum') ! regular expressions find the numbers, to_number casts them
  numbers = re_findall(text, '-?\d+(?:\.\d+)?')
  value = 0
  do i = 1, size(numbers)
    value = value + numbers(i)%to_number(kind=1._R8P)
  enddo
  print '(A,F0.1)', 'sum = ', value
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
endprogram sfn
