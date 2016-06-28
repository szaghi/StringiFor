!< StringiFor `replace` test.
program replace
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `replace` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(3) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'When YOU are sad YOU should think to me :-)'
write(stdout, "(A)") 'Original:                                 "'//astring//'"'

test_passed(1) = (astring%replace(old='YOU', new='THEY')//''=='When THEY are sad THEY should think to me :-)')
write(stdout, "(A)") 'Replace "YOU" with "THEY":                "'//astring%replace(old='YOU', new='THEY')//'"'

test_passed(2) = (astring%replace(old='YOU', new='THEY', count=1)//''=='When THEY are sad YOU should think to me :-)')
write(stdout, "(A)") 'Replace only the first "YOU" with "THEY": "'//astring%replace(old='YOU', new='THEY', count=1)//'"'

astring = repeat(new_line('a')//'abcd', 20)
write(stdout, "(A)") 'Original new_line test: "'//astring//'"'
astring = astring%replace(old=new_line('a'), new='|cr|')
astring = astring%replace(old='|cr|', new=new_line('a')//'    ')
test_passed(3) = (astring//''==repeat(new_line('a')//'    '//'abcd', 20))
write(stdout, "(A)") 'Replace "new_line" with "new_line+indent": "'//astring//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram replace
