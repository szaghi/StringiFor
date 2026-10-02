program write_a_file
!< Write strings to a file.
use stringifor
implicit none
type(string) :: lines(3)

lines(1) = 'bread'
lines(2) = 'milk'
lines(3) = 'coffee'
call write_file(file='shopping.txt', lines=lines)
print '(A)', 'written'
endprogram write_a_file
