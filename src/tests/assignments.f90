!< StringiFor `assignments` test.
program assignments
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `assignments` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string, I1P, I2P, I4P, I8P, R4P, R8P
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
integer(I1P) :: ainteger_I1P   !< A integer (I1P).
integer(I2P) :: ainteger_I2P   !< A integer (I2P).
integer(I4P) :: ainteger_I4P   !< A integer (I4P).
integer(I8P) :: ainteger_I8P   !< A integer (I8P).
real(R4P)    :: areal_R4P      !< A real (R4P).
real(R8P)    :: areal_R8P      !< A real (R8P).
logical      :: test_passed(6) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

ainteger_I1P = 127_I1P
astring = ainteger_I1P
test_passed(1) = astring//''=='+127'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='+127'

ainteger_I2P = 32767_I2P
astring = ainteger_I2P
test_passed(2) = astring//''=='+32767'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='+32767'

ainteger_I4P = 2147483647_I4P
astring = ainteger_I4P
test_passed(3) = astring//''=='+2147483647'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='+2147483647'

ainteger_I8P = -9223372036854775807_I8P
astring = ainteger_I8P
test_passed(4) = astring//''=='-9223372036854775807'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='-9223372036854775807'

areal_R4P = 3.021e6
astring = areal_R4P
test_passed(5) = astring//''=='+0.302100E+07'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='+0.302100E+07'

areal_R8P = 7.00907641e23
astring = areal_R8P
test_passed(6) = astring//''=='+0.700907675971439E+024'
write(stdout, "(A,L1)") 'Assigned to: "'//astring//'" is correct? ', astring//''=='+0.700907675971439E+024'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram assignments
