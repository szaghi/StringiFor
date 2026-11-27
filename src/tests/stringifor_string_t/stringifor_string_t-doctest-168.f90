program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 type(string) :: bstring
 type(string) :: cstring
 integer :: scratch
 logical :: test_passed(4)
 astring = repeat('a', 250)//'  '
 open(newunit=scratch, status='SCRATCH', form='UNFORMATTED')
 write(scratch) astring, bstring
 rewind(scratch)
 read(scratch) cstring, bstring
 close(scratch)
 test_passed(1) = cstring%len()==252.and.cstring==astring
 test_passed(2) = bstring%is_allocated().and.bstring%len()==0
 open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
 write(scratch) astring
 rewind(scratch)
 read(scratch) cstring
 close(scratch)
 test_passed(3) = cstring%len()==252
 test_passed(4) = cstring==astring
 print '(L1)', all(test_passed)
endprogram volatile_doctest