!< StringiFor `sadjustlr` test.
program sadjustlr
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `sadjustlr` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(4) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '   Hello World!'
write(stdout, "(A)") 'Original: "'//astring//'"'

test_passed(1) = astring%adjustl()//''=='Hello World!   '
write(stdout, "(A,L1)") 'AdjustL:  "'//astring%adjustl()//'", is correct? ', test_passed(1)

test_passed(2) = adjustl(astring)//''=='Hello World!   '
write(stdout, "(A,L1)") 'AdjustL (builtin):  "'//adjustl(astring)//'", is correct? ', test_passed(2)

astring = 'Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'

test_passed(3) = astring%adjustr()//''=='   Hello World!'
write(stdout, "(A,L1)") 'AdjustR:  "'//astring%adjustr()//'", is correct? ', test_passed(3)

test_passed(4) = adjustr(astring)//''=='   Hello World!'
write(stdout, "(A,L1)") 'AdjustR (builtin):  "'//adjustr(astring)//'", is correct? ', test_passed(4)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram sadjustlr
