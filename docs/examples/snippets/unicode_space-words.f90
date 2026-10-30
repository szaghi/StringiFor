words = 'one'//char(226)//char(128)//char(131)//'two'//char(194)//char(160)//char(194)//char(160)//'three' ! EM SPACE, 2 NBSP
print '(A)', words%compact(sep='|')//''
print '(A)', words%compact(sep='|', unicode=.true.)//''
print '(L1,1X,L1)', cell%is_space(), cell%is_space(unicode=.true.)
cell = char(194)//char(160)//char(227)//char(128)//char(128)
print '(L1,1X,L1)', cell%is_space(), cell%is_space(unicode=.true.)
