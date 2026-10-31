line = re%sub('\g<user> at \g<host>', 'write to ann@example.org or bob@test.net')
print '(A)', line%chars()
parts = re_split('a, b ;c', '\s*[,;]\s*')
print '(3(A,"|"))', (parts(i)%chars(), i=1, size(parts))
