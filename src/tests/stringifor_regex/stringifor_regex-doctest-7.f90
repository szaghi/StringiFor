program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(string), allocatable :: p(:)
 logical :: test_passed(3)
 call re%compile('\s*[,;]\s*')
 p = re%split('a , b;c ;  d')
 test_passed(1) = size(p)==4.and.p(4)=='d'
 p = re%split('a , b;c ;  d', maxsplit=1)
 test_passed(2) = size(p)==2.and.p(2)=='b;c ;  d'
 call re%compile('([,;])')
 p = re%split('a,b;c')
 test_passed(3) = size(p)==5.and.p(2)==','.and.p(4)==';'
 print '(L1)', all(test_passed)
endprogram volatile_doctest