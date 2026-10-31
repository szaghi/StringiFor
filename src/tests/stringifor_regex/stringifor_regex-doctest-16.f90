program volatile_doctest
use stringifor_regex
 type(string) :: s
 s = re_sub('x=1, y=22', '(\w)=(\d+)', '\2=\1')
 print '(L1)', s=='1=x, 22=y'
endprogram volatile_doctest