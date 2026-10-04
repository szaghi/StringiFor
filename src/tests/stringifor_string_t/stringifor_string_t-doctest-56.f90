program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(6)
 astring = 'Hello World'
 test_passed(1) = astring%len_last_word()==5
 astring = '   fly me   to   the moon  '
 test_passed(2) = astring%len_last_word()==4
 astring = 'joyboy'
 test_passed(3) = astring%len_last_word()==6
 astring = 'src/lib/stringifor//'
 test_passed(4) = astring%len_last_word(sep='/')==10
 astring = '    '
 test_passed(5) = astring%len_last_word()==0
 call astring%free
 test_passed(6) = astring%len_last_word()==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest