program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: anotherstring
 logical :: test_passed(3)
 astring = 'src/lib/stringifor.F90'
 anotherstring = 'src/lib/stringifor_string_t.F90'
 test_passed(1) = astring%common_prefix(anotherstring)//''=='src/lib/stringifor'
 anotherstring = 'docs/index.md'
 test_passed(2) = astring%common_prefix(anotherstring)//''==''
 call anotherstring%free
 test_passed(3) = astring%common_prefix(anotherstring)//''==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest