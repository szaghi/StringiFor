m = re_fullmatch('2026-10-31', '\d{4}-\d\d-\d\d')
print '(A,L2)', 're_fullmatch 2026-10-31:', m%found
call re%compile('\d{4}-\d\d-\d\d')
m = re%fullmatch('on 2026-10-31')
print '(A,L2)', 'fullmatch on 2026-10-31:', m%found
m = re%search('on 2026-10-31')
print '(A,L2)', 'search on 2026-10-31:   ', m%found
