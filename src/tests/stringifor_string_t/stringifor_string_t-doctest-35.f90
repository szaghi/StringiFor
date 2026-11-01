program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = 'h'//char(195)//char(169)//char(228)//char(189)//char(160)
 test_passed(1) = all(astring%codepoints()==[104, 233, 20320])
 astring = 'a'//char(255)//char(192)//char(175)
 test_passed(2) = all(astring%codepoints()==[97, -255, -192, -175])
 astring = char(240)//char(159)//char(152)//char(128)
 test_passed(3) = all(astring%codepoints()==[128512])
 astring = ''
 test_passed(4) = size(astring%codepoints())==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest