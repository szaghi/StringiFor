program pad_a_string
!< Pad to a width.
use stringifor
implicit none
type(string) :: s

s = '42'
print '(A)', s%fill(width=6)//''                             ! zeros on the left
print '(A)', s%fill(width=6, right=.true.)//''
print '(A)', s%fill(width=6, filling_char='.')//''
s = 'name'
print '(A)', '['//s%fill(width=10, right=.true., filling_char=' ')//']'
endprogram pad_a_string
