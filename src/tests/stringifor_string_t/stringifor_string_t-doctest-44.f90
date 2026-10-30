program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'a<b & "c"'
 test_passed(1) = astring%escape_xml()=='a&lt;b &amp; &quot;c&quot;'
 astring = 'it''s'//achar(10)
 test_passed(2) = astring%escape_xml()=='it&apos;s'//achar(10)
 test_passed(3) = astring%escape_xml(attribute=.true.)=='it&apos;s&#10;'
 print '(L1)', all(test_passed)
endprogram volatile_doctest