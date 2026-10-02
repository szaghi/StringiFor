program partition_once
!< Split at the first separator, keeping the three parts.
use stringifor
implicit none
type(string) :: s, parts(3)

s = 'name = John = Smith'
parts = s%partition(sep=' = ')
print '(A)', '['//parts(1)//'] ['//parts(2)//'] ['//parts(3)//']'
endprogram partition_once
