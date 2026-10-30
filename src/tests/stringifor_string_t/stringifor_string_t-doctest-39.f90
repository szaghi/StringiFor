program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(8)
 astring = '1.01'
 test_passed(1) = astring%compare_version('1.001')==0
 astring = '1.0'
 test_passed(2) = astring%compare_version('1.0.0')==0
 astring = '0.1'
 test_passed(3) = astring%compare_version('1.1')==-1
 astring = '1.10'
 test_passed(4) = astring%compare_version('1.9')==1
 astring = '1-2-3'
 test_passed(5) = astring%compare_version('1-2-4', sep='-')==-1
 astring = '1.99999999999999999999999'
 test_passed(6) = astring%compare_version('1.100000000000000000000000')==-1
 astring = '1.2.b'
 test_passed(7) = astring%compare_version('1.2.a')==1
 astring = '1.'
 test_passed(8) = astring%compare_version('1')==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest