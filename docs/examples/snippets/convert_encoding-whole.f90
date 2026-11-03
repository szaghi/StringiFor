bytes = file_bytes('utf16.txt')
encoding = bom_encoding(bytes)                                 ! the mark names the encoding
call to_utf8(bytes=bytes(bom_length(bytes)+1:), encoding=encoding, utf8=utf8)
print '(A)', encoding//': '//utf8
bytes = file_bytes('latin1.txt')
call to_utf8(bytes=bytes, encoding='latin1', utf8=utf8)        ! no mark: the encoding must be known
print '(A)', canonical_encoding('latin1')//': '//utf8
