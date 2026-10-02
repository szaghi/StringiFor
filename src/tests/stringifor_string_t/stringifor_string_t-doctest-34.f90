program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: decoded
 logical :: test_passed(11)
 astring = 'SG93IGFyZSB5b3U/'
 test_passed(1) = astring%decode(codec='base64')//''=='How are you?'
 astring = 'SGVsbG8gV29ybGQ='
 test_passed(2) = astring%decode(codec='base64')//''=='Hello World'
 astring = 'aGVsbG8gd29ybGQhIQ=='
 test_passed(3) = astring%decode(codec='base64')//''=='hello world!!'
 astring = 'SGVsbG8gV29ybGQ'
 test_passed(4) = astring%decode(codec='base64')//''=='Hello World'
 astring = '  spaces kept  '
 astring = astring%encode(codec='base64')
 test_passed(5) = astring%decode(codec='base64')//''=='  spaces kept  '
 test_passed(6) = len(astring%decode(codec='base64')//'')==15
 astring = 'YQ=='
 test_passed(7) = astring%decode(codec='base64')//''=='a'
 astring = 'YWJjZ'
 test_passed(8) = len(astring%decode(codec='base64')//'')==0
 astring = ''
 test_passed(9) = len(astring%decode(codec='base64')//'')==0
 astring = 'SGVsbG8gV29ybGQ='
 decoded = astring%decode(codec='BASE64')
 test_passed(10) = decoded%is_allocated().and.decoded=='Hello World'
 decoded = astring%decode(codec='rot13')
 test_passed(11) = .not.decoded%is_allocated()
 print '(L1)', all(test_passed)
endprogram volatile_doctest