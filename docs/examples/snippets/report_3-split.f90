row = '1999, Chevy, Venture, 4900.50, extended edition'
call row%split(tokens=cells, sep=',')
print '(I0,A)', size(cells), ' cells'
cells = cells%strip()                             ! elemental: every cell at once
do c = 1, size(cells)
  print '(I0,A)', c, ': ['//cells(c)//']'
enddo
