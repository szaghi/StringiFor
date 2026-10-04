program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(12)
 astring = 'Hello World'
 test_passed(1) = astring%slice(first=1, last=5)=='Hello'
 test_passed(2) = astring%slice(first=7)=='World'
 test_passed(3) = astring%slice(last=5)=='Hello'
 test_passed(4) = astring%slice()=='Hello World'
 test_passed(5) = astring%slice(stride=2)=='HloWrd'
 test_passed(6) = astring%slice(stride=-1)=='dlroW olleH'
 test_passed(7) = astring%slice(first=5, last=1, stride=-2)=='olH'
 test_passed(8) = astring%slice(first=-3, last=100)=='Hello World'
 test_passed(9) = len(astring%slice(first=7, last=5))==0
 test_passed(10) = len(astring%slice(stride=0))==0
 test_passed(11) = astring%slice(istart=1, iend=5)=='Hello'
 call astring%free
 test_passed(12) = len(astring%slice(first=1, last=5))==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest