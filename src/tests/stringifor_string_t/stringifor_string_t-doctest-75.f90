program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string), allocatable :: strings(:)
 logical :: test_passed(14)
 astring = '+ab-++cre-++cre-ab+'
 call astring%split(tokens=strings, sep='+')
 test_passed(1) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'ab-++cre-++cre-ab+'
 call astring%split(tokens=strings, sep='+')
 test_passed(2) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'ab-++cre-++cre-ab'
 call astring%split(tokens=strings, sep='+')
 test_passed(3) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'Hello '//new_line('a')//'World!'
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(4) = (strings(1)//''=='Hello '.and.strings(2)//''=='World!')
 astring = 'Hello World!'
 call astring%split(tokens=strings)
 test_passed(5) = (strings(1)//''=='Hello'.and.strings(2)//''=='World!')
 astring = '+ab-'
 call astring%split(tokens=strings, sep='+')
 test_passed(6) = (strings(1)//''=='ab-')
 astring = '+ab-'
 call astring%split(tokens=strings, sep='-')
 test_passed(7) = (strings(1)//''=='+ab')
 astring = '+ab-+cd-'
 call astring%split(tokens=strings, sep='+')
 test_passed(8) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = 'ab-+cd-+'
 call astring%split(tokens=strings, sep='+')
 test_passed(9) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = '+ab-+cd-+'
 call astring%split(tokens=strings, sep='+')
 test_passed(10) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = '1-2-3-4-5-6-7-8'
 call astring%split(tokens=strings, sep='-', max_tokens=3)
 test_passed(11) = (strings(1)//''=='1'.and.strings(2)//''=='2'.and.strings(3)//''=='3'.and.strings(4)//''=='4-5-6-7-8')
 astring = '+++'
 call astring%split(tokens=strings, sep='+')
 test_passed(12) = (size(strings, dim=1)==0)
 astring = ',a,,b,'
 call astring%split(tokens=strings, sep=',', keep_empty=.true.)
 test_passed(13) = size(strings, dim=1)==5
 if (test_passed(13)) test_passed(13) = all(strings==['  ', 'a ', '  ', 'b ', '  ']).and.all(strings%len()==[0, 1, 0, 1, 0])
 call astring%split(tokens=strings, sep=',', max_tokens=2, keep_empty=.true.)
 test_passed(14) = size(strings, dim=1)==3
 if (test_passed(14)) test_passed(14) = strings(1)//''==''.and.strings(2)//''=='a'.and.strings(3)//''==',b,'
 print '(L1)', all(test_passed)
endprogram volatile_doctest