program convert_encoding
!< Text files in other encodings, as Windows tools and older European data write them, read as UTF-8.
use stringifor
implicit none
character(len=:), allocatable :: bytes, utf8, carry, encoding
integer                       :: first, iostat, unit

! a UTF-16 file (little endian, with its byte order mark) and an ISO-8859-1 file, their bytes as they are
open(newunit=unit, file='utf16.txt', access='stream', form='unformatted', status='replace')
write(unit) char(255)//char(254)//'c'//char(0)//'a'//char(0)//'f'//char(0)//char(233)//char(0)
close(unit)
open(newunit=unit, file='latin1.txt', access='stream', form='unformatted', status='replace')
write(unit) 'caf'//char(233)
close(unit)

bytes = file_bytes('utf16.txt')
encoding = bom_encoding(bytes)                                 ! the mark names the encoding
call to_utf8(bytes=bytes(bom_length(bytes)+1:), encoding=encoding, utf8=utf8)
print '(A)', encoding//': '//utf8
bytes = file_bytes('latin1.txt')
call to_utf8(bytes=bytes, encoding='latin1', utf8=utf8)        ! no mark: the encoding must be known
print '(A)', canonical_encoding('latin1')//': '//utf8

bytes = file_bytes('utf16.txt')
bytes = bytes(3:)                                              ! the mark dropped
carry = ''
do first = 1, len(bytes), 3                                    ! 3 bytes at a time: units are split
   call to_utf8(bytes=bytes(first:min(first+2, len(bytes))), encoding='UTF-16LE', utf8=utf8, carry=carry, &
                is_last=first+3>len(bytes))
   write(*, '(A)', advance='no') utf8
enddo
print '(A)', ''

call to_utf8(bytes='a'//char(0)//char(0)//char(220), encoding='UTF-16LE', utf8=utf8, iostat=iostat)
print '(A,I0)', utf8//' first invalid sequence at byte ', iostat
contains
   function file_bytes(file) result(content)
   !< Return the bytes of a file.
   character(len=*), intent(in)  :: file    !< File name.
   character(len=:), allocatable :: content !< Bytes.
   integer                       :: unit_, size_

   open(newunit=unit_, file=file, access='stream', form='unformatted', status='old')
   inquire(unit=unit_, size=size_)
   allocate(character(len=size_) :: content)
   read(unit_) content
   close(unit_)
   endfunction file_bytes
endprogram convert_encoding
