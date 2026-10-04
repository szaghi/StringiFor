program unit_io
!< Lines written to and read from a unit already open.
use stringifor
implicit none
type(string)              :: line, text
type(string), allocatable :: lines(:)
integer                   :: unit, l

open(newunit=unit, file='notes.txt', status='replace')
line = 'first line'
call line%write_line(unit=unit)                       ! one string, one line
text = 'second line'//new_line('a')//'third line'
call text%write_lines(unit=unit)                      ! one string, a line for each line it holds
call read_lines(unit=unit, lines=lines)               ! rewinds the unit, one string for each line
close(unit, status='delete')
do l = 1, size(lines)
  print '(I0,A)', l, ': '//lines(l)
enddo
endprogram unit_io
