program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(2)
 astring = 'caMeL caSe var'
 test_passed(1) = astring%camelcase()//''=='CamelCaseVar'
 astring = '   '
 test_passed(2) = astring%camelcase()//''==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest