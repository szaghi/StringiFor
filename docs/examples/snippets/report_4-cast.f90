highest = 0._R8P
do p = 1, size(prices)
  price = prices(p)%to_number(kind=1._R8P)        ! the kind of the result is the kind of the argument
  highest = max(highest, price)
enddo
print '(A,F0.2)', 'highest price: ', highest
