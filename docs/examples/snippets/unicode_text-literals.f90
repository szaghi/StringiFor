names(1) = 'Ren\u00e9e'
names(2) = 'Ada'
names(3) = '\u65e5\u672c\u8a9e'
names = names%unescape_c()
text = names(1)
print '(A)', text%chars()
print '(A)', text%escape_c()//''
