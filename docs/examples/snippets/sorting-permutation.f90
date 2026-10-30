names = [string('c'), string('a'), string('b'), string('a'), string('c'), string('b')]
sizes = [3.0, 1.0, 2.0, 1.5, 3.5, 2.5]
call strsort(names, index=perm)
sizes = sizes(perm) ! the data follows its key; equal keys keep their order
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
print '(6(F3.1,1X))', sizes
