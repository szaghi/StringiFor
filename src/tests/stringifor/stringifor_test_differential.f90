!< StringiFor differential test: the string methods rewritten for performance against reference implementations.
program stringifor_test_differential
!< StringiFor differential test: the string methods rewritten for performance against reference implementations.
!<
!< The reference implementations are the algorithms of StringiFor v1.3.1, copied here as internal procedures, or naive
!< implementations of the intended semantics where v1.3.1 was wrong:
!<
!<+ `replace` is not recursive (v1.4.0): it is checked against a naive left-to-right scan;
!<+ `count` (the character one) counted wrongly in v1.3.1: it is checked against a naive scan;
!<+ `split` of a string made only of separators returned the string itself in v1.3.1: it now returns no tokens;
!<+ `match` (v1.5.0) is checked against a naive recursive matcher;
!<+ `split` with `keep_empty` (v1.5.0) is checked against a naive left-to-right scan, `read_number` (v1.5.0) against
!<  `to_number` and `is_integer`/`is_number`.
!<
!< The inputs are short random strings over a small alphabet that contains the separators, generated with a fixed seed.
use, intrinsic :: iso_fortran_env, only : iostat_eor
use stringifor

implicit none
character(len=*), parameter :: ALPHABET = 'ab+ '                                                !< Characters of random strings.
character(len=3), parameter :: SEPS(7) = ['+  ', '   ', 'a  ', 'ab ', '++ ', 'aa ', '+a+'] !< Separators, to be trimmed.
integer,          parameter :: SEPS_LEN(7) = [1, 1, 1, 2, 2, 2, 3]                          !< Length of the separators.
integer,          parameter :: CASES = 10000                                                !< Random cases for each method.
logical                     :: test_passed(12)                                              !< List of passed tests.

call init_random()
test_passed(1) = check_split()
test_passed(2) = check_unique()
test_passed(3) = check_replace()
test_passed(4) = check_escape()
test_passed(5) = check_count()
test_passed(6) = check_join()
test_passed(7) = check_strjoin()
test_passed(8) = check_read_lines(form='FORMATTED')
test_passed(9) = check_read_lines(form='UNFORMATTED')
test_passed(10) = check_match()
test_passed(11) = check_split_keep_empty()
test_passed(12) = check_read_number()
print '(L1)', all(test_passed)
if (.not.all(test_passed)) error stop 1 ! runners checking only the exit code must see the failure

