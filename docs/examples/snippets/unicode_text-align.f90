do i = 1, size(names)
  print '(3A)', '|', names(i)%ljust(8, '.')//'', '| bytes'
enddo
do i = 1, size(names)
  print '(3A)', '|', names(i)%ljust(8, '.', by=SF_COLUMNS)//'', '| columns'
enddo
