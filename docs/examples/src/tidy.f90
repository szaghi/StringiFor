!run tidy tidy
program tidy
!< Whitespace, repeated characters, tabs, character sets and quotes.
use stringifor
implicit none
type(string) :: s

s = '  too   many'//achar(9)//'blanks  '
print '(A)', '['//s%compact()//']'
print '(A)', '['//s%compact(sep='_')//']'
s = 'Mississippi --- yes!!!'
print '(A)', s%squeeze()//''
print '(A)', s%squeeze(set='-!')//''
s = 'id'//achar(9)//'name'//achar(9)//'value'
print '(A)', s%expand_tabs(8)//''
s = 'hello world'
print '(A)', s%transliterate('lo', 'LO')//''
print '(A)', s%transliterate('aeiou', '')//''
s = 'say "hi"'
s = s%quote()
print '(A)', s//''
print '(A)', s%unquote()//''
endprogram tidy
