program volatile_doctest
use stringifor_encodings
 character(len=:), allocatable :: utf8
 character(len=:), allocatable :: carry
 integer :: iostat
 logical :: test_passed(5)
 call to_utf8(bytes='caf'//char(233), encoding='latin1', utf8=utf8)
 test_passed(1) = utf8=='caf'//char(195)//char(169)
 call to_utf8(bytes=char(128)//'5', encoding='windows-1252', utf8=utf8)
 test_passed(2) = utf8==char(226)//char(130)//char(172)//'5'
 carry = ''
 call to_utf8(bytes='a'//char(0)//char(61), encoding='UTF-16LE', utf8=utf8, carry=carry, is_last=.false.)
 test_passed(3) = utf8=='a'.and.len(carry)==1
 call to_utf8(bytes=char(216)//char(0)//char(222), encoding='UTF-16LE', utf8=utf8, carry=carry, is_last=.true.)
 test_passed(4) = utf8==char(240)//char(159)//char(152)//char(128)
 call to_utf8(bytes='a'//char(0)//char(0)//char(220), encoding='UTF-16LE', utf8=utf8, iostat=iostat)
 test_passed(5) = utf8=='a'//char(239)//char(191)//char(189).and.iostat==3
 print '(L1)', all(test_passed)
endprogram volatile_doctest