text = text//char(233)//'!' ! a Latin-1 byte: not UTF-8
print '(A,L1,A,I0)', 'well-formed: ', text%is_utf8(), ', first error at byte ', text%utf8_error()
print '(A,*(1X,I0))', 'codepoints:', text%codepoints()
text = text%to_valid_utf8(replacement='?')
print '(A,A)', 'repaired: ', text%chars()
