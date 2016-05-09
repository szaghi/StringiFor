!< StringiFor `is_integer` test.
program is_integer
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `is_integer` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(6) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '   -1212112 '
test_passed(1) = astring%is_integer().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is integer? ', astring%is_integer()

astring = '   -1212112'
test_passed(2) = astring%is_integer(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is integer (no spaces allowed)? ', astring%is_integer(allow_spaces=.false.)

astring = '-1212112   '
test_passed(3) = astring%is_integer(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is integer (no spaces allowed)? ', astring%is_integer(allow_spaces=.false.)

astring = '+2e20'
test_passed(4) = astring%is_integer().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is integer? ', astring%is_integer()

astring = ' -2E13 '
test_passed(5) = astring%is_integer().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is integer? ', astring%is_integer()

astring = ' -2 E13 '
test_passed(6) = astring%is_integer().eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is integer? ', astring%is_integer()

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram is_integer
