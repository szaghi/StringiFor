program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: hexed
 logical :: test_passed(7)
 astring = 26
 test_passed(1) = astring%hex()//''=='1a'
 astring = -1
 test_passed(2) = astring%hex(bits=32)//''=='ffffffff'
 test_passed(3) = astring%hex()//''=='ffffffffffffffff'
 astring = 0
 test_passed(4) = astring%hex()//''=='0'
 astring = '255'
 test_passed(5) = astring%hex(uppercase=.true.)//''=='FF'
 astring = 4096
 test_passed(6) = astring%hex(bits=8)//''=='0'
 astring = 'not a number'
 hexed = astring%hex()
 test_passed(7) = hexed%is_allocated().eqv..false.
 print '(L1)', all(test_passed)
endprogram volatile_doctest