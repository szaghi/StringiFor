program regex_rename
!< Plan the renaming of files: IMG_YYYYMMDD_hhmm.jpg becomes YYYY-MM-DD_hhmm.jpg, the other names are kept.
use stringifor
implicit none
type(string) :: names(4)
type(string) :: renamed
type(regex)  :: photo
integer      :: n
integer      :: i

names = [string('IMG_20261030_0915.jpg'), string('img_20261031_1802.JPG'), string('notes.txt'), &
         string('IMG_2026_x.jpg')]
call photo%compile('^img_(\d{4})(\d\d)(\d\d)_(\d{4})\.jpg$', flags='i')
do i = 1, size(names)
  renamed = photo%sub('\1-\2-\3_\4.jpg', names(i), nsub=n)
  if (n > 0) print '(3A)', names(i)%chars(), ' -> ', renamed%chars()
enddo
endprogram regex_rename
