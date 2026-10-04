program report
!< Tutorial, chapter 4: numbers.
use stringifor
implicit none
type(string) :: prices(3), cell, total
real(R8P)    :: price, highest
integer      :: p, iostat
character(99) :: iomsg

prices(1) = '3000.00'
prices(2) = '4900.50'
prices(3) = '2500'
do p = 1, size(prices)
  print '(A,3(1X,L1))', prices(p)//':', prices(p)%is_number(), prices(p)%is_real(), prices(p)%is_integer()
enddo
cell = 'n/a'
print '(A,1X,L1)', cell//':', cell%is_number()

highest = 0._R8P
do p = 1, size(prices)
  price = prices(p)%to_number(kind=1._R8P)        ! the kind of the result is the kind of the argument
  highest = max(highest, price)
enddo
print '(A,F0.2)', 'highest price: ', highest

cell = 'n/a'
call cell%read_number(price, iostat=iostat, iomsg=iomsg)   ! the failure is reported
if (iostat /= 0) print '(A)', cell//': '//trim(iomsg)
call prices(2)%read_number(price, iostat=iostat)
if (iostat == 0) print '(A,F0.2)', prices(2)//': ', price

total = sum(prices%to_number(kind=1._R8P))        ! a number assigned to a string
print '(A)', 'total: '//total
total = 3_I4P
print '(A)', 'cars: '//total
total = 2001
print '(A)', 'year 2001 in hexadecimal: '//total%hex()
endprogram report
