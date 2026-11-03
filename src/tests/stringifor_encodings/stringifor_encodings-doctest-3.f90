program volatile_doctest
use stringifor_encodings
 logical :: test_passed(5)
 test_passed(1) = canonical_encoding('utf8')=='UTF-8'
 test_passed(2) = canonical_encoding(' Latin1 ')=='ISO-8859-1'
 test_passed(3) = canonical_encoding('CP1252')=='windows-1252'
 test_passed(4) = canonical_encoding('ascii')=='US-ASCII'
 test_passed(5) = canonical_encoding('Shift_JIS')==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest