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
#ifndef __GFORTRAN__
type(string)                  :: astring        !< A string.
character(len=:), allocatable :: acharacter     !< A character.
integer                       :: iostat         !< IO status code.
character(len=99)             :: iomsg          !< IO status message.
#endif
logical                       :: test_passed(2) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

#ifndef __GFORTRAN__
astring = 'Hello World!'
acharacter = 'New Hello World!'

write(stdout, "(DT)", iostat=iostat, iomsg=iomsg) astring
test_passed(1) = iostat==0
if (iostat/=0) print "(A)", iomsg

read(acharacter, "(DT)", iostat=iostat, iomsg=iomsg) astring
test_passed(2) = iostat==0
if (iostat/=0) print "(A)", iomsg

print "(DT)", astring
#else
! GNU gfortran does not support defined IO
test_passed = .true.
#endif

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram io_basic
