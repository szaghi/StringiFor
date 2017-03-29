!< StringiFor `start_end` test.
program start_end
!< StringiFor `start_end` test.
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string

implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(9) !< List of passed tests.

test_passed = .false.

astring = 'Hello WorLD!'
write(stdout, "(A)") 'Original: "'//astring//'"'

test_passed(1) = astring%start_with(prefix='Hello').eqv..true.
write(stdout, "(A,L1)") 'start with "Hello"? ', astring%start_with(prefix='Hello')

test_passed(2) = astring%start_with(prefix='hell').eqv..false.
write(stdout, "(A,L1)") 'start with "hell"? ', astring%start_with(prefix='hell')

test_passed(3) = astring%start_with(prefix='llo Wor', start=3).eqv..true.
write(stdout, "(A,L1)") 'slice (3:) start with "llo Wor"? ', astring%start_with(prefix='llo Wor', start=3)

test_passed(4) = astring%start_with(prefix='lo W', start=4, end=7).eqv..true.
write(stdout, "(A,L1)") 'slice (4:7) start with "lo W"? ', astring%start_with(prefix='lo W', start=4, end=7)

test_passed(5) = astring%end_with(suffix='LD!').eqv..true.
write(stdout, "(A,L1)") 'end with "LD!"? ', astring%end_with(suffix='LD!')

test_passed(6) = astring%end_with(suffix='lD!').eqv..false.
write(stdout, "(A,L1)") 'end with "lD!"? ', astring%end_with(suffix='lD!')

test_passed(7) = astring%end_with(suffix='orLD!', start=5).eqv..true.
write(stdout, "(A,L1)") 'slice (5:) end with "orLD!"? ', astring%end_with(suffix='orLD!', start=5)

test_passed(8) = astring%end_with(suffix='orLD!', start=8, end=12).eqv..true.
write(stdout, "(A,L1)") 'slice (8:12) end with "orLD!"? ', astring%end_with(suffix='orLD!', start=8, end=12)

test_passed(9) = astring%end_with(suffix='!').eqv..true.
write(stdout, "(A,L1)") 'end with "!"? ', astring%end_with(suffix='!')

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
endprogram start_end
