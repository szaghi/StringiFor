note = 'a   small  city car'
note = note%unique(' ')                           ! runs of blanks collapsed to one
print '(A)', note%startcase()//''
print '(A)', note%snakecase()//''
print '(A)', note%camelcase()//''
print '(A)', note%capitalize()//''
