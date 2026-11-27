program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'bookkeeper  --  aa'
 test_passed(1) = astring%squeeze()//''=='bokeper - a'
 test_passed(2) = astring%squeeze(set=' -')//''=='bookkeeper - aa'
 astring = 'n'//char(195)//char(169)//char(195)//char(169)//'e'
 test_passed(3) = astring%squeeze()//''=='n'//char(195)//char(169)//'e'
 test_passed(4) = astring%squeeze(set=char(195))//''==astring//''
 print '(L1)', all(test_passed)
endprogram volatile_doctest