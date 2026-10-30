note = 'caf&#233; &#x2615; &lt;b&gt; AT&amp;T'
text = note%unescape_xml()
print '(A)', text%chars()
note = 'R&D &nbsp; &#0; &#X41;'
print '(A,I0)', 'first malformed reference at byte ', note%xml_error()
print '(A)', note%unescape_xml()//''
