bad = 'caf'//char(233)
print '(A,L2,A,I0)', 'well-formed:', bad%is_utf8(), ', first bad byte: ', bad%utf8_error()
print '(A)', bad%escape_c()//''
print '(A)', bad%to_valid_utf8()//''
print '(A)', bad%to_valid_utf8(replacement='?')//''
