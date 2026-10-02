call cheapest%split(tokens=cells, sep=',')
cells = cells%strip()
print '(A)', ''
print '(A)', 'The cheapest is the '//glue%join(array=cells(2:3), sep=' ')//':'
call cells(5)%justify(lines=lines, width=30)
do l = 1, size(lines)
  print '(A)', '  '//lines(l)%colorize(style='italics_on')
enddo
