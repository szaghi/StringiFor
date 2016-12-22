!< StringiFor `tempname` test.
program tempname
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `tempname` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring        !< A string.
character(len=:), allocatable :: tmpname        !< A temporary name.
logical                       :: test_passed(5) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

tmpname = astring%tempname()
inquire(file=tmpname, exist=test_passed(1))
test_passed(1) = .not.test_passed(1)
write(stdout, "(A,L1)") 'tempname: "'//tmpname//'", is safe? ', test_passed(1)

tmpname = astring%tempname(is_file=.false.)
inquire(file=tmpname, exist=test_passed(2))
test_passed(2) = .not.test_passed(2)
write(stdout, "(A,L1)") 'tempname: "'//tmpname//'", is safe? ', test_passed(2)

tmpname = astring%tempname(path='./')
inquire(file=tmpname, exist=test_passed(3))
test_passed(3) = .not.test_passed(3)
write(stdout, "(A,L1)") 'tempname: "'//tmpname//'", is safe? ', test_passed(3)

astring = 'me-'
tmpname = astring%tempname()
inquire(file=tmpname, exist=test_passed(4))
test_passed(4) = .not.test_passed(4)
write(stdout, "(A,L1)") 'tempname: "'//tmpname//'", is safe? ', test_passed(4)

tmpname = astring%tempname(prefix='you-')
inquire(file=tmpname, exist=test_passed(5))
test_passed(5) = .not.test_passed(5)
write(stdout, "(A,L1)") 'tempname: "'//tmpname//'", is safe? ', test_passed(5)

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram tempname
