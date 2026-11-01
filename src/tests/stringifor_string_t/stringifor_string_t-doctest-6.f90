program volatile_doctest
use stringifor_string_t
 type(string) :: names(5)
 integer :: perm(5)
 logical :: test_passed(3)
 names = [string('file10'), string('File2'), string('file2'), string('b'), string('file1')]
 call strsort(names, index=perm)
 test_passed(1) = all(names == [string('File2'), string('b'), string('file1'), string('file10'), string('file2')]).and. &
 all(perm == [2, 4, 5, 1, 3])
 call strsort(names, less=strless_natural)
 test_passed(2) = all(names == [string('File2'), string('b'), string('file1'), string('file2'), string('file10')])
 call strsort(names, less=strless_nocase)
 test_passed(3) = all(names == [string('b'), string('file1'), string('file10'), string('File2'), string('file2')])
 print '(L1)', all(test_passed)
endprogram volatile_doctest