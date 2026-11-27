word(1) = char(206)//char(163)//char(206)//char(159)//char(206)//char(166)//char(206)//char(159)//char(206)//char(163) ! Greek
word(2) = '273 '//char(226)//char(132)//char(170)                                                                    ! Kelvin sign U+212A
word(3) = char(239)//char(172)//char(129)//'le'                                                                      ! ligature fi U+FB01
word(4) = 'Ma'//char(195)//char(159)//'e'
do l = 1, size(word)
  key = word(l)%casefold()
  print '(A,1X,I0,A,A,1X,I0)', word(l)%chars(), word(l)%len(), ' bytes -> ', key%chars(), key%len()
enddo
