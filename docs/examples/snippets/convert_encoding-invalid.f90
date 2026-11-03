call to_utf8(bytes='a'//char(0)//char(0)//char(220), encoding='UTF-16LE', utf8=utf8, iostat=iostat)
print '(A,I0)', utf8//' first invalid sequence at byte ', iostat
