!< StringiFor `pythonishes` test.
program pythonishes
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `pythonishes` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)              :: astring       !< A string.
type(string), allocatable :: strings(:)    !< A set of strings.
integer                   :: s          !< Counter.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
write(stdout, "(A)") new_line('A')//'Unique'
astring = '+++ab-++cre-++cre-ab+++++'
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A)") 'Unique:   "'//astring%unique(substring='+')//'"'
write(stdout, "(A)") new_line('A')//'Split'
astring = '+ab-++cre-++cre-ab+'
write(stdout, "(A)") 'Split "'//astring//'" at "+"'
call astring%split(sep='+', tokens=strings)
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo
astring = 'ab-++cre-++cre-ab+'
write(stdout, "(A)") 'Split "'//astring//'" at "+"'
call astring%split(sep='+', tokens=strings)
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo
astring = 'ab-++cre-++cre-ab'
write(stdout, "(A)") 'Split "'//astring//'" at "+"'
call astring%split(sep='+', tokens=strings)
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo
astring = 'Hello '//new_line('a')//'World!'
write(stdout, "(A)") 'Split "'//astring//'" at "new_line"'
call astring%split(sep=new_line('a'), tokens=strings)
do s=1, size(strings)
  write(stdout, "(A)") '+ "'//strings(s)//'"'
enddo
deallocate(strings)
write(stdout, "(A)") new_line('A')//'Strip'
astring = '  Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A)") 'Strip:    "'//astring%strip()//'"'
write(stdout, "(A)") new_line('A')//'Swapcase'
astring = '  Hello World!   '
write(stdout, "(A)") 'Original: "'//astring//'"'
write(stdout, "(A)") 'Swapcase: "'//astring%swapcase()//'"'
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram pythonishes
