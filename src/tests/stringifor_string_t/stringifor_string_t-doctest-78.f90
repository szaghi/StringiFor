program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'abcdefghilmnopqrstuvz'
 test_passed(1) = (astring%reverse()//''=='zvutsrqponmlihgfedcba')
 astring = '0123456789'
 test_passed(2) = (astring%reverse()//''=='9876543210')
 astring = 'ab'//char(228)//char(189)//char(160)//char(195)//char(169)
 test_passed(3) = (astring%reverse()//''==char(195)//char(169)//char(228)//char(189)//char(160)//'ba')
 print '(L1)', all(test_passed)
endprogram volatile_doctest