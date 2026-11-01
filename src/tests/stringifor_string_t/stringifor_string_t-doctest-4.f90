program volatile_doctest
use stringifor_string_t
 use penf
 type(string) :: astring
 logical :: test_passed(4)
 astring = shortest(0.1_R8P)
 test_passed(1) = astring%raw=='0.1'
 astring = shortest(1.e23_R8P)
 test_passed(2) = astring%raw=='1e+23'
 astring = shortest(100._R8P)
 test_passed(3) = astring%raw=='100.0'
 test_passed(4) = astring%to_number(1._R8P)==100._R8P
 print '(L1)', all(test_passed)
endprogram volatile_doctest