program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(8)
 astring = 'When YOU are sad YOU should think to me :-)'
 test_passed(1) = (astring%replace(old='YOU', new='THEY')//''=='When THEY are sad THEY should think to me :-)')
 test_passed(2) = (astring%replace(old='YOU', new='THEY', count=1)//''=='When THEY are sad YOU should think to me :-)')
 astring = repeat(new_line('a')//'abcd', 20)
 astring = astring%replace(old=new_line('a'), new='|cr|')
 astring = astring%replace(old='|cr|', new=new_line('a')//'    ')
 test_passed(3) = (astring//''==repeat(new_line('a')//'    '//'abcd', 20))
 astring = 'abcd  efg    hlmn'
 astring = astring%replace(old='', new='-')
 test_passed(4) = (astring//''=='abcd  efg    hlmn')
 astring = 'aaa'
 test_passed(5) = (astring%replace(old='a', new='aa')//''=='aaaaaa')
 astring = 'aaaa'
 test_passed(6) = (astring%replace(old='aa', new='a')//''=='aa')
 astring = 'abab'
 test_passed(7) = (astring%replace(old='ab', new='x', count=0)//''=='abab')
 test_passed(8) = (astring%replace(old='ab', new='')//''=='')
 print '(L1)', all(test_passed)
endprogram volatile_doctest