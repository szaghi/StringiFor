program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(4)
 astring = ' '//achar(9)//new_line('a')
 test_passed(1) = astring%is_space()
 astring = ' x '
 test_passed(2) = .not.astring%is_space()
 astring = ''
 test_passed(3) = .not.astring%is_space()
 astring = char(194)//char(160)//char(227)//char(128)//char(128)//' '
 test_passed(4) = astring%is_space(unicode=.true.).and..not.astring%is_space()
 print '(L1)', all(test_passed)
endprogram volatile_doctest