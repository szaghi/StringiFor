program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = '  one'//achar(9)//' two'//new_line('a')//'three  '
 test_passed(1) = astring%compact()//''=='one two three'
 test_passed(2) = astring%compact(sep=', ')//''=='one, two, three'
 test_passed(3) = astring%compact(sep='')//''=='onetwothree'
 print '(L1)', all(test_passed)
endprogram volatile_doctest