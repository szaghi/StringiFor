program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: another
 logical :: test_passed(4)
 astring = 'kitten'
 another = 'sitting'
 test_passed(1) = astring%edit_distance(another)==3
 test_passed(2) = astring%edit_distance('kitten')==0
 astring = 'caf'//char(195)//char(169)
 test_passed(3) = astring%edit_distance('cafe')==2
 test_passed(4) = astring%edit_distance('cafe', by=SF_CHARS)==1
 print '(L1)', all(test_passed)
endprogram volatile_doctest