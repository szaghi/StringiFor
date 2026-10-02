program number_cast
!< From a string to a number.
use stringifor
implicit none
type(string) :: s
real(R8P)    :: x
integer(I4P) :: n

s = '3.4e2'
if (s%is_number()) x = s%to_number(kind=1._R8P)   ! the kind of the argument selects the result
print '(F0.1)', x
s = '42'
if (s%is_integer()) n = s%to_number(kind=1_I4P)
print '(I0)', n + 1
x = s%to_number(kind=1._R8P)                      ! an integer string is a valid real
print '(F0.1)', x
endprogram number_cast
