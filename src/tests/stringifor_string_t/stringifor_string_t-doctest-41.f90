program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string), allocatable :: alist_str(:)
 character(len=:), allocatable :: alist_chr(:)
 logical :: test_passed(2)
 call astring%glob(pattern='no-file-has-this-name-*', list=alist_str)
 test_passed(1) = allocated(alist_str).and.size(alist_str, dim=1)==0
 call astring%glob(pattern='no-file-has-this-name-*', list=alist_chr)
 test_passed(2) = allocated(alist_chr).and.size(alist_chr, dim=1)==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest