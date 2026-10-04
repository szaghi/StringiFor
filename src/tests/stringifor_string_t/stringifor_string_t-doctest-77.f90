program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(2)
 astring = 'bookkeeper  --  aa'
 test_passed(1) = astring%squeeze()//''=='bokeper - a'
 test_passed(2) = astring%squeeze(set=' -')//''=='bookkeeper - aa'
 print '(L1)', all(test_passed)
endprogram volatile_doctest