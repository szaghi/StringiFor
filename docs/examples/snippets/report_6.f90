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

title = 'cars report'
title = title%startcase()
print '(A)', title%colorize(color_fg='cyan', style='bold_on')
print '(A)', repeat('=', title%len())

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
  print '(A)', cells(1)//'  '//cells(2)%ljust(6)//cells(3)%ljust(8)//cells(4)%rjust(6, '.')
enddo

call cheapest%split(tokens=cells, sep=',')
cells = cells%strip()
print '(A)', ''
print '(A)', 'The cheapest is the '//glue%join(array=cells(2:3), sep=' ')//':'
call cells(5)%justify(lines=lines, width=30)
do l = 1, size(lines)
  print '(A)', '  '//lines(l)%colorize(style='italics_on')
enddo
endprogram report
