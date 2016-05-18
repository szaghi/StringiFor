!< StringiFor `unescape` test.
program unescape
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `unescape` test.
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

astring = '^\\s \\d+\\s*'
write(stdout, "(A)") 'Original:  "'//astring//'"'

test_passed(1) = (astring%unescape(to_unescape='\')//''=='^\s \d+\s*')
write(stdout, "(A)") 'Escaped: "'//astring%unescape(to_unescape='\')//'"'

test_passed(2) = (astring%unescape(to_unescape='s')//''=='^\s \\d+\s*')
write(stdout, "(A)") 'Escaped: "'//astring%unescape(to_unescape='s')//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram unescape
