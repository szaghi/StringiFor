do i = 1, size(names)
  print '(A,": bytes ",I0,", characters ",I0,", columns ",I0)', names(i)%chars(), names(i)%len(), &
                                                                 names(i)%len(by=SF_CHARS), names(i)%width()
enddo
