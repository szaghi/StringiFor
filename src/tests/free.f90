!< StringiFor `free` test.
program free
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `free` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(2) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'say all Hello WorLD!'
write(stdout, "(A)") 'Original: "'//astring//'"'
test_passed(1) = astring%is_allocated().eqv..true.
write(stdout, "(A,L1)") 'Is allocated? ', astring%is_allocated()

call astring%free
test_passed(2) = astring%is_allocated().eqv..false.
write(stdout, "(A,L1)") 'Is allocated? ', astring%is_allocated()

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram free
