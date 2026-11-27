!run unicode_punct unicode_punct
program unicode_punct
!< Punctuation and symbols beyond ASCII: General_Category P or S, the Unicode punctuation of CommonMark.
use stringifor
implicit none
type(string) :: token(5)
integer      :: t

!region classes
token(1) = '!?'                                                              ! ASCII
token(2) = char(194)//char(171)//char(194)//char(187)                        ! guillemets U+00AB, U+00BB
token(3) = char(226)//char(128)//char(148)//char(226)//char(130)//char(172)  ! em dash U+2014, euro sign U+20AC
token(4) = char(194)//char(169)//'2026'                                      ! copyright sign U+00A9, digits
token(5) = '*'//char(195)//char(169)//'*'                                    ! a letter between asterisks
do t = 1, size(token)
  print '(L1,1X,L1,2X,A)', token(t)%is_punct(), token(t)%is_punct(unicode=.true.), token(t)%chars()
enddo
!endregion classes
endprogram unicode_punct
