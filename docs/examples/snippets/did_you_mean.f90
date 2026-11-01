program did_you_mean
!< The nearest of a list of known words, for a "did you mean" message.
use stringifor
implicit none
character(len=8), parameter :: KNOWN(4) = [character(len=8) :: 'build', 'clean', 'install', 'rule']
type(string)                :: typed
integer                     :: distances(size(KNOWN))
integer                     :: k

typed = 'instal'
do k = 1, size(KNOWN)
  distances(k) = typed%edit_distance(trim(KNOWN(k)))
enddo
k = minloc(distances, dim=1)
print '(A)', 'unknown command '//typed//', did you mean '//trim(KNOWN(k))//'?'
typed = 'caf'//char(195)//char(169)
print '(I0,1X,I0)', typed%edit_distance('cafe'), typed%edit_distance('cafe', by=SF_CHARS)
endprogram did_you_mean
