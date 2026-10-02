!run number_string number_string
program number_to_string
!< From a number to a string.
use stringifor
implicit none
type(string) :: s

s = 42
print '(A)', s//''
s = -127_I1P
print '(A)', s//''
s = 2.5_R4P
print '(A)', s//''
s = 1._R8P/3._R8P
print '(A)', s//''
s = 255
print '(A)', s%hex()//' '//s%hex(uppercase=.true.)
s = -1
print '(A)', s%hex(bits=16)//''                   ! two's complement on 16 bits
endprogram number_to_string
