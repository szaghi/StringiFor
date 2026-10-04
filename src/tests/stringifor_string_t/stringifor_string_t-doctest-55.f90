program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string), allocatable :: lines(:)
 logical :: test_passed(9)
 astring = 'This is an example of text justification.'
 call astring%justify(lines=lines, width=16)
 test_passed(1) = size(lines, dim=1)==3
 test_passed(2) = lines(1)//''=='This    is    an'
 test_passed(3) = lines(2)//''=='example  of text'
 test_passed(4) = lines(3)//''=='justification.  '
 astring = '  What must be   acknowledgment shall be '
 call astring%justify(lines=lines, width=16)
 test_passed(5) = lines(1)//''=='What   must   be'
 test_passed(6) = lines(2)//''=='acknowledgment  '
 test_passed(7) = lines(3)//''=='shall be        '
 call astring%justify(lines=lines, width=4)
 test_passed(8) = size(lines, dim=1)==6.and.lines(4)//''=='acknowledgment'
 astring = '   '
 call astring%justify(lines=lines, width=16)
 test_passed(9) = size(lines, dim=1)==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest