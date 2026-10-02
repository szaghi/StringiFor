!as report
!run report_2 report
program report
!< Tutorial, chapter 2: cleaning and transforming.
use stringifor
implicit none
type(string) :: header, note

!region clean
header = '   year,   make , model,price   '
print '(A)', '['//header//']'
header = header%strip()                           ! blanks at both ends
print '(A)', '['//header//']'
header = header%replace(old=' ', new='')          ! every blank
print '(A)', '['//header//']'
print '(A)', '['//header%upper()//']'
!endregion clean

!region words
note = 'a   small  city car'
note = note%unique(' ')                           ! runs of blanks collapsed to one
print '(A)', note%startcase()//''
print '(A)', note%snakecase()//''
print '(A)', note%camelcase()//''
print '(A)', note%capitalize()//''
!endregion words

!region strip
note = '** sold **'
print '(A)', '['//note%strip(remove='* ')//']'    ! a set of characters to remove
!endregion strip
endprogram report
