print '(A)', 'directory: '//input%basedir()
print '(A)', 'file:      '//input%basename()
print '(A)', 'extension: '//input%extension()
output = input%basename(strip_last_extension=.true.)//'.md'
