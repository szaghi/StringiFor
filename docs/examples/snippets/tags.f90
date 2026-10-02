program tagged_text
!< The text between two tags.
use stringifor
implicit none
type(string) :: s, found
integer      :: first, last

s = '<b>bold</b> plain <b>bold again</b>'
found = s%search(tag_start='<b>', tag_end='</b>', istart=first, iend=last)
print '(A,2(1X,I0))', found//'', first, last
endprogram tagged_text
