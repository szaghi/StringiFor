program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'a&lt;b &amp; caf&#233;&#x21;'
 test_passed(1) = astring%unescape_xml()=='a<b & caf'//char(195)//char(169)//'!'
 astring = 'AT&T &nbsp; &#0;'
 test_passed(2) = astring%unescape_xml()==astring
 astring = 'x="'//char(255)//achar(10)//'"'
 astring = astring%escape_xml(attribute=.true.)
 test_passed(3) = astring%unescape_xml()=='x="'//char(255)//achar(10)//'"'
 print '(L1)', all(test_passed)
endprogram volatile_doctest