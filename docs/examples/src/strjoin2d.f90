!run strjoin2d strjoin2d
program join_a_table
!< Join the columns, or the rows, of a 2D array.
use stringifor
implicit none
type(string) :: table(3,2), columns(2), rows(3)
integer      :: j

table(1,1) = 'a' ; table(2,1) = 'b' ; table(3,1) = 'c'
table(1,2) = 'd' ; table(2,2) = 'e' ; table(3,2) = 'f'
columns = strjoin(array=table, sep=',')                 ! each column joined
print '(*(A,:,1X))', (columns(j)//'', j=1, size(columns))
rows = strjoin(array=table, sep=',', is_col=.false.)    ! each row joined
print '(*(A,:,1X))', (rows(j)//'', j=1, size(rows))
endprogram join_a_table
