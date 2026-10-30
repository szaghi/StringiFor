program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: anotherstring
 logical :: test_passed(2)
 astring = '1.2.0'
 anotherstring = '1.10'
 test_passed(1) = astring%compare_version(anotherstring)==-1
 test_passed(2) = anotherstring%compare_version(astring)==1
 print '(L1)', all(test_passed)
endprogram volatile_doctest