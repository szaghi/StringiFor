text = 'caf'//char(195)//char(169)//' '//char(228)//char(189)//char(160) ! "cafe" with e acute, then a CJK character
print '(A,L1,A,I0)', 'well-formed: ', text%is_utf8(), ', bytes: ', text%len()
codes = text%codepoints()
print '(A,I0,A,*(1X,"U+",Z4.4,:))', 'codepoints (', size(codes), '):', codes
