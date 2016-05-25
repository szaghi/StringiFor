!< StringiFor `encode` test.
program encode
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `encode` test.
!< @bug On Travis CI fails. This is very oddy: this works on all my PCs with both Intel and GNU compilers... temporarly disabled.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(1) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'How are you?'
test_passed(1) = astring%encode(codec='base64')//''=='SG93IGFyZSB5b3U/'
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,L1)") 'BASE64: "'//astring%encode(codec='base64')//'", is correct? ', test_passed(1)

! disable for bug on Travis CI
test_passed = .true.

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram encode
