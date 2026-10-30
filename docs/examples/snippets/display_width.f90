program display_width
!< Align text by display columns, CJK included.
use stringifor
implicit none
type(string) :: names(3)
integer      :: n

names(1) = 'Ada'
names(2) = 'Jos'//char(195)//char(169)
names(3) = char(228)//char(189)//char(160)//char(229)//char(165)//char(189) ! the CJK "ni hao"
do n = 1, size(names)
  print '(A,2(I0,1X),I0)', '|'//names(n)%ljust(8, '.', by=SF_COLUMNS)//'| bytes, characters, columns: ', &
    names(n)%len(), names(n)%len(by=SF_CHARS), names(n)%width()
enddo
endprogram display_width
