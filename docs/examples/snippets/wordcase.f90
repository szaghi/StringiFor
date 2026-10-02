program word_case
!< Word-level case styles.
use stringifor
implicit none
type(string) :: s

s = 'the quick brown fox'
print '(A)', s%startcase()//''
print '(A)', s%camelcase()//''
print '(A)', s%snakecase()//''
s = 'the-quick-brown-fox'
print '(A)', s%camelcase(sep='-')//''
endprogram word_case
