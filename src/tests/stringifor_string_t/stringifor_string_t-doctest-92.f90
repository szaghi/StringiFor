program volatile_doctest
use stringifor_string_t
 use penf
 type(string) :: astrings(3)
 real(R8P) :: reals(3)
 integer :: iostats(3)
 logical :: test_passed(3)
 astrings(1) = '3.4e9'
 astrings(2) = '12'
 astrings(3) = 'twelve'
 call astrings%read_number(reals, iostat=iostats)
 test_passed(1) = reals(1)==3.4e9_R8P.and.iostats(1)==0
 test_passed(2) = reals(2)==12._R8P.and.iostats(2)==0
 test_passed(3) = reals(3)/=reals(3).and.iostats(3)>0
 print '(L1)', all(test_passed)
endprogram volatile_doctest