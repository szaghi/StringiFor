codes = text%codepoints()
print '(*(Z0,:,1X))', codes
print '(A)', from_codepoints(codes(5:1:-1))//''
