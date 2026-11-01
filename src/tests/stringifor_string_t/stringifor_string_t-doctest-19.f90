program volatile_doctest
use stringifor_string_t
 type(string) :: string1
 type(string) :: string2
 logical :: test_passed(4)
 string1 = 'Hello World Hello!'
 string2 = 'llo'
 test_passed(1) = string1%index(substring=string2)==index(string='Hello World Hello!', substring='llo')
 test_passed(2) = string1%index(substring=string2, back=.true.)==index(string='Hello World Hello!', substring='llo', &
 back=.true.)
 string1 = 'ab-ab-ab'
 string2 = 'ab'
 test_passed(3) = string1%index(string2, occurrence=2)==4.and.string1%index(string2, occurrence=4)==0
 test_passed(4) = string1%index(string2, back=.true., occurrence=2)==4
 print '(L1)', all(test_passed)
endprogram volatile_doctest