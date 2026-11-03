program volatile_doctest
use stringifor_encodings
 logical :: test_passed(4)
 test_passed(1) = bom_encoding(char(239)//char(187)//char(191)//'<a/>')=='UTF-8'
 test_passed(2) = bom_encoding(char(255)//char(254)//'<'//char(0))=='UTF-16LE'
 test_passed(3) = bom_encoding(char(0)//char(0)//char(254)//char(255))=='UTF-32BE'
 test_passed(4) = bom_encoding('<a/>')==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest