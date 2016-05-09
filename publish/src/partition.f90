!< StringiFor `partition` test.
program partition
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `partition` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
type(string) :: strings(3)     !< A set of strings.
logical      :: test_passed(3) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'Hello WorLD!'
strings = astring%partition(sep='lo Wo')
test_passed(1) = (strings(1)//''=='Hel'.and.strings(2)//''=='lo Wo'.and.strings(3)//''=='rLD!')
write(stdout, "(A)") 'Original: "'//astring//'" separator: "'//'lo Wo'//'"'
write(stdout, "(A)") 'Before sep: "'//strings(1)//'"'
write(stdout, "(A)") 'Sep itself: "'//strings(2)//'"'
write(stdout, "(A)") 'After sep:  "'//strings(3)//'"'

strings = astring%partition(sep='Hello')
test_passed(2) = (strings(1)//''==''.and.strings(2)//''=='Hello'.and.strings(3)//''==' WorLD!')
write(stdout, "(A)") 'Original: "'//astring//'" separator: "'//'Hello'//'"'
write(stdout, "(A)") 'Before sep: "'//strings(1)//'"'
write(stdout, "(A)") 'Sep itself: "'//strings(2)//'"'
write(stdout, "(A)") 'After sep:  "'//strings(3)//'"'

astring = 'Hello WorLD!'
strings = astring%partition()
test_passed(3) = (strings(1)//''=='Hello'.and.strings(2)//''==' '.and.strings(3)//''=='WorLD!')
write(stdout, "(A)") 'Original: "'//astring//'" separator: "'//' '//'"'
write(stdout, "(A)") 'Before sep: "'//strings(1)//'"'
write(stdout, "(A)") 'Sep itself: "'//strings(2)//'"'
write(stdout, "(A)") 'After sep:  "'//strings(3)//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram partition
