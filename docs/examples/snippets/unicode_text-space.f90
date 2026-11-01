text = '\u3000 two\u00a0 words \u2003'
text = text%unescape_c()
print '(3A)', '[', text%strip(whitespace=.true., unicode=.true.)//'', ']'
print '(3A)', '[', text%compact(unicode=.true.)//'', ']'
print '(L1)', text%is_space(unicode=.true.)
