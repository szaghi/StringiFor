program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = '&lt;a&gt; &#x1F600;'
 test_passed(1) = astring%xml_error()==0
 astring = 'Q&amp;A, R&D'
 test_passed(2) = astring%xml_error()==11
 astring = '&#xD800;'
 test_passed(3) = astring%xml_error()==1
 print '(L1)', all(test_passed)
endprogram volatile_doctest