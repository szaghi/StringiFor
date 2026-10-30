program by_chars
!< Positions, lengths and widths in characters instead of bytes.
use stringifor
implicit none
type(string) :: text
type(string) :: names(3)
integer      :: n

! "Gruesse" with u-umlaut and sharp s, then the CJK "ni hao"
text = 'Gr'//char(195)//char(188)//char(195)//char(159)//'e '//char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
print '(A,I0,A,I0)', 'bytes: ', text%len(), ', characters: ', text%len(by=SF_CHARS)
print '(A,I0,A,I0)', 'space at byte ', text%index(' '), ', at character ', text%index(' ', by=SF_CHARS)
print '(A)', text%slice(first=7, last=8, by=SF_CHARS)
print '(A,I0,A,I0)', 'character 7 starts at byte ', text%byte_pos(7), ', byte 9 is in character ', text%char_pos(9)

names(1) = 'Ada'
names(2) = 'Jos'//char(195)//char(169)
names(3) = char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
do n = 1, size(names)
  print '(A)', '|'//names(n)%center(7, '.')//'|'//names(n)%center(7, '.', by=SF_CHARS)//'|'
enddo
endprogram by_chars
