program c_escapes
!< Non-ASCII text written in ASCII source, and any bytes logged readably.
use stringifor
implicit none
type(string) :: text

text = 'Gr\u00fc\u00dfe, \u4f60\u597d! \U0001f600'
text = text%unescape_c()
print '(A)', text%chars()

text = 'tab'//achar(9)//'nul'//achar(0)//'latin-1 '//char(233)//' utf-8 '//char(195)//char(169)
print '(A)', text%escape_c()//''
print '(A)', text%escape_c(ascii=.false.)//''
text = text%escape_c()
print '(A,L1)', 'read back: ', text%unescape_c()=='tab'//achar(9)//'nul'//achar(0)//'latin-1 '//char(233)// &
                                                 ' utf-8 '//char(195)//char(169)

text = 'ok\n, then \q and \u12'
print '(A,I0)', 'first malformed escape at byte ', text%escapes_error()
print '(A)', text%unescape_c()//''
endprogram c_escapes
