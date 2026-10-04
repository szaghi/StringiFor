program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(3)
 astring = 'Fortran'
 test_passed(1) = astring%is_alpha()
 astring = 'Fortran2023'
 test_passed(2) = .not.astring%is_alpha()
 astring = ''
 test_passed(3) = .not.astring%is_alpha()
 print '(L1)', all(test_passed)
endprogram volatile_doctest