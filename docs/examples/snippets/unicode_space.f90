program unicode_space
!< Whitespace beyond ASCII: no-break and ideographic spaces, as in text copied from web pages or CJK documents.
use stringifor
implicit none
type(string) :: cell
type(string) :: words

cell = char(194)//char(160)//' 42 '//char(227)//char(128)//char(128) ! NBSP, ' 42 ', ideographic space
print '(A)', '['//cell%strip(whitespace=.true.)//']'
print '(A)', '['//cell%strip(whitespace=.true., unicode=.true.)//']'

words = 'one'//char(226)//char(128)//char(131)//'two'//char(194)//char(160)//char(194)//char(160)//'three' ! EM SPACE, 2 NBSP
print '(A)', words%compact(sep='|')//''
print '(A)', words%compact(sep='|', unicode=.true.)//''
print '(L1,1X,L1)', cell%is_space(), cell%is_space(unicode=.true.)
cell = char(194)//char(160)//char(227)//char(128)//char(128)
print '(L1,1X,L1)', cell%is_space(), cell%is_space(unicode=.true.)
endprogram unicode_space
