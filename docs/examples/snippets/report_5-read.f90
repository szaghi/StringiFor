call read_file(file=input%chars(), lines=rows)    ! one string for each line
print '(I0,A)', size(rows), ' rows read from '//input
