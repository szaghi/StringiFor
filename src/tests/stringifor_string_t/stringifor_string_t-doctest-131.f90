program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'caf'//char(195)//char(169)
 test_passed(1) = astring%is_utf8()
 astring = 'caf'//char(233)
 test_passed(2) = .not.astring%is_utf8()
 astring = char(192)//char(175)
 test_passed(3) = .not.astring%is_utf8()
 astring = ''
 test_passed(4) = astring%is_utf8()
 print '(L1)', all(test_passed)
endprogram volatile_doctest