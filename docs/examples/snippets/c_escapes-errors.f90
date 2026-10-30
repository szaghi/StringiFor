text = 'ok\n, then \q and \u12'
print '(A,I0)', 'first malformed escape at byte ', text%escapes_error()
print '(A)', text%unescape_c()//''
