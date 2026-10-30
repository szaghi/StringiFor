print '(A,I0,A,I0)', 'bytes: ', text%len(), ', characters: ', text%len(by=SF_CHARS)
print '(A,I0,A,I0)', 'space at byte ', text%index(' '), ', at character ', text%index(' ', by=SF_CHARS)
print '(A)', text%slice(first=7, last=8, by=SF_CHARS)
print '(A,I0,A,I0)', 'character 7 starts at byte ', text%byte_pos(7), ', byte 9 is in character ', text%char_pos(9)
