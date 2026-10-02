print '(A)', '| '//glue%join(array=cells, sep=' | ')//' |'
glue = '-'
print '(A)', glue%join(array=cells(2:3))//''      ! the string itself is the separator
