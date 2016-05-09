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
logical                       :: test_passed(6)   !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'Hello '
anotherstring = 'Bye bye'
acharacter = 'World!'

write(stdout, "(A)") 'Original: "'//astring//'"+"'//acharacter//'"'
test_passed(1) = astring//acharacter=='Hello World!'
write(stdout, "(A)") astring//acharacter

test_passed(2) = acharacter//astring=='World!Hello '
write(stdout, "(A)") 'Original: "'//acharacter//'"+"'//astring//'"'
write(stdout, "(A)") acharacter//astring

test_passed(3) = astring//anotherstring=='Hello Bye bye'
write(stdout, "(A)") 'Original: "'//astring//'"+"'//anotherstring//'"'
write(stdout, "(A)") astring//anotherstring

yetanotherstring = astring.cat.acharacter
test_passed(4) = yetanotherstring%chars()=='Hello World!'
write(stdout, "(A)") 'Original: "'//astring//'"+"'//acharacter//'"'
write(stdout, "(A)") yetanotherstring%chars()

yetanotherstring = acharacter.cat.astring
test_passed(5) = yetanotherstring%chars()=='World!Hello '
write(stdout, "(A)") 'Original: "'//acharacter//'"+"'//astring//'"'
write(stdout, "(A)") yetanotherstring%chars()

yetanotherstring = astring.cat.anotherstring
test_passed(6) = yetanotherstring%chars()=='Hello Bye bye'
write(stdout, "(A)") 'Original: "'//astring//'"+"'//anotherstring//'"'
write(stdout, "(A)") yetanotherstring%chars()

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram concatenation
