names(1) = 'Ada'
names(2) = 'Jos'//char(195)//char(169)
names(3) = char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
do n = 1, size(names)
  print '(A)', '|'//names(n)%center(7, '.')//'|'//names(n)%center(7, '.', by=SF_CHARS)//'|'
enddo
