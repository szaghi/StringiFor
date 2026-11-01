program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = from_codepoints([104, 233, 20320])
 test_passed(1) = astring%raw=='h'//char(195)//char(169)//char(228)//char(189)//char(160)
 astring = from_codepoints([97, -255])
 test_passed(2) = astring%raw=='a'//char(255)
 astring = from_codepoints([55296])
 test_passed(3) = astring%raw==char(239)//char(191)//char(189)
 astring = 'x'//char(192)//char(175)//'y'
 astring = from_codepoints(astring%codepoints())
 test_passed(4) = astring%raw=='x'//char(192)//char(175)//'y'
 print '(L1)', all(test_passed)
endprogram volatile_doctest