!< StringiFor `unique` test.
program unique
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `unique` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)              :: astring        !< A string.
type(string), allocatable :: strings(:)     !< A set of strings.
integer                   :: s              !< Counter.
logical                   :: test_passed(1) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

write(stdout, "(A)") new_line('A')//'Unique'
astring = '+++ab-++cre-++cre-ab+++++'
write(stdout, "(A)") 'Original: "'//astring//'"'
test_passed(1) = astring%unique(substring='+')//''=='+ab-+cre-+cre-ab+'
write(stdout, "(A)") 'Unique:   "'//astring%unique(substring='+')//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram unique
