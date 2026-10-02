program colours
!< Colours and styles for the terminal.
use stringifor
implicit none
type(string) :: s

s = 'error: the file is missing'
print '(A)', s%colorize(color_fg='red', style='bold_on')
s = 'warning: the file is empty'
print '(A)', s%colorize(color_fg='yellow')
s = 'done'
print '(A)', s%colorize(color_fg='green', style='underline_on')
endprogram colours
