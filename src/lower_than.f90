!< StringiFor `lower_than` test.
program lower_than
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `lower_than` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring        !< A string.
type(string)                  :: anotherstring  !< A string.
character(len=:), allocatable :: acharacter     !< A character.
logical                       :: test_passed(6) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'one'
anotherstring = 'ONE'
acharacter = 'ONE'
test_passed(1) = ((astring<anotherstring).eqv..false.)
write(stdout, "(A,L1)") 'Test "'//astring//'<'//anotherstring//'", test passed? ', test_passed(1)
test_passed(2) = ((astring<acharacter).eqv..false.)
write(stdout, "(A,L1)") 'Test "'//astring//'<'//acharacter//'", test passed? ', test_passed(2)
test_passed(3) = ((acharacter<astring).eqv..true.)
write(stdout, "(A,L1)") 'Test "'//acharacter//'<'//astring//'", test passed? ', test_passed(3)

astring = 'ONE'
anotherstring = 'one'
acharacter = 'one'
test_passed(4) = ((astring<anotherstring).eqv..true.)
write(stdout, "(A,L1)") 'Test "'//astring//'<'//anotherstring//'", test passed? ', test_passed(4)
test_passed(5) = ((astring<acharacter).eqv..true.)
write(stdout, "(A,L1)") 'Test "'//astring//'<'//acharacter//'", test passed? ', test_passed(5)
test_passed(6) = ((acharacter<astring).eqv..false.)
write(stdout, "(A,L1)") 'Test "'//acharacter//'<'//astring//'", test passed? ', test_passed(6)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram lower_than
