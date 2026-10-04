program char_classes
!< The class of the characters of some strings.
use stringifor
implicit none
type(string) :: words(5)
integer      :: w

words(1) = 'Fortran'
words(2) = 'F2023'
words(3) = 'c0ffee'
words(4) = '?!,'
words(5) = ' '
print '(A)', 'word      alpha alnum xdigit punct space'
do w = 1, size(words)
  print '(A,5L6)', words(w)%ljust(10)//'', words(w)%is_alpha(), words(w)%is_alnum(), words(w)%is_xdigit(), &
                   words(w)%is_punct(), words(w)%is_space()
enddo
endprogram char_classes
