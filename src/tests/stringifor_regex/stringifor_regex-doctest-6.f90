program volatile_doctest
use stringifor_regex
 type(regex) :: re
 type(string), allocatable :: t(:)
 logical :: test_passed(3)
 call re%compile('-?\d+(?:\.\d+)?')
 t = re%findall('x=1.5, y=-2, z=30')
 test_passed(1) = size(t)==3.and.t(2)=='-2'
 call re%compile('(\w+)=')
 t = re%findall('x=1.5, y=-2')
 test_passed(2) = size(t)==2.and.t(1)=='x'.and.t(2)=='y'
 t = re%findall('x=1.5, y=-2', group=0)
 test_passed(3) = t(2)=='y='
 print '(L1)', all(test_passed)
endprogram volatile_doctest