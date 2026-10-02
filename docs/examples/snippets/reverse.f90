program reverse_things
!< Reverse the characters or the words.
use stringifor
implicit none
type(string) :: s

s = 'the sky is blue'
print '(A)', s%reverse()//''
print '(A)', s%reverse_words()//''
s = 'usr/local/lib'
print '(A)', s%reverse_words(sep='/')//''
endprogram reverse_things
