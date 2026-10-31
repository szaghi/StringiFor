program volatile_doctest
use stringifor_regex
 type(string), allocatable :: words(:)
 words = re_findall('one, two;three', '\w+')
 print '(L1)', size(words)==3.and.words(3)=='three'
endprogram volatile_doctest