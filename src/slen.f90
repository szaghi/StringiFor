!< StringiFor `slen` test.
program slen
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `slen` test.
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

astring = 'Hello World!   '

write(stdout, "(A)") 'Original: "'//astring//'"'

test_passed(1) = astring%slen()==len('Hello World!   ')
write(stdout, "(A,I2,A,L1)") 'Slen: ', astring%slen(), ' is correct? ', test_passed(1)

test_passed(2) = astring%slen_trim()==len_trim('Hello World!   ')
write(stdout, "(A,I2,A,L1)") 'Slen_trim: ', astring%slen_trim(), ' is correct? ', test_passed(2)

test_passed(3) = len(astring)==len('Hello World!   ')
write(stdout, "(A,I2,A,L1)") 'Len: ', len(astring), ' is correct? ', test_passed(3)

test_passed(4) = len_trim(astring)==len_trim('Hello World!   ')
write(stdout, "(A,I2,A,L1)") 'Len_trim: ', len_trim(astring), ' is correct? ', test_passed(4)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram slen
