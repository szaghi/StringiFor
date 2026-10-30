program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = '00ff7FA9'
 test_passed(1) = astring%is_xdigit()
 astring = '0x00ff'
 test_passed(2) = .not.astring%is_xdigit()
 astring = ''
 test_passed(3) = .not.astring%is_xdigit()
 print '(L1)', all(test_passed)
endprogram volatile_doctest