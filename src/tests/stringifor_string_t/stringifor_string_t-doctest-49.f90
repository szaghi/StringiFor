program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'ok'//char(92)//'n'//char(92)//'u00e9'
 test_passed(1) = astring%escapes_error()==0
 astring = 'ab'//char(92)//'q'
 test_passed(2) = astring%escapes_error()==3
 astring = char(92)//'n'//char(92)//'ud800'
 test_passed(3) = astring%escapes_error()==3
 print '(L1)', all(test_passed)
endprogram volatile_doctest