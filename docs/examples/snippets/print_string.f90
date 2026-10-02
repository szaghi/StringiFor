program print_a_string
!< Three ways to print a string.
use stringifor
implicit none
type(string) :: s

s = 'Hello World'
print '(A)', s//''          ! concatenation gives a character
print '(A)', s%chars()      ! the raw characters
print '(DT)', s             ! defined I/O
endprogram print_a_string
