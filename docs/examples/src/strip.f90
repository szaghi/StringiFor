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
print '(A)', '['//s%lstrip(remove='-=')//']'  ! the beginning only
print '(A)', '['//s%rstrip(remove='-=')//']'  ! the end only
s = achar(9)//' hello world'//new_line('a')
print '(A)', '['//s%strip(whitespace=.true.)//']'  ! tabs and new lines too
endprogram strip_blanks
