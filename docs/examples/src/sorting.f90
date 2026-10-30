!run sorting sorting
program sorting
!< Sort file names: byte order, natural order, case ignored, and the permutation to reorder data that goes with them.
use stringifor
implicit none
type(string) :: names(6)
real         :: sizes(6)
integer      :: perm(6)
integer      :: i

!region orders
names = [string('run10.dat'), string('Run2.dat'), string('run2.dat'), string('run1.dat'), string('README'), &
         string('run02.dat')]
call strsort(names)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
call strsort(names, less=strless_natural)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
call strsort(names, less=strless_nocase)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
!endregion orders

!region permutation
names = [string('c'), string('a'), string('b'), string('a'), string('c'), string('b')]
sizes = [3.0, 1.0, 2.0, 1.5, 3.5, 2.5]
call strsort(names, index=perm)
sizes = sizes(perm) ! the data follows its key; equal keys keep their order
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
print '(6(F3.1,1X))', sizes
!endregion permutation

!region custom
names = [string('bb'), string('a'), string('ccc'), string('ab'), string('e'), string('fff')]
call strsort(names, less=longer_first)
print '(6(A,1X))', (names(i)%chars(), i=1, 6)
!endregion custom
contains
  pure function longer_first(a, b) result(is_less)
  !< The longer string first, byte order among strings of the same length.
  character(kind=CK, len=*), intent(in) :: a, b
  logical                               :: is_less

  is_less = len(a) > len(b) .or. (len(a) == len(b) .and. strless(a, b))
  endfunction longer_first
endprogram sorting
