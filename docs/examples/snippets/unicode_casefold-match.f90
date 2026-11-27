label(1) = 'Stra'//char(195)//char(159)//'e' ! sharp s U+00DF
label(2) = 'STRASSE'
label(3) = 'strasse'
label(4) = 'Strasbourg'
key = label(1)%casefold()
do l = 1, size(label)
  print '(L1,1X,L1,2X,A)', label(l)%lower() == label(1)%lower(), label(l)%casefold() == key, label(l)%chars()
enddo
