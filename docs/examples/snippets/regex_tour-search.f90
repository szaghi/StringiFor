call re%compile('(?P<user>\w+)@(?P<host>[\w.]+)')
m = re%search('write to ann@example.org or bob@test.net')
print '(L1,1X,A,1X,2I3)', m%found, m%group(0)//'', m%span(0)
print '(A,1X,A)', m%group('user')//'', m%group('host')//''
