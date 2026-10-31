program volatile_doctest
use stringifor_regex
 type(regex) :: re
 integer :: iostat
 character(len=99) :: iomsg
 logical :: test_passed(6)
 call re%compile('(\d+)-(\d+)', iostat=iostat)
 test_passed(1) = iostat==0.and.re%group_count()==2
 call re%compile('a(b', iostat=iostat, iomsg=iomsg)
 test_passed(2) = iostat==4.and.trim(iomsg)=='missing ), unterminated group opened at byte 2'
 call re%compile('x{2,1}', iostat=iostat)
 test_passed(3) = iostat==2
 call re%compile('a{1001}', iostat=iostat, iomsg=iomsg)
 test_passed(4) = iostat==2.and.trim(iomsg)=='repeat count above 1000'
 call re%compile(repeat('(', 300)//repeat(')', 300), iostat=iostat, iomsg=iomsg)
 test_passed(5) = iostat==201.and.trim(iomsg)=='groups nested too deep'
 call re%compile('(a{1000}){1000}', iostat=iostat, iomsg=iomsg)
 test_passed(6) = iostat==1.and.index(iomsg, 'pattern too large')==1.and..not.re%is_compiled()
 print '(L1)', all(test_passed)
endprogram volatile_doctest