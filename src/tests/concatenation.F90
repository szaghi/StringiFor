!< StringiFor `concatenation` test.
program concatenation
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `concatenation` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring       !< A string.
type(string)                  :: anotherstring !< Another string.
character(len=:), allocatable :: acharacter    !< A character.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
astring = 'Hello '
anotherstring = 'Bye bye'
acharacter = 'World!'
#ifndef __GFORTRAN__
write(stdout, "(DT)") astring//acharacter
write(stdout, "(DT)") acharacter//astring
write(stdout, "(DT)") astring//anotherstring
#else
astring = astring//acharacter
write(stdout, "(A)") astring%chars()
astring = acharacter//astring
write(stdout, "(A)") astring%chars()
astring = astring//anotherstring
write(stdout, "(A)") astring%chars()
#endif
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram concatenation

