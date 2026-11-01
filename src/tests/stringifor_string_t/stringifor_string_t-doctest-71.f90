program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = '  xx-ab-xx  '
 test_passed(1) = astring%lstrip()//'|'=='xx-ab-xx  |'
 test_passed(2) = astring%lstrip(remove=' x')//''=='-ab-xx'
 test_passed(3) = astring%lstrip(remove='')//''==astring//''
 print '(L1)', all(test_passed)
endprogram volatile_doctest