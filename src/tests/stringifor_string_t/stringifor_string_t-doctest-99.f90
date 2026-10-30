program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'caf'//char(195)//char(169)
 test_passed(1) = astring%utf8_error()==0
 astring = 'ab'//char(237)//char(160)//char(128)
 test_passed(2) = astring%utf8_error()==3
 astring = 'x'//char(228)//char(189)
 test_passed(3) = astring%utf8_error()==2
 print '(L1)', all(test_passed)
endprogram volatile_doctest