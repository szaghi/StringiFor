program volatile_doctest
use stringifor_regex
 type(regex_match) :: m
 logical :: test_passed(2)
 m = re_search('key = 42', '(\w+)\s*=\s*(\d+)')
 test_passed(1) = m%group(1)=='key'.and.m%group(2)=='42'
 m = re_search('KEY=1', 'key=(\d)', flags='i')
 test_passed(2) = m%group(1)=='1'
 print '(L1)', all(test_passed)
endprogram volatile_doctest