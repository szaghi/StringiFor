program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(195)//char(169)//'!'
 test_passed(1) = astring%byte_pos(4)==4
 test_passed(2) = astring%byte_pos(5)==6
 test_passed(3) = astring%byte_pos(6)==7
 test_passed(4) = astring%byte_pos(7)==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest