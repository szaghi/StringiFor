program operators
!< Assignment, concatenation and comparison.
use stringifor
implicit none
type(string)              :: a, b, c
character(:), allocatable :: chars

a = 'Hello'                  ! from a character
b = a                        ! from a string
c = a//' '//'World'          ! // gives a character, assigned to a string
chars = a//' again'          ! or kept as a character
c = a .cat. ' World'         ! .cat. gives a string
print '(A)', c//''
print '(A)', chars
print '(3(L1,1X))', a == b, a == 'Hello', a /= c
print '(3(L1,1X))', a < c, 'Apple' < a, a >= b
endprogram operators
