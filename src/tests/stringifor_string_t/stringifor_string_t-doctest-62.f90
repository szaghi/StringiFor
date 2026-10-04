program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 integer :: iostat
 integer :: scratch
 integer :: l
 logical :: test_passed(6)
 open(newunit=scratch, status='SCRATCH')
 write(scratch, "(A)") 'first'
 write(scratch, "(A)") ''
 write(scratch, "(A)") 'third'
 rewind(scratch)
 astring = 'untouched'
 call astring%read_line(unit=scratch, iostat=iostat)
 test_passed(1) = (iostat==0.and.astring=='first')
 call astring%read_line(unit=scratch, iostat=iostat)
 test_passed(2) = (iostat==0.and.astring%len()==0)
 call astring%read_line(unit=scratch, iostat=iostat)
 test_passed(3) = (iostat==0.and.astring=='third')
 call astring%read_line(unit=scratch, iostat=iostat)
 test_passed(4) = (is_iostat_end(iostat).and.astring=='third')
 close(scratch)
 open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
 write(scratch) 'first'//new_line('a')//new_line('a')//'last, not terminated'
 rewind(scratch)
 l = 0
 do
 call astring%read_line(unit=scratch, iostat=iostat, form='unformatted')
 if (iostat/=0) exit
 l = l + 1
 enddo
 test_passed(5) = (l==3.and.astring=='last, not terminated')
 test_passed(6) = is_iostat_end(iostat)
 close(scratch)
 print '(L1)', all(test_passed)
endprogram volatile_doctest