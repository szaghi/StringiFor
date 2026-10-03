program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(9)
 astring = 'data/report-2026.csv'
 test_passed(1) = astring%match('*.csv')
 test_passed(2) = astring%match('data/report-????.csv')
 test_passed(3) = astring%match('*-20[0-9][0-9].*')
 test_passed(4) = .not.astring%match('*.CSV')
 test_passed(5) = .not.astring%match('report*')
 test_passed(6) = astring%match('*[!a-z].csv')
 astring = 'a*b'
 test_passed(7) = astring%match('a[*]b').and..not.astring%match('a[*]c')
 astring = ''
 test_passed(8) = astring%match('*').and..not.astring%match('?')
 astring = '[x]'
 test_passed(9) = astring%match('[[]x]').and.astring%match('[[]x[]]').and..not.astring%match('[]x]*')
 print '(L1)', all(test_passed)
endprogram volatile_doctest