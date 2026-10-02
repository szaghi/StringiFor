!run strip strip
program strip_blanks
!< Remove what surrounds a string.
use stringifor
implicit none
type(string) :: s

s = '   hello world   '
print '(A)', '['//s%strip()//']'              ! both ends
print '(A)', '['//s%trim()//']'               ! the end only
print '(A)', '['//s%adjustl()//']'            ! moved to the left, same length
s = '--=hello world=--'
print '(A)', '['//s%strip(remove='-=')//']'   ! any character of a set
endprogram strip_blanks
