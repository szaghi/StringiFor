program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 character(len=:), allocatable :: acharacter
 logical :: test_passed(3)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((astring>=acharacter).eqv..true.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((astring>=acharacter).eqv..false.)
 astring = 'ONE'
 acharacter = 'ONE'
 test_passed(3) = ((astring>=acharacter).eqv..true.)
 print '(L1)', all(test_passed)
endprogram volatile_doctest