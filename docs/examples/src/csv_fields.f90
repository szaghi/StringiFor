!run csv_fields csv_fields
program csv_fields
!< The fields of a CSV record, the empty ones included.
use stringifor
implicit none
type(string)              :: record
type(string), allocatable :: fields(:)
integer                   :: f

record = 'Rossi,,42,'
call record%split(tokens=fields, sep=',', keep_empty=.true.)
do f = 1, size(fields)
  print '(I0,A)', f, ': ['//fields(f)//']'
enddo
call record%split(tokens=fields, sep=',')
print '(I0,A)', size(fields), ' tokens without keep_empty'
endprogram csv_fields
