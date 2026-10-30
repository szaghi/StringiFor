program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: centered
 logical :: test_passed(5)
 astring = 'abc'
 test_passed(1) = astring%center(7, '*')//''=='**abc**'
 centered = astring%center(6)
 test_passed(2) = centered%len()==6.and.centered//''==' abc'
 test_passed(3) = astring%center(2)//''=='abc'
 astring = 'ab'
 test_passed(4) = astring%center(5, '-')//''=='--ab-'
 astring = 'caf'//char(195)//char(169)
 test_passed(5) = astring%center(6, '*', by=SF_CHARS)//''=='*'//'caf'//char(195)//char(169)//'*'
 print '(L1)', all(test_passed)
endprogram volatile_doctest