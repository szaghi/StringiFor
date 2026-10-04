program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(6)
 astring = '   Hello World  !    '
 test_passed(1) = astring%count(substring=' ')==10
 astring = 'Hello World  !    '
 test_passed(2) = astring%count(substring=' ', ignore_isolated=.true.)==6
 astring = '    Hello World  !'
 test_passed(3) = astring%count(substring=' ', ignore_isolated=.true.)==6
 astring = '   Hello World  !    '
 test_passed(4) = astring%count(substring=' ', ignore_isolated=.true.)==8
 test_passed(5) = astring%count(substring='')==0
 astring = 'aaaa'
 test_passed(6) = astring%count('aa')==2.and.astring%count('aa', overlapping=.true.)==3
 print '(L1)', all(test_passed)
endprogram volatile_doctest