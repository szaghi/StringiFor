program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: folded
 logical :: test_passed(6)
 astring = 'Stra'//char(195)//char(159)//'e'
 folded = astring%casefold()
 test_passed(1) = folded//''=='strasse'
 astring = 'STRASSE'
 test_passed(2) = astring%casefold()==folded
 astring = 'A'//char(255)//'B'//char(206)
 folded = astring%casefold()
 test_passed(3) = folded//''=='a'//char(255)//'b'//char(206)
 astring = ''
 folded = astring%casefold()
 test_passed(4) = folded%is_allocated().and.folded//''==''
 astring = char(206)//char(163)//char(206)//char(145)//char(206)//char(163)//char(207)//char(130)
 folded = astring%casefold()
 test_passed(5) = folded//''==char(207)//char(131)//char(206)//char(177)//char(207)//char(131)//char(207)//char(131)
 call astring%free
 folded = astring%casefold()
 test_passed(6) = .not.folded%is_allocated()
 print '(L1)', all(test_passed)
endprogram volatile_doctest