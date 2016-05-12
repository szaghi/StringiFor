!< StringiFor `sindex` test.
program sindex
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `sindex` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring          !< A string.
character(len=:), allocatable :: acharacter       !< A character.
character(len=:), allocatable :: anothercharacter !< Another character.
integer                       :: i                !< Index result.
integer                       :: ic               !< Index result comparison.
logical                       :: test_passed(6)   !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

acharacter = 'Hello World Hello!'
anothercharacter = 'llo'
astring = acharacter

i = astring%sindex(substring=anothercharacter)
ic = index(string=acharacter, substring=anothercharacter)
test_passed(1) = i==ic
write(stdout, "(A,I2,A,L1)") 'Sindex basic call result: ', i, ' is correct? ', test_passed(1)

i = astring%sindex(substring=anothercharacter, back=.true.)
ic = index(string=acharacter, substring=anothercharacter, back=.true.)
test_passed(2) = i==ic
write(stdout, "(A,I2,A,L1)") 'Sindex back call result: ', i, ' is correct? ', test_passed(2)

i = index(astring, substring=anothercharacter)
ic = index(string=acharacter, substring=anothercharacter)
test_passed(3) = i==ic
write(stdout, "(A,I2,A,L1)") 'Index basic call result: ', i, ' is correct? ', test_passed(3)

i = index(astring, substring=anothercharacter, back=.true.)
ic = index(string=acharacter, substring=anothercharacter, back=.true.)
test_passed(4) = i==ic
write(stdout, "(A,I2,A,L1)") 'Sindex back call result: ', i, ' is correct? ', test_passed(4)

astring = anothercharacter
i = index(acharacter, substring=astring)
ic = index(string=acharacter, substring=anothercharacter)
test_passed(5) = i==ic
write(stdout, "(A,I2,A,L1)") 'Index (inverted) basic call result: ', i, ' is correct? ', test_passed(5)

astring = anothercharacter
i = index(acharacter, substring=astring, back=.true.)
ic = index(string=acharacter, substring=anothercharacter, back=.true.)
test_passed(6) = i==ic
write(stdout, "(A,I2,A,L1)") 'Index (inverted) back call result: ', i, ' is correct? ', test_passed(6)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram sindex
