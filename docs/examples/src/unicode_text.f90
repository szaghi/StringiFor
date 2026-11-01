!run unicode_text unicode_text
program unicode_text
!< A table of names in several scripts: what a string of bytes means when the text is UTF-8.
use stringifor
implicit none
type(string) :: names(3), text, bad
integer(I4P), allocatable :: codes(:)
integer :: i, b

!region literals
names(1) = 'Ren\u00e9e'
names(2) = 'Ada'
names(3) = '\u65e5\u672c\u8a9e'
names = names%unescape_c()
text = names(1)
print '(A)', text%chars()
print '(A)', text%escape_c()//''
!endregion literals

!region sizes
do i = 1, size(names)
  print '(A,": bytes ",I0,", characters ",I0,", columns ",I0)', names(i)%chars(), names(i)%len(), &
                                                                 names(i)%len(by=SF_CHARS), names(i)%width()
enddo
!endregion sizes

!region align
do i = 1, size(names)
  print '(3A)', '|', names(i)%ljust(8, '.')//'', '| bytes'
enddo
do i = 1, size(names)
  print '(3A)', '|', names(i)%ljust(8, '.', by=SF_COLUMNS)//'', '| columns'
enddo
!endregion align

!region positions
b = text%index('e', back=.true.)
print '(A,I0,A,I0)', 'last e: byte ', b, ', character ', text%index('e', back=.true., by=SF_CHARS)
print '(A,I0)', 'character 5 starts at byte ', text%byte_pos(5)
print '(A,I0)', 'byte 5 is in character ', text%char_pos(5)
print '(2A)', 'characters 1 to 4: ', text%slice(first=1, last=4, by=SF_CHARS)//''
bad = text%slice(first=1, last=4)
print '(2A)', 'bytes 1 to 4:      ', bad%escape_c()//''
!endregion positions

!region codes
codes = text%codepoints()
print '(*(Z0,:,1X))', codes
print '(A)', from_codepoints(codes(5:1:-1))//''
!endregion codes

!region check
bad = 'caf'//char(233)
print '(A,L2,A,I0)', 'well-formed:', bad%is_utf8(), ', first bad byte: ', bad%utf8_error()
print '(A)', bad%escape_c()//''
print '(A)', bad%to_valid_utf8()//''
print '(A)', bad%to_valid_utf8(replacement='?')//''
!endregion check

!region space
text = '\u3000 two\u00a0 words \u2003'
text = text%unescape_c()
print '(3A)', '[', text%strip(whitespace=.true., unicode=.true.)//'', ']'
print '(3A)', '[', text%compact(unicode=.true.)//'', ']'
print '(L1)', text%is_space(unicode=.true.)
!endregion space
endprogram unicode_text
