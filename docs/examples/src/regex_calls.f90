!run regex_calls regex_calls
program regex_calls
!< The regular expression calls for one-off use, validation and groups.
use stringifor
implicit none
type(regex)               :: re
type(regex_match)         :: m
type(string)              :: s
type(string), allocatable :: g(:)
integer                   :: iostat

!region oneoff
m = re_search('key = 42', '(\w+)\s*=\s*(\d+)')
print '(A,1X,A)', m%group(1)//'', m%group(2)//''
s = re_sub('x=1, y=22', '(\w)=(\d+)', '\2=\1')
print '(A)', s%chars()
!endregion oneoff

!region whole
m = re_fullmatch('2026-10-31', '\d{4}-\d\d-\d\d')
print '(A,L2)', 're_fullmatch 2026-10-31:', m%found
call re%compile('\d{4}-\d\d-\d\d')
m = re%fullmatch('on 2026-10-31')
print '(A,L2)', 'fullmatch on 2026-10-31:', m%found
m = re%search('on 2026-10-31')
print '(A,L2)', 'search on 2026-10-31:   ', m%found
!endregion whole

!region groups
call re%compile('(?P<y>\d{4})-(?P<m>\d\d)(-\d\d)?')
print '(A,I0,A,I0)', 'groups: ', re%group_count(), ', m is number ', re%group_index('m')
m = re%search('2026-10')
g = m%groups()
print '(3A,L2)', g(1)%chars(), ' ', g(2)%chars(), g(3)%is_allocated()
!endregion groups

!region flags
call re%compile('^name', flags='im')
m = re%search('# header'//new_line('a')//'NAME = x')
print '(A,2I4)', m%group(0)//'', m%span(0)
call re%compile('(?s)a.b')
m = re%search('a'//new_line('a')//'b')
print '(L1)', m%found
call re%compile('(', iostat=iostat)
print '(I0,L2)', iostat, re%is_compiled()
!endregion flags
endprogram regex_calls
