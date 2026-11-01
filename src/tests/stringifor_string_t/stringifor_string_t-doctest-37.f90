program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(195)//char(169)//'!'
 test_passed(1) = astring%char_pos(4)==4
 test_passed(2) = astring%char_pos(5)==4
 test_passed(3) = astring%char_pos(6)==5
 test_passed(4) = astring%char_pos(7)==6
 print '(L1)', all(test_passed)
endprogram volatile_doctest