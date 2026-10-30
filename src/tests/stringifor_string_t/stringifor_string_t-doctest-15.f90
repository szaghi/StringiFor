program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'Hello World!   '
 test_passed(1) = astring%len()==len('Hello World!   ')
 astring = 'caf'//char(195)//char(169)
 test_passed(2) = astring%len()==5
 test_passed(3) = astring%len(by=SF_CHARS)==4
 print '(L1)', all(test_passed)
endprogram volatile_doctest