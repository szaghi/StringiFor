!< StringiFor `upper_lower` test.
program upper_lower
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `upper_lower` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring          !< A string.
logical      :: test_passed(1:8) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring    = 'Hello WorLD!'
test_passed(1) = astring%upper()//''=='HELLO WORLD!'
test_passed(2) = astring%lower()//''=='hello world!'
write(stdout, "(A)")    'Original: "'//astring//'"'
write(stdout, "(A,L1)") 'UPPER:    "'//astring%upper()//'". Is correct? ', test_passed(1)
write(stdout, "(A,L1)") 'lower:    "'//astring%lower()//'". Is correct? ', test_passed(2)

astring = ' Hello World'
test_passed(3) = astring%is_upper().eqv..false.
test_passed(4) = astring%is_lower().eqv..false.
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A,L1,A,L1)") 'Is UPPER? ', astring%is_upper(), '. Is correct? ', test_passed(3)
write(stdout, "(A,L1,A,L1)") 'Is lower? ', astring%is_lower(), '. Is correct? ', test_passed(4)

astring = ' HELLO WORLD'
test_passed(5) = astring%is_upper().eqv..true.
test_passed(6) = astring%is_lower().eqv..false.
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A,L1,A,L1)") 'Is UPPER? ', astring%is_upper(), '. Is correct? ', test_passed(5)
write(stdout, "(A,L1,A,L1)") 'Is lower? ', astring%is_lower(), '. Is correct? ', test_passed(6)

astring = ' hello world'
test_passed(7) = astring%is_upper().eqv..false.
test_passed(8) = astring%is_lower().eqv..true.
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A,L1,A,L1)") 'Is UPPER? ', astring%is_upper(), '. Is correct? ', test_passed(7)
write(stdout, "(A,L1,A,L1)") 'Is lower? ', astring%is_lower(), '. Is correct? ', test_passed(8)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram upper_lower
