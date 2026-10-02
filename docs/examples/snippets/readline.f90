program read_line_by_line
!< Read a file one line at a time.
use stringifor
implicit none
type(string) :: line
integer      :: unit, iostat, n

n = 0
open(newunit=unit, file='poem.txt', status='old', action='read')
do
  call line%read_line(unit=unit, iostat=iostat)
  if (iostat /= 0) exit                           ! the end of the file, or an error
  n = n + 1
  print '(I0,A)', n, ': ['//line//']'
enddo
close(unit)
endprogram read_line_by_line
