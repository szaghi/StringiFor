program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(string) :: s
 integer :: n
 logical :: test_passed(3)
 call re%compile('(?P<y>\d{4})-(?P<m>\d\d)-(?P<d>\d\d)')
 s = re%sub('\g<d>/\g<m>/\g<y>', 'from 2026-10-30 to 2026-11-02', nsub=n)
 test_passed(1) = s=='from 30/10/2026 to 02/11/2026'.and.n==2
 call re%compile('\s+')
 s = re%sub(' ', '  too   many spaces ', count=2)
 test_passed(2) = s==' too many spaces '
 s = re%sub('\q', 'a b', iostat=n)
 test_passed(3) = n==1.and.s=='a b'
 print '(L1)', all(test_passed)
endprogram volatile_doctest