bytes = file_bytes('utf16.txt')
bytes = bytes(3:)                                              ! the mark dropped
carry = ''
do first = 1, len(bytes), 3                                    ! 3 bytes at a time: units are split
   call to_utf8(bytes=bytes(first:min(first+2, len(bytes))), encoding='UTF-16LE', utf8=utf8, carry=carry, &
                is_last=first+3>len(bytes))
   write(*, '(A)', advance='no') utf8
enddo
print '(A)', ''
