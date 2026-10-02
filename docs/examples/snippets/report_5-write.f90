allocate(table(size(rows) + 1))
do r = 1, size(rows)
  call rows(r)%split(tokens=cells, sep=',')
  cells = cells%strip()
  table(merge(1, r + 1, r == 1)) = '| '//glue%join(array=cells(1:4), sep=' | ')//' |'
enddo
table(2) = '|---|---|---|---|'
call write_file(file=output%chars(), lines=table)
print '(A)', 'table written to '//output
