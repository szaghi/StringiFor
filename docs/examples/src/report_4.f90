!as report
!run report_4 report
program report
!< Tutorial, chapter 4: numbers.
use stringifor
implicit none
type(string) :: prices(3), cell, total
real(R8P)    :: price, highest
integer      :: p

!region check
prices(1) = '3000.00'
prices(2) = '4900.50'
prices(3) = '2500'
do p = 1, size(prices)
  print '(A,3(1X,L1))', prices(p)//':', prices(p)%is_number(), prices(p)%is_real(), prices(p)%is_integer()
enddo
cell = 'n/a'
print '(A,1X,L1)', cell//':', cell%is_number()
!endregion check

!region cast
highest = 0._R8P
do p = 1, size(prices)
  price = prices(p)%to_number(kind=1._R8P)        ! the kind of the result is the kind of the argument
  highest = max(highest, price)
enddo
print '(A,F0.2)', 'highest price: ', highest
!endregion cast

!region assign
total = sum(prices%to_number(kind=1._R8P))        ! a number assigned to a string
print '(A)', 'total: '//total
total = 3_I4P
print '(A)', 'cars: '//total
total = 2001
print '(A)', 'year 2001 in hexadecimal: '//total%hex()
!endregion assign
endprogram report
