program volatile_doctest
use stringifor_string_t
 type(string), allocatable :: strings_arr(:, :)
 logical :: test_passed(5)

 strings_arr = reshape( source = &
 [string('one'), string('two'), string('three'), &
 string('ONE'), string('TWO'), string('THREE')], &
 shape = [3, 2] )

 test_passed(1) = all( strjoin(array=strings_arr) == &
 reshape([string('onetwothree'), string('ONETWOTHREE')], &
 shape = [2]) )

 test_passed(2) = all( strjoin(array=strings_arr, sep='_') == &
 reshape([string('one_two_three'), string('ONE_TWO_THREE')], &
 shape = [2]) )

 test_passed(3) = all( strjoin(array=strings_arr, is_col=.false.) == &
 reshape([string('oneONE'), string('twoTWO'), string('threeTHREE')], &
 shape = [3]) )

 test_passed(4) = all( strjoin(array=strings_arr, sep='_', is_col=.false.) == &
 reshape([string('one_ONE'), string('two_TWO'), string('three_THREE')], &
 shape = [3]) )

 call strings_arr(2, 1)%free
 test_passed(5) = all( strjoin(array=strings_arr, sep='_', is_col=.false.) == &
 reshape([string('one_ONE'), string('TWO'), string('three_THREE')], &
 shape = [3]) )

 print '(L1)', all(test_passed)
endprogram volatile_doctest