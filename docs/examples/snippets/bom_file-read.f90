call text%read_file(file='windows.txt')
print '(A,L1,A,L1)', 'has a BOM: ', text%has_bom(), ', starts with key: ', text%start_with('key')
call text%read_file(file='windows.txt', skip_bom=.true.)
print '(A,L1,A,L1)', 'has a BOM: ', text%has_bom(), ', starts with key: ', text%start_with('key')
call read_file(file='windows.txt', lines=lines, skip_bom=.true.)
print '(A)', lines(1)//'|'
