program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = '"say ""hi"""'
 test_passed(1) = astring%unquote()//''=='say "hi"'
 astring = "'it''s'"
 test_passed(2) = astring%unquote()//''=="it's"
 astring = '"unbalanced'
 test_passed(3) = astring%unquote()//''=='"unbalanced'
 astring = '""'
 test_passed(4) = astring%unquote()//''==''.and.astring%len()==2
 print '(L1)', all(test_passed)
endprogram volatile_doctest