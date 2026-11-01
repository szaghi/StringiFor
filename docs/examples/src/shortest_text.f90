!run shortest_text shortest_text
program shortest_text
!< A real as the shortest text that reads back as exactly that number, against the assignment.
use stringifor
implicit none
real(R8P)    :: values(5)
type(string) :: full
type(string) :: short
integer      :: v

values = [0.1_R8P, 100._R8P, 1.e23_R8P, 1.5e-7_R8P, -2.5_R8P]
do v = 1, size(values)
  full = values(v)
  short = shortest(values(v))
  print '(A,1X,A)', full%chars(), short%chars()
enddo
if (short%to_number(1._R8P) == values(5)) print '(A)', 'it reads back as the same number'
endprogram shortest_text
