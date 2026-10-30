program volatile_doctest
use stringifor_string_t
 character(5) :: characters(3)
 logical :: test_passed(13)
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(1) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2))//trim(characters(3)))
 test_passed(2) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2))//'-'//trim(characters(3)))
 test_passed(3) = ( strjoin(array=characters, is_trim=.false.)//''==characters(1)//characters(2)//characters(3))
 test_passed(4) = ( strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2)//'-'//characters(3))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(5) = (strjoin(array=characters)//''==trim(characters(2))//trim(characters(3)))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(6) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2)))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(7) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(3)))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(8) = (strjoin(array=characters, sep='-')//''==trim(characters(2))//'-'//trim(characters(3)))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(9) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2)))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(10) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(3)))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(11) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(2)//'-'//characters(3))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(12) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(13) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(3))
 print '(L1)', all(test_passed)
endprogram volatile_doctest