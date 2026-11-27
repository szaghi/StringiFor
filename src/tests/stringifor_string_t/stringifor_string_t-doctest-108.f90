program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(92)//'u00e9'//char(92)//'t!'
 test_passed(1) = astring%unescape_c()=='caf'//char(195)//char(169)//achar(9)//'!'
 astring = char(92)//'x41'//char(92)//'101'//char(92)//char(92)
 test_passed(2) = astring%unescape_c()=='AA'//char(92)
 astring = char(92)//'q'//char(92)//'x4'
 test_passed(3) = astring%unescape_c()==astring
 astring = 'a'//char(255)//char(9)
 astring = astring%escape_c()
 test_passed(4) = astring%unescape_c()=='a'//char(255)//char(9)
 print '(L1)', all(test_passed)
endprogram volatile_doctest