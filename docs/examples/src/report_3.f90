!as report
!run report_3 report
program report
!< Tutorial, chapter 3: splitting and joining.
use stringifor
implicit none
type(string)              :: row, glue, pieces(3), record
type(string), allocatable :: cells(:)
integer                   :: c

!region split
row = '1999, Chevy, Venture, 4900.50, extended edition'
call row%split(tokens=cells, sep=',')
print '(I0,A)', size(cells), ' cells'
cells = cells%strip()                             ! elemental: every cell at once
do c = 1, size(cells)
  print '(I0,A)', c, ': ['//cells(c)//']'
enddo
!endregion split

!region join
print '(A)', '| '//glue%join(array=cells, sep=' | ')//' |'
glue = '-'
print '(A)', glue%join(array=cells(2:3))//''      ! the string itself is the separator
!endregion join

!region partition
pieces = row%partition(sep=', ')                  ! before, separator, after
print '(A)', 'year: '//pieces(1)
print '(A)', 'rest: '//pieces(3)
print '(A,I0)', 'commas: ', row%count(',')
!endregion partition

!region find
print '(2(L1,1X))', row%start_with('1999'), row%end_with('edition')
print '(A,I0)', 'second comma at ', row%index(',', occurrence=2)
print '(A,I0)', 'last comma at   ', row%index(',', back=.true.)
!endregion find

!region empty
record = '2003,Fiat,,1800,'                       ! the model and the notes are missing
call record%split(tokens=cells, sep=',')
print '(I0,A)', size(cells), ' tokens: '//glue%join(array=cells, sep='|')
call record%split(tokens=cells, sep=',', keep_empty=.true.)
print '(I0,A)', size(cells), ' fields: '//glue%join(array=cells, sep='|')
!endregion empty
endprogram report
