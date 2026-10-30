program volatile_doctest
use stringifor_string_t
 use penf
 type(string) :: astring
 integer(I4P) :: integer_
 integer :: iostat
 character(len=99) :: iomsg
 logical :: test_passed(4)
 astring = '127'
 call astring%read_number(integer_, iostat=iostat)
 test_passed(1) = integer_==127_I4P.and.iostat==0
 astring = '12x'
 call astring%read_number(integer_, iostat=iostat, iomsg=iomsg)
 test_passed(2) = integer_==0_I4P.and.iostat>0.and.trim(iomsg)=='the string is not an integer'
 astring = '99999999999'
 call astring%read_number(integer_, iostat=iostat)
 test_passed(3) = integer_==0_I4P.and.iostat/=0
 call astring%free
 call astring%read_number(integer_, iostat=iostat)
 test_passed(4) = iostat>0
 print '(L1)', all(test_passed)
endprogram volatile_doctest