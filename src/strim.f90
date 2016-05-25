!< StringiFor `strim` test.
program strim
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `strim` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(2) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'

test_passed(1) = astring%trim()//''=='Hello World!'
write(stdout, "(A,L1)") 'Trimmed:  "'//astring%trim()//'", is correct? ', test_passed(1)

test_passed(2) = trim(astring)//''=='Hello World!'
write(stdout, "(A,L1)") 'Trimmed (builtin):  "'//trim(astring)//'", is correct? ', test_passed(2)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram strim
