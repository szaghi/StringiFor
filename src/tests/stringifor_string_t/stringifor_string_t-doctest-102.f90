program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'a'//char(228)//char(189)//'b'
 astring = astring%to_valid_utf8()
 test_passed(1) = astring%raw=='a'//char(239)//char(191)//char(189)//'b'
 astring = char(192)//char(175)
 astring = astring%to_valid_utf8(replacement='?')
 test_passed(2) = astring%raw=='??'
 astring = 'caf'//char(195)//char(169)
 test_passed(3) = astring%to_valid_utf8()==astring
 print '(L1)', all(test_passed)
endprogram volatile_doctest