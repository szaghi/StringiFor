program path_pieces
!< The pieces of a file name.
use stringifor
implicit none
type(string) :: path

path = '/home/user/data/archive.tar.gz'
print '(A)', path%basedir()//''
print '(A)', path%basename()//''
print '(A)', path%extension()//''
print '(A)', path%basename(strip_last_extension=.true.)//''
print '(A)', path%basename(extension='.tar.gz')//''
endprogram path_pieces
