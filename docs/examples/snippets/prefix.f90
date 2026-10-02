program common_prefix
!< What several strings start with.
use stringifor
implicit none
type(string) :: files(3), prefix

files(1) = 'src/lib/stringifor.F90'
files(2) = 'src/lib/stringifor_string_t.F90'
files(3) = 'src/tests/stringifor/test.f90'
prefix = files(1)%common_prefix(files(2))         ! of two strings
print '(A)', prefix//''
prefix = files(1)%common_prefix(array=files)      ! of an array
print '(A)', prefix//''
endprogram common_prefix
