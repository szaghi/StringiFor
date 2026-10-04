note = '  ac'//achar(9)//'abs   moon  '
print '(A)', '['//note%compact()//']'              ! whitespace runs to one blank, the ends removed
note = 'extended edition!!! ...'
print '(A)', note%squeeze(set='!.')//''           ! runs of these characters reduced to one
note = 'E350'
print '(A)', note%transliterate('0123456789', '#')//''  ! every digit becomes a '#'
