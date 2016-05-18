!< StringiFor `read_line` test.
program read_line
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `read_line` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)      :: astring        !< A string.
type(string)      :: line(3)        !< A set of strings.
integer           :: iostat         !< IO status code.
character(len=99) :: iomsg          !< IO status message.
integer           :: scratch        !< Scratch file unit.
integer           :: l              !< Counter.
logical           :: test_passed(6) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

line(1) = ' Hello World!   '
line(2) = 'How are you?  '
line(3) = '   All say: "Fine thanks"'

write(stdout, "(A)")' Formatted read'
open(newunit=scratch, status='SCRATCH')
write(scratch, "(A)") line(1)%chars()
write(scratch, "(A)") line(2)%chars()
write(scratch, "(A)") line(3)%chars()
rewind(scratch)

l = 0
iostat = 0
do
  l = l + 1
  call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg)
  if (iostat/=0.and..not.is_iostat_eor(iostat)) then
    write(stdout, "(A)")iomsg
    exit
  else
    test_passed(l) = (astring==line(l))
    write(stdout, "(A,L1)") 'line: "'//astring//'", is correct? ', test_passed(l)
  endif
enddo

close(scratch)

write(stdout, "(A)")' Unformatted read'
open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
write(scratch) line(1)%chars()//new_line('a')
write(scratch) line(2)%chars()//new_line('a')
write(scratch) line(3)%chars()//new_line('a')
rewind(scratch)

l = 0
iostat = 0
do
  l = l + 1
  call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg, form='UnfORMatteD')
  if (iostat/=0.and..not.is_iostat_eor(iostat)) then
    write(stdout, "(A)")iomsg
    exit
  else
    test_passed(l+3) = (astring==line(l))
    write(stdout, "(A,L1)") 'line: "'//astring//'", is correct? ', test_passed(l+3)
  endif
enddo

close(scratch)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram read_line
