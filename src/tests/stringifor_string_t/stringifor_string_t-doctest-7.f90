program volatile_doctest
use stringifor_string_t
 logical :: test_passed(3)
 test_passed(1) = strless('a', 'a'//achar(9))
 test_passed(2) = strless('z', char(195)//char(169))
 test_passed(3) = .not.strless('ab', 'ab')
 print '(L1)', all(test_passed)
endprogram volatile_doctest