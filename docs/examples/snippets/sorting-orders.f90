names = [string('run10.dat'), string('Run2.dat'), string('run2.dat'), string('run1.dat'), string('README'), &
         string('run02.dat')]
call strsort(names)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
call strsort(names, less=strless_natural)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
call strsort(names, less=strless_nocase)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
