header = '   year,   make , model,price   '
print '(A)', '['//header//']'
header = header%strip()                           ! blanks at both ends
print '(A)', '['//header//']'
header = header%replace(old=' ', new='')          ! every blank
print '(A)', '['//header//']'
print '(A)', '['//header%upper()//']'
