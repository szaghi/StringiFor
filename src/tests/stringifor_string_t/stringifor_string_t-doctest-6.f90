program volatile_doctest
use stringifor_string_t
 logical :: test_passed(6)
 test_passed(1) = count('hello', substring='ll')==1
 test_passed(2) = count('aaaa', substring='a')==4
 test_passed(3) = count('aaaa', substring='aa')==2
 test_passed(4) = count('abc', substring='')==0
 test_passed(5) = count('aaaa', substring='aa', overlapping=.true.)==3
 test_passed(6) = count('abab', substring='ab', overlapping=.true.)==2
 print '(L1)', all(test_passed)
endprogram volatile_doctest