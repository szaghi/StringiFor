!< StringiFor `is_real` test.
program is_real
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `is_real` test.
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

astring = '   -1212112.d0 '
test_passed(1) = astring%is_real().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is real? ', astring%is_real()

astring = '   -1212112.d0'
test_passed(2) = astring%is_real(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is real (no spaces allowed)? ', astring%is_real(allow_spaces=.false.)

astring = '-1212112.d0   '
test_passed(3) = astring%is_real(allow_spaces=.false.).eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is real (no spaces allowed)? ', astring%is_real(allow_spaces=.false.)

astring = '+2.e20'
test_passed(4) = astring%is_real().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is real? ', astring%is_real()

astring = ' -2.01E13 '
test_passed(5) = astring%is_real().eqv..true.
write(stdout, "(A,L1)") '"'//astring//'" is real? ', astring%is_real()

astring = ' -2.01 E13 '
test_passed(6) = astring%is_real().eqv..false.
write(stdout, "(A,L1)") '"'//astring//'" is real? ', astring%is_real()

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram is_real
