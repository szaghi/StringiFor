program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = ' '//achar(9)//new_line('a')
 test_passed(1) = astring%is_space()
 astring = ' x '
 test_passed(2) = .not.astring%is_space()
 astring = ''
 test_passed(3) = .not.astring%is_space()
 print '(L1)', all(test_passed)
endprogram volatile_doctest