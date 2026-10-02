!run escape escape
program escape_characters
!< Escape a character, and back.
use stringifor
implicit none
type(string) :: s, escaped

s = 'C:\temp\new'
escaped = s%escape(to_escape='\')
print '(A)', escaped//''
print '(A)', escaped%unescape(to_unescape='\')//''
endprogram escape_characters
