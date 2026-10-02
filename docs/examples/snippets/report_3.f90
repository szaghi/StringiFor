program report
!< Tutorial, chapter 3: splitting and joining.
use stringifor
implicit none
type(string)              :: row, glue, pieces(3)
type(string), allocatable :: cells(:)
integer                   :: c

row = '1999, Chevy, Venture, 4900.50, extended edition'
call row%split(tokens=cells, sep=',')
print '(I0,A)', size(cells), ' cells'
cells = cells%strip()                             ! elemental: every cell at once
do c = 1, size(cells)
  print '(I0,A)', c, ': ['//cells(c)//']'
enddo

print '(A)', '| '//glue%join(array=cells, sep=' | ')//' |'
glue = '-'
print '(A)', glue%join(array=cells(2:3))//''      ! the string itself is the separator

pieces = row%partition(sep=', ')                  ! before, separator, after
print '(A)', 'year: '//pieces(1)
print '(A)', 'rest: '//pieces(3)
print '(A,I0)', 'commas: ', row%count(',')
endprogram report
