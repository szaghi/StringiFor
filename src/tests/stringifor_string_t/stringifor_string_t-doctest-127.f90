program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 logical :: test_passed(128)
 integer :: c
 do c=0, 127
 astring = achar(c)
 test_passed(c+1) = (astring%is_punct().eqv.((c>=33.and.c<=47).or.(c>=58.and.c<=64).or. &
 (c>=91.and.c<=96).or.(c>=123.and.c<=126))).and. &
 (astring%is_punct(unicode=.true.).eqv.astring%is_punct())
 enddo
 print '(L1)', all(test_passed)
endprogram volatile_doctest