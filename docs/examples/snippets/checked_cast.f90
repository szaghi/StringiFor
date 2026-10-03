program checked_cast
!< Numbers read from strings, with an error status.
use stringifor
implicit none
type(string)      :: fields(3)
real(R8P)         :: value
integer           :: iostat
character(len=99) :: iomsg
integer           :: f

fields(1) = '3.25'
fields(2) = 'n/a'
fields(3) = '1e3'
do f = 1, size(fields)
  call fields(f)%read_number(value, iostat=iostat, iomsg=iomsg)
  if (iostat == 0) then
    print '(A,F8.2)', fields(f)//' -> ', value
  else
    print '(A)', fields(f)//' -> error: '//trim(iomsg)
  endif
enddo
endprogram checked_cast
