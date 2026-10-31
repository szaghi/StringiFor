program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(regex_match), allocatable :: m(:)
 logical :: test_passed(3)
 call re%compile('\d+')
 m = re%finditer('a1 b22 c333')
 test_passed(1) = size(m)==3.and.m(3)%group(0)=='333'.and.all(m(2)%span(0)==[5, 6])
 call re%compile('x*')
 m = re%finditer('axb')
 test_passed(2) = size(m)==4 ! '' at 1, 'x' at 2, '' at 3 (after a non-empty match), '' at the end
 test_passed(3) = all(m(3)%span(0)==[3, 2]).and.all(m(4)%span(0)==[4, 3])
 print '(L1)', all(test_passed)
endprogram volatile_doctest