contains
   ! checks
   function check_split() result(is_ok)
   !< Check split against the v1.3.1 algorithm.
   logical                   :: is_ok         !< Check result.
   type(string)              :: astring       !< A random string.
   type(string), allocatable :: tokens(:)     !< Tokens of split.
   type(string), allocatable :: ref_tokens(:) !< Tokens of the reference split.
   integer                   :: max_tokens(5) !< Values of max_tokens.
   character(len=32)         :: label         !< Label of a failure.
   integer                   :: i, s, m       !< Counters.

   max_tokens = [-1, 0, 1, 2, 3]
   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      do s=1, size(SEPS)
         call astring%split(tokens=tokens, sep=SEPS(s)(1:SEPS_LEN(s)))
         call ref_split(astring, ref_tokens, sep=SEPS(s)(1:SEPS_LEN(s)))
         if (.not.same_tokens(tokens, ref_tokens)) then
            call report('split', astring%raw, SEPS(s)(1:SEPS_LEN(s)))
            is_ok = .false.
            return
         endif
         do m=1, size(max_tokens)
            call astring%split(tokens=tokens, sep=SEPS(s)(1:SEPS_LEN(s)), max_tokens=max_tokens(m))
            call ref_split(astring, ref_tokens, sep=SEPS(s)(1:SEPS_LEN(s)), max_tokens=max_tokens(m))
            if (.not.same_tokens(tokens, ref_tokens)) then
               write(label, '(A,I0)') 'split max_tokens=', max_tokens(m)
               call report(trim(label), astring%raw, SEPS(s)(1:SEPS_LEN(s)))
               is_ok = .false.
               return
            endif
         enddo
      enddo
   enddo
   endfunction check_split

   function check_unique() result(is_ok)
   !< Check unique against the v1.3.1 algorithm.
   logical                       :: is_ok    !< Check result.
   type(string)                  :: astring  !< A random string.
   type(string)                  :: uniq     !< Result of unique.
   character(len=:), allocatable :: expected !< Expected result.
   integer                       :: i, s     !< Counters.

   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      do s=1, size(SEPS)
         uniq = astring%unique(SEPS(s)(1:SEPS_LEN(s)))
         expected = ref_unique(astring%raw, SEPS(s)(1:SEPS_LEN(s)))
         if (.not.same_raw(uniq, expected)) then
            call report('unique', astring%raw, SEPS(s)(1:SEPS_LEN(s)))
            is_ok = .false.
            return
         endif
      enddo
   enddo
   endfunction check_unique

   function check_replace() result(is_ok)
   !< Check replace against a naive left-to-right, not recursive, scan.
   logical                       :: is_ok    !< Check result.
   type(string)                  :: astring  !< A random string.
   type(string)                  :: replaced !< Result of replace.
   character(len=:), allocatable :: old      !< Old substring.
   character(len=:), allocatable :: new      !< New substring.
   character(len=:), allocatable :: expected !< Expected result.
   integer                       :: i, c     !< Counters.

   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      old = random_string(max_len=3)
      new = random_string(max_len=4)
      if (len(old)==0) cycle
      do c=-1, 3 ! -1 means count absent
         if (c==-1) then
            replaced = astring%replace(old=old, new=new)
            expected = naive_replace(astring%raw, old, new)
         else
            replaced = astring%replace(old=old, new=new, count=c)
            expected = naive_replace(astring%raw, old, new, c)
         endif
         if (.not.same_raw(replaced, expected)) then
            call report('replace', astring%raw, old//'->'//new)
            is_ok = .false.
            return
         endif
      enddo
   enddo
   endfunction check_replace

   function check_escape() result(is_ok)
   !< Check escape against the v1.3.1 algorithm, unescape as its inverse.
   logical      :: is_ok     !< Check result.
   type(string) :: astring   !< A random string.
   type(string) :: escaped   !< Escaped string.
   type(string) :: unescaped !< Unescaped string.
   integer      :: i         !< Counter.

   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      escaped = astring%escape(to_escape='+')
      if (.not.same_raw(escaped, ref_escape(astring%raw, '+', '\'))) then
         call report('escape', astring%raw, '+')
         is_ok = .false.
         return
      endif
      unescaped = escaped%unescape(to_unescape='+')
      if (.not.same_raw(unescaped, astring%raw)) then
         call report('unescape', escaped%raw, '+')
         is_ok = .false.
         return
      endif
      if (index(astring%raw, 'b')>0) cycle ! 'b' is the custom escape character below
      escaped = astring%escape(to_escape='+', esc='b')
      if (.not.same_raw(escaped, ref_escape(astring%raw, '+', 'b'))) then
         call report('escape esc=b', astring%raw, '+')
         is_ok = .false.
         return
      endif
      unescaped = escaped%unescape(to_unescape='+', unesc='b')
      if (.not.same_raw(unescaped, astring%raw)) then
         call report('unescape unesc=b', escaped%raw, '+')
         is_ok = .false.
         return
      endif
   enddo
   endfunction check_escape

   function check_count() result(is_ok)
   !< Check the character count and the string count method against a naive scan.
   logical                       :: is_ok     !< Check result.
   type(string)                  :: astring   !< A random string.
   character(len=:), allocatable :: substring !< Substring.
   integer                       :: i         !< Counter.

   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      substring = random_string(max_len=3)
      if (len(substring)==0) cycle
      if (count(astring%raw, substring)/=naive_count(astring%raw, substring).or. &
          astring%count(substring)/=naive_count(astring%raw, substring)) then
         call report('count', astring%raw, substring)
         is_ok = .false.
         return
      endif
   enddo
   endfunction check_count

   function check_join() result(is_ok)
   !< Check the join methods against the v1.3.1 algorithms.
   logical                   :: is_ok         !< Check result.
   type(string)              :: astring       !< The joiner.
   type(string), allocatable :: array(:)      !< Array of strings.
   character(len=4)          :: characters(5) !< Array of characters.
   type(string)              :: joined        !< Join result.
   integer                   :: i, a, n       !< Counters.

   is_ok = .true.
   do i=1, CASES
      n = random_integer(0, 5)
      if (allocated(array)) deallocate(array)
      allocate(array(n))
      do a=1, n
         if (random_integer(0, 3)>0) array(a) = random_string(max_len=4) ! some elements are left not allocated
         characters(a) = random_string(max_len=4)
      enddo
      call astring%free
      if (random_integer(0, 1)==1) astring = random_string(max_len=2)
      joined = astring%join(array=array, sep='+-')
      if (.not.same_raw(joined, ref_join_strings(array, '+-'))) then
         call report('join strings', '', '+-')
         is_ok = .false.
         return
      endif
      joined = astring%join(array=characters(1:n), sep='+-')
      if (.not.same_raw(joined, ref_join_characters(characters(1:n), '+-'))) then
         call report('join characters', '', '+-')
         is_ok = .false.
         return
      endif
      if (allocated(astring%raw)) then
         joined = astring%join(array=array)
         if (.not.same_raw(joined, ref_join_strings(array, astring%raw))) then
            call report('join strings, self separator', astring%raw, '')
            is_ok = .false.
            return
         endif
      endif
   enddo
   endfunction check_join

   function check_strjoin() result(is_ok)
   !< Check the strjoin procedures against the v1.3.1 algorithms.
   logical                   :: is_ok         !< Check result.
   type(string), allocatable :: array(:)      !< Array of strings.
   type(string), allocatable :: array2(:,:)   !< 2D array of strings.
   type(string), allocatable :: joined2(:)    !< 2D join result.
   character(len=4)          :: characters(5) !< Array of characters.
   type(string)              :: joined        !< Join result.
   logical                   :: is_trim       !< Trim flag.
   integer                   :: i, a, n       !< Counters.

   is_ok = .true.
   do i=1, CASES
      n = random_integer(0, 5)
      if (allocated(array)) deallocate(array)
      allocate(array(n))
      do a=1, n
         if (random_integer(0, 3)>0) array(a) = random_string(max_len=4)
         characters(a) = random_string(max_len=4)
      enddo
      joined = strjoin(array=array, sep='+-')
      if (.not.same_raw(joined, ref_join_strings(array, '+-'))) then
         call report('strjoin strings', '', '+-')
         is_ok = .false.
         return
      endif
      is_trim = random_integer(0, 1)==1
      joined = strjoin(array=characters(1:n), sep='+-', is_trim=is_trim)
      if (.not.same_raw(joined, ref_strjoin_characters(characters(1:n), '+-', is_trim))) then
         call report('strjoin characters', '', '+-')
         is_ok = .false.
         return
      endif
      if (n>0) then
         if (allocated(array2)) deallocate(array2)
         allocate(array2(n, 2))
         array2(:, 1) = array
         array2(:, 2) = array
         joined2 = strjoin(array=array2, sep='+-', is_col=.true.)
         do a=1, 2
            if (.not.same_raw(joined2(a), ref_join_strings(array, '+-'))) then
               call report('strjoin 2D', '', '+-')
               is_ok = .false.
               return
            endif
         enddo
      endif
   enddo
   endfunction check_strjoin

   function check_read_lines(form) result(is_ok)
   !< Check read_lines (and read_file for the formatted form) against the v1.3.1 algorithm on random files.
   character(len=*), intent(in)  :: form      !< Form of the file.
   logical                       :: is_ok     !< Check result.
   type(string)                  :: lines     !< Lines read.
   character(len=:), allocatable :: content   !< Content of the file.
   character(len=:), allocatable :: expected  !< Lines read by the reference.
   character(len=*), parameter   :: FILE_NAME = 'stringifor_test_differential.tmp' !< File name.
   integer                       :: unit      !< Logical unit.
   integer                       :: i, l      !< Counters.

   is_ok = .true.
   do i=1, CASES / 50
      content = ''
      do l=1, random_integer(0, 6)
         content = content//repeat(random_string(max_len=8), random_integer(1, 300))//new_line('a') ! up to 2400 chars
      enddo
      if (random_integer(0, 1)==1) content = content//random_string(max_len=8) ! last line without terminator
      open(newunit=unit, file=FILE_NAME, access='stream', form='unformatted', status='replace')
      write(unit) content
      close(unit)
      if (form=='FORMATTED') then
         open(newunit=unit, file=FILE_NAME, status='old', action='read')
      else
         open(newunit=unit, file=FILE_NAME, status='old', action='read', form='unformatted', access='stream')
      endif
      expected = ref_read_lines(unit, form)
      call lines%free
      call lines%read_lines(unit=unit, form=form)
      close(unit)
      if (expected=='') then
         is_ok = .not.allocated(lines%raw) ! an empty file leaves the string not allocated
      else
         is_ok = same_raw(lines, expected)
      endif
      if (.not.is_ok) then
         call report('read_lines '//form, content, '')
         exit
      endif
      if (form=='FORMATTED') then
         call lines%free
         call lines%read_file(file=FILE_NAME)
         if (expected=='') then
            is_ok = .not.allocated(lines%raw)
         else
            is_ok = same_raw(lines, expected)
         endif
         if (.not.is_ok) then
            call report('read_file', content, '')
            exit
         endif
      endif
   enddo
   open(newunit=unit, file=FILE_NAME)
   close(unit, status='delete')
   endfunction check_read_lines

   function check_match() result(is_ok)
   !< Check match against a naive recursive matcher, on patterns rich of wildcards and class syntax.
   character(len=*), parameter   :: PATTERN_ALPHABET = 'ab-]![*?' !< Characters of the random patterns.
   logical                       :: is_ok                        !< Check result.
   type(string)                  :: astring                      !< A random string.
   character(len=:), allocatable :: pattern                      !< A random pattern.
   integer                       :: i, c                         !< Counters.

   is_ok = .true.
   do i=1, 10 * CASES
      astring = random_string(max_len=8)
      allocate(character(len=random_integer(0, 8)) :: pattern)
      do c=1, len(pattern)
         pattern(c:c) = PATTERN_ALPHABET(random_integer(1, len(PATTERN_ALPHABET)):)
      enddo
      if (astring%match(pattern).neqv.naive_match(astring%raw, pattern)) then
         call report('match', astring%raw, pattern)
         is_ok = .false.
         return
      endif
      deallocate(pattern)
   enddo
   endfunction check_match

   function check_split_keep_empty() result(is_ok)
   !< Check split keeping the empty fields against a naive left-to-right scan (as Python str.split(sep, maxsplit)).
   logical                   :: is_ok         !< Check result.
   type(string)              :: astring       !< A random string.
   type(string), allocatable :: tokens(:)     !< Tokens of split.
   type(string), allocatable :: ref_tokens(:) !< Tokens of the reference split.
   integer                   :: max_tokens(5) !< Values of max_tokens.
   integer                   :: i, s, m       !< Counters.

   max_tokens = [-1, 0, 1, 2, 3]
   is_ok = .true.
   do i=1, CASES
      astring = random_string()
      do s=1, size(SEPS)
         do m=0, size(max_tokens)
            if (m==0) then
               call astring%split(tokens=tokens, sep=SEPS(s)(1:SEPS_LEN(s)), keep_empty=.true.)
               call naive_split_keep_empty(astring%raw, SEPS(s)(1:SEPS_LEN(s)), huge(1), ref_tokens)
            else
               call astring%split(tokens=tokens, sep=SEPS(s)(1:SEPS_LEN(s)), max_tokens=max_tokens(m), keep_empty=.true.)
               call naive_split_keep_empty(astring%raw, SEPS(s)(1:SEPS_LEN(s)), max_tokens(m), ref_tokens)
            endif
            if (.not.same_tokens(tokens, ref_tokens)) then
               call report('split keep_empty', astring%raw, SEPS(s)(1:SEPS_LEN(s)))
               is_ok = .false.
               return
            endif
         enddo
      enddo
   enddo
   endfunction check_split_keep_empty

   function check_read_number() result(is_ok)
   !< Check read_number against to_number and is_integer/is_number, on random strings looking like numbers.
   character(len=*), parameter :: NUMBER_ALPHABET = '0123456789+-.eEdx ' !< Characters of the random strings.
   logical                     :: is_ok                                  !< Check result.
   type(string)                :: astring                                !< A random string.
   real(R8P)                   :: real_                                  !< Number read.
   integer(I4P)                :: integer_                               !< Number read.
   integer                     :: iostat                                 !< IO status code.
   integer                     :: i, c                                   !< Counters.

   is_ok = .true.
   do i=1, CASES
      astring = repeat(' ', random_integer(0, 8))
      do c=1, astring%len()
         astring%raw(c:c) = NUMBER_ALPHABET(random_integer(1, len(NUMBER_ALPHABET)):)
      enddo
      call astring%read_number(real_, iostat=iostat)
      if (iostat==0.and..not.astring%is_number()) is_ok = .false. ! a number may still overflow
      if (iostat==0) then
         if (real_/=astring%to_number(kind=1._R8P)) is_ok = .false.
      else
         if (real_==real_) is_ok = .false. ! not a NaN
      endif
      call astring%read_number(integer_, iostat=iostat)
      if (iostat==0.and..not.astring%is_integer()) is_ok = .false.
      if (integer_/=astring%to_number(kind=1_I4P)) is_ok = .false.
      if (.not.is_ok) then
         call report('read_number', astring%raw, '')
         return
      endif
   enddo
   endfunction check_read_number

   ! helpers
   subroutine init_random()
   !< Seed the random generator with a fixed seed.
   integer, allocatable :: seed(:) !< Seed.
   integer              :: n       !< Seed size.

   call random_seed(size=n)
   allocate(seed(n))
   seed = 20261003
   call random_seed(put=seed)
   endsubroutine init_random

   function random_integer(low, high) result(i)
   !< Return a random integer in [low, high].
   integer, intent(in) :: low  !< Lower bound.
   integer, intent(in) :: high !< Upper bound.
   integer             :: i    !< Random integer.
   real                :: r    !< Random real.

   call random_number(r)
   i = low + min(int(r * (high - low + 1)), high - low)
   endfunction random_integer

   function random_string(max_len) result(chars)
   !< Return a random string over the alphabet, of length up to max_len (default 30).
   integer, intent(in), optional :: max_len !< Maximum length.
   character(len=:), allocatable :: chars   !< Random string.
   integer                       :: max_len_ !< Maximum length, local variable.
   integer                       :: c       !< Counter.

   max_len_ = 30 ; if (present(max_len)) max_len_ = max_len
   allocate(character(len=random_integer(0, max_len_)) :: chars)
   do c=1, len(chars)
      chars(c:c) = ALPHABET(random_integer(1, len(ALPHABET)):)
   enddo
   endfunction random_string

   pure function same_tokens(tokens, ref_tokens) result(is_same)
   !< Return true if the two lists of tokens are equal (allocation status, size, contents and lengths).
   type(string), allocatable, intent(in) :: tokens(:)     !< Tokens.
   type(string), allocatable, intent(in) :: ref_tokens(:) !< Reference tokens.
   logical                               :: is_same       !< Check result.
   integer                               :: t             !< Counter.

   is_same = allocated(tokens).eqv.allocated(ref_tokens)
   if (.not.is_same.or..not.allocated(tokens)) return
   is_same = size(tokens)==size(ref_tokens)
   if (.not.is_same) return
   do t=1, size(tokens)
      is_same = same_raw(tokens(t), ref_tokens(t)%raw)
      if (.not.is_same) return
   enddo
   endfunction same_tokens

   pure function same_raw(astring, chars) result(is_same)
   !< Return true if the string is allocated and equal, in contents and length, to the characters.
   type(string),     intent(in) :: astring !< The string.
   character(len=*), intent(in) :: chars   !< The characters.
   logical                      :: is_same !< Check result.

   is_same = .false.
   if (allocated(astring%raw)) is_same = astring%raw==chars.and.len(astring%raw)==len(chars)
   endfunction same_raw

   subroutine report(method, input, argument)
   !< Report a failed case.
   character(len=*), intent(in) :: method   !< Method checked.
   character(len=*), intent(in) :: input    !< Input string.
   character(len=*), intent(in) :: argument !< Argument of the method.

   print '(A)', 'failed '//method//' on input ['//input//'] with argument ['//argument//']'
   endsubroutine report

   ! reference implementations
   pure function naive_replace(chars, old, new, count) result(replaced)
   !< Replace, left to right and not recursively, the first count occurrences (all if count is absent) of old by new.
   character(len=*), intent(in)           :: chars    !< Input.
   character(len=*), intent(in)           :: old      !< Old substring.
   character(len=*), intent(in)           :: new      !< New substring.
   integer,          intent(in), optional :: count    !< Number of replacements.
   character(len=:), allocatable          :: replaced !< Result.
   integer                                :: c, r     !< Counters.

   replaced = ''
   c = 1
   r = 0
   do while (c<=len(chars))
      if (present(count)) then
         if (r>=count) exit
      endif
      if (c+len(old)-1<=len(chars)) then
         if (chars(c:c+len(old)-1)==old) then
            replaced = replaced//new
            c = c + len(old)
            r = r + 1
            cycle
         endif
      endif
      replaced = replaced//chars(c:c)
      c = c + 1
   enddo
   replaced = replaced//chars(c:)
   endfunction naive_replace

   pure recursive function naive_match(chars, pattern) result(is_match)
   !< Match a wildcard pattern by recursion on its first token (`*`, `?`, `[seq]`, `[!seq]` or a plain character).
   character(len=*), intent(in) :: chars      !< Input.
   character(len=*), intent(in) :: pattern    !< Wildcard pattern.
   logical                      :: is_match   !< Result.
   integer                      :: last       !< Position of the closing bracket of a class.
   integer                      :: first      !< First character of the set of a class.
   integer                      :: i          !< Counter.
   logical                      :: is_member  !< The character is a member of the set.
   logical                      :: is_negated !< The class is negated.

   if (len(pattern)==0) then
      is_match = len(chars)==0
      return
   endif
   if (pattern(1:1)=='*') then
      is_match = naive_match(chars, pattern(2:))
      if (.not.is_match.and.len(chars)>0) is_match = naive_match(chars(2:), pattern)
      return
   endif
   is_match = .false.
   if (len(chars)==0) return
   if (pattern(1:1)=='?') then
      is_match = naive_match(chars(2:), pattern(2:))
   elseif (pattern(1:1)=='[') then
      first = 2
      is_negated = .false.
      if (len(pattern)>=2) is_negated = pattern(2:2)=='!'
      if (is_negated) first = 3
      last = 0
      do i=first+1, len(pattern) ! the first member may be a ']'
         if (pattern(i:i)==']') then
            last = i
            exit
         endif
      enddo
      if (last==0) then ! a plain '['
         if (chars(1:1)=='[') is_match = naive_match(chars(2:), pattern(2:))
         return
      endif
      is_member = .false.
      i = first
      do while (i<last)
         if (i+2<last) then
            if (pattern(i+1:i+1)=='-') then
               if (chars(1:1)>=pattern(i:i).and.chars(1:1)<=pattern(i+2:i+2)) is_member = .true.
               i = i + 3
               cycle
            endif
         endif
         if (chars(1:1)==pattern(i:i)) is_member = .true.
         i = i + 1
      enddo
      if (is_member.neqv.is_negated) is_match = naive_match(chars(2:), pattern(last+1:))
   else
      if (chars(1:1)==pattern(1:1)) is_match = naive_match(chars(2:), pattern(2:))
   endif
   endfunction naive_match

   pure subroutine naive_split_keep_empty(chars, sep, max_splits, tokens)
   !< Split at every separator, left to right, at most max_splits times (all if max_splits<=0), keeping the empty fields.
   character(len=*),          intent(in)  :: chars      !< Input.
   character(len=*),          intent(in)  :: sep        !< Separator.
   integer,                   intent(in)  :: max_splits !< Maximum number of splits.
   type(string), allocatable, intent(out) :: tokens(:)  !< Tokens.
   type(string), allocatable              :: grown(:)   !< Grown tokens.
   character(len=:), allocatable          :: field      !< Current field.
   integer                                :: c          !< Character counter.

   allocate(tokens(0))
   field = ''
   c = 1
   do while (c<=len(chars))
      if (size(tokens)<max_splits.or.max_splits<=0) then
         if (c+len(sep)-1<=len(chars)) then
            if (chars(c:c+len(sep)-1)==sep) then
               allocate(grown(size(tokens)+1))
               grown(1:size(tokens)) = tokens
               grown(size(grown))%raw = field
               call move_alloc(from=grown, to=tokens)
               field = ''
               c = c + len(sep)
               cycle
            endif
         endif
      endif
      field = field//chars(c:c)
      c = c + 1
   enddo
   allocate(grown(size(tokens)+1))
   grown(1:size(tokens)) = tokens
   grown(size(grown))%raw = field
   call move_alloc(from=grown, to=tokens)
   endsubroutine naive_split_keep_empty

   pure function naive_count(chars, substring) result(n)
   !< Count the not overlapping occurrences of substring, left to right.
   character(len=*), intent(in) :: chars     !< Input.
   character(len=*), intent(in) :: substring !< Substring.
   integer                      :: n         !< Number of occurrences.
   integer                      :: c         !< Counter.

   n = 0
   c = 1
   do while (c+len(substring)-1<=len(chars))
      if (chars(c:c+len(substring)-1)==substring) then
         n = n + 1
         c = c + len(substring)
      else
         c = c + 1
      endif
   enddo
   endfunction naive_count

   pure function ref_replace_recursive(chars, old, new) result(replaced)
   !< The v1.3.1 replace (without count): replace the first occurrence until none is left.
   character(len=*), intent(in)  :: chars    !< Input.
   character(len=*), intent(in)  :: old      !< Old substring.
   character(len=*), intent(in)  :: new      !< New substring.
   character(len=:), allocatable :: replaced !< Result.
   integer                       :: pos      !< Position of old.

   replaced = chars
   if (len(old)==0) return
   do
      pos = index(replaced, old)
      if (pos==0) exit
      replaced = replaced(1:pos-1)//new//replaced(pos+len(old):)
   enddo
   endfunction ref_replace_recursive

   pure function ref_unique(chars, substring) result(uniq)
   !< The v1.3.1 unique.
   character(len=*), intent(in)  :: chars     !< Input.
   character(len=*), intent(in)  :: substring !< Substring.
   character(len=:), allocatable :: uniq      !< Result.

   uniq = chars
   do
      if (.not.index(uniq, repeat(substring, 2))>0) exit
      uniq = ref_replace_recursive(uniq, repeat(substring, 2), substring)
   enddo
   endfunction ref_unique

   pure function ref_partition(chars, sep) result(partitions)
   !< The v1.3.1 partition.
   character(len=*), intent(in) :: chars         !< Input.
   character(len=*), intent(in) :: sep           !< Separator.
   type(string)                 :: partitions(3) !< Partitions: before the separator, the separator, after the separator.
   integer                      :: c             !< Character counter.

   partitions(1) = chars
   partitions(2) = sep
   partitions(3) = ''
   if (len(sep)>=len(chars)) return
   c = index(chars, sep)
   if (c>0) then
      partitions(1)%raw = chars(1:c-1)
      partitions(2)%raw = chars(c:c+len(sep)-1)
      partitions(3)%raw = chars(c+len(sep):)
   endif
   endfunction ref_partition

   pure subroutine ref_split(self, tokens, sep, max_tokens)
   !< The v1.3.1 split, except that a string made only of separators gives no tokens (it gave the string itself).
   type(string),              intent(in)           :: self           !< The string.
   type(string), allocatable, intent(out)          :: tokens(:)      !< Tokens substring.
   character(len=*),          intent(in)           :: sep            !< Separator.
   integer,                   intent(in), optional :: max_tokens     !< Fix the maximum number of returned tokens.
   integer                                         :: No             !< Number of occurrences of sep.
   integer                                         :: t              !< Character counter.
   type(string)                                    :: temporary      !< Temporary storage.
   type(string), allocatable                       :: temp_toks(:,:) !< Temporary tokens substring.

   if (allocated(self%raw)) then
     temporary = ref_unique(self%raw, sep)
     if (temporary%raw==sep.and.len(temporary%raw)==len(sep)) then
       allocate(tokens(0)) ! intended difference: a string made only of separators has no tokens
       return
     endif
     No = naive_count(temporary%raw, sep)

     if (No>0) then
       if (present(max_tokens)) then
         if (max_tokens < No.and.max_tokens > 0) No = max_tokens
       endif
       allocate(temp_toks(3, No))
       temp_toks(:, 1) = ref_partition(temporary%raw, sep)
       if (No>1) then
         do t=2, No
           temp_toks(:, t) = ref_partition(temp_toks(3, t-1)%raw, sep)
         enddo
       endif

       if (temp_toks(1, 1)%raw/=''.and.temp_toks(3, No)%raw/='') then
         allocate(tokens(No+1))
         do t=1, No
           if (t==No) then
             tokens(t  ) = temp_toks(1, t)
             tokens(t+1) = temp_toks(3, t)
           else
             tokens(t) = temp_toks(1, t)
           endif
         enddo
       elseif (temp_toks(1, 1)%raw/='') then
         allocate(tokens(No))
         do t=1, No
           tokens(t) = temp_toks(1, t)
         enddo
       elseif (temp_toks(3, No)%raw/='') then
         allocate(tokens(No))
         do t=1, No-1
           tokens(t) = temp_toks(1, t+1)
         enddo
         tokens(No) = temp_toks(3, No)
       else
         allocate(tokens(No-1))
         do t=2, No
           tokens(t-1) = temp_toks(1, t)
         enddo
       endif

     else
       allocate(tokens(1))
       tokens(1) = self
     endif
   endif
   endsubroutine ref_split

   pure function ref_escape(chars, to_escape, esc) result(escaped)
   !< The v1.3.1 escape.
   character(len=*), intent(in)  :: chars     !< Input.
   character(len=1), intent(in)  :: to_escape !< Character to be escaped.
   character(len=*), intent(in)  :: esc       !< Character used to escape.
   character(len=:), allocatable :: escaped   !< Escaped string.
   integer                       :: c         !< Character counter.

   escaped = ''
   do c=1, len(chars)
     if (chars(c:c)==to_escape) then
       escaped = escaped//esc//to_escape
     else
       escaped = escaped//chars(c:c)
     endif
   enddo
   endfunction ref_escape

   pure function ref_join_strings(array, sep) result(join)
   !< The v1.3.1 join of strings (and strjoin of strings).
   type(string),     intent(in)  :: array(1:) !< Array to be joined.
   character(len=*), intent(in)  :: sep       !< Separator.
   character(len=:), allocatable :: join      !< The join of array.
   integer                       :: a         !< Counter.

   join = ''
   if (size(array, dim=1)==0) return
   do a=2, size(array, dim=1)
      if (allocated(array(a)%raw)) join = join//sep//array(a)%raw
   enddo
   if (allocated(array(1)%raw)) then
      join = array(1)%raw//join
   else
      join = join(len(sep)+1:len(join))
   endif
   endfunction ref_join_strings

   pure function ref_join_characters(array, sep) result(join)
   !< The v1.3.1 join of characters.
   character(len=*), intent(in)  :: array(1:) !< Array to be joined.
   character(len=*), intent(in)  :: sep       !< Separator.
   character(len=:), allocatable :: join      !< The join of array.
   integer                       :: a         !< Counter.

   join = ''
   if (size(array, dim=1)==0) return
   do a=2, size(array, dim=1)
      if (array(a)/='') join = join//sep//array(a)
   enddo
   if (array(1)/='') then
      join = array(1)//join
   else
      join = join(len(sep)+1:len(join))
   endif
   endfunction ref_join_characters

   pure function ref_strjoin_characters(array, sep, is_trim) result(join)
   !< The v1.3.1 strjoin of characters.
   character(len=*), intent(in)  :: array(1:) !< Array to be joined.
   character(len=*), intent(in)  :: sep       !< Separator.
   logical,          intent(in)  :: is_trim   !< Flag to trim the items.
   character(len=:), allocatable :: join      !< The join of array.
   integer                       :: a         !< Counter.

   if (.not.is_trim) then
      join = ref_join_characters(array, sep)
      return
   endif
   join = ''
   if (size(array, dim=1)==0) return
   do a=2, size(array, dim=1)
      if (trim(array(a))/='') join = join//sep//trim(array(a))
   enddo
   if (trim(array(1))/='') then
      join = trim(array(1))//join
   else
      join = join(len(sep)+1:len(join))
   endif
   endfunction ref_strjoin_characters

   function ref_read_lines(unit, form) result(lines)
   !< The v1.3.1 read_lines (with its read_line).
   integer,          intent(in)  :: unit    !< Logical unit.
   character(len=*), intent(in)  :: form    !< Form of the unit.
   character(len=:), allocatable :: lines   !< Lines read.
   character(len=:), allocatable :: line    !< Line read.
   integer                       :: iostat_ !< IO status code.

   rewind(unit)
   lines = ''
   do
      call ref_read_line(unit, form, line, iostat_)
      if (iostat_/=0) exit
      lines = lines//line//new_line('a')
   enddo
   rewind(unit)
   endfunction ref_read_lines

   subroutine ref_read_line(unit, form, line, iostat_)
   !< The v1.3.1 read_line.
   integer,                       intent(in)  :: unit    !< Logical unit.
   character(len=*),              intent(in)  :: form    !< Form of the unit.
   character(len=:), allocatable, intent(out) :: line    !< Line read.
   integer,                       intent(out) :: iostat_ !< IO status code.
   character(len=1)                           :: ch      !< Character storage.

   line = ''
   select case(form)
   case('FORMATTED')
      do
         read(unit, "(A)", advance='no', iostat=iostat_, err=10, end=10, eor=10) ch
         line = line//ch
      enddo
   case('UNFORMATTED')
      do
         read(unit, iostat=iostat_, err=10, end=10) ch
         if (ch==new_line('a')) then
            iostat_ = iostat_eor
            exit
         endif
         line = line//ch
      enddo
   endselect
   10 if (is_iostat_eor(iostat_)) iostat_ = 0
   if (is_iostat_end(iostat_).and.len(line)>0) iostat_ = 0
   endsubroutine ref_read_line
endprogram stringifor_test_differential
