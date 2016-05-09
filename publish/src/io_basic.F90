!< StringiFor `io_basic` test.
program io_basic
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `io_basic` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring        !< A string.
character(len=:), allocatable :: acharacter     !< A character.
integer                       :: iostat         !< IO status code.
character(len=99)             :: iomsg          !< IO status message.
logical                       :: test_passed(2) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'Hello World!'
acharacter = 'New Hello World!'
#ifndef __GFORTRAN__
write(stdout, "(DT)", iostat=iostat) astring
test_passed(1) = iostat==0

read(acharacter, "(DT)", iostat=iostat) astring
test_passed(2) = iostat==0
print "(DT)", astring
#else
call astring%write_formatted(stdout, "(DT)", [1], iostat, iomsg)
test_passed(1) = iostat==0
call astring%read_formatted_internal(acharacter, "(DT)", [1], iostat, iomsg)
test_passed(2) = iostat==0
write(stdout, "(A)") astring%chars()
#endif

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram io_basic
