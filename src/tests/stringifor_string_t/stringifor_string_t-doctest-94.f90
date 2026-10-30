program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'hello world'
 test_passed(1) = astring%transliterate('lo', 'LO')//''=='heLLO wOrLd'
 test_passed(2) = astring%transliterate('elo', 'x')//''=='hxxxx wxrxd'
 test_passed(3) = astring%transliterate('lo', '')//''=='he wrd'
 print '(L1)', all(test_passed)
endprogram volatile_doctest