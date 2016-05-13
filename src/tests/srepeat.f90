!< StringiFor `srepeat` test.
program srepeat
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `srepeat` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(3) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.
astring = 'x'

test_passed(1) = astring%repeat(rstring='x', ncopies=5)//''=='xxxxx'
write(stdout, "(A,L1)") 'Repeat x 5 times: "'//astring%repeat(rstring='x', ncopies=5)//'", is correct? ', test_passed(1)

test_passed(2) = astring%repeat(ncopies=5)//''=='xxxxx'
write(stdout, "(A,L1)") 'Repeat (self) x 5 times: "'//astring%repeat(ncopies=5)//'", is correct? ', test_passed(2)

test_passed(3) = repeat(astring, 5)//''=='xxxxx'
write(stdout, "(A,L1)") 'Repeat (builtin) x 5 times: "'//repeat(astring, 5)//'", is correct? ', test_passed(3)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram srepeat
