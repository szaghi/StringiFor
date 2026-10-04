program binary_io
!< Strings saved to and loaded from an unformatted file.
use stringifor
implicit none
type(string) :: saved(3), loaded(3)
integer      :: unit, s

saved(1) = 'Venture'
saved(2) = '  blanks kept  '
saved(3) = ''
open(newunit=unit, file='names.bin', form='unformatted', access='stream', status='replace')
write(unit) saved                                     ! each string: its length, then its characters
close(unit)
open(newunit=unit, file='names.bin', form='unformatted', access='stream', status='old')
read(unit) loaded
close(unit, status='delete')
do s = 1, size(loaded)
  print '(I2,A)', loaded(s)%len(), ' characters: ['//loaded(s)//']'
enddo
endprogram binary_io
