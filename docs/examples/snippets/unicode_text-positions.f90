b = text%index('e', back=.true.)
print '(A,I0,A,I0)', 'last e: byte ', b, ', character ', text%index('e', back=.true., by=SF_CHARS)
print '(A,I0)', 'character 5 starts at byte ', text%byte_pos(5)
print '(A,I0)', 'byte 5 is in character ', text%char_pos(5)
print '(2A)', 'characters 1 to 4: ', text%slice(first=1, last=4, by=SF_CHARS)//''
bad = text%slice(first=1, last=4)
print '(2A)', 'bytes 1 to 4:      ', bad%escape_c()//''
