!run regex_keyvalue regex_keyvalue
program regex_keyvalue
!< Read the settings of a key = value file, comments and blank lines skipped.
use stringifor
implicit none
type(string)      :: lines(5)
type(regex)       :: setting
type(regex_match) :: m
integer           :: i

lines = [string('# solver settings'), string('  cfl = 0.8   # stable'), string(''), string('scheme=WENO5'), &
         string('bad line')]
call setting%compile('^\s*(?P<key>\w+)\s*=\s*(?P<value>[^#]*?)\s*(?:#.*)?$')
do i = 1, size(lines)
  m = setting%match(lines(i))
  if (m%found) then
    print '(A,"=[",A,"]")', m%group('key')//'', m%group('value')//''
  elseif (lines(i)%len() > 0 .and. .not.lines(i)%start_with('#')) then
    print '(A,I0,2A)', 'line ', i, ' is not a setting: ', lines(i)%chars()
  endif
enddo
endprogram regex_keyvalue
