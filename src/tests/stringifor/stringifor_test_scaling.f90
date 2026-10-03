!< StringiFor scaling test: the string methods must run in linear time on large inputs.
program stringifor_test_scaling
!< StringiFor scaling test: the string methods must run in linear time on large inputs.
!<
!< Each method runs on an input large enough that a quadratic implementation takes seconds (and, for split, gigabytes), while
!< the linear one takes milliseconds: the time limit sits between the two, far enough from both to be independent of the
!< machine and of the build flags (debug, coverage).
!<
!< Set the environment variable `STRINGIFOR_SCALING_VERBOSE` to print the times.
use stringifor

implicit none
real,             parameter :: TIME_LIMIT = 0.2                             !< Time limit for each method [s].
character(len=*), parameter :: FILE_NAME = 'stringifor_test_scaling.tmp' !< File name.
type(string)                :: astring                                    !< A large string.
type(string)                :: result_                                    !< Result of a method.
type(string), allocatable   :: tokens(:)                                  !< Tokens of split.
type(string), allocatable   :: array(:)                                   !< Array to join.
integer(I8P)                :: tic                                        !< Clock at the start of a method.
logical                     :: is_verbose                                 !< Print the times.
logical                     :: test_passed(10)                            !< List of passed tests.
integer                     :: unit                                       !< Logical unit.
integer                     :: status                                     !< Status of the environment variable.
integer                     :: l                                          !< Counter.

call get_environment_variable('STRINGIFOR_SCALING_VERBOSE', status=status)
is_verbose = status==0

astring = repeat('ab,', 40000)                       ! 120 kB, 40000 tokens
call start
call astring%split(tokens=tokens, sep=',')
test_passed(1) = in_time('split') .and. size(tokens, dim=1)==40000

call start
result_ = astring%replace(old='ab', new='abab')
test_passed(2) = in_time('replace') .and. result_%len()==200000

astring = repeat('a,,,,', 20000)                     ! 100 kB of sequential separators
call start
result_ = astring%unique(',')
test_passed(3) = in_time('unique') .and. result_%len()==40000

astring = repeat('a\b', 40000)                       ! 120 kB, 40000 characters to escape
call start
result_ = astring%escape(to_escape='\')
test_passed(4) = in_time('escape') .and. result_%len()==160000

call start
result_ = result_%unescape(to_unescape='\')
test_passed(5) = in_time('unescape') .and. result_==astring

allocate(array(20000))                               ! 800 kB joined
do l=1, size(array, dim=1)
   array(l) = repeat('x', 39)
enddo
call start
result_ = astring%join(array=array, sep=',')
test_passed(6) = in_time('join') .and. result_%len()==20000*40-1

astring = repeat('word ', 40000)                     ! 200 kB, 40000 words
call start
result_ = astring%camelcase()
test_passed(7) = in_time('camelcase') .and. result_%len()==160000

call start
result_ = astring%upper()
test_passed(8) = in_time('upper') .and. result_%len()==200000

open(newunit=unit, file=FILE_NAME, status='replace') ! 2 MB, 50000 lines
do l=1, 50000
   write(unit, '(A)') repeat('x', 39)
enddo
close(unit)
call start
call result_%read_file(file=FILE_NAME)
test_passed(9) = in_time('read_file') .and. result_%len()==50000*40

open(newunit=unit, file=FILE_NAME, status='replace') ! 800 kB, 20000 lines
do l=1, 20000
   write(unit, '(A)') repeat('x', 39)
enddo
close(unit)
open(newunit=unit, file=FILE_NAME, access='stream', form='unformatted', status='old')
call start
call result_%read_lines(unit=unit, form='unformatted')
test_passed(10) = in_time('read_lines unformatted') .and. result_%len()==20000*40
close(unit, status='delete')

print '(L1)', all(test_passed)
if (.not.all(test_passed)) error stop 1 ! runners checking only the exit code must see the failure

contains
   subroutine start()
   !< Start the clock.

   call system_clock(tic)
   endsubroutine start

   function in_time(method) result(is_in_time)
   !< Return true if the method has run within the time limit.
   character(len=*), intent(in) :: method     !< Method name.
   logical                      :: is_in_time !< Check result.
   integer(I8P)                 :: toc        !< Clock at the end of the method.
   integer(I8P)                 :: rate       !< Clock rate.
   real                         :: elapsed    !< Elapsed time [s].

   call system_clock(toc, rate)
   elapsed = real(toc - tic) / real(rate)
   is_in_time = elapsed<TIME_LIMIT
   if (is_verbose.or..not.is_in_time) print '(A,F8.4,A)', method//': ', elapsed, ' s'
   endfunction in_time
endprogram stringifor_test_scaling
