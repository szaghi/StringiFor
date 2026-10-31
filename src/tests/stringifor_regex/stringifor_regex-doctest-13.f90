program volatile_doctest
use stringifor_regex
 logical :: test_passed(2)
 type(regex_match) :: m
 m = re_fullmatch('2026-10-30', '\d{4}-\d\d-\d\d')
 test_passed(1) = m%found
 m = re_fullmatch('2026-10-30 ', '\d{4}-\d\d-\d\d')
 test_passed(2) = .not.m%found
 print '(L1)', all(test_passed)
endprogram volatile_doctest