program temporary_name
!< A name for a temporary file.
use stringifor
implicit none
type(string) :: s, name

name = s%tempname(prefix='scratch-')              ! a name not used by any file of the directory
print '(L1,1X,L1)', name%start_with('scratch-'), name%len() > len('scratch-')
endprogram temporary_name
