record = '2003,Fiat,,1800,'                       ! the model and the notes are missing
call record%split(tokens=cells, sep=',')
print '(I0,A)', size(cells), ' tokens: '//glue%join(array=cells, sep='|')
call record%split(tokens=cells, sep=',', keep_empty=.true.)
print '(I0,A)', size(cells), ' fields: '//glue%join(array=cells, sep='|')
