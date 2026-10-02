program read_a_file
!< Read a whole file.
use stringifor
implicit none
type(string), allocatable :: lines(:)
type(string)              :: content

call read_file(file='notes.txt', lines=lines)     ! one string for each line
print '(I0,A)', size(lines), ' lines, the last is "'//lines(size(lines))//'"'

call content%read_file(file='notes.txt')          ! the whole file in one string
print '(I0,A,I0,A)', content%len(), ' characters, ', content%count(new_line('a')), ' line ends'
endprogram read_a_file
