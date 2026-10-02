program base64
!< Encode and decode in base64.
use stringifor
implicit none
type(string) :: s, code

s = 'Hello World'
code = s%encode(codec='base64')
print '(A)', code//''
print '(A)', code%decode(codec='base64')//''
endprogram base64
