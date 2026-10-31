program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 logical :: test_passed(3)
 call re%compile('a|ab')
 m = re%fullmatch('ab')
 test_passed(1) = m%group(0)=='ab'
 m = re%search('ab')
 test_passed(2) = m%group(0)=='a'
 call re%compile('caf'//char(92)//'u00e9|tea', flags='i')
 m = re%fullmatch('CAF'//char(195)//char(169))
 test_passed(3) = m%found
 print '(L1)', all(test_passed)
endprogram volatile_doctest