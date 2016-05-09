!< StringiFor `is_number` test.
program is_number
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `is_number` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(7) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '   -1212112 '
test_passed(1) = astring%is_number().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is number? ', astring%is_number()

astring = '   -121.2112 '
test_passed(2) = astring%is_number().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is number? ', astring%is_number()

astring = '   -1212112'
test_passed(3) = astring%is_number(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is number (no spaces allowed)? ', astring%is_number(allow_spaces=.false.)

astring = '-12121.12   '
test_passed(4) = astring%is_number(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is number (no spaces allowed)? ', astring%is_number(allow_spaces=.false.)

astring = '+2e20'
test_passed(5) = astring%is_number().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is number? ', astring%is_number()

astring = ' -2.4E13 '
test_passed(6) = astring%is_number().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is number? ', astring%is_number()

astring = ' -2 E13 '
test_passed(7) = astring%is_number().eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is number? ', astring%is_number()

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram is_number
