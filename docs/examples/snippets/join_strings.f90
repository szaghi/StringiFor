program join_strings
!< Join an array into one string.
use stringifor
implicit none
type(string) :: glue, words(3), joined
character(5) :: chars(3)

words(1) = 'one' ; words(2) = 'two' ; words(3) = 'three'
glue = ', '
joined = glue%join(array=words)                 ! the string is the separator
print '(A)', joined//''
print '(A)', glue%join(array=words, sep='-')//'' ! or pass one

chars = ['alpha', 'beta ', 'gamma']
joined = strjoin(array=chars, sep='+')          ! no separator string needed; characters are trimmed
print '(A)', joined//''
endprogram join_strings
