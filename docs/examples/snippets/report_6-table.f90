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
