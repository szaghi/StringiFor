program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(2)
 astring = 'say all Hello WorLD!'
 test_passed(1) = astring%capitalize()//''=='Say all hello world!'
 astring = ''
 test_passed(2) = astring%capitalize()//''==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest