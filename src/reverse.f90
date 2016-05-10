!< StringiFor `reverse` test.
program reverse
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `reverse` test.
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

astring = 'abcdefghilmnopqrstuvz'
test_passed(1) = (astring%reverse()//''=='zvutsrqponmlihgfedcba')
write(stdout, "(A,L1)") 'Original:  "'//astring//'", reversed: "'//astring%reverse()//'", is correct? ', &
  astring%reverse()//''=='zvutsrqponmlihgfedcba'

astring = '0123456789'
test_passed(2) = (astring%reverse()//''=='9876543210')
write(stdout, "(A,L1)") 'Original:  "'//astring//'", reversed: "'//astring%reverse()//'", is correct? ', &
  astring%reverse()//''=='9876543210'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram reverse
