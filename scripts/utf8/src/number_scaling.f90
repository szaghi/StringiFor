!< Timing check of the number parsing, built by scripts/utf8/build.sh.
!<
!< Times to_number and the read statement on 17 digit doubles of any exponent, and on plain numbers, in ns per number.
!< Exits with status 1 if to_number is not at least 4 times faster than read on either.
program number_scaling
use, intrinsic :: iso_fortran_env, only : int64, output_unit, real64
use stringifor, only : R8P, string
implicit none
integer, parameter        :: N = 1000000  !< Numbers.
character(len=32), allocatable :: text(:) !< The numbers.
real(real64)              :: x            !< A random number.
real(real64)              :: fast(2)      !< ns per number, to_number.
real(real64)              :: slow(2)      !< ns per number, read.
integer                   :: i            !< Counter.
integer                   :: k            !< Input kind.

allocate(text(N))
do k = 1, 2
  do i = 1, N
    call random_number(x)
    if (k == 1) then
      write(text(i), '(es25.16e3)') x * 10._real64 ** (int(x * 600) - 300)
    else
      write(text(i), '(f12.4)') x * 1000._real64
    endif
    text(i) = adjustl(text(i))
  enddo
  fast(k) = time_to_number()
  slow(k) = time_read()
  write(output_unit, '(a,i0,a,f0.1,a,f0.1,a)') 'input ', k, ': to_number ', fast(k), ' ns, read ', slow(k), ' ns'
enddo
if (any(fast * 4 > slow)) error stop 'number_scaling: to_number is not 4 times faster than read'

contains
  function time_to_number() result(ns)
  !< Best of 3 times of to_number over the numbers (ns per number).
  real(real64)   :: ns    !< Time.
  type(string)   :: s     !< A string.
  real(real64)   :: sum_  !< Sum, so that no call is optimized away.
  integer(int64) :: t0    !< Start.
  integer(int64) :: t1    !< End.
  integer(int64) :: rate  !< Clock rate.
  integer        :: r     !< Repetition.
  integer        :: j     !< Counter.

  ns = huge(1._real64)
  do r = 1, 3
    sum_ = 0
    call system_clock(t0, rate)
    do j = 1, N
      s%raw = trim(text(j))
      sum_ = sum_ + s%to_number(kind=1._R8P)
    enddo
    call system_clock(t1)
    if (sum_ /= sum_) error stop 'number_scaling: a number was not read'
    ns = min(ns, real(t1 - t0, real64) / rate / N * 1.e9_real64)
  enddo
  endfunction time_to_number

  function time_read() result(ns)
  !< Best of 3 times of read over the numbers (ns per number).
  real(real64)   :: ns    !< Time.
  real(real64)   :: value !< A number.
  real(real64)   :: sum_  !< Sum, so that no call is optimized away.
  integer(int64) :: t0    !< Start.
  integer(int64) :: t1    !< End.
  integer(int64) :: rate  !< Clock rate.
  integer        :: r     !< Repetition.
  integer        :: j     !< Counter.

  ns = huge(1._real64)
  do r = 1, 3
    sum_ = 0
    call system_clock(t0, rate)
    do j = 1, N
      read(text(j), *) value
      sum_ = sum_ + value
    enddo
    call system_clock(t1)
    if (sum_ /= sum_) error stop 'number_scaling: a number was not read'
    ns = min(ns, real(t1 - t0, real64) / rate / N * 1.e9_real64)
  enddo
  endfunction time_read
endprogram number_scaling
