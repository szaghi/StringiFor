!run number_check number_check
program number_check
!< Is it a number?
use stringifor
implicit none
type(string) :: s(6)
integer      :: i

s(1) = '42' ; s(2) = '-3.14' ; s(3) = '6.02e23' ; s(4) = '1.' ; s(5) = '12 apples' ; s(6) = '007'
print '(A)', 'string      number integer real digit'
do i = 1, size(s)
  print '(A,4(L1,6X))', s(i)%fill(width=12, right=.true., filling_char=' ')//'', &
        s(i)%is_number(), s(i)%is_integer(), s(i)%is_real(), s(i)%is_digit()
enddo
endprogram number_check
