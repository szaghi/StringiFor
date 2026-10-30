program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(195)//char(169)//achar(9)//'!'
 test_passed(1) = astring%escape_c()=='caf'//char(92)//'u00e9'//char(92)//'t!'
 test_passed(2) = astring%escape_c(ascii=.false.)=='caf'//char(195)//char(169)//char(92)//'t!'
 astring = 'a'//char(255)//char(92)
 test_passed(3) = astring%escape_c()=='a'//char(92)//'xff'//char(92)//char(92)
 astring = char(240)//char(159)//char(152)//char(128)
 test_passed(4) = astring%escape_c()==char(92)//'U0001f600'
 print '(L1)', all(test_passed)
endprogram volatile_doctest