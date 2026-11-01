m = re_search('key = 42', '(\w+)\s*=\s*(\d+)')
print '(A,1X,A)', m%group(1)//'', m%group(2)//''
s = re_sub('x=1, y=22', '(\w)=(\d+)', '\2=\1')
print '(A)', s%chars()
