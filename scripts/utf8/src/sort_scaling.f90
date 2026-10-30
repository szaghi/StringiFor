!< Scaling check of strsort (issue #51, step 9.3), built by scripts/utf8/build.sh.
!<
!< Times strsort on n = 2**10 .. 2**18 strings of 4 kinds (random, sorted, reversed, all equal) and prints the time of
!< one comparison step, t / (n log2 n). An O(n log n) sort keeps it about constant; a quadratic one multiplies it by
!< n / log2 n, about 2,000 times from the smallest to the largest n. Exits with status 1 if, for some kind, the largest
!< value is more than 4 times the smallest.
program sort_scaling
use, intrinsic :: iso_fortran_env, only : int64, output_unit, real64
use stringifor, only : string, strsort
implicit none
character(len=8), parameter :: KINDS(4) = [character(len=8) :: 'random', 'sorted', 'reversed', 'equal']
real(real64)                :: step(4, 10:18) !< Time of one comparison step (ns), per kind and log2 n.
integer                     :: k          !< Kind counter.
integer                     :: p          !< log2 n.
integer                     :: n          !< Number of strings.
integer                     :: status     !< Exit status.

status = 0
write(output_unit, '(a)') 'kind,n,ns_per_n_log2_n'
do k = 1, size(KINDS)
  do p = 10, 18
    n = 2**p
    step(k, p) = best_time(trim(KINDS(k)), n) / (real(n, real64) * p) * 1.e9_real64
    write(output_unit, '(a,",",i0,",",f8.3)') trim(KINDS(k)), n, step(k, p)
  enddo
  if (maxval(step(k, :)) > 4 * minval(step(k, :))) then
    write(output_unit, '(a)') 'sort_scaling: '//trim(KINDS(k))//' does not scale as n log n'
    status = 1
  endif
enddo
if (status /= 0) error stop 1

contains
  function best_time(kind, n) result(best)
  !< Best of 3 times of sorting n strings of a kind (s).
  character(len=*), intent(in) :: kind !< Kind of input.
  integer,          intent(in) :: n    !< Number of strings.
  real(real64)                 :: best !< Time (s).
  integer(int64)               :: t0   !< Start.
  integer(int64)               :: t1   !< End.
  integer(int64)               :: rate !< Clock rate.
  integer                      :: r    !< Repetition.
  type(string), allocatable    :: strings(:) !< Strings to sort.

  call system_clock(count_rate=rate)
  best = huge(1._real64)
  do r = 1, 3
    call make(kind, n, strings)
    call system_clock(t0)
    call strsort(strings)
    call system_clock(t1)
    best = min(best, real(t1 - t0, real64) / real(rate, real64))
  enddo
  endfunction best_time

  subroutine make(kind, n, strings)
  !< Fill strings with n strings of a kind: 12 lowercase letters from a fixed linear congruential sequence.
  character(len=*), intent(in) :: kind  !< Kind of input.
  integer,          intent(in) :: n     !< Number of strings.
  type(string), allocatable, intent(out) :: strings(:) !< The strings.
  character(len=12)            :: word  !< A string.
  integer(int64)               :: state !< Generator state.
  integer                      :: i     !< String counter.
  integer                      :: c     !< Character counter.

  allocate(strings(n))
  state = 12345_int64
  do i = 1, n
    select case (kind)
    case ('sorted', 'reversed')
      write(word, '(i12.12)') merge(i, n - i, kind == 'sorted')
    case ('equal')
      word = 'same'
    case default
      do c = 1, len(word)
        state = mod(state * 1103515245_int64 + 12345_int64, 2147483648_int64)
        word(c:c) = achar(97 + int(mod(state / 65536_int64, 26_int64)))
      enddo
    endselect
    strings(i) = word
  enddo
  endsubroutine make
endprogram sort_scaling
