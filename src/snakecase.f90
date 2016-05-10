!< StringiFor `snakecase` test.
program snakecase
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `snakecase` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(1) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
test_passed(1) = astring%snakecase()//''=='the_quick_brown_fox_jumps_over_the_lazy_dog.'
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A)") 'Startcase: "'//astring%snakecase()//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram snakecase
