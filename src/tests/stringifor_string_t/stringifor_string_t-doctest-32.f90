program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: strings(3)
 logical :: test_passed(3)
 strings(1) = 'flower'
 strings(2) = 'flow'
 strings(3) = 'flight'
 astring = strings(1)%common_prefix(array=strings)
 test_passed(1) = astring//''=='fl'
 astring = strings(1)%common_prefix(array=strings(1:2))
 test_passed(2) = astring//''=='flow'
 strings(1) = 'dog'
 strings(2) = 'racecar'
 strings(3) = 'car'
 astring = strings(1)%common_prefix(array=strings)
 test_passed(3) = astring//''==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest