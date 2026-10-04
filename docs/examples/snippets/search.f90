program search_text
!< Look for something in a string.
use stringifor
implicit none
type(string) :: s

s = 'report_2001_final.tar.gz'
print '(2(L1,1X))', s%start_with('report'), s%end_with('.gz')
print '(I0)', s%count('_')
print '(I0)', s%index('2001')
print '(I0)', s%index('.', back=.true.)
print '(I0)', s%scan('0123456789')              ! the first digit
print '(I0)', s%verify('abcdefghijklmnopqrstuvwxyz')  ! the first character that is not a letter
s = 'aaaa'
print '(I0,1X,I0)', s%count('aa'), s%count('aa', overlapping=.true.)
s = 'a.b.c.d'
print '(I0,1X,I0)', s%index('.', occurrence=2), s%index('.', back=.true., occurrence=2)
endprogram search_text
