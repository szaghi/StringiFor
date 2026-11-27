program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(6)
 astring = '!?(),.;'
 test_passed(1) = astring%is_punct()
 astring = '!? ok'
 test_passed(2) = .not.astring%is_punct()
 astring = ''
 test_passed(3) = .not.astring%is_punct().and..not.astring%is_punct(unicode=.true.)
 astring = char(194)//char(171)//char(226)//char(128)//char(148)//char(226)//char(130)//char(172)//char(194)//char(187)//'+'
 test_passed(4) = astring%is_punct(unicode=.true.).and..not.astring%is_punct()
 astring = char(194)//char(171)//char(195)//char(169)//char(194)//char(187)
 test_passed(5) = .not.astring%is_punct(unicode=.true.)
 astring = '!'//char(128)
 test_passed(6) = .not.astring%is_punct(unicode=.true.)
 print '(L1)', all(test_passed)
endprogram volatile_doctest