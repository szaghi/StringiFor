program replace_text
!< Replace, collapse, insert.
use stringifor
implicit none
type(string) :: s

s = 'a-b-c-d'
print '(A)', s%replace(old='-', new=' + ')//''
print '(A)', s%replace(old='-', new='', count=2)//''   ! the first two only
s = 'too    many     blanks'
print '(A)', s%unique(' ')//''
s = 'Helo'
print '(A)', s%insert(substring='l', pos=3)//''
endprogram replace_text
