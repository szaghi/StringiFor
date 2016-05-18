!< StringiFor `read_lines` test.
program read_lines
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `read_lines` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit, iostat_end
use stringifor, only : read_lines_standalone => read_lines, string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)              :: astring         !< A string.
type(string), allocatable :: strings(:)      !< A set of strings.
type(string)              :: line(3)         !< Another set of string.
integer                   :: iostat          !< IO status code.
character(len=99)         :: iomsg           !< IO status message.
integer                   :: scratch         !< Scratch file unit.
integer                   :: l               !< Counter.
logical                   :: test_passed(16) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

line(1) = ' Hello World!   '
line(2) = 'How are you?  '
line(3) = '   All say: "Fine thanks"'

open(newunit=scratch, status='SCRATCH')
write(scratch, "(A)") line(1)%chars()
write(scratch, "(A)") line(2)%chars()
write(scratch, "(A)") line(3)%chars()

write(stdout, "(A)") "TBP read_lines"
call astring%read_lines(unit=scratch, iostat=iostat, iomsg=iomsg)
call astring%split(tokens=strings, sep=new_line('a'))
test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
do l=1, size(strings, dim=1)
  test_passed(l+1) = (strings(l)==line(l))
  write(stdout, "(A,L1)") 'line: "'//strings(l)//'", is correct? ', test_passed(l+1)
enddo

write(stdout, "(A)") "Standalone read_lines"
call read_lines_standalone(unit=scratch, lines=strings, iostat=iostat, iomsg=iomsg)
if (iostat/=0.and..not.is_iostat_eor(iostat).and.iostat/=iostat_end) write(stdout, "(A)")iomsg
test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
do l=1, size(strings, dim=1)
  test_passed(l+5) = (strings(l)==line(l))
  write(stdout, "(A,L1)") 'line: "'//strings(l)//'", is correct? ', test_passed(l+5)
enddo

close(scratch)

open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
write(scratch) line(1)%chars()//new_line('a')
write(scratch) line(2)%chars()//new_line('a')
write(scratch) line(3)%chars()//new_line('a')

write(stdout, "(A)") "TBP read_lines unformatted"
call astring%read_lines(unit=scratch, form='unformatted', iostat=iostat, iomsg=iomsg)
call astring%split(tokens=strings, sep=new_line('a'))
test_passed(9) = (size(strings, dim=1)==size(line, dim=1))
do l=1, size(strings, dim=1)
  test_passed(l+9) = (strings(l)==line(l))
  write(stdout, "(A,L1)") 'line: "'//strings(l)//'", is correct? ', test_passed(l+9)
enddo

write(stdout, "(A)") "Standalone read_lines unformatted"
call read_lines_standalone(unit=scratch, lines=strings, form='unformatted', iostat=iostat, iomsg=iomsg)
if (iostat/=0.and..not.is_iostat_eor(iostat).and.iostat/=iostat_end) write(stdout, "(A)")iomsg
test_passed(13) = (size(strings, dim=1)==size(line, dim=1))
do l=1, size(strings, dim=1)
  test_passed(l+13) = (strings(l)==line(l))
  write(stdout, "(A,L1)") 'line: "'//strings(l)//'", is correct? ', test_passed(l+13)
enddo

close(scratch)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram read_lines
