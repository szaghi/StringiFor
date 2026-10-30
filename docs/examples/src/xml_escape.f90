!run xml_escape xml_escape
program xml_escape
!< Text written into an XML element and attribute, and read back.
use stringifor
implicit none
type(string) :: text
type(string) :: note

!region write
text = 'Q&A: "x < y" isn''t'//achar(10)//'always true'
print '(A)', '<note title="'//text%escape_xml(attribute=.true.)//'">'
print '(A)', text%escape_xml()//''
print '(A)', '</note>'
!endregion write

!region read
note = 'caf&#233; &#x2615; &lt;b&gt; AT&amp;T'
text = note%unescape_xml()
print '(A)', text%chars()
note = 'R&D &nbsp; &#0; &#X41;'
print '(A,I0)', 'first malformed reference at byte ', note%xml_error()
print '(A)', note%unescape_xml()//''
!endregion read
endprogram xml_escape
