program csv_line
!< Parse a line of comma-separated values, empty cells included.
use stringifor
implicit none
type(string)              :: line
type(string), allocatable :: cells(:)
real(R8P)                 :: value, total
integer                   :: c, iostat, bad

line = ' 12.5 , 7 ,  n/a,, 30.25 '
call line%split(tokens=cells, sep=',', keep_empty=.true.)  ! the empty cell keeps its column
cells = cells%strip()                                      ! every cell at once
total = 0._R8P
bad = 0
do c = 1, size(cells)
  call cells(c)%read_number(value, iostat=iostat)
  if (iostat == 0) then
    total = total + value
  else
    bad = bad + 1
  endif
enddo
print '(I0,A,F0.2,A,I0,A)', size(cells), ' cells, the numbers sum to ', total, ', ', bad, ' are not numbers'
endprogram csv_line
