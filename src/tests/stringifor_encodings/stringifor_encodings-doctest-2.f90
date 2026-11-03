program volatile_doctest
use stringifor_encodings
 logical :: test_passed(3)
 test_passed(1) = bom_length(char(239)//char(187)//char(191)//'x')==3
 test_passed(2) = bom_length(char(254)//char(255)//char(0)//'x')==2
 test_passed(3) = bom_length('x')==0
 print '(L1)', all(test_passed)
endprogram volatile_doctest