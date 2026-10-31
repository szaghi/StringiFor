program regex_tour
!< A tour of the regular expressions: compile, search, groups, all the matches, replace, split.
use stringifor
implicit none
type(regex)                    :: re
type(regex_match)              :: m
type(regex_match), allocatable :: all(:)
type(string),      allocatable :: parts(:)
type(string)                   :: line
integer                        :: i
integer                        :: iostat
character(len=99)              :: iomsg

call re%compile('(?P<user>\w+)@(?P<host>[\w.]+)')
m = re%search('write to ann@example.org or bob@test.net')
print '(L1,1X,A,1X,2I3)', m%found, m%group(0)//'', m%span(0)
print '(A,1X,A)', m%group('user')//'', m%group('host')//''

all = re%finditer('write to ann@example.org or bob@test.net')
do i = 1, size(all)
  print '(I0,2A)', i, ': ', all(i)%group('user')//''
enddo

line = re%sub('\g<user> at \g<host>', 'write to ann@example.org or bob@test.net')
print '(A)', line%chars()
parts = re_split('a, b ;c', '\s*[,;]\s*')
print '(3(A,"|"))', (parts(i)%chars(), i=1, size(parts))

call re%compile('(\d+', iostat=iostat, iomsg=iomsg)
print '(A,I0,2A)', 'error at byte ', iostat, ': ', trim(iomsg)
endprogram regex_tour
