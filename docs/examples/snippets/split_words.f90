program split_words
!< Split a string into tokens.
use stringifor
implicit none
type(string)              :: s
type(string), allocatable :: tokens(:)
integer                   :: t

s = 'the quick  brown   fox'
call s%split(tokens=tokens)                         ! on blanks, repeated ones count as one
print '(I0,A)', size(tokens), ' words, the last one is "'//tokens(size(tokens))//'"'

s = '2001-07-14'
call s%split(tokens=tokens, sep='-')
print '(*(A,:,"/"))', (tokens(t)//'', t=size(tokens), 1, -1)

s = 'key = value = with = equals'
call s%split(tokens=tokens, sep=' = ', max_tokens=1)  ! split once
print '(A)', '['//tokens(1)//'] ['//tokens(2)//']'
endprogram split_words
