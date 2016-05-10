!< StringiFor `to_number` test.
program to_number
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `to_number` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string, I1P, I2P, I4P, I8P, R4P, R8P
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
integer(I1P) :: integer_I1P    !< A integer.
integer(I1P) :: integer_I1P_   !< A integer.
integer(I2P) :: integer_I2P    !< A integer.
integer(I2P) :: integer_I2P_   !< A integer.
integer(I4P) :: integer_I4P    !< A integer.
integer(I4P) :: integer_I4P_   !< A integer.
integer(I8P) :: integer_I8P    !< A integer.
integer(I8P) :: integer_I8P_   !< A integer.
real(R4P)    :: real_R4P       !< A real.
real(R4P)    :: real_R4P_      !< A real.
real(R8P)    :: real_R8P       !< A real.
real(R8P)    :: real_R8P_      !< A real.
logical      :: test_passed(6) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '127'
integer_I1P = astring%to_number(kind=1_I1P)
integer_I1P_ = 127_I1P
test_passed(1) = integer_I1P==integer_I1P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,I4,A)") 'To number: "', integer_I1P, '"'

astring = '32767'
integer_I2P = astring%to_number(kind=1_I2P)
integer_I2P_ = 32767_I2P
test_passed(2) = integer_I2P==integer_I2P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,I6,A)") 'To number: "', integer_I2P, '"'

astring = '2147483647'
integer_I4P = astring%to_number(kind=1_I4P)
integer_I4P_ = 2147483647_I4P
test_passed(3) = integer_I4P==integer_I4P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,I11,A)") 'To number: "', integer_I4P, '"'

astring = '-9223372036854775807'
integer_I8P = astring%to_number(kind=1_I8P)
integer_I8P_ = -9223372036854775807_I8P
test_passed(4) = integer_I8P==integer_I8P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,I20,A)") 'To number: "', integer_I8P, '"'

astring = '3.4e9'
real_R4P = astring%to_number(kind=1._R4P)
real_R4P_ = 3.4e9_R4P
test_passed(5) = real_R4P==real_R4P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,E13.6,A)") 'To number: "', real_R4P, '"'

astring = '-13.4345345e21'
real_R8P = astring%to_number(kind=1._R8P)
real_R8P_ = -13.4345345e21_R8P
test_passed(6) = real_R8P==real_R8P_
write(stdout, "(A)") 'Original:  "'//astring//'"'
write(stdout, "(A,E23.15,A)") 'To number: "', real_R8P, '"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram to_number
