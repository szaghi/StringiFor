program allocation_status
!< A string is allocated by its first assignment.
use stringifor
implicit none
type(string) :: s

print '(L1,1X,I0)', s%is_allocated(), s%len()
s = ''
print '(L1,1X,I0)', s%is_allocated(), s%len()
s = 'some text'
print '(L1,1X,I0)', s%is_allocated(), s%len()
call s%free
print '(L1)', s%is_allocated()
endprogram allocation_status
