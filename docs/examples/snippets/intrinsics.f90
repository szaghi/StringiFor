program intrinsics_on_strings
!< The Fortran intrinsics, on strings.
use stringifor
implicit none
type(string) :: s

s = '  hello  '
print '(A)', '['//trim(s)//']'
print '(A)', '['//adjustl(s)//']'
print '(I0)', len_trim(s)
print '(I0)', index(s, 'll')
print '(A)', repeat(s%strip(), 3)//''
endprogram intrinsics_on_strings
