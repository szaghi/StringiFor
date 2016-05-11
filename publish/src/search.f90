!< StringiFor `search` test.
program search
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `search` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring        !< A string.
type(string)                  :: anotherstring  !< Another string.
character(len=:), allocatable :: acharacter     !< A character.
integer                       :: istart         !< Start index of searched tag.
integer                       :: iend           !< End index of searched tag.
logical                       :: test_passed(5) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '<test> <first> hello </first> <first> not the first </first> </test>'
anotherstring = astring%search(tag_start='<first>', tag_end='</first>')
test_passed(1) = anotherstring//''=='<first> hello </first>'
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,L1)") 'Search: "'//anotherstring//'", is correct? ', test_passed(1)

astring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
anotherstring = astring%search(tag_start='<a>', tag_end='</a>')
test_passed(2) = anotherstring//''=='<a> <a> <a> the nested a </a> </a> </a>'
write(stdout, "(A)") new_line('a')//'Original:  "'//astring//'"'
write(stdout, "(A,L1)") 'Search: "'//anotherstring//'", is correct? ', test_passed(2)

call astring%free
anotherstring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
astring = astring%search(in_string=anotherstring, tag_start='<a>', tag_end='</a>')
test_passed(3) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
write(stdout, "(A)") new_line('a')//'Original:  "'//anotherstring//'"'
write(stdout, "(A,L1)") 'Search: "'//astring//'", is correct? ', test_passed(3)

call astring%free
acharacter = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
astring = astring%search(in_character=acharacter, tag_start='<a>', tag_end='</a>')
test_passed(4) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
write(stdout, "(A)") new_line('a')//'Original:  "'//acharacter//'"'
write(stdout, "(A,L1)") 'Search: "'//astring//'", is correct? ', test_passed(4)

acharacter = '<test> <first> hello </first> <sec> <sec>not the first</sec> </sec> </test>'
astring = astring%search(in_character=acharacter, tag_start='<sec>', tag_end='</sec>', istart=istart, iend=iend)
test_passed(5) = astring//''==acharacter(31:67)
write(stdout, "(A)") new_line('a')//'Original:  "'//acharacter//'"'
write(stdout, "(A,L1)") 'Search: "'//astring//'", is correct? ', test_passed(5)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram search
