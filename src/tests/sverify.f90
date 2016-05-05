!< StringiFor `sverify` test.
program sverify
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `sverify` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring          !< A string.
character(len=:), allocatable :: acharacter       !< A character.
character(len=:), allocatable :: anothercharacter !< Another character.
integer                       :: i                !< Index result.
integer                       :: ic               !< Index result comparison.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
acharacter = 'Hello World Hello!'
anothercharacter = 'llo'
astring = acharacter
i = astring%sverify(set=anothercharacter)
ic = verify(string=acharacter, set=anothercharacter)
write(stdout, "(A,I2,A,L1)") 'Basic call result: ', i, ' is correct? ', i==ic
i = astring%sverify(set=anothercharacter, back=.true.)
ic = verify(string=acharacter, set=anothercharacter, back=.true.)
write(stdout, "(A,I2,A,L1)") 'Back call result: ', i, ' is correct? ', i==ic
anothercharacter = acharacter
i = astring%sverify(set=anothercharacter, back=.true.)
ic = verify(string=acharacter, set=anothercharacter, back=.true.)
write(stdout, "(A,I2,A,L1)") 'Identical strings call result: ', i, ' is correct? ', i==ic
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram sverify
