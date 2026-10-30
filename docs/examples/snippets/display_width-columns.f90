do n = 1, size(names)
  print '(A,2(I0,1X),I0)', '|'//names(n)%ljust(8, '.', by=SF_COLUMNS)//'| bytes, characters, columns: ', &
    names(n)%len(), names(n)%len(by=SF_CHARS), names(n)%width()
enddo
