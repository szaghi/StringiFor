program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(5)
 astring = 'the sky is blue'
 test_passed(1) = astring%reverse_words()//''=='blue is sky the'
 astring = '  hello world  '
 test_passed(2) = astring%reverse_words()//''=='world hello'
 astring = 'a good   example'
 test_passed(3) = astring%reverse_words()//''=='example good a'
 astring = 'src/lib/stringifor'
 test_passed(4) = astring%reverse_words(sep='/')//''=='stringifor/lib/src'
 astring = '   '
 test_passed(5) = astring%reverse_words()//''==''
 print '(L1)', all(test_passed)
endprogram volatile_doctest