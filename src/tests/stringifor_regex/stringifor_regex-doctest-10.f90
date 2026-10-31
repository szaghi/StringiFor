program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 type(string) :: g
 logical :: test_passed(2)
 call re%compile('(\d+)(?:\.(\d+))?')
 m = re%search('v12')
 test_passed(1) = m%group(1)=='12'
 g = m%group(2)
 test_passed(2) = .not.g%is_allocated()
 print '(L1)', all(test_passed)
endprogram volatile_doctest