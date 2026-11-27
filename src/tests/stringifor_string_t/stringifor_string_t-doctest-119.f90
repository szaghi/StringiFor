program volatile_doctest
use stringifor_string_t
 type(string) :: astring
 integer :: scratch
 logical :: test_passed(7)
 astring = char(239)//char(187)//char(191)//'text'
 test_passed(1) = astring%has_bom()
 astring = 'text'
 test_passed(2) = .not.astring%has_bom()
 astring = ''
 test_passed(3) = .not.astring%has_bom()
 astring = 'line one'//new_line('a')//'line two'
 call astring%write_file(file='has_bom_test.tmp', bom=.true.)
 call astring%read_file(file='has_bom_test.tmp')
 test_passed(4) = astring%has_bom()
 call astring%read_file(file='has_bom_test.tmp', skip_bom=.true.)
 test_passed(5) = astring%start_with('line one').and.(.not.astring%has_bom())
 call astring%read_file(file='has_bom_test.tmp', is_fast=.true., skip_bom=.true.)
 test_passed(6) = astring%start_with('line one')
 call astring%write_file(file='has_bom_test.tmp', bom=.true.) ! a string without a BOM: written once
 astring = char(239)//char(187)//char(191)//'x'
 call astring%write_file(file='has_bom_test.tmp', bom=.true.) ! a string with a BOM: not doubled
 call astring%read_file(file='has_bom_test.tmp', skip_bom=.true.)
 test_passed(7) = astring%start_with('x')
 open(newunit=scratch, file='has_bom_test.tmp')
 close(scratch, status='delete')
 print '(L1)', all(test_passed)
endprogram volatile_doctest