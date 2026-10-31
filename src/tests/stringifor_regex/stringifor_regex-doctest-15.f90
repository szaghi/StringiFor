program volatile_doctest
use stringifor_regex
 type(string), allocatable :: fields(:)
 fields = re_split('a1b22c', '\d+')
 print '(L1)', size(fields)==3.and.fields(2)=='b'
endprogram volatile_doctest