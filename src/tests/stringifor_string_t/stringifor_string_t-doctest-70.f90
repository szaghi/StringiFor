program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = '  xx-ab-xx'//achar(9)//new_line('a')
 test_passed(1) = '|'//astring%rstrip(whitespace=.true.)=='|  xx-ab-xx'
 test_passed(2) = astring%rstrip(remove='x', whitespace=.true.)//''=='  xx-ab-'
 test_passed(3) = astring%rstrip()//''==astring//''
 print '(L1)', all(test_passed)
endprogram volatile_doctest