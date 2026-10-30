text = 'Q&A: "x < y" isn''t'//achar(10)//'always true'
print '(A)', '<note title="'//text%escape_xml(attribute=.true.)//'">'
print '(A)', text%escape_xml()//''
print '(A)', '</note>'
