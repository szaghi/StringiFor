cell = char(194)//char(160)//' 42 '//char(227)//char(128)//char(128) ! NBSP, ' 42 ', ideographic space
print '(A)', '['//cell%strip(whitespace=.true.)//']'
print '(A)', '['//cell%strip(whitespace=.true., unicode=.true.)//']'
