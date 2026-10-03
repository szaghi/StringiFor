program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: anotherstring
 type(string) :: notallocated
 logical :: test_passed(2)
 astring = 'hello'
 anotherstring = astring
 test_passed(1) = astring%chars()==anotherstring%chars()
 anotherstring = notallocated
 test_passed(2) = .not.anotherstring%is_allocated()
 print '(L1)', all(test_passed)
endprogram volatile_doctest