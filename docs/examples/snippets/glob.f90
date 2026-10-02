program list_files
!< The files matching a pattern.
use stringifor
implicit none
type(string)              :: s
type(string), allocatable :: files(:)
integer                   :: f

call s%glob(pattern='data/*.csv', list=files)
do f = 1, size(files)
  print '(A)', files(f)//''
enddo
endprogram list_files
