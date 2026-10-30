program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(12)
 astring = '   -1212112.d0 '
 test_passed(1) = astring%is_real().eqv..true.
 astring = '   -1212112.d0'
 test_passed(2) = astring%is_real(allow_spaces=.false.).eqv..false.
 astring = '-1212112.d0   '
 test_passed(3) = astring%is_real(allow_spaces=.false.).eqv..false.
 astring = '+2.e20'
 test_passed(4) = astring%is_real().eqv..true.
 astring = ' -2.01E13 '
 test_passed(5) = astring%is_real().eqv..true.
 astring = ' -2.01 E13 '
 test_passed(6) = astring%is_real().eqv..false.
 astring = '42'
 test_passed(7) = astring%is_real().eqv..false.
 astring = ' -42  '
 test_passed(8) = astring%is_real().eqv..false.
 astring = '42.'
 test_passed(9) = astring%is_real().eqv..true.
 astring = '.5'
 test_passed(10) = astring%is_real().eqv..true.
 astring = '2e20'
 test_passed(11) = astring%is_real().eqv..true.
 call astring%free
 test_passed(12) = astring%is_real().eqv..false.
 print '(L1)', all(test_passed)
endprogram volatile_doctest