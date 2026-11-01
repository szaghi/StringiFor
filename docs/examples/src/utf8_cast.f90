!as sfu
!run utf8_cast-sizes sfu sizes 'caf\u00e9 \u65e5\u672c'
!run utf8_cast-reverse sfu reverse 'caf\u00e9 \u65e5\u672c'
!run utf8_cast-align sfu align '\u65e5\u672c\u8a9e'
!run utf8_cast-codes sfu codes 'a\u00e9\u20ac'
!run utf8_cast-check sfu check 'ok\xff!'
!run utf8_cast-space sfu space '\u3000 tidy\u00a0 words \u2003'
!run utf8_cast-xml sfu xml 'a<b & "c"'
!cast utf8_cast utf8_cast-sizes utf8_cast-reverse utf8_cast-align utf8_cast-codes utf8_cast-check utf8_cast-space utf8_cast-xml
program sfu
!< UTF-8 from the command line: the text goes through unescape_c, so it can be typed in ASCII.
use stringifor
implicit none
type(string)              :: command, text, other
integer(I4P), allocatable :: codes(:)

command = argument(1)
text = argument(2)
text = text%unescape_c()
select case(command%chars())
case('sizes')
  print '(A)', text%chars()
  print '(3(A,I0))', 'bytes ', text%len(), ', characters ', text%len(by=SF_CHARS), ', columns ', text%width()
case('reverse')
  print '(A)', text%reverse()//''
case('align')
  print '(3A)', '|', text%ljust(10, '.')//'', '| 10 bytes'
  print '(3A)', '|', text%ljust(10, '.', by=SF_CHARS)//'', '| 10 characters'
  print '(3A)', '|', text%ljust(10, '.', by=SF_COLUMNS)//'', '| 10 columns'
case('codes')
  codes = text%codepoints()
  print '(*(Z0,:,1X))', codes
case('check')
  print '(A,L2,A,I0)', 'well-formed:', text%is_utf8(), ', first error at byte ', text%utf8_error()
  print '(2A)', 'escaped:  ', text%escape_c()//''
  print '(2A)', 'repaired: ', text%to_valid_utf8()//''
case('space')
  print '(3A)', '[', text%strip(whitespace=.true.)//'', '] ASCII'
  print '(3A)', '[', text%compact(unicode=.true.)//'', '] Unicode'
case('xml')
  print '(A)', text%escape_xml()//''
  other = text%escape_xml()
  print '(A,L2)', 'read back:', other%unescape_xml() == text
endselect

contains
  function argument(n) result(arg)
  !< The n-th command line argument, as a string.
  integer, intent(in)       :: n
  type(string)              :: arg
  character(:), allocatable :: buffer
  integer                   :: length

  call get_command_argument(n, length=length)
  allocate(character(length) :: buffer)
  call get_command_argument(n, value=buffer)
  arg = buffer
  endfunction argument
endprogram sfu
