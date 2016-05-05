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
type(string)                  :: astring          !< A string.
type(string)                  :: anotherstring    !< Another string.
type(string)                  :: yetanotherstring !< Yet another string.
character(len=:), allocatable :: acharacter       !< A character.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
astring = 'Hello '
anotherstring = 'Bye bye'
acharacter = 'World!'
write(stdout, "(A)") astring//acharacter
write(stdout, "(A)") acharacter//astring
write(stdout, "(A)") astring//anotherstring
yetanotherstring = astring.cat.acharacter
write(stdout, "(A)") yetanotherstring%chars()
yetanotherstring = acharacter.cat.astring
write(stdout, "(A)") yetanotherstring%chars()
yetanotherstring = astring.cat.anotherstring
write(stdout, "(A)") yetanotherstring%chars()
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram concatenation
