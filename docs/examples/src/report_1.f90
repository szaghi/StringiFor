!as report
!run report_1 report
program report
!< Tutorial, chapter 1: a first string.
use stringifor
implicit none
type(string) :: title, subtitle, heading

title = 'cars report'                       ! from a character, of any length
subtitle = title                            ! from another string
print '(A)', title//''                      ! // gives a character
print '(A)', title%chars()                  ! so does chars()
print '(DT)', title                         ! defined I/O

heading = title%startcase()//', year '//'2001'
print '(A)', heading//''
print '(A,I0)', 'length: ', heading%len()

print '(A,L1)', 'same title? ', title == subtitle
print '(A,L1)', 'same as a character? ', title == 'cars report'
print '(A,L1)', 'sorts before "dogs"? ', title < 'dogs'

subtitle = title .cat. ', draft'            ! .cat. gives a string
print '(A)', subtitle%upper()//''
endprogram report
