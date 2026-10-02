program report
!< Tutorial, chapter 5: files and paths.
use stringifor
implicit none
type(string)              :: input, output, glue
type(string), allocatable :: rows(:), cells(:), table(:)
character(256)            :: argument
integer                   :: r

call get_command_argument(1, argument)
input = trim(argument)

print '(A)', 'directory: '//input%basedir()
print '(A)', 'file:      '//input%basename()
print '(A)', 'extension: '//input%extension()
output = input%basename(strip_last_extension=.true.)//'.md'

call read_file(file=input%chars(), lines=rows)    ! one string for each line
print '(I0,A)', size(rows), ' rows read from '//input

allocate(table(size(rows) + 1))
do r = 1, size(rows)
  call rows(r)%split(tokens=cells, sep=',')
  cells = cells%strip()
  table(merge(1, r + 1, r == 1)) = '| '//glue%join(array=cells(1:4), sep=' | ')//' |'
enddo
table(2) = '|---|---|---|---|'
call write_file(file=output%chars(), lines=table)
print '(A)', 'table written to '//output
endprogram report
