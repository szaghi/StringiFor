!as report
!run report_6 report data/cars.csv
!image report_6
program report
!< Tutorial, chapter 6: a polished report.
use stringifor
implicit none
type(string)              :: glue, title, cheapest
type(string), allocatable :: rows(:), cells(:), lines(:)
character(256)            :: argument
real(R8P)                 :: price, lowest
integer                   :: r, l

call get_command_argument(1, argument)
call read_file(file=trim(argument), lines=rows)

!region title
title = 'cars report'
title = title%startcase()
print '(A)', title%colorize(color_fg='cyan', style='bold_on')
print '(A)', repeat('=', title%len())
!endregion title

!region table
lowest = huge(1._R8P)
do r = 2, size(rows)
  call rows(r)%split(tokens=cells, sep=',')
  cells = cells%strip()
  price = cells(4)%to_number(kind=1._R8P)
  if (price < lowest) then
    lowest = price
    cheapest = rows(r)
  endif
  cells(4) = nint(price)                          ! a number into a string: +3000
  cells(4) = cells(4)%slice(first=2)              ! without the sign
  print '(A)', cells(1)//'  '//cells(2)%fill(width=6, right=.true., filling_char=' ')// &
               cells(3)%fill(width=8, right=.true., filling_char=' ')//cells(4)%fill(width=6, filling_char='.')
enddo
!endregion table

!region notes
call cheapest%split(tokens=cells, sep=',')
cells = cells%strip()
print '(A)', ''
print '(A)', 'The cheapest is the '//glue%join(array=cells(2:3), sep=' ')//':'
call cells(5)%justify(lines=lines, width=30)
do l = 1, size(lines)
  print '(A)', '  '//lines(l)%colorize(style='italics_on')
enddo
!endregion notes
endprogram report
