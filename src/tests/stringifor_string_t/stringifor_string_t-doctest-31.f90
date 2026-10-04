program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: prefix
 logical :: test_passed(4)
 astring = 'flower'
 test_passed(1) = astring%common_prefix('flow')//''=='flow'
 test_passed(2) = astring%common_prefix('flight')//''=='fl'
 test_passed(3) = astring%common_prefix('dog')//''==''
 call astring%free
 prefix = astring%common_prefix('flow')
 test_passed(4) = prefix%is_allocated().eqv..false.
 print '(L1)', all(test_passed)
endprogram volatile_doctest