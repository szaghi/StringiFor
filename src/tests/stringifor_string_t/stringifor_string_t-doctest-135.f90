program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'hello'
 test_passed(1) = astring%chars()=='hello'
 astring = astring%raw(2:)
 test_passed(2) = astring%chars()=='ello'
 astring = astring%raw(1:2)//astring%raw
 test_passed(3) = astring%chars()=='elello'
 astring = astring%raw
 test_passed(4) = astring%chars()=='elello'
 print '(L1)', all(test_passed)
endprogram volatile_doctest