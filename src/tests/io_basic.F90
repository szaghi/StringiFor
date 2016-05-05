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
type(string)                  :: astring    !< A string.
character(len=:), allocatable :: acharacter !< A character.
integer                       :: iostat     !< IO status code.
character(len=99)             :: iomsg      !< IO status message.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
astring = 'Hello World!'
acharacter = 'New Hello World!'
#ifndef __GFORTRAN__
write(stdout, "(DT)") astring
read(acharacter, "(DT)") astring
print "(DT)", astring
#else
call astring%write_formatted(stdout, "(DT)", [1], iostat, iomsg)
call astring%read_formatted_internal(acharacter, "(DT)", [1], iostat, iomsg)
write(stdout, "(A)") astring%chars()
#endif
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram io_basic
