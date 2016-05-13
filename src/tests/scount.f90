!< StringiFor `count_string` test.
program count_string
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `count_string` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
integer      :: No             !< Number of occurences.
logical      :: test_passed(3) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '   Hello World!'
write(stdout, "(A)") 'Original: "'//astring//'"'

No = astring%count(substring=' ', ignore_isolated=.true.)
test_passed(1) = No==3
write(stdout, "(A,I1,A,L1)") 'Count " " ignore isolated: "', No,'", is correct? ', test_passed(1)

No = astring%count(substring=' ')
test_passed(2) = No==4
write(stdout, "(A,I1,A,L1)") 'Count " ": "', No,'", is correct? ', test_passed(2)

No = astring%count(substring='l')
test_passed(3) = No==3
write(stdout, "(A,I1,A,L1)") 'Count "l": "', No,'", is correct? ', test_passed(3)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram count_string
