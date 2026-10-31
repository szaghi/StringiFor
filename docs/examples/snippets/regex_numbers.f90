program regex_numbers
!< Extract the numbers of a text, with their sign, fraction and exponent, and convert them.
use stringifor
implicit none
type(string), allocatable :: numbers(:)
real(R8P)                 :: total
integer                   :: i

numbers = re_findall('dt = 1.5e-3 s, steps: 2000, residual -4.2E+01 (x2)', &
                     '[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?')
total = 0
do i = 1, size(numbers)
  total = total + numbers(i)%to_number(kind=1._R8P)
  print '(A)', numbers(i)%chars()
enddo
print '(A,F12.4)', 'sum:', total
endprogram regex_numbers
