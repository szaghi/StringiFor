!run justify justify
program justify_text
!< Wrap a paragraph in justified lines.
use stringifor
implicit none
type(string)              :: text
type(string), allocatable :: lines(:)
integer                   :: l

text = 'Fortran is a general-purpose, compiled imperative programming language '// &
       'that is especially suited to numeric computation and scientific computing.'
call text%justify(lines=lines, width=36)
do l = 1, size(lines)
  print '(A)', '|'//lines(l)//'|'
enddo
print '(A,I0)', 'the last word has length ', text%len_last_word()
endprogram justify_text
