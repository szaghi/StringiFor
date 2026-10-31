!< ReDoS and scaling check of the regular expressions (issue #51, step 10.9), built by scripts/utf8/build.sh.
!<
!< Times patterns that take exponential time in a backtracking engine, on subjects of n = 10**3 .. 10**5 bytes that
!< they do not match, and prints the time per byte. The Pike VM is linear in the subject: the time per byte stays about
!< constant. Exits with status 1 if, for some pattern, the largest time per byte is more than 4 times the smallest, or
!< if one search of 10**5 bytes takes more than 2 seconds.
program regex_scaling
use, intrinsic :: iso_fortran_env, only : int64, output_unit, real64
use stringifor, only : regex, regex_match
implicit none
character(len=1),  parameter :: BS = achar(92) !< Backslash (nvfortran reads backslash escapes in literals).
character(len=12), parameter :: PATTERNS(5) = [character(len=12) :: '(a*)*b', '(a|aa)*c', '(a+a+)+b', '(a|a)*b', &
                                                '('//BS//'w+'//BS//'s?)*!x'] !< Exponential for a backtracking engine.
integer,           parameter :: SIZES(3) = [1000, 10000, 100000]
real(real64)                 :: per_byte(3) !< Time per byte (ns) for each size.
real(real64)                 :: seconds     !< Time of one search.
integer                      :: k           !< Pattern counter.
integer                      :: s           !< Size counter.
integer                      :: status      !< Exit status.

status = 0
write(output_unit, '(a)') 'pattern,bytes,ns_per_byte'
do k = 1, size(PATTERNS)
  do s = 1, size(SIZES)
    seconds = best_time(trim(PATTERNS(k)), SIZES(s))
    per_byte(s) = seconds / SIZES(s) * 1.e9_real64
    write(output_unit, '(a,",",i0,",",f10.3)') trim(PATTERNS(k)), SIZES(s), per_byte(s)
  enddo
  if (maxval(per_byte) > 4 * minval(per_byte) .or. seconds > 2._real64) then
    write(output_unit, '(a)') 'regex_scaling: '//trim(PATTERNS(k))//' is not linear in the subject'
    status = 1
  endif
enddo
if (status /= 0) error stop 1

contains
  function best_time(pattern, n) result(best)
  !< Best of 3 times of searching the pattern in n bytes 'a...a!', which it does not match (s).
  character(len=*), intent(in) :: pattern !< Pattern.
  integer,          intent(in) :: n       !< Bytes.
  real(real64)                 :: best    !< Time (s).
  type(regex)                  :: re      !< The regex.
  type(regex_match)            :: found   !< The match.
  character(len=:), allocatable :: subject !< Subject.
  integer(int64)               :: t0      !< Start.
  integer(int64)               :: t1      !< End.
  integer(int64)               :: rate    !< Clock rate.
  integer                      :: r       !< Repetition.

  call re%compile(pattern)
  subject = repeat('a', n - 1)//'!'
  call system_clock(count_rate=rate)
  best = huge(1._real64)
  do r = 1, 3
    call system_clock(t0)
    found = re%search(subject)
    call system_clock(t1)
    best = min(best, real(t1 - t0, real64) / real(rate, real64))
  enddo
  if (found%found) error stop 'regex_scaling: unexpected match'
  endfunction best_time
endprogram regex_scaling
