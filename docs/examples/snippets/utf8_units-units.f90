print '(A)', text%reverse()//''
print '(A,L1)', 'match Caf? *  : ', text%match('Caf? *')
print '(A,I0)', 'scan e acute  : ', text%scan(char(195)//char(169))
print '(A)', text%transliterate(char(195)//char(169), 'e')//''
print '(A)', text%strip(remove=char(228)//char(189)//char(160)//char(229)//char(165)//char(189))//'|'
