program volatile_doctest
use stringifor_string_t
 logical :: test_passed(4)
 test_passed(1) = strless_natural('file2', 'file10')
 test_passed(2) = strless_natural('v1.9.1', 'v1.10.0')
 test_passed(3) = .not.strless_natural('a007', 'a7').and..not.strless_natural('a7', 'a007')
 test_passed(4) = strless_natural('x99999999999999999999998', 'x99999999999999999999999')
 print '(L1)', all(test_passed)
endprogram volatile_doctest