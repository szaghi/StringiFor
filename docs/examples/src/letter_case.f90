!run letter_case letter_case
program case_conversion
!< Upper, lower and the like.
use stringifor
implicit none
type(string) :: s

s = 'Hello World'
print '(A)', s%upper()//''
print '(A)', s%lower()//''
print '(A)', s%swapcase()//''
print '(A)', s%capitalize()//''
print '(2(L1,1X))', s%is_upper(), s%is_lower()
endprogram case_conversion
