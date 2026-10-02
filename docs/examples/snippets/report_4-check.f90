prices(1) = '3000.00'
prices(2) = '4900.50'
prices(3) = '2500'
do p = 1, size(prices)
  print '(A,3(1X,L1))', prices(p)//':', prices(p)%is_number(), prices(p)%is_real(), prices(p)%is_integer()
enddo
cell = 'n/a'
print '(A,1X,L1)', cell//':', cell%is_number()
