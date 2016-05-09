!< StringiFor `sadjustlr` test.
program sadjustlr
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `sadjustlr` test.
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

astring = '   Hello World!'
write(stdout, "(A)") 'Original: "'//astring//'"'
test_passed(1) = astring%sadjustl()//''=='Hello World!   '
write(stdout, "(A)") 'AdjustL:  "'//astring%sadjustl()//'"'

astring = 'Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'
test_passed(2) = astring%sadjustr()//''=='   Hello World!'
write(stdout, "(A)") 'AdjustR:  "'//astring%sadjustr()//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram sadjustlr
