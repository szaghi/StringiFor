all = re%finditer('write to ann@example.org or bob@test.net')
do i = 1, size(all)
  print '(I0,2A)', i, ': ', all(i)%group('user')//''
enddo
