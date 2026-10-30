program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: centered
 logical :: test_passed(3)
 astring = 'abc'
 test_passed(1) = astring%ljust(6, '.')//''=='abc...'
 centered = astring%ljust(6)
 test_passed(2) = centered%len()==6.and.centered//''=='abc'
 test_passed(3) = astring%ljust(2)//''=='abc'
 print '(L1)', all(test_passed)
endprogram volatile_doctest