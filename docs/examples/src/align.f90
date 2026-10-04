!run align align
program align
!< Strings centered or justified in a given width.
use stringifor
implicit none
type(string) :: s

s = 'title'
print '(A)', '['//s%center(11)//']'
print '(A)', '['//s%center(11, '=')//']'
print '(A)', '['//s%ljust(11, '.')//']'
print '(A)', '['//s%rjust(11)//']'
print '(A)', '['//s%center(3)//']'
endprogram align
