program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'say "hi"'
 test_passed(1) = astring%quote()//''=='"say ""hi"""'
 test_passed(2) = astring%quote("'")//''=="'say ""hi""'"
 astring = astring%quote()
 test_passed(3) = astring%unquote()//''=='say "hi"'
 print '(L1)', all(test_passed)
endprogram volatile_doctest