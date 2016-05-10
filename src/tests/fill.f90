!< StringiFor `fill` test.
program fill
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `fill` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(4) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'this is string example....wow!!!'
write(stdout, "(A)") 'Original:  "'//astring//'"'

test_passed(1) = astring%fill(width=40)//''=='00000000this is string example....wow!!!'
write(stdout, "(A)") 'Fill (w=40): "'//astring%fill(width=40)//'"'

test_passed(2) = astring%fill(width=50)//''=='000000000000000000this is string example....wow!!!'
write(stdout, "(A)") 'Fill (w=50): "'//astring%fill(width=50)//'"'

test_passed(3) = astring%fill(width=50, right=.true.)//''=='this is string example....wow!!!000000000000000000'
write(stdout, "(A)") 'Fill (w=50, right): "'//astring%fill(width=50, right=.true.)//'"'

test_passed(4) = astring%fill(width=40, filling_char='*')//''=='********this is string example....wow!!!'
write(stdout, "(A)") 'Fill (w=40, fc=*): "'//astring%fill(width=40, filling_char='*')//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram fill
