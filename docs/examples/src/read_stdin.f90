!run read_stdin echo '"two words" three' | read_stdin
program read_standard_input
!< Read strings with list-directed input.
use stringifor
implicit none
type(string) :: first, second

read *, first, second
print '(A)', '['//first//'] ['//second//']'
endprogram read_standard_input
