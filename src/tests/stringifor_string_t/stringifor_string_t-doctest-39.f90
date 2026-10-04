program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'a'//achar(9)//'bc'//achar(9)//'d'
 test_passed(1) = astring%expand_tabs()//''=='a       bc      d'
 test_passed(2) = astring%expand_tabs(4)//''=='a   bc  d'
 astring = 'abcd'//achar(9)//'e'//new_line('a')//achar(9)//'f'
 test_passed(3) = astring%expand_tabs(4)//''=='abcd    e'//new_line('a')//'    f'
 print '(L1)', all(test_passed)
endprogram volatile_doctest