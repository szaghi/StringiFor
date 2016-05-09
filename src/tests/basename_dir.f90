!< StringiFor `basename_dir` test.
program basename_dir
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `basename_dir` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string) :: astring        !< A string.
logical      :: test_passed(8) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = '/bar/foo.tar.bz2'
write(stdout, "(A)") 'Original:                  "'//astring//'"'

test_passed(1) = (astring%basedir()//''=='/bar')
write(stdout, "(A)") 'Basedir:                   "'//astring%basedir()//'"'

test_passed(2) = (astring%basename()//''=='foo.tar.bz2')
write(stdout, "(A)") 'Basename:                  "'//astring%basename()//'"'

test_passed(3) = (astring%basename(extension='.tar')//''=='foo')
write(stdout, "(A)") 'Basename (extension):      "'//astring%basename(extension='.tar')//'"'

test_passed(4) = (astring%basename(strip_last_extension=.true.)//''=='foo.tar')
write(stdout, "(A)") 'Basename (last extension): "'//astring%basename(strip_last_extension=.true.)//'"'

astring = '\bar\foo.tar.bz2'
write(stdout, "(A)") 'Original (\ sep):          "'//astring//'"'

test_passed(5) = (astring%basedir(sep='\')//''=='\bar')
write(stdout, "(A)") 'Basedir:                   "'//astring%basedir(sep='\')//'"'

test_passed(6) = (astring%basename(sep='\')//''=='foo.tar.bz2')
write(stdout, "(A)") 'Basename:                  "'//astring%basename(sep='\')//'"'

test_passed(7) = (astring%basename(sep='\', extension='.tar')//''=='foo')
write(stdout, "(A)") 'Basename (extension):      "'//astring%basename(sep='\', extension='.tar')//'"'

test_passed(8) = (astring%basename(sep='\', strip_last_extension=.true.)//''=='foo.tar')
write(stdout, "(A)") 'Basename (last extension): "'//astring%basename(sep='\', strip_last_extension=.true.)//'"'

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram basename_dir
