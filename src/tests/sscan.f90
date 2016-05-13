!< StringiFor `sscan` test.
program sscan
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `sscan` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring          !< A string.
type(string)                  :: anotherstring    !< Another string.
character(len=:), allocatable :: acharacter       !< A character.
character(len=:), allocatable :: anothercharacter !< Another character.
integer                       :: i                !< Index result.
integer                       :: ic               !< Index result comparison.
logical                       :: test_passed(5)   !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

acharacter = 'Hello World Hello!'
anothercharacter = 'llo'
astring = acharacter
anotherstring = anothercharacter

i = astring%scan(set=anothercharacter)
ic = scan(string=acharacter, set=anothercharacter)
test_passed(1) = i==ic
write(stdout, "(A,I2,A,L1)") 'Basic call result: ', i, ' is correct? ', test_passed(1)

i = astring%scan(set=anothercharacter, back=.true.)
ic = scan(string=acharacter, set=anothercharacter, back=.true.)
test_passed(2) = i==ic
write(stdout, "(A,I2,A,L1)") 'Back call result: ', i, ' is correct? ', test_passed(2)

i = scan(astring, set=anothercharacter, back=.true.)
ic = scan(string=acharacter, set=anothercharacter, back=.true.)
test_passed(3) = i==ic
write(stdout, "(A,I2,A,L1)") 'Back call (builtin) result: ', i, ' is correct? ', test_passed(3)

i = scan(acharacter, set=anotherstring, back=.true.)
ic = scan(string=acharacter, set=anothercharacter, back=.true.)
test_passed(4) = i==ic
write(stdout, "(A,I2,A,L1)") 'Back call (builtin) result: ', i, ' is correct? ', test_passed(4)

i = scan(astring, set=anotherstring, back=.true.)
ic = scan(string=acharacter, set=anothercharacter, back=.true.)
test_passed(5) = i==ic
write(stdout, "(A,I2,A,L1)") 'Back call (builtin) result: ', i, ' is correct? ', test_passed(5)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram sscan
