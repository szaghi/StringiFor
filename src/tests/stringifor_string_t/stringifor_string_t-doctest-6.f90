program volatile_doctest
use stringifor_string_t
 logical :: test_passed(3)
 test_passed(1) = strless_nocase('Apple', 'banana')
 test_passed(2) = .not.strless_nocase('ABC', 'abc').and..not.strless_nocase('abc', 'ABC')
 test_passed(3) = strless('Z', '_').and..not.strless_nocase('Z', '_') ! '_' is between 'Z' and 'z'
 print '(L1)', all(test_passed)
endprogram volatile_doctest