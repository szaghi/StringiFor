!run arrays arrays
program arrays_of_strings
!< A method applied to every element of an array.
use stringifor
implicit none
type(string) :: names(3), glue
integer      :: n

names(1) = 'ada' ; names(2) = 'grace hopper' ; names(3) = 'linus'   ! elements of different lengths
names = names%startcase()                         ! the methods are elemental
print '(A)', glue%join(array=names, sep=', ')//''
print '(3(I0,1X))', names%len()
print '(3(L1,1X))', names%start_with('G')
n = maxloc(names%len(), dim=1)
print '(A)', 'the longest is '//names(n)
endprogram arrays_of_strings
