!< StringiFor `swapcase` test.
program swapcase
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `swapcase` test.
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

write(stdout, "(A)") new_line('A')//'Swapcase'
astring = '  Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'
test_passed(1) = astring%swapcase()//''=='  hELLO wORLD!   '
write(stdout, "(A)") 'Swapcase: "'//astring%swapcase()//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram swapcase
