program unicode_casefold
!< Caseless matching with the full Unicode case folding, as CommonMark matches link reference labels.
use stringifor
implicit none
type(string) :: label(4)
type(string) :: word(4)
type(string) :: key
integer      :: l

label(1) = 'Stra'//char(195)//char(159)//'e' ! sharp s U+00DF
label(2) = 'STRASSE'
label(3) = 'strasse'
label(4) = 'Strasbourg'
key = label(1)%casefold()
do l = 1, size(label)
  print '(L1,1X,L1,2X,A)', label(l)%lower() == label(1)%lower(), label(l)%casefold() == key, label(l)%chars()
enddo

word(1) = char(206)//char(163)//char(206)//char(159)//char(206)//char(166)//char(206)//char(159)//char(206)//char(163) ! Greek
word(2) = '273 '//char(226)//char(132)//char(170)                                                                    ! Kelvin sign U+212A
word(3) = char(239)//char(172)//char(129)//'le'                                                                      ! ligature fi U+FB01
word(4) = 'Ma'//char(195)//char(159)//'e'
do l = 1, size(word)
  key = word(l)%casefold()
  print '(A,1X,I0,A,A,1X,I0)', word(l)%chars(), word(l)%len(), ' bytes -> ', key%chars(), key%len()
enddo
endprogram unicode_casefold
