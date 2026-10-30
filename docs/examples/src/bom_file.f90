!run bom_file bom_file
!run bom_file-od od -c windows.txt
program bom_file
!< A UTF-8 file that starts with a byte order mark, as some Windows editors save them.
use stringifor
implicit none
type(string)              :: text
type(string), allocatable :: lines(:)

text = 'key = value'//new_line('a')//'other = 1'
call text%write_file(file='windows.txt', bom=.true.) ! as such an editor saves it

!region read
call text%read_file(file='windows.txt')
print '(A,L1,A,L1)', 'has a BOM: ', text%has_bom(), ', starts with key: ', text%start_with('key')
call text%read_file(file='windows.txt', skip_bom=.true.)
print '(A,L1,A,L1)', 'has a BOM: ', text%has_bom(), ', starts with key: ', text%start_with('key')
call read_file(file='windows.txt', lines=lines, skip_bom=.true.)
print '(A)', lines(1)//'|'
!endregion read
endprogram bom_file
