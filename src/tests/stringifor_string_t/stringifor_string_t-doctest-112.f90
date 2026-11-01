program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(195)//char(169)
 test_passed(1) = astring%width()==4
 astring = char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
 test_passed(2) = astring%width()==4
 astring = 'e'//char(204)//char(129)
 test_passed(3) = astring%width()==1
 astring = 'a'//achar(9)//'b'
 test_passed(4) = astring%width()==2
 print '(L1)', all(test_passed)
endprogram volatile_doctest