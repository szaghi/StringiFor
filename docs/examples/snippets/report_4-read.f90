cell = 'n/a'
call cell%read_number(price, iostat=iostat, iomsg=iomsg)   ! the failure is reported
if (iostat /= 0) print '(A)', cell//': '//trim(iomsg)
call prices(2)%read_number(price, iostat=iostat)
if (iostat == 0) print '(A,F0.2)', prices(2)//': ', price
