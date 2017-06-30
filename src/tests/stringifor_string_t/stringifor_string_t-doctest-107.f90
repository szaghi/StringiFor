program volatile_doctest
use stringifor_string_t
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 integer                       :: iostat
 character(len=99)             :: iomsg
 logical                       :: test_passed(1)
 acharacter = 'New Hello World!'
 read(acharacter, "(DT)", iostat=iostat, iomsg=iomsg) astring
 test_passed(1) = iostat==0 .and. astring=='New Hello World!'
 !acharacter = '"Has quotes" not read'
 !read(acharacter, *, iostat=iostat, iomsg=iomsg) astring
 !test_passed(2) = (astring == 'Has quotes')
 !acharacter = 'NoSpaces'
 !read(acharacter, *, iostat=iostat, iomsg=iomsg) astring
 !test_passed(2) = (astring == 'NoSpaces')
 print '(L1)', all(test_passed)
endprogram volatile_doctest