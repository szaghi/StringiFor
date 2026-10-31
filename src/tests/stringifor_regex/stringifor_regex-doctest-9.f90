program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 logical :: test_passed(3)
 call re%compile('(a)|(b)|(x*)')
 m = re%search('b')
 test_passed(1) = all(m%span(0) == [1, 1]).and.all(m%span(2) == [1, 1])
 test_passed(2) = all(m%span(1) == [0, -1])
 m = re%search('c')
 test_passed(3) = all(m%span(3) == [1, 0])
 print '(L1)', all(test_passed)
endprogram volatile_doctest