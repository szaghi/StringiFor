program compare_versions
!< Which version is newer?
use stringifor
implicit none
type(string) :: version

version = '1.10.0'
print '(I0)', version%compare_version('1.9.3')    !  1: newer
print '(I0)', version%compare_version('1.10')     !  0: the same, missing fields are zero
print '(I0)', version%compare_version('2.0')      ! -1: older
version = '2024-03'
print '(I0)', version%compare_version('2024-11', sep='-')
endprogram compare_versions
