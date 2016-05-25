!< StringiFor `insert` test.
program insert
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `insert` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring         !< A string.
type(string)                  :: anotherstring   !< Another string.
character(len=:), allocatable :: acharacter      !< A character.
logical                       :: test_passed(10) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'this is string example wow!!!'
anotherstring = '... '
acharacter = '... '

write(stdout, "(A)") 'Original string:  "'//astring//'"'
write(stdout, "(A)") 'Substring:  "'//anotherstring//'"'

write(stdout, "(A)") 'Test substring of type string'
test_passed(1) = astring%insert(substring=anotherstring, pos=1)//''=='... this is string example wow!!!'
write(stdout, "(A,L1)") 'insert at pos=1: "'//astring%insert(substring=anotherstring, pos=1)//'", is correct? ', test_passed(1)

test_passed(2) = astring%insert(substring=anotherstring, pos=23)//''=='this is string example...  wow!!!'
write(stdout, "(A,L1)") 'insert at pos=23: "'//astring%insert(substring=anotherstring, pos=23)//'", is correct? ', test_passed(2)

test_passed(3) = astring%insert(substring=anotherstring, pos=29)//''=='this is string example wow!!!... '
write(stdout, "(A,L1)") 'insert at pos=29: "'//astring%insert(substring=anotherstring, pos=29)//'", is correct? ', test_passed(3)

test_passed(4) = astring%insert(substring=anotherstring, pos=-1)//''=='... this is string example wow!!!'
write(stdout, "(A,L1)") 'insert at pos=-1: "'//astring%insert(substring=anotherstring, pos=-1)//'", is correct? ', test_passed(4)

test_passed(5) = astring%insert(substring=anotherstring, pos=100)//''=='this is string example wow!!!... '
write(stdout, "(A,L1)") 'insert at pos=100: "'//astring%insert(substring=anotherstring, pos=100)//'", is correct? ', test_passed(5)

write(stdout, "(A)") 'Test substring of type character'
test_passed(6) = astring%insert(substring=acharacter, pos=1)//''=='... this is string example wow!!!'
write(stdout, "(A,L1)") 'insert at pos=1: "'//astring%insert(substring=acharacter, pos=1)//'", is correct? ', test_passed(6)

test_passed(7) = astring%insert(substring=acharacter, pos=23)//''=='this is string example...  wow!!!'
write(stdout, "(A,L1)") 'insert at pos=23: "'//astring%insert(substring=acharacter, pos=23)//'", is correct? ', test_passed(7)

test_passed(8) = astring%insert(substring=acharacter, pos=29)//''=='this is string example wow!!!... '
write(stdout, "(A,L1)") 'insert at pos=29: "'//astring%insert(substring=acharacter, pos=29)//'", is correct? ', test_passed(8)

test_passed(9) = astring%insert(substring=acharacter, pos=-1)//''=='... this is string example wow!!!'
write(stdout, "(A,L1)") 'insert at pos=-1: "'//astring%insert(substring=acharacter, pos=-1)//'", is correct? ', test_passed(9)

test_passed(10) = astring%insert(substring=acharacter, pos=100)//''=='this is string example wow!!!... '
write(stdout, "(A,L1)") 'insert at pos=100: "'//astring%insert(substring=acharacter, pos=100)//'", is correct? ', test_passed(10)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram insert
