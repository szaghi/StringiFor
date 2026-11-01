call re%compile('^name', flags='im')
m = re%search('# header'//new_line('a')//'NAME = x')
print '(A,2I4)', m%group(0)//'', m%span(0)
call re%compile('(?s)a.b')
m = re%search('a'//new_line('a')//'b')
print '(L1)', m%found
call re%compile('(', iostat=iostat)
print '(I0,L2)', iostat, re%is_compiled()
