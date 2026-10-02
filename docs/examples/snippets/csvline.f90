program csv_line
!< Parse a line of comma-separated values.
use stringifor
implicit none
type(string)              :: line
type(string), allocatable :: cells(:)
real(R8P)                 :: total
integer                   :: c

line = ' 12.5 , 7 ,  n/a, 30.25 '
call line%split(tokens=cells, sep=',')
cells = cells%strip()                           ! every cell at once
total = 0._R8P
do c = 1, size(cells)
  if (cells(c)%is_number()) total = total + cells(c)%to_number(kind=1._R8P)
enddo
print '(I0,A,F0.2)', size(cells), ' cells, the numbers sum to ', total
endprogram csv_line
