program utf8_units
!< The methods that work on characters (units), not on bytes, on UTF-8 text.
use stringifor
implicit none
type(string) :: text

! "Cafe" with an e acute, then the CJK "ni hao"
text = 'Caf'//char(195)//char(169)//' '//char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
print '(A)', text%reverse()//''
print '(A,L1)', 'match Caf? *  : ', text%match('Caf? *')
print '(A,I0)', 'scan e acute  : ', text%scan(char(195)//char(169))
print '(A)', text%transliterate(char(195)//char(169), 'e')//''
print '(A)', text%strip(remove=char(228)//char(189)//char(160)//char(229)//char(165)//char(189))//'|'
endprogram utf8_units
