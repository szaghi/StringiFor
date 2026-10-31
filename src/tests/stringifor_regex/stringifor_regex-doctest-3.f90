program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 logical :: test_passed(2)
 call re%compile('\d+')
 m = re%match('42 and 7')
 test_passed(1) = m%group(0)=='42'
 m = re%match('x42')
 test_passed(2) = .not.m%found
 print '(L1)', all(test_passed)
endprogram volatile_doctest