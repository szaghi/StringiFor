program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: encoded
 logical :: test_passed(3)
 astring = 'How are you?'
 test_passed(1) = astring%encode(codec='base64')//''=='SG93IGFyZSB5b3U/'
 encoded = astring%encode(codec='BASE64')
 test_passed(2) = encoded%is_allocated().and.encoded=='SG93IGFyZSB5b3U/'
 encoded = astring%encode(codec='rot13')
 test_passed(3) = .not.encoded%is_allocated()
 print '(L1)', all(test_passed)
endprogram volatile_doctest