pieces = row%partition(sep=', ')                  ! before, separator, after
print '(A)', 'year: '//pieces(1)
print '(A)', 'rest: '//pieces(3)
print '(A,I0)', 'commas: ', row%count(',')
