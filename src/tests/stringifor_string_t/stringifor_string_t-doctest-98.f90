program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(5)
 astring = 'hello world'
 test_passed(1) = astring%transliterate('lo', 'LO')//''=='heLLO wOrLd'
 test_passed(2) = astring%transliterate('elo', 'x')//''=='hxxxx wxrxd'
 test_passed(3) = astring%transliterate('lo', '')//''=='he wrd'
 astring = 'caf'//char(195)//char(169)
 test_passed(4) = astring%transliterate(char(195)//char(169), 'e')//''=='cafe'
 test_passed(5) = astring%transliterate('a'//char(195)//char(169), char(206)//char(177)//'E')//''== &
 'c'//char(206)//char(177)//'fE'
 print '(L1)', all(test_passed)
endprogram volatile_doctest