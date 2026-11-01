program split_big
!< Split a long string in a fixed number of chunks of work, not one big scan.
use stringifor
implicit none
type(string)              :: text
type(string), allocatable :: tokens(:)

text = repeat('field,', 5000)
call text%split_chunked(tokens=tokens, sep=',', chunks=100)
print '(I0,1X,A)', size(tokens), tokens(5000)%chars()
endprogram split_big
