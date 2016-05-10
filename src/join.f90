!< StringiFor `join` test.
program join
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `join` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring         !< A string.
type(string) :: strings(3)      !< A set of strings.
character(5) :: characters(3)   !< A set of characters.
logical      :: test_passed(11) !< List of passed tests.
integer      :: s               !< Counter.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

strings(1) = 'one'
strings(2) = 'two'
strings(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo

write(stdout, "(A)") 'join (default sep) "'//astring%join(array=strings)//'"'
test_passed(1) = (astring%join(array=strings)//''==strings(1)//strings(2)//strings(3))

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=strings, sep='-')//'"'
test_passed(2) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2)//'-'//strings(3))

call strings(1)%free
strings(2) = 'two'
strings(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=strings, sep='-')//'"'
test_passed(3) = (astring%join(array=strings, sep='-')//''==strings(2)//'-'//strings(3))

strings(1) = 'one'
strings(2) = 'two'
call strings(3)%free
write(stdout, "(A)") 'Originals:'
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=strings, sep='-')//'"'
test_passed(4) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2))

strings(1) = 'one'
call strings(2)%free
strings(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=strings, sep='-')//'"'
test_passed(5) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(3))

characters(1) = 'one'
characters(2) = 'two'
characters(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(characters)
  write(stdout, "(A)") '+ "'//characters(s)//'"'
enddo

write(stdout, "(A)") 'join (default sep) "'//astring%join(array=characters)//'"'
test_passed(6) = (astring%join(array=characters)//''==characters(1)//characters(2)//characters(3))

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=characters, sep='-')//'"'
test_passed(7) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2)//'-'//characters(3))

characters(1) = ''
characters(2) = 'two'
characters(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(characters)
  write(stdout, "(A)") '+ "'//characters(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=characters, sep='-')//'"'
test_passed(8) = (astring%join(array=characters, sep='-')//''==characters(2)//'-'//characters(3))

characters(1) = 'one'
characters(2) = 'two'
characters(3) = ''
write(stdout, "(A)") 'Originals:'
do s=1, size(characters)
  write(stdout, "(A)") '+ "'//characters(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=characters, sep='-')//'"'
test_passed(9) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2))

characters(1) = 'one'
characters(2) = ''
characters(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(characters)
  write(stdout, "(A)") '+ "'//characters(s)//'"'
enddo

write(stdout, "(A)") 'join (sep="-") "'//astring%join(array=characters, sep='-')//'"'
test_passed(10) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(3))

characters(1) = 'one'
characters(2) = 'two'
characters(3) = 'three'
write(stdout, "(A)") 'Originals:'
do s=1, size(characters)
  write(stdout, "(A)") '+ "'//characters(s)//'"'
enddo

astring = '_'
write(stdout, "(A)") 'join (sep by astring) "'//astring%join(array=characters)//'"'
test_passed(11) = (astring%join(array=characters)//''==characters(1)//'_'//characters(2)//'_'//characters(3))

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram join
