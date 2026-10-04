program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(10)
 astring = '  Hello World!   '
 test_passed(1) = astring%strip()//''=='Hello World!'
 astring = '   hello   '
 test_passed(2) = astring%strip(remove=' h')//''=='ello'
 astring = 'xxyHello Worldyx'
 test_passed(3) = astring%strip(remove='xy')//''=='Hello World'
 test_passed(4) = astring%strip(remove='')//''=='xxyHello Worldyx'
 astring = 'xyxy'
 test_passed(5) = astring%strip(remove='xy')//''==''
 astring = '  ab'//char(0)//char(0)
 test_passed(6) = astring%strip(remove_nulls=.true.)//''=='ab'
 astring = ''
 test_passed(7) = astring%strip(remove=' ')//''==''
 astring = '--a-b--'
 test_passed(8) = astring%strip(remove='-')//''=='a-b'
 astring = achar(9)//' a b'//new_line('a')
 test_passed(9) = astring%strip(whitespace=.true.)//''=='a b'
 test_passed(10) = astring%strip(remove='b', whitespace=.true.)//''=='a'
 print '(L1)', all(test_passed)
endprogram volatile_doctest