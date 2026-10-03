!run wildcards wildcards
program wildcards
!< The names matching a wildcard pattern.
use stringifor
implicit none
type(string) :: names(5)
integer      :: n

names(1) = 'report-2025.csv'
names(2) = 'report-2026.csv'
names(3) = 'report-2026.txt'
names(4) = 'notes.txt'
names(5) = 'Report-2026.csv'
do n = 1, size(names)
  if (names(n)%match('report-202[5-9].csv')) print '(A)', names(n)//''
enddo
print '(5L2)', names%match('*.txt')
endprogram wildcards
