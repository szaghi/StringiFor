program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 type(string), allocatable :: g(:)
 call re%compile('(\w+)@(\w+)\.(\w+)')
 m = re%search('mail: ann@example.org')
 g = m%groups()
 print '(L1)', size(g)==3.and.g(1)=='ann'.and.g(3)=='org'
endprogram volatile_doctest