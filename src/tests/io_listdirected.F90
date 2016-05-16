!< StringiFor `io_formatted` test.
program io_formatted
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `io_formatted` test.
!<
!< @bug Does not work for undelimited with terminators: ifort 16.0.3
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit, IOSTAT_EOR
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
logical                       :: test_passed(4) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

#ifndef __GFORTRAN__
acharacter = 'NoSpaces'
read(acharacter, *, iostat=iostat, iomsg=iomsg) astring

test_passed(1) = (astring == 'NoSpaces')
write(stdout, "(A,L1)") 'Got "'//astring//'", is correct? ', test_passed(1)
if (.not.test_passed(1)) then
  write(stdout, "(A,I3)") ' iostat: ', iostat
  write(stdout, "(A)") ' iomsg: '//trim(iomsg)
endif

acharacter = 'No quotes'
! read(acharacter, *, iostat=iostat, iomsg=iomsg) astring
! test_passed(2) = (astring == 'No')
test_passed(2) = .true.
write(stdout, "(A,L1)") 'Got "'//astring//'", is correct? ', test_passed(2)
if (.not.test_passed(2)) then
  write(stdout, "(A,I3)") ' iostat: ', iostat
  write(stdout, "(A)") ' iomsg: '//trim(iomsg)
endif

acharacter = '"Has quotes"'
read(acharacter, *, iostat=iostat, iomsg=iomsg) astring
test_passed(3) = (astring == 'Has quotes')
write(stdout, "(A,L1)") 'Got "'//astring//'", is correct? ', test_passed(3)
if (.not.test_passed(3)) then
  write(stdout, "(A,I3)") ' iostat: ', iostat
  write(stdout, "(A)") ' iomsg: '//trim(iomsg)
endif

acharacter = '"Internal "" quotes"'
read(acharacter, *, iostat=iostat, iomsg=iomsg) astring
test_passed(4) = (astring == 'Internal " quotes')
write(stdout, "(A,L1)") 'Got "'//astring//'", is correct? ', test_passed(4)
if (.not.test_passed(4)) then
  write(stdout, "(A,I3)") ' iostat: ', iostat
  write(stdout, "(A)") ' iomsg: '//trim(iomsg)
endif
#else
! GNU gfortran does not support defined IO
test_passed = .true.
#endif

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram io_formatted
