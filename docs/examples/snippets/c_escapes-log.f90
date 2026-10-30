text = 'tab'//achar(9)//'nul'//achar(0)//'latin-1 '//char(233)//' utf-8 '//char(195)//char(169)
print '(A)', text%escape_c()//''
print '(A)', text%escape_c(ascii=.false.)//''
text = text%escape_c()
print '(A,L1)', 'read back: ', text%unescape_c()=='tab'//achar(9)//'nul'//achar(0)//'latin-1 '//char(233)// &
                                                 ' utf-8 '//char(195)//char(169)
