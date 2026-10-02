!run slice slice
program slice_a_string
!< Substrings, with a stride too.
use stringifor
implicit none
type(string) :: s

s = 'Hello World'
print '(A)', s%slice(first=1, last=5)
print '(A)', s%slice(first=7)                   ! to the end
print '(A)', s%slice(last=5)                    ! from the beginning
print '(A)', s%slice(stride=2)                  ! every other character
print '(A)', s%slice(stride=-1)                 ! backwards
print '(A)', '['//s%slice(first=20, last=30)//']' ! out of the string: clamped, never out of bounds
endprogram slice_a_string
