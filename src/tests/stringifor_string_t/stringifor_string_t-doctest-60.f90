program volatile_doctest
use stringifor_string_t
 character(len=10) :: chars_arr(3, 2)
 logical :: test_passed(9)
 chars_arr(:, 1) = ['one       ', 'two       ', 'three     ']
 chars_arr(:, 2) = ['ONE       ', 'TWO       ', 'THREE     ']

 test_passed(1) = all( strjoin(array=chars_arr) == &
 reshape([string('onetwothree'), string('ONETWOTHREE')], &
 shape = [2]) )

 test_passed(2) = all( strjoin(array=chars_arr, is_trim=.false.) == &
 reshape([string('one       two       three     '), &
 string('ONE       TWO       THREE     ')], &
 shape = [2]) )

 test_passed(3) = all( strjoin(array=chars_arr, sep='_') == &
 reshape([string('one_two_three'), string('ONE_TWO_THREE')], &
 shape = [2]) )

 test_passed(4) = all( strjoin(array=chars_arr, sep='_', is_trim=.false.) == &
 reshape([string('one       _two       _three     '), &
 string('ONE       _TWO       _THREE     ')], &
 shape = [2]) )

 test_passed(5) = all( strjoin(array=chars_arr, is_col=.false.) == &
 reshape([string('oneONE'), string('twoTWO'), string('threeTHREE')], &
 shape = [3]) )

 test_passed(6) = all( strjoin(array=chars_arr, is_trim=.false., is_col=.false.) == &
 reshape([string('one       ONE       '), &
 string('two       TWO       '), &
 string('three     THREE     ')], &
 shape = [3]) )

 test_passed(7) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) == &
 reshape([string('one_ONE'), string('two_TWO'), string('three_THREE')], &
 shape = [3]) )

 test_passed(8) = all( strjoin(array=chars_arr, sep='_', is_trim=.false., is_col=.false.) == &
 reshape([string('one       _ONE       '), &
 string('two       _TWO       '), &
 string('three     _THREE     ')], &
 shape = [3]) )

 chars_arr(2,1) = ''
 test_passed(9) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) == &
 reshape([string('one_ONE'), &
 string('TWO'), &
 string('three_THREE')], &
 shape = [3]) )

 print '(L1)', all(test_passed)
endprogram volatile_doctest