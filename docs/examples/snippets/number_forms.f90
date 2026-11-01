program number_forms
!< The forms a real can take in a string: what Fortran writes, and the special values.
use stringifor
implicit none
type(string) :: fields(6)
real(R8P)    :: value
integer      :: iostat
integer      :: f

fields(1) = '1.5-101' ! as E and ES edit descriptors write a 3 digit exponent
fields(2) = '1.5d3'
fields(3) = 'inf'
fields(4) = '-Infinity'
fields(5) = 'nan'
fields(6) = '2026-11' ! not a number
do f = 1, size(fields)
  call fields(f)%read_number(value, iostat=iostat)
  print '(A10,1X,L1,1X,ES12.4)', fields(f)%chars(), iostat == 0, value
enddo
endprogram number_forms
