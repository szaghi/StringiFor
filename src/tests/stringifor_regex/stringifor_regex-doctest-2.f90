program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match) :: m
 logical :: test_passed(4)
 call re%compile('(?P<key>\w+)\s*=\s*(?P<value>\w*)')
 m = re%search('# x = 1, y=two')
 test_passed(1) = m%found.and.all(m%span(0) == [3, 7])
 test_passed(2) = m%group('key')=='x'.and.m%group(2)=='1'
 m = re%search('# x = 1, y=two', start=8)
 test_passed(3) = m%group(0)=='y=two'
 m = re%search('nothing here')
 test_passed(4) = .not.m%found
 print '(L1)', all(test_passed)
endprogram volatile_doctest