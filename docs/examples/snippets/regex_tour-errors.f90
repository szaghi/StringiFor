call re%compile('(\d+', iostat=iostat, iomsg=iomsg)
print '(A,I0,2A)', 'error at byte ', iostat, ': ', trim(iomsg)
