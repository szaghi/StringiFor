program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string), allocatable :: alist_str(:)
 character(len=:), allocatable :: files(:)
 character(len=:), allocatable :: directory
 integer :: file_unit
 integer :: f
 logical :: is_injected
 logical :: test_passed(5)
 files = [character(len=20) :: astring%tempname(prefix='glob test-'), astring%tempname(prefix='glob test-'), &
 astring%tempname(prefix='-glob-')]
 do f=1, size(files, dim=1)
 open(newunit=file_unit, file=files(f))
 close(unit=file_unit)
 enddo
 call astring%glob(pattern='glob test-*.tmp', list=alist_str)
 test_passed(1) = size(alist_str, dim=1)==2
 if (test_passed(1)) test_passed(1) = all(alist_str==files(1).or.alist_str==files(2))
 call astring%glob(pattern=files(3), list=alist_str)
 test_passed(2) = size(alist_str, dim=1)==1
 call astring%glob(pattern='glob test-*; touch glob-injected', list=alist_str)
 inquire(file='glob-injected', exist=is_injected)
 test_passed(3) = size(alist_str, dim=1)==0.and..not.is_injected
 do f=1, size(files, dim=1)
 open(newunit=file_unit, file=files(f))
 close(unit=file_unit, status='delete')
 enddo
 directory = astring%tempname(is_file=.false., prefix='glob-dir-')
 call execute_command_line('mkdir '//directory)
 call astring%glob(pattern=directory, list=alist_str)
 test_passed(4) = size(alist_str, dim=1)==1
 if (test_passed(4)) test_passed(4) = alist_str(1)==directory
 call execute_command_line('rmdir '//directory)
 call astring%glob(pattern='', list=alist_str)
 test_passed(5) = size(alist_str, dim=1)==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest