!run utf8_check utf8_check
program utf8_check
!< Check, inspect and repair UTF-8 text.
use stringifor
implicit none
type(string)              :: text
integer(I4P), allocatable :: codes(:)

!region inspect
text = 'caf'//char(195)//char(169)//' '//char(228)//char(189)//char(160) ! "cafe" with e acute, then a CJK character
print '(A,L1,A,I0)', 'well-formed: ', text%is_utf8(), ', bytes: ', text%len()
codes = text%codepoints()
print '(A,I0,A,*(1X,"U+",Z4.4,:))', 'codepoints (', size(codes), '):', codes
!endregion inspect

!region repair
text = text//char(233)//'!' ! a Latin-1 byte: not UTF-8
print '(A,L1,A,I0)', 'well-formed: ', text%is_utf8(), ', first error at byte ', text%utf8_error()
print '(A,*(1X,I0))', 'codepoints:', text%codepoints()
text = text%to_valid_utf8(replacement='?')
print '(A,A)', 'repaired: ', text%chars()
!endregion repair
endprogram utf8_check
