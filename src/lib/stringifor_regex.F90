!< StringiFor, regular expressions: a Pike VM, linear in the subject.
module stringifor_regex
!< StringiFor, regular expressions: a Pike VM, linear in the subject.
!<
!< A pattern is parsed into a syntax tree, compiled into a program of a small virtual machine and run by a Pike VM: a
!< simulation of the Thompson NFA that carries the capture positions with each thread. The time is O(n m), n the length
!< of the subject and m the size of the program, whatever the pattern: there is no backtracking. Among the matches
!< starting at the leftmost position the VM picks the one a backtracking engine (Perl, Python) would find first.
!<
!< Matching is by unit, as the rest of StringiFor: a well-formed UTF-8 sequence, or a single byte that is not part of one.
!< Internally a unit is a code: its codepoint, or U+DC00 + b for an ill-formed byte b, as Python's surrogateescape.
use, intrinsic :: iso_fortran_env, only : error_unit
use penf, only : I4P
use stringifor_string_t, only : CK, string
use stringifor_utf8, only : utf8_decode

implicit none
private
public :: regex
public :: regex_match
public :: string ! the type of the texts the regexes return

integer, parameter :: MAX_PROGRAM = 100000 !< Largest program, in instructions.
integer, parameter :: MAX_DEPTH = 200      !< Deepest nesting of groups.
integer, parameter :: MAX_REPEAT = 1000    !< Largest count of a {m,n} quantifier.
integer, parameter :: MAX_GROUPS = 1000    !< Most capturing groups.
integer, parameter :: MAX_CODE = 1114111   !< Largest code of a unit (U+10FFFF).
integer, parameter :: BYTE_BASE = 56320    !< Code of the ill-formed byte b: BYTE_BASE + b (U+DC00 + b).
character(len=1), parameter :: BACKSLASH = achar(92) !< Backslash (nvfortran reads backslash escapes in literals).

! instructions of the program
integer, parameter :: OP_CHAR = 1   !< Match the unit of code arg1.
integer, parameter :: OP_CHARI = 2  !< Match the unit of code arg1, ASCII case ignored (arg1 is lowercase).
integer, parameter :: OP_ANY = 3    !< Match any unit but LF.
integer, parameter :: OP_ANYNL = 4  !< Match any unit.
integer, parameter :: OP_CLASS = 5  !< Match a unit of the class arg1.
integer, parameter :: OP_SPLIT = 6  !< Continue at arg1 (preferred) and at arg2.
integer, parameter :: OP_JMP = 7    !< Continue at arg1.
integer, parameter :: OP_SAVE = 8   !< Save the position into the slot arg1.
integer, parameter :: OP_ASSERT = 9 !< Continue if the assertion arg1 holds at the position.
integer, parameter :: OP_MARK = 10  !< Save the position into the register arg1 (start of a loop iteration).
integer, parameter :: OP_CHECK = 11 !< Continue at arg2 if the iteration was empty (register arg1 = position), else at arg3.
integer, parameter :: OP_MATCH = 12 !< A match.

! assertions
integer, parameter :: AS_BOT = 1    !< \A, and ^ without m: start of the subject.
integer, parameter :: AS_EOT = 2    !< \z (\Z): end of the subject.
integer, parameter :: AS_MBOL = 3   !< ^ with m: start of a line.
integer, parameter :: AS_EOL = 4    !< $ without m: end of the subject, or before a LF ending it.
integer, parameter :: AS_MEOL = 5   !< $ with m: end of a line.
integer, parameter :: AS_WORDB = 6  !< \b: a word boundary (ASCII word characters).
integer, parameter :: AS_NWORDB = 7 !< \B: not a word boundary.

! nodes of the syntax tree
integer, parameter :: N_EMPTY = 1  !< Nothing.
integer, parameter :: N_LIT = 2    !< A unit, code val1.
integer, parameter :: N_ANY = 3    !< The dot.
integer, parameter :: N_CLASS = 4  !< A class, index val1.
integer, parameter :: N_ASSERT = 5 !< An assertion, kind val1.
integer, parameter :: N_GROUP = 6  !< A group, capturing if val1 > 0 (its number): one child.
integer, parameter :: N_CAT = 7    !< A concatenation of the children.
integer, parameter :: N_ALT = 8    !< An alternation of the children.
integer, parameter :: N_REPEAT = 9 !< The child repeated val1 to val2 times (val2 < 0: no limit), greedy if val3 = 1.

type :: regex
  !< A compiled regular expression.
  !<
  !< Compile it with [[regex:compile]], then match it with [[regex:search]], [[regex:match]] or [[regex:fullmatch]].
  private
  logical                   :: compiled = .false. !< True once compiled.
  integer                   :: ngroups = 0        !< Number of capturing groups.
  integer                   :: nregs = 0          !< Number of loop registers.
  integer,      allocatable :: op(:)              !< Instructions.
  integer,      allocatable :: arg1(:)            !< First argument of the instructions.
  integer,      allocatable :: arg2(:)            !< Second argument of the instructions.
  integer,      allocatable :: arg3(:)            !< Third argument of the instructions.
  integer(I4P), allocatable :: ranges(:,:)        !< Ranges [first, last] of codes of all the classes.
  integer,      allocatable :: class_first(:)     !< First range of each class.
  integer,      allocatable :: class_last(:)      !< Last range of each class.
  logical,      allocatable :: class_negated(:)   !< True if the class is negated.
  type(string), allocatable :: names(:)           !< Name of each group, null if unnamed.
  contains
    procedure, pass(self) :: compile     !< Compile a pattern.
    procedure, pass(self) :: is_compiled !< Return true if the regex is compiled.
    procedure, pass(self) :: group_count !< Return the number of capturing groups.
    procedure, pass(self) :: group_index !< Return the number of a named group, 0 if there is none.
    generic               :: search => search_character, search_string       !< Search the leftmost match.
    generic               :: match => match_character, match_string          !< Match at the start.
    generic               :: fullmatch => fullmatch_character, fullmatch_string !< Match the whole subject.
    procedure, pass(self), private :: search_character    !< Search the leftmost match in a character.
    procedure, pass(self), private :: search_string       !< Search the leftmost match in a string.
    procedure, pass(self), private :: match_character     !< Match at the start of a character.
    procedure, pass(self), private :: match_string        !< Match at the start of a string.
    procedure, pass(self), private :: fullmatch_character !< Match the whole character.
    procedure, pass(self), private :: fullmatch_string    !< Match the whole string.
endtype regex

type :: regex_match
  !< The result of a match: whether it was found, and the position and the text of each group.
  logical                   :: found = .false. !< True if there is a match.
  integer,      allocatable :: spans(:,:)      !< First and last byte of each group 0..n; [0, -1] if it did not match.
  type(string), allocatable :: texts(:)        !< Text of each group 0..n; not allocated if it did not match.
  type(string), allocatable :: names(:)        !< Name of each group 1..n, null if unnamed.
  contains
    generic               :: span => span_number, span_name   !< Return the first and last byte of a group.
    generic               :: group => group_number, group_name !< Return the text of a group.
    procedure, pass(self) :: groups                            !< Return the texts of the groups 1..n.
    procedure, pass(self), private :: span_number  !< Span of a group by number.
    procedure, pass(self), private :: span_name    !< Span of a group by name.
    procedure, pass(self), private :: group_number !< Text of a group by number.
    procedure, pass(self), private :: group_name   !< Text of a group by name.
endtype regex_match

type :: parser
  !< State of the parser and of the compiler of a pattern.
  character(kind=CK, len=:), allocatable :: pattern       !< The pattern.
  integer                                :: ip = 1        !< Position in the pattern.
  logical                                :: nocase = .false.    !< Flag i.
  logical                                :: multiline = .false. !< Flag m.
  logical                                :: dotall = .false.    !< Flag s.
  integer                                :: nnodes = 0    !< Number of nodes.
  integer,      allocatable              :: kind(:)       !< Kind of each node.
  integer,      allocatable              :: val1(:)       !< First value of each node.
  integer,      allocatable              :: val2(:)       !< Second value of each node.
  integer,      allocatable              :: val3(:)       !< Third value of each node.
  integer,      allocatable              :: child(:)      !< First child of each node.
  integer,      allocatable              :: sibling(:)    !< Next sibling of each node.
  integer                                :: nranges = 0   !< Number of ranges.
  integer(I4P), allocatable              :: ranges(:,:)   !< Ranges of the classes.
  integer                                :: nclasses = 0  !< Number of classes.
  integer,      allocatable              :: class_first(:)   !< First range of each class.
  integer,      allocatable              :: class_last(:)    !< Last range of each class.
  logical,      allocatable              :: class_negated(:) !< True if the class is negated.
  integer                                :: ngroups = 0   !< Number of capturing groups.
  type(string), allocatable              :: names(:)      !< Names of the groups.
  integer                                :: nregs = 0     !< Number of loop registers.
  integer                                :: npc = 0       !< Size of the program.
  integer,      allocatable              :: op(:)         !< Instructions.
  integer,      allocatable              :: arg1(:)       !< First arguments.
  integer,      allocatable              :: arg2(:)       !< Second arguments.
  integer,      allocatable              :: arg3(:)       !< Third arguments.
  integer                                :: error = 0     !< Position of the first error, 0 if none.
  character(len=:), allocatable          :: message       !< Message of the first error.
endtype parser

contains
  ! public methods of regex
  subroutine compile(self, pattern, flags, iostat, iomsg)
  !< Compile a pattern.
  !<
  !< `flags` holds the letters of the flags: `i` (ASCII case ignored), `m` (multiline: `^` and `$` at the line ends), `s`
  !< (the dot matches LF too); they can also start the pattern, as `(?im)`. On a malformed pattern `iostat` is the byte
  !< position of the error and `iomsg` says what it is, and the regex is left not compiled; without `iostat` the program
  !< stops with that message.
  !<
  !<```fortran
  !< type(regex) :: re
  !< integer     :: iostat
  !< character(len=99) :: iomsg
  !< logical     :: test_passed(6)
  !< call re%compile('(\d+)-(\d+)', iostat=iostat)
  !< test_passed(1) = iostat==0.and.re%group_count()==2
  !< call re%compile('a(b', iostat=iostat, iomsg=iomsg)
  !< test_passed(2) = iostat==4.and.trim(iomsg)=='missing ), unterminated group opened at byte 2'
  !< call re%compile('x{2,1}', iostat=iostat)
  !< test_passed(3) = iostat==2
  !< call re%compile('a{1001}', iostat=iostat, iomsg=iomsg)
  !< test_passed(4) = iostat==2.and.trim(iomsg)=='repeat count above 1000'
  !< call re%compile(repeat('(', 300)//repeat(')', 300), iostat=iostat, iomsg=iomsg)
  !< test_passed(5) = iostat==201.and.trim(iomsg)=='groups nested too deep'
  !< call re%compile('(a{1000}){1000}', iostat=iostat, iomsg=iomsg)
  !< test_passed(6) = iostat==1.and.index(iomsg, 'pattern too large')==1.and..not.re%is_compiled()
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex),     intent(in out)           :: self    !< The regex.
  character(len=*), intent(in)               :: pattern !< The pattern.
  character(len=*), intent(in),     optional :: flags   !< Flags: letters i, m, s.
  integer,          intent(out),    optional :: iostat  !< Byte position of the error, 0 if none.
  character(len=*), intent(inout),  optional :: iomsg   !< Message of the error.
  type(parser)                               :: p       !< Parser.
  integer                                    :: root    !< Root of the tree.
  integer                                    :: i       !< Counter.

  self%compiled = .false.
  p%pattern = pattern
  p%message = ''
  allocate(p%kind(8), p%val1(8), p%val2(8), p%val3(8), p%child(8), p%sibling(8))
  allocate(p%ranges(2, 16), p%class_first(4), p%class_last(4), p%class_negated(4), p%names(4))
  allocate(p%op(16), p%arg1(16), p%arg2(16), p%arg3(16))
  if (present(flags)) then
    do i = 1, len(flags)
      call set_flag(p, flags(i:i), 0)
    enddo
  endif
  call parse_global_flags(p)
  if (p%error == 0) call parse_alternation(p, 0, root)
  if (p%error == 0 .and. p%ip <= len(p%pattern)) call fail(p, p%ip, 'unbalanced )') ! the only way the parser stops early
  if (p%error == 0) then
    call emit(p, OP_SAVE, 0)
    call compile_node(p, root)
    call emit(p, OP_SAVE, 1)
    call emit(p, OP_MATCH)
  endif
  if (present(iostat)) then
    iostat = p%error
    if (present(iomsg) .and. p%error /= 0) iomsg = p%message
  elseif (p%error /= 0) then
    write(error_unit, '(a)') 'stringifor_regex: '//p%message
    error stop 'stringifor_regex: malformed pattern'
  endif
  if (p%error /= 0) return
  self%ngroups = p%ngroups
  self%nregs = p%nregs
  self%op = p%op(1:p%npc)
  self%arg1 = p%arg1(1:p%npc)
  self%arg2 = p%arg2(1:p%npc)
  self%arg3 = p%arg3(1:p%npc)
  self%ranges = p%ranges(:, 1:p%nranges)
  self%class_first = p%class_first(1:p%nclasses)
  self%class_last = p%class_last(1:p%nclasses)
  self%class_negated = p%class_negated(1:p%nclasses)
  if (allocated(self%names)) deallocate(self%names)
  allocate(self%names(p%ngroups))
  do i = 1, p%ngroups
    if (allocated(p%names(i)%raw)) self%names(i)%raw = p%names(i)%raw
  enddo
  self%compiled = .true.
  endsubroutine compile

  elemental function is_compiled(self)
  !< Return true if the regex is compiled.
  class(regex), intent(in) :: self        !< The regex.
  logical                  :: is_compiled !< True if compiled.

  is_compiled = self%compiled
  endfunction is_compiled

  elemental function group_count(self) result(n)
  !< Return the number of capturing groups.
  class(regex), intent(in) :: self !< The regex.
  integer                  :: n    !< Number of capturing groups.

  n = self%ngroups
  endfunction group_count

  elemental function group_index(self, name) result(n)
  !< Return the number of the group named `name`, 0 if there is none.
  class(regex),     intent(in) :: self !< The regex.
  character(len=*), intent(in) :: name !< Name of a group.
  integer                      :: n    !< Number of the group.
  integer                      :: g    !< Counter.

  n = 0
  if (.not.allocated(self%names)) return
  do g = 1, size(self%names)
    if (allocated(self%names(g)%raw)) then
      if (self%names(g)%raw == name .and. len(self%names(g)%raw) == len(name)) then
        n = g
        return
      endif
    endif
  enddo
  endfunction group_index

  pure function search_character(self, subject, start) result(found)
  !< Search the leftmost match in the subject, from the byte `start` (default 1).
  !<
  !< @note As Python `pattern.search(subject, start)`: `^` and `\A` still mean the start of the subject, and `\b` looks at
  !< the byte before `start`.
  !<
  !<```fortran
  !< type(regex)       :: re
  !< type(regex_match) :: m
  !< logical           :: test_passed(4)
  !< call re%compile('(?P<key>\w+)\s*=\s*(?P<value>\w*)')
  !< m = re%search('# x = 1, y=two')
  !< test_passed(1) = m%found.and.all(m%span(0) == [3, 7])
  !< test_passed(2) = m%group('key')=='x'.and.m%group(2)=='1'
  !< m = re%search('# x = 1, y=two', start=8)
  !< test_passed(3) = m%group(0)=='y=two'
  !< m = re%search('nothing here')
  !< test_passed(4) = .not.m%found
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex),     intent(in)           :: self    !< The regex.
  character(len=*), intent(in)           :: subject !< The subject.
  integer,          intent(in), optional :: start   !< First byte of the search, default 1.
  type(regex_match)                      :: found   !< The match.

  found = run(self, subject, start, anchored=.false., full=.false., advance=.false.)
  endfunction search_character

  pure function search_string(self, subject, start) result(found)
  !< Search the leftmost match in the subject, from the byte `start` (default 1); see [[regex:search_character]].
  !<
  !< @note The doctest is not necessary, this being tested by [[regex:search_character]].
  class(regex),  intent(in)           :: self    !< The regex.
  type(string),  intent(in)           :: subject !< The subject.
  integer,       intent(in), optional :: start   !< First byte of the search, default 1.
  type(regex_match)                   :: found   !< The match.

  if (allocated(subject%raw)) then
    found = run(self, subject%raw, start, anchored=.false., full=.false., advance=.false.)
  else
    found = run(self, '', start, anchored=.false., full=.false., advance=.false.)
  endif
  endfunction search_string

  pure function match_character(self, subject, start) result(found)
  !< Match at the byte `start` (default 1) of the subject only.
  !<
  !<```fortran
  !< type(regex)       :: re
  !< type(regex_match) :: m
  !< logical           :: test_passed(2)
  !< call re%compile('\d+')
  !< m = re%match('42 and 7')
  !< test_passed(1) = m%group(0)=='42'
  !< m = re%match('x42')
  !< test_passed(2) = .not.m%found
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex),     intent(in)           :: self    !< The regex.
  character(len=*), intent(in)           :: subject !< The subject.
  integer,          intent(in), optional :: start   !< Byte where the match must start, default 1.
  type(regex_match)                      :: found   !< The match.

  found = run(self, subject, start, anchored=.true., full=.false., advance=.false.)
  endfunction match_character

  pure function match_string(self, subject, start) result(found)
  !< Match at the byte `start` (default 1) of the subject only; see [[regex:match_character]].
  !<
  !< @note The doctest is not necessary, this being tested by [[regex:match_character]].
  class(regex),  intent(in)           :: self    !< The regex.
  type(string),  intent(in)           :: subject !< The subject.
  integer,       intent(in), optional :: start   !< Byte where the match must start, default 1.
  type(regex_match)                   :: found   !< The match.

  if (allocated(subject%raw)) then
    found = run(self, subject%raw, start, anchored=.true., full=.false., advance=.false.)
  else
    found = run(self, '', start, anchored=.true., full=.false., advance=.false.)
  endif
  endfunction match_string

  pure function fullmatch_character(self, subject, start) result(found)
  !< Match the whole subject, from the byte `start` (default 1) to its end.
  !<
  !<```fortran
  !< type(regex)       :: re
  !< type(regex_match) :: m
  !< logical           :: test_passed(3)
  !< call re%compile('a|ab')
  !< m = re%fullmatch('ab')
  !< test_passed(1) = m%group(0)=='ab'
  !< m = re%search('ab')
  !< test_passed(2) = m%group(0)=='a'
  !< call re%compile('caf'//char(92)//'u00e9|tea', flags='i')
  !< m = re%fullmatch('CAF'//char(195)//char(169))
  !< test_passed(3) = m%found
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex),     intent(in)           :: self    !< The regex.
  character(len=*), intent(in)           :: subject !< The subject.
  integer,          intent(in), optional :: start   !< Byte where the match must start, default 1.
  type(regex_match)                      :: found   !< The match.

  found = run(self, subject, start, anchored=.true., full=.true., advance=.false.)
  endfunction fullmatch_character

  pure function fullmatch_string(self, subject, start) result(found)
  !< Match the whole subject, from the byte `start` (default 1); see [[regex:fullmatch_character]].
  !<
  !< @note The doctest is not necessary, this being tested by [[regex:fullmatch_character]].
  class(regex),  intent(in)           :: self    !< The regex.
  type(string),  intent(in)           :: subject !< The subject.
  integer,       intent(in), optional :: start   !< Byte where the match must start, default 1.
  type(regex_match)                   :: found   !< The match.

  if (allocated(subject%raw)) then
    found = run(self, subject%raw, start, anchored=.true., full=.true., advance=.false.)
  else
    found = run(self, '', start, anchored=.true., full=.true., advance=.false.)
  endif
  endfunction fullmatch_string

  ! public methods of regex_match
  pure function span_number(self, group) result(span)
  !< Return the first and the last byte of a group (0: the whole match); [0, -1] if the group did not match.
  !<
  !< @note An empty group at byte p gives [p, p-1], so `subject(span(1):span(2))` is always its text.
  !<
  !<```fortran
  !< type(regex)       :: re
  !< type(regex_match) :: m
  !< logical           :: test_passed(3)
  !< call re%compile('(a)|(b)|(x*)')
  !< m = re%search('b')
  !< test_passed(1) = all(m%span(0) == [1, 1]).and.all(m%span(2) == [1, 1])
  !< test_passed(2) = all(m%span(1) == [0, -1])
  !< m = re%search('c')
  !< test_passed(3) = all(m%span(3) == [1, 0])
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex_match), intent(in) :: self    !< The match.
  integer,            intent(in) :: group   !< Number of the group.
  integer                        :: span(2) !< First and last byte.

  span = [0, -1]
  if (.not.allocated(self%spans)) return
  if (group < 0 .or. group > ubound(self%spans, dim=2)) return
  span = self%spans(:, group)
  endfunction span_number

  pure function span_name(self, group) result(span)
  !< Return the first and the last byte of a named group; [0, -1] if it did not match or there is no such group.
  !<
  !< @note The doctest is not necessary, this being tested by [[regex:search_character]].
  class(regex_match), intent(in) :: self    !< The match.
  character(len=*),   intent(in) :: group   !< Name of the group.
  integer                        :: span(2) !< First and last byte.

  span = self%span_number(name_index(self, group))
  endfunction span_name

  pure function group_number(self, group) result(text)
  !< Return the text of a group (0: the whole match); a not allocated string if the group did not match.
  !<
  !<```fortran
  !< type(regex)       :: re
  !< type(regex_match) :: m
  !< type(string)      :: g
  !< logical           :: test_passed(2)
  !< call re%compile('(\d+)(?:\.(\d+))?')
  !< m = re%search('v12')
  !< test_passed(1) = m%group(1)=='12'
  !< g = m%group(2)
  !< test_passed(2) = .not.g%is_allocated()
  !< print '(L1)', all(test_passed)
  !<```
  !=> T <<<
  class(regex_match), intent(in) :: self  !< The match.
  integer,            intent(in) :: group !< Number of the group.
  type(string)                   :: text  !< Text of the group.

  if (.not.allocated(self%texts)) return
  if (group < 0 .or. group > ubound(self%texts, dim=1)) return
  if (allocated(self%texts(group)%raw)) text%raw = self%texts(group)%raw
  endfunction group_number

  pure function group_name(self, group) result(text)
  !< Return the text of a named group; a not allocated string if it did not match or there is no such group.
  !<
  !< @note The doctest is not necessary, this being tested by [[regex:search_character]].
  class(regex_match), intent(in) :: self  !< The match.
  character(len=*),   intent(in) :: group !< Name of the group.
  type(string)                   :: text  !< Text of the group.

  text = self%group_number(name_index(self, group))
  endfunction group_name

  pure function groups(self) result(texts)
  !< Return the texts of the groups 1..n; a group that did not match is a not allocated string.
  !<
  !<```fortran
  !< type(regex)               :: re
  !< type(regex_match)         :: m
  !< type(string), allocatable :: g(:)
  !< call re%compile('(\w+)@(\w+)\.(\w+)')
  !< m = re%search('mail: ann@example.org')
  !< g = m%groups()
  !< print '(L1)', size(g)==3.and.g(1)=='ann'.and.g(3)=='org'
  !<```
  !=> T <<<
  class(regex_match), intent(in) :: self     !< The match.
  type(string), allocatable      :: texts(:) !< Texts of the groups.

  if (allocated(self%texts)) then
    allocate(texts(ubound(self%texts, dim=1)))
    texts = self%texts(1:)
  else
    allocate(texts(0))
  endif
  endfunction groups

  ! private procedures
  pure function name_index(self, name) result(n)
  !< Return the number of the group named `name` in a match, -1 if there is none.
  type(regex_match), intent(in) :: self !< The match.
  character(len=*),  intent(in) :: name !< Name of a group.
  integer                       :: n    !< Number of the group, -1 if none.
  integer                       :: g    !< Counter.

  n = -1
  if (.not.allocated(self%names)) return
  do g = 1, size(self%names)
    if (allocated(self%names(g)%raw)) then
      if (self%names(g)%raw == name .and. len(self%names(g)%raw) == len(name)) then
        n = g
        return
      endif
    endif
  enddo
  endfunction name_index

  pure function run(self, subject, start, anchored, full, advance) result(found)
  !< Run the Pike VM on the subject from the byte `start`.
  !<
  !< `anchored`: the match must start at `start`; `full`: it must end at the end of the subject; `advance`: an empty match
  !< at `start` is not accepted (the search after an empty match, as Python's finditer, sub and split do).
  type(regex),      intent(in)           :: self     !< The regex.
  character(len=*), intent(in)           :: subject  !< The subject.
  integer,          intent(in), optional :: start    !< First byte of the search, default 1.
  logical,          intent(in)           :: anchored !< The match must start at start.
  logical,          intent(in)           :: full     !< The match must end at the end of the subject.
  logical,          intent(in)           :: advance  !< No empty match at start.
  type(regex_match)                      :: found    !< The match.
  integer                                :: first    !< First byte of the search.
  integer                                :: n        !< Length of the subject.
  integer                                :: m        !< Size of the program.
  integer                                :: nslots   !< Capture slots and loop registers of a thread.
  integer,      allocatable              :: cpc(:)   !< Instructions of the current threads.
  integer,      allocatable              :: npc(:)   !< Instructions of the next threads.
  integer,      allocatable              :: ccap(:,:) !< Slots of the current threads.
  integer,      allocatable              :: ncap(:,:) !< Slots of the next threads.
  integer,      allocatable              :: caps(:)  !< Slots of the thread being added.
  integer,      allocatable              :: best(:)  !< Slots of the match.
  integer,      allocatable              :: mark(:)  !< Generation in which each instruction was added.
  integer,      allocatable              :: stack(:,:) !< Stack of the thread addition: (instruction or -slot, value).
  integer                                :: cn       !< Number of current threads.
  integer                                :: nn       !< Number of next threads.
  integer                                :: cgen     !< Generation of the current list.
  integer                                :: ngen     !< Generation of the next list.
  integer                                :: i        !< Position in the subject.
  integer                                :: len_unit !< Length of the unit at i.
  integer(I4P)                           :: code     !< Code of the unit at i.
  integer                                :: t        !< Thread counter.
  integer                                :: pc       !< Instruction.
  logical                                :: matched  !< True once a match is found.
  logical                                :: ok       !< The thread consumes the unit.
  integer                                :: g        !< Group counter.

  found%found = .false.
  if (.not.self%compiled) return ! a regex not compiled matches nothing
  n = len(subject)
  first = 1 ; if (present(start)) first = max(1, start)
  found%found = .false.
  if (first > n + 1) return
  m = size(self%op)
  nslots = 2 * (self%ngroups + 1) + self%nregs
  allocate(cpc(m), npc(m), ccap(nslots, m), ncap(nslots, m), caps(nslots), best(nslots), mark(m), stack(2, 3 * m + 3))
  mark = 0
  cgen = 1
  ngen = 1
  cn = 0
  matched = .false.
  i = first
  do
    if (.not.matched .and. (.not.anchored .or. i == first)) then
      caps = 0
      call add_thread(self, subject, stack, mark, caps, cpc, ccap, cn, cgen, 1, i)
    endif
    len_unit = 1
    code = -1
    if (i <= n) then
      call utf8_decode(subject, i, code, len_unit)
      if (code < 0) code = BYTE_BASE - code
    endif
    if (cn == 0) then ! no thread alive: stop, or try the next start
      if (matched .or. anchored .or. i > n) exit
      i = i + len_unit
      cgen = cgen + 1 ! a new list: the instructions marked at the previous position are free again
      cycle
    endif
    ngen = cgen + 1
    nn = 0
    do t = 1, cn
      pc = cpc(t)
      ok = .false.
      select case (self%op(pc))
      case (OP_MATCH)
        if (full .and. i /= n + 1) cycle
        if (advance .and. i == first .and. ccap(1, t) == first) cycle ! an empty match where the search starts
        matched = .true.
        best = ccap(:, t)
        exit ! the threads after this one have a lower priority
      case (OP_CHAR)
        ok = i <= n .and. code == self%arg1(pc)
      case (OP_CHARI)
        ok = i <= n .and. fold(code) == self%arg1(pc)
      case (OP_ANY)
        ok = i <= n .and. code /= 10
      case (OP_ANYNL)
        ok = i <= n
      case (OP_CLASS)
        ok = i <= n
        if (ok) ok = in_class(self, self%arg1(pc), code)
      endselect
      if (ok) then
        caps = ccap(:, t)
        call add_thread(self, subject, stack, mark, caps, npc, ncap, nn, ngen, pc + 1, i + len_unit)
      endif
    enddo
    if (i > n) exit
    cpc(1:nn) = npc(1:nn)
    ccap(:, 1:nn) = ncap(:, 1:nn)
    cn = nn
    cgen = ngen
    i = i + len_unit
  enddo
  if (.not.matched) return
  found%found = .true.
  allocate(found%spans(2, 0:self%ngroups), found%texts(0:self%ngroups))
  do g = 0, self%ngroups
    if (best(2 * g + 1) > 0 .and. best(2 * g + 2) > 0) then
      found%spans(:, g) = [best(2 * g + 1), best(2 * g + 2) - 1]
      found%texts(g)%raw = subject(best(2 * g + 1):best(2 * g + 2) - 1)
    else
      found%spans(:, g) = [0, -1]
    endif
  enddo
  found%names = self%names
  endfunction run

  pure subroutine add_thread(self, subject, stack, mark, caps, list_pc, list_cap, count, gen, pc0, pos)
  !< Add to a list the threads reached from the instruction pc0 at the position pos, in priority order.
  !<
  !< The epsilon closure is followed with an explicit stack, so a long program never overflows the call stack. A
  !< negative entry restores a slot when the branch that set it is done.
  type(regex),      intent(in)    :: self       !< The regex.
  character(len=*), intent(in)    :: subject    !< The subject.
  integer,          intent(inout) :: stack(:,:) !< Stack: (instruction or -slot, value).
  integer,          intent(inout) :: mark(:)    !< Generation in which each instruction was added.
  integer,          intent(inout) :: caps(:)    !< Slots of the thread being added, restored on exit.
  integer,          intent(inout) :: list_pc(:)    !< Instructions of the list.
  integer,          intent(inout) :: list_cap(:,:) !< Slots of the list.
  integer,          intent(inout) :: count      !< Threads in the list.
  integer,          intent(in)    :: gen        !< Generation of the list.
  integer,          intent(in)    :: pc0        !< First instruction.
  integer,          intent(in)    :: pos        !< Position.
  integer                         :: sp         !< Stack pointer.
  integer                         :: q          !< Instruction.

  sp = 1
  stack(:, 1) = [pc0, 0]
  do while (sp > 0)
    q = stack(1, sp)
    if (q < 0) then ! restore a slot
      caps(-q) = stack(2, sp)
      sp = sp - 1
      cycle
    endif
    sp = sp - 1
    if (mark(q) == gen) cycle
    mark(q) = gen
    select case (self%op(q))
    case (OP_JMP)
      sp = sp + 1 ; stack(:, sp) = [self%arg1(q), 0]
    case (OP_SPLIT)
      sp = sp + 1 ; stack(:, sp) = [self%arg2(q), 0]
      sp = sp + 1 ; stack(:, sp) = [self%arg1(q), 0]
    case (OP_SAVE, OP_MARK)
      sp = sp + 1 ; stack(:, sp) = [-(self%arg1(q) + 1), caps(self%arg1(q) + 1)]
      caps(self%arg1(q) + 1) = pos
      sp = sp + 1 ; stack(:, sp) = [q + 1, 0]
    case (OP_CHECK)
      if (caps(self%arg1(q) + 1) == pos) then
        sp = sp + 1 ; stack(:, sp) = [self%arg2(q), 0]
      else
        sp = sp + 1 ; stack(:, sp) = [self%arg3(q), 0]
      endif
    case (OP_ASSERT)
      if (assertion(self%arg1(q), subject, pos)) then
        sp = sp + 1 ; stack(:, sp) = [q + 1, 0]
      endif
    case default ! an instruction that consumes a unit, or a match
      count = count + 1
      list_pc(count) = q
      list_cap(:, count) = caps
    endselect
  enddo
  endsubroutine add_thread

  pure function assertion(kind, subject, pos) result(holds)
  !< Return true if the assertion holds at the position pos of the subject.
  integer,          intent(in) :: kind    !< Kind of assertion.
  character(len=*), intent(in) :: subject !< The subject.
  integer,          intent(in) :: pos     !< Position, 1 to len(subject) + 1.
  logical                      :: holds   !< True if the assertion holds.
  integer                      :: n       !< Length of the subject.

  n = len(subject)
  select case (kind)
  case (AS_BOT)
    holds = pos == 1
  case (AS_EOT)
    holds = pos == n + 1
  case (AS_MBOL)
    holds = pos == 1
    if (.not.holds) holds = subject(pos-1:pos-1) == achar(10)
  case (AS_EOL)
    holds = pos == n + 1
    if (.not.holds .and. pos == n) holds = subject(n:n) == achar(10)
  case (AS_MEOL)
    holds = pos == n + 1
    if (.not.holds) holds = subject(pos:pos) == achar(10)
  case (AS_WORDB, AS_NWORDB) ! neither holds in an empty subject, as in Python
    holds = is_word(subject, pos - 1) .neqv. is_word(subject, pos)
    if (kind == AS_NWORDB) holds = .not.holds .and. n > 0
  case default
    holds = .false.
  endselect
  endfunction assertion

  pure function is_word(subject, pos) result(word)
  !< Return true if the byte at pos is an ASCII word character, letter, digit or underscore (false outside).
  character(len=*), intent(in) :: subject !< The subject.
  integer,          intent(in) :: pos     !< Position.
  logical                      :: word    !< True if a word character.

  word = .false.
  if (pos < 1 .or. pos > len(subject)) return
  select case (subject(pos:pos))
  case ('a':'z', 'A':'Z', '0':'9', '_')
    word = .true.
  endselect
  endfunction is_word

  elemental function fold(code) result(folded)
  !< Return the code with the ASCII uppercase letters lowercased.
  integer(I4P), intent(in) :: code   !< Code of a unit.
  integer(I4P)             :: folded !< Folded code.

  folded = code
  if (code >= 65 .and. code <= 90) folded = code + 32
  endfunction fold

  pure function in_class(self, k, code) result(inside)
  !< Return true if the code belongs to the class k.
  type(regex),  intent(in) :: self   !< The regex.
  integer,      intent(in) :: k      !< Class.
  integer(I4P), intent(in) :: code   !< Code of a unit.
  logical                  :: inside !< True if inside.
  integer                  :: r      !< Range counter.

  inside = .false.
  do r = self%class_first(k), self%class_last(k)
    if (code >= self%ranges(1, r) .and. code <= self%ranges(2, r)) then
      inside = .true.
      exit
    endif
  enddo
  if (self%class_negated(k)) inside = .not.inside
  endfunction in_class

  ! parser
  pure subroutine fail(p, pos, message)
  !< Record the first error.
  type(parser),     intent(inout) :: p       !< Parser.
  integer,          intent(in)    :: pos     !< Byte position of the error.
  character(len=*), intent(in)    :: message !< What is wrong.

  if (p%error /= 0) return
  p%error = max(1, pos)
  p%message = message
  endsubroutine fail

  pure subroutine set_flag(p, letter, pos)
  !< Set a flag from its letter.
  type(parser),     intent(inout) :: p      !< Parser.
  character(len=1), intent(in)    :: letter !< Letter of the flag.
  integer,          intent(in)    :: pos    !< Position of the letter in the pattern, 0 if in the flags argument.

  select case (letter)
  case ('i')
    p%nocase = .true.
  case ('m')
    p%multiline = .true.
  case ('s')
    p%dotall = .true.
  case ('a') ! ASCII classes and case: always the case
  case default
    call fail(p, pos, 'unknown flag '//letter)
  endselect
  endsubroutine set_flag

  pure subroutine parse_global_flags(p)
  !< Parse the flags `(?ims)` at the start of the pattern.
  type(parser), intent(inout) :: p !< Parser.
  integer                     :: j !< Position.

  if (len(p%pattern) < 3) return
  if (p%pattern(1:2) /= '(?') return
  j = 3
  do while (j <= len(p%pattern))
    if (index('imsa', p%pattern(j:j)) == 0) exit
    j = j + 1
  enddo
  if (j == 3 .or. j > len(p%pattern)) return ! not a flag group: parsed (and rejected if need be) as a group
  if (p%pattern(j:j) /= ')') return
  do j = 3, j - 1
    call set_flag(p, p%pattern(j:j), j)
  enddo
  p%ip = j + 1
  endsubroutine parse_global_flags

  pure subroutine new_node(p, node, kind, val1, val2, val3)
  !< Add a node to the tree.
  type(parser), intent(inout)        :: p    !< Parser.
  integer,      intent(out)          :: node !< The node.
  integer,      intent(in)           :: kind !< Kind of node.
  integer,      intent(in), optional :: val1 !< First value.
  integer,      intent(in), optional :: val2 !< Second value.
  integer,      intent(in), optional :: val3 !< Third value.

  if (p%nnodes == size(p%kind)) then
    p%kind = [p%kind, p%kind]
    p%val1 = [p%val1, p%val1]
    p%val2 = [p%val2, p%val2]
    p%val3 = [p%val3, p%val3]
    p%child = [p%child, p%child]
    p%sibling = [p%sibling, p%sibling]
  endif
  p%nnodes = p%nnodes + 1
  node = p%nnodes
  p%kind(node) = kind
  p%val1(node) = 0 ; if (present(val1)) p%val1(node) = val1
  p%val2(node) = 0 ; if (present(val2)) p%val2(node) = val2
  p%val3(node) = 0 ; if (present(val3)) p%val3(node) = val3
  p%child(node) = 0
  p%sibling(node) = 0
  endsubroutine new_node

  pure subroutine add_child(p, parent, last, node)
  !< Append a child to a node; last is its last child so far (0 if none), updated.
  type(parser), intent(inout) :: p      !< Parser.
  integer,      intent(in)    :: parent !< Parent node.
  integer,      intent(inout) :: last   !< Last child.
  integer,      intent(in)    :: node   !< New child.

  if (last == 0) then
    p%child(parent) = node
  else
    p%sibling(last) = node
  endif
  last = node
  endsubroutine add_child

  pure recursive subroutine parse_alternation(p, depth, node)
  !< Parse `concatenation ( '|' concatenation )*`.
  type(parser), intent(inout) :: p     !< Parser.
  integer,      intent(in)    :: depth !< Nesting depth of the groups.
  integer,      intent(out)   :: node  !< The node.
  integer                     :: item  !< A concatenation.
  integer                     :: last  !< Last child.

  call parse_concatenation(p, depth, item)
  if (p%error /= 0) return
  if (p%ip > len(p%pattern)) then
    node = item
    return
  endif
  if (p%pattern(p%ip:p%ip) /= '|') then
    node = item
    return
  endif
  call new_node(p, node, N_ALT)
  last = 0
  call add_child(p, node, last, item)
  do while (p%ip <= len(p%pattern))
    if (p%pattern(p%ip:p%ip) /= '|') exit
    p%ip = p%ip + 1
    call parse_concatenation(p, depth, item)
    if (p%error /= 0) return
    call add_child(p, node, last, item)
  enddo
  endsubroutine parse_alternation

  pure recursive subroutine parse_concatenation(p, depth, node)
  !< Parse a sequence of repeated atoms, up to `|`, `)` or the end.
  type(parser), intent(inout) :: p     !< Parser.
  integer,      intent(in)    :: depth !< Nesting depth of the groups.
  integer,      intent(out)   :: node  !< The node.
  integer                     :: item  !< A repeated atom.
  integer                     :: last  !< Last child.

  call new_node(p, node, N_CAT)
  last = 0
  do while (p%ip <= len(p%pattern))
    if (p%pattern(p%ip:p%ip) == '|' .or. p%pattern(p%ip:p%ip) == ')') exit
    call parse_repeat(p, depth, item)
    if (p%error /= 0) return
    call add_child(p, node, last, item)
  enddo
  if (last == 0) p%kind(node) = N_EMPTY
  endsubroutine parse_concatenation

  pure recursive subroutine parse_repeat(p, depth, node)
  !< Parse an atom and its quantifier, if any: `*`, `+`, `?`, `{m}`, `{m,}`, `{,n}`, `{m,n}`, each followed by an
  !< optional `?` (lazy).
  type(parser), intent(inout) :: p      !< Parser.
  integer,      intent(in)    :: depth  !< Nesting depth of the groups.
  integer,      intent(out)   :: node   !< The node.
  integer                     :: atom   !< The atom.
  integer                     :: lo     !< Minimum count.
  integer                     :: hi     !< Maximum count, -1 if none.
  integer                     :: start  !< Position of the quantifier.
  integer                     :: after  !< Position after the quantifier.
  logical                     :: is_quantifier !< A quantifier follows.

  start = p%ip
  call quantifier(p, p%ip, is_quantifier, lo, hi, after)
  if (is_quantifier) then
    call fail(p, p%ip, 'nothing to repeat')
    node = 0
    return
  endif
  call parse_atom(p, depth, atom)
  node = atom
  if (p%error /= 0) return
  start = p%ip
  call quantifier(p, p%ip, is_quantifier, lo, hi, after)
  if (.not.is_quantifier) return
  if (p%kind(atom) == N_ASSERT .or. p%kind(atom) == N_EMPTY) then
    call fail(p, start, 'nothing to repeat')
    return
  endif
  if (hi >= 0 .and. lo > hi) then
    call fail(p, start, 'min repeat greater than max repeat')
    return
  endif
  if (lo > MAX_REPEAT .or. hi > MAX_REPEAT) then
    call fail(p, start, 'repeat count above 1000')
    return
  endif
  p%ip = after
  call new_node(p, node, N_REPEAT, lo, hi, 1)
  p%child(node) = atom
  if (p%ip <= len(p%pattern)) then
    if (p%pattern(p%ip:p%ip) == '?') then
      p%val3(node) = 0
      p%ip = p%ip + 1
    endif
  endif
  call quantifier(p, p%ip, is_quantifier, lo, hi, after)
  if (is_quantifier) call fail(p, p%ip, 'multiple repeat')
  endsubroutine parse_repeat

  pure subroutine quantifier(p, pos, is_quantifier, lo, hi, after)
  !< Read the quantifier at pos, if any. A `{` that does not start `{m}`, `{m,}`, `{,n}`, `{m,n}` or `{,}` is a literal.
  type(parser), intent(in)  :: p             !< Parser.
  integer,      intent(in)  :: pos           !< Position.
  logical,      intent(out) :: is_quantifier !< True if a quantifier is there.
  integer,      intent(out) :: lo            !< Minimum count.
  integer,      intent(out) :: hi            !< Maximum count, -1 if none.
  integer,      intent(out) :: after         !< Position after the quantifier.
  integer                   :: j             !< Position.
  logical                   :: has_lo        !< Digits before the comma.
  logical                   :: has_hi        !< Digits after the comma.

  is_quantifier = .false.
  lo = 0
  hi = -1
  after = pos
  if (pos > len(p%pattern)) return
  select case (p%pattern(pos:pos))
  case ('*')
    is_quantifier = .true.
  case ('+')
    is_quantifier = .true.
    lo = 1
  case ('?')
    is_quantifier = .true.
    hi = 1
  case ('{')
    j = pos + 1
    call read_count(p%pattern, j, lo, has_lo)
    if (j > len(p%pattern)) return
    if (p%pattern(j:j) == ',') then
      j = j + 1
      call read_count(p%pattern, j, hi, has_hi)
      if (.not.has_hi) hi = -1
    else
      if (.not.has_lo) return ! '{}' or '{x': a literal
      hi = lo
    endif
    if (j > len(p%pattern)) return
    if (p%pattern(j:j) /= '}') return
    if (.not.has_lo) lo = 0
    is_quantifier = .true.
    after = j + 1
    return
  case default
    return
  endselect
  after = pos + 1
  endsubroutine quantifier

  pure subroutine read_count(text, j, value, has_digits)
  !< Read decimal digits at j, saturated above MAX_REPEAT + 1; j moves after them.
  character(len=*), intent(in)    :: text       !< Text.
  integer,          intent(inout) :: j          !< Position.
  integer,          intent(out)   :: value      !< Value.
  logical,          intent(out)   :: has_digits !< True if there was at least one digit.

  value = 0
  has_digits = .false.
  do while (j <= len(text))
    if (text(j:j) < '0' .or. text(j:j) > '9') exit
    has_digits = .true.
    value = min(MAX_REPEAT + 1, value * 10 + (ichar(text(j:j)) - ichar('0')))
    j = j + 1
  enddo
  endsubroutine read_count

  pure recursive subroutine parse_atom(p, depth, node)
  !< Parse an atom: a group, a class, the dot, an anchor, an escape or a unit.
  type(parser), intent(inout) :: p     !< Parser.
  integer,      intent(in)    :: depth !< Nesting depth of the groups.
  integer,      intent(out)   :: node  !< The node.
  character(len=1)            :: c     !< Current byte.
  integer                     :: open  !< Position of the group opening.
  integer                     :: group !< Number of a capturing group, 0 if not capturing.
  integer                     :: inner !< Content of a group.
  integer                     :: close !< End of a group name.
  integer(I4P)                :: code  !< Code of a unit.
  integer                     :: n     !< Length of a unit.

  node = 0
  c = p%pattern(p%ip:p%ip)
  select case (c)
  case ('(')
    open = p%ip
    if (depth >= MAX_DEPTH) then
      call fail(p, open, 'groups nested too deep')
      return
    endif
    group = -1
    p%ip = p%ip + 1
    if (p%ip <= len(p%pattern)) then
      if (p%pattern(p%ip:p%ip) == '?') then
        if (p%ip + 1 <= len(p%pattern)) then
          if (p%pattern(p%ip+1:p%ip+1) == ':') then
            group = 0
            p%ip = p%ip + 2
          elseif (p%pattern(p%ip+1:min(p%ip+2, len(p%pattern))) == 'P<') then
            close = index(p%pattern(p%ip+3:), '>')
            if (close == 0) then
              call fail(p, p%ip + 3, 'missing >, unterminated name')
              return
            endif
            close = p%ip + 2 + close
            if (.not.is_identifier(p%pattern(p%ip+3:close-1))) then
              call fail(p, p%ip + 3, 'bad character in group name')
              return
            endif
            call new_group(p, p%pattern(p%ip+3:close-1), p%ip + 3, group)
            p%ip = close + 1
          endif
        endif
        if (group < 0 .and. p%error == 0) then
          call fail(p, p%ip, 'unsupported group: only (?:...), (?P<name>...) and leading flags (?ims)')
          return
        endif
      endif
    endif
    if (p%error /= 0) return
    if (group < 0) call new_group(p, '', open, group)
    if (p%error /= 0) return
    call parse_alternation(p, depth + 1, inner)
    if (p%error /= 0) return
    if (p%ip > len(p%pattern)) then
      call fail(p, len(p%pattern) + 1, 'missing ), unterminated group opened at byte '//itoa(open))
      return
    endif
    p%ip = p%ip + 1 ! the ')'
    call new_node(p, node, N_GROUP, group)
    p%child(node) = inner
  case ('[')
    call parse_class(p, node)
  case ('.')
    call new_node(p, node, N_ANY)
    p%ip = p%ip + 1
  case ('^')
    call new_node(p, node, N_ASSERT, merge(AS_MBOL, AS_BOT, p%multiline))
    p%ip = p%ip + 1
  case ('$')
    call new_node(p, node, N_ASSERT, merge(AS_MEOL, AS_EOL, p%multiline))
    p%ip = p%ip + 1
  case (BACKSLASH)
    call parse_escape(p, node)
  case default
    call utf8_decode(p%pattern, p%ip, code, n)
    if (code < 0) code = BYTE_BASE - code
    call new_node(p, node, N_LIT, int(code))
    p%ip = p%ip + n
  endselect
  endsubroutine parse_atom

  pure subroutine new_group(p, name, pos, group)
  !< Number a new capturing group.
  type(parser),     intent(inout) :: p     !< Parser.
  character(len=*), intent(in)    :: name  !< Name, empty if unnamed.
  integer,          intent(in)    :: pos   !< Position, for the errors.
  integer,          intent(out)   :: group !< Number of the group.
  integer                         :: g     !< Counter.

  group = 0
  if (p%ngroups >= MAX_GROUPS) then
    call fail(p, pos, 'more than 1000 groups')
    return
  endif
  if (len(name) > 0) then
    do g = 1, p%ngroups
      if (allocated(p%names(g)%raw)) then
        if (p%names(g)%raw == name .and. len(p%names(g)%raw) == len(name)) then
          call fail(p, pos, 'redefinition of group name '//name)
          return
        endif
      endif
    enddo
  endif
  if (p%ngroups == size(p%names)) call grow_names(p)
  p%ngroups = p%ngroups + 1
  group = p%ngroups
  if (len(name) > 0) p%names(group)%raw = name
  endsubroutine new_group

  pure subroutine grow_names(p)
  !< Double the room for the names of the groups; the new ones are not allocated (unnamed).
  type(parser), intent(inout) :: p     !< Parser.
  type(string), allocatable   :: grown(:) !< Names, grown.
  integer                     :: g     !< Counter.

  allocate(grown(2 * size(p%names)))
  do g = 1, size(p%names)
    if (allocated(p%names(g)%raw)) grown(g)%raw = p%names(g)%raw
  enddo
  call move_alloc(from=grown, to=p%names)
  endsubroutine grow_names

  pure function is_identifier(name) result(ok)
  !< Return true if the name is an ASCII identifier: a letter or underscore, then letters, digits, underscores.
  character(len=*), intent(in) :: name !< Name.
  logical                      :: ok   !< True if an identifier.
  integer                      :: j    !< Counter.

  ok = len(name) > 0
  do j = 1, len(name)
    select case (name(j:j))
    case ('a':'z', 'A':'Z', '_')
    case ('0':'9')
      if (j == 1) ok = .false.
    case default
      ok = .false.
    endselect
  enddo
  endfunction is_identifier

  pure subroutine parse_escape(p, node)
  !< Parse an escape outside a class.
  type(parser), intent(inout) :: p     !< Parser.
  integer,      intent(out)   :: node  !< The node.
  integer(I4P)                :: code  !< Code of a unit.
  integer                     :: set   !< Class of a class escape, 0 if not one.
  logical                     :: neg   !< The class escape is negated.
  integer                     :: start !< Position of the backslash.

  node = 0
  start = p%ip
  if (p%ip == len(p%pattern)) then
    call fail(p, start, 'bad escape (end of pattern)')
    return
  endif
  select case (p%pattern(p%ip+1:p%ip+1))
  case ('b')
    call new_node(p, node, N_ASSERT, AS_WORDB)
    p%ip = p%ip + 2
  case ('B')
    call new_node(p, node, N_ASSERT, AS_NWORDB)
    p%ip = p%ip + 2
  case ('A')
    call new_node(p, node, N_ASSERT, AS_BOT)
    p%ip = p%ip + 2
  case ('z', 'Z')
    call new_node(p, node, N_ASSERT, AS_EOT)
    p%ip = p%ip + 2
  case ('d', 'D', 'w', 'W', 's', 'S')
    call new_class(p, set)
    call add_escape_class(p, p%pattern(p%ip+1:p%ip+1), neg)
    p%class_negated(set) = neg
    call close_class(p, set)
    call new_node(p, node, N_CLASS, set)
    p%ip = p%ip + 2
  case default
    call escape_code(p, code)
    if (p%error /= 0) return
    call new_node(p, node, N_LIT, int(code))
  endselect
  endsubroutine parse_escape

  pure subroutine escape_code(p, code)
  !< Parse the escape of a single unit at p%ip (the backslash) and move after it.
  type(parser), intent(inout) :: p     !< Parser.
  integer(I4P), intent(out)   :: code  !< Code of the unit.
  integer                     :: start !< Position of the backslash.
  integer                     :: n     !< Length of a unit.
  integer                     :: digits !< Number of hexadecimal digits.

  start = p%ip
  code = 0
  if (p%ip == len(p%pattern)) then
    call fail(p, start, 'bad escape (end of pattern)')
    return
  endif
  digits = 0
  select case (p%pattern(p%ip+1:p%ip+1))
  case ('t')
    code = 9
  case ('n')
    code = 10
  case ('r')
    code = 13
  case ('f')
    code = 12
  case ('v')
    code = 11
  case ('a')
    code = 7
  case ('x')
    digits = 2
  case ('u')
    digits = 4
  case ('U')
    digits = 8
  case ('0':'9')
    call fail(p, start, 'backreferences and octal escapes are not supported')
    return
  case default ! an unknown ASCII letter is an error, any other unit stands for itself
    if (verify(p%pattern(p%ip+1:p%ip+1), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') == 0) then
      call fail(p, start, 'bad escape '//BACKSLASH//p%pattern(p%ip+1:p%ip+1))
      return
    endif
    call utf8_decode(p%pattern, p%ip + 1, code, n)
    if (code < 0) code = BYTE_BASE - code
    p%ip = p%ip + 1 + n
    return
  endselect
  if (digits == 0) then
    p%ip = p%ip + 2
    return
  endif
  code = hex_value(p%pattern, p%ip + 2, digits)
  if (code < 0) then
    call fail(p, start, 'incomplete escape '//BACKSLASH//p%pattern(p%ip+1:p%ip+1))
    return
  endif
  if (digits == 2 .and. code >= 128) then
    code = BYTE_BASE + code ! \xHH above 7F is the byte HH, an ill-formed unit
  elseif (digits > 2 .and. ((code >= 55296 .and. code <= 57343) .or. code > MAX_CODE)) then
    call fail(p, start, 'bad escape: a surrogate or a value above U+10FFFF')
    return
  endif
  p%ip = p%ip + 2 + digits
  endsubroutine escape_code

  pure function hex_value(text, first, digits) result(value)
  !< Return the value of exactly `digits` hexadecimal digits at first, -1 if they are not there.
  character(len=*), intent(in) :: text   !< Text.
  integer,          intent(in) :: first  !< Position of the first digit.
  integer,          intent(in) :: digits !< Number of digits.
  integer(I4P)                 :: value  !< Value.
  integer                      :: j      !< Counter.
  integer                      :: h      !< Digit value.

  value = -1
  if (first + digits - 1 > len(text)) return
  value = 0
  do j = first, first + digits - 1
    h = index('0123456789abcdef', text(j:j)) - 1
    if (h < 0) h = index('0123456789ABCDEF', text(j:j)) - 1
    if (h < 0) then
      value = -1
      return
    endif
    if (value > 134217727) then
      value = huge(value)
    else
      value = value * 16 + h
    endif
  enddo
  endfunction hex_value

  pure subroutine new_class(p, k)
  !< Open a new class.
  type(parser), intent(inout) :: p !< Parser.
  integer,      intent(out)   :: k !< The class.

  if (p%nclasses == size(p%class_first)) then
    p%class_first = [p%class_first, p%class_first]
    p%class_last = [p%class_last, p%class_last]
    p%class_negated = [p%class_negated, p%class_negated]
  endif
  p%nclasses = p%nclasses + 1
  k = p%nclasses
  p%class_first(k) = p%nranges + 1
  p%class_last(k) = p%nranges
  p%class_negated(k) = .false.
  endsubroutine new_class

  pure subroutine add_range(p, first, last)
  !< Add a range of codes to the class being built.
  type(parser), intent(inout) :: p     !< Parser.
  integer(I4P), intent(in)    :: first !< First code.
  integer(I4P), intent(in)    :: last  !< Last code.
  integer(I4P), allocatable   :: grown(:,:) !< Ranges, grown.

  if (p%nranges == size(p%ranges, dim=2)) then
    allocate(grown(2, 2 * size(p%ranges, dim=2)))
    grown(:, 1:p%nranges) = p%ranges(:, 1:p%nranges)
    call move_alloc(from=grown, to=p%ranges)
  endif
  p%nranges = p%nranges + 1
  p%ranges(:, p%nranges) = [first, last]
  p%class_last(p%nclasses) = p%nranges
  endsubroutine add_range

  pure subroutine add_escape_class(p, letter, negated)
  !< Add the ranges of `\d`, `\w`, `\s` to the class being built; for `\D`, `\W`, `\S` the complement if negated is not
  !< wanted by the caller (inside brackets), else the plain ranges with negated true.
  type(parser),     intent(inout) :: p       !< Parser.
  character(len=1), intent(in)    :: letter  !< d, D, w, W, s, S.
  logical,          intent(out)   :: negated !< True for D, W, S.

  negated = letter == 'D' .or. letter == 'W' .or. letter == 'S'
  select case (letter)
  case ('d', 'D')
    call add_range(p, 48_I4P, 57_I4P)
  case ('w', 'W')
    call add_range(p, 48_I4P, 57_I4P)
    call add_range(p, 65_I4P, 90_I4P)
    call add_range(p, 95_I4P, 95_I4P)
    call add_range(p, 97_I4P, 122_I4P)
  case ('s', 'S')
    call add_range(p, 9_I4P, 13_I4P)
    call add_range(p, 32_I4P, 32_I4P)
  endselect
  endsubroutine add_escape_class

  pure subroutine add_complement(p, first)
  !< Replace the ranges of the class from the range `first` on (sorted, disjoint) with their complement in [0, MAX_CODE].
  type(parser), intent(inout) :: p     !< Parser.
  integer,      intent(in)    :: first !< First range to complement.
  integer(I4P), allocatable   :: old(:,:) !< The ranges to complement.
  integer(I4P)                :: next  !< First code not yet covered.
  integer                     :: r     !< Counter.

  old = p%ranges(:, first:p%nranges)
  p%nranges = first - 1
  p%class_last(p%nclasses) = p%nranges
  next = 0
  do r = 1, size(old, dim=2)
    if (old(1, r) > next) call add_range(p, next, old(1, r) - 1)
    next = old(2, r) + 1
  enddo
  if (next <= MAX_CODE) call add_range(p, next, int(MAX_CODE, I4P))
  endsubroutine add_complement

  pure subroutine close_class(p, k)
  !< Finish the class k: with flag i, add the other case of the ASCII letters it holds.
  type(parser), intent(inout) :: p !< Parser.
  integer,      intent(in)    :: k !< The class.
  integer                     :: r !< Counter.
  integer                     :: last !< Last range before the additions.
  integer(I4P)                :: lo !< First code of an overlap.
  integer(I4P)                :: hi !< Last code of an overlap.

  if (.not.p%nocase) return
  last = p%class_last(k)
  do r = p%class_first(k), last
    lo = max(p%ranges(1, r), 65_I4P)
    hi = min(p%ranges(2, r), 90_I4P)
    if (lo <= hi) call add_range(p, lo + 32, hi + 32)
    lo = max(p%ranges(1, r), 97_I4P)
    hi = min(p%ranges(2, r), 122_I4P)
    if (lo <= hi) call add_range(p, lo - 32, hi - 32)
  enddo
  endsubroutine close_class

  pure subroutine parse_class(p, node)
  !< Parse a class `[...]`: `^` negates it, a `]` first is a literal, a `-` first or last is a literal, ranges `a-z`,
  !< escapes as outside plus `\b` (backspace), and the class escapes `\d \w \s \D \W \S`.
  type(parser), intent(inout) :: p      !< Parser.
  integer,      intent(out)   :: node   !< The node.
  integer                     :: k      !< The class.
  integer                     :: open   !< Position of the `[`.
  integer(I4P)                :: lo     !< First code of an item.
  integer(I4P)                :: hi     !< Last code of a range.
  logical                     :: is_set !< The item is a class escape.
  logical                     :: hi_set !< The end of a range is a class escape.
  logical                     :: first_item !< The next item is the first one.
  integer                     :: item_start !< Position of an item.

  node = 0
  open = p%ip
  p%ip = p%ip + 1
  call new_class(p, k)
  if (p%ip <= len(p%pattern)) then
    if (p%pattern(p%ip:p%ip) == '^') then
      p%class_negated(k) = .true.
      p%ip = p%ip + 1
    endif
  endif
  first_item = .true.
  do
    if (p%ip > len(p%pattern)) then
      call fail(p, open, 'unterminated character set')
      return
    endif
    if (p%pattern(p%ip:p%ip) == ']' .and. .not.first_item) exit
    first_item = .false.
    item_start = p%ip
    call class_item(p, lo, is_set)
    if (p%error /= 0) return
    if (is_set) cycle
    hi = lo
    if (p%ip + 1 <= len(p%pattern)) then
      if (p%pattern(p%ip:p%ip) == '-' .and. p%pattern(p%ip+1:p%ip+1) /= ']') then
        p%ip = p%ip + 1
        call class_item(p, hi, hi_set)
        if (p%error /= 0) return
        if (hi_set .or. hi < lo) then
          call fail(p, item_start, 'bad character range')
          return
        endif
      endif
    endif
    call add_range(p, lo, hi)
  enddo
  p%ip = p%ip + 1 ! the ']'
  call sort_ranges(p, k)
  call close_class(p, k)
  call new_node(p, node, N_CLASS, k)
  endsubroutine parse_class

  pure subroutine class_item(p, code, is_set)
  !< Parse an item of a class: a unit, an escape or a class escape (whose ranges are added at once).
  type(parser), intent(inout) :: p      !< Parser.
  integer(I4P), intent(out)   :: code   !< Code of the unit.
  logical,      intent(out)   :: is_set !< The item was a class escape.
  integer                     :: n      !< Length of a unit.
  integer                     :: first  !< First range of a negated class escape.
  logical                     :: neg    !< The class escape is negated.

  is_set = .false.
  code = 0
  if (p%pattern(p%ip:p%ip) /= BACKSLASH) then
    call utf8_decode(p%pattern, p%ip, code, n)
    if (code < 0) code = BYTE_BASE - code
    p%ip = p%ip + n
    return
  endif
  if (p%ip == len(p%pattern)) then
    call fail(p, p%ip, 'bad escape (end of pattern)')
    return
  endif
  select case (p%pattern(p%ip+1:p%ip+1))
  case ('d', 'D', 'w', 'W', 's', 'S')
    is_set = .true.
    first = p%nranges + 1
    call add_escape_class(p, p%pattern(p%ip+1:p%ip+1), neg)
    if (neg) call add_complement(p, first)
    p%ip = p%ip + 2
  case ('b')
    code = 8
    p%ip = p%ip + 2
  case ('A', 'B', 'z', 'Z')
    call fail(p, p%ip, 'bad escape '//BACKSLASH//p%pattern(p%ip+1:p%ip+1)//' in a character set')
  case default
    call escape_code(p, code)
  endselect
  endsubroutine class_item

  pure subroutine sort_ranges(p, k)
  !< Sort the ranges of the class k by their first code (insertion sort: classes are small).
  type(parser), intent(inout) :: p   !< Parser.
  integer,      intent(in)    :: k   !< The class.
  integer(I4P)                :: r(2) !< A range.
  integer                     :: i   !< Counter.
  integer                     :: j   !< Counter.

  do i = p%class_first(k) + 1, p%class_last(k)
    r = p%ranges(:, i)
    j = i - 1
    do while (j >= p%class_first(k))
      if (p%ranges(1, j) <= r(1)) exit
      p%ranges(:, j+1) = p%ranges(:, j)
      j = j - 1
    enddo
    p%ranges(:, j+1) = r
  enddo
  endsubroutine sort_ranges

  ! compiler
  pure subroutine emit(p, op, a1, a2, a3)
  !< Append an instruction to the program.
  type(parser), intent(inout)        :: p  !< Parser.
  integer,      intent(in)           :: op !< Instruction.
  integer,      intent(in), optional :: a1 !< First argument.
  integer,      intent(in), optional :: a2 !< Second argument.
  integer,      intent(in), optional :: a3 !< Third argument.

  if (p%error /= 0) return
  if (p%npc >= MAX_PROGRAM) then
    call fail(p, 1, 'pattern too large: more than 100000 instructions')
    return
  endif
  if (p%npc == size(p%op)) then
    p%op = [p%op, p%op]
    p%arg1 = [p%arg1, p%arg1]
    p%arg2 = [p%arg2, p%arg2]
    p%arg3 = [p%arg3, p%arg3]
  endif
  p%npc = p%npc + 1
  p%op(p%npc) = op
  p%arg1(p%npc) = 0 ; if (present(a1)) p%arg1(p%npc) = a1
  p%arg2(p%npc) = 0 ; if (present(a2)) p%arg2(p%npc) = a2
  p%arg3(p%npc) = 0 ; if (present(a3)) p%arg3(p%npc) = a3
  endsubroutine emit

  pure recursive function nullable(p, node) result(empty)
  !< Return true if the node can match the empty string.
  type(parser), intent(in) :: p     !< Parser.
  integer,      intent(in) :: node  !< The node.
  logical                  :: empty !< True if it can match empty.
  integer                  :: c     !< Child.

  select case (p%kind(node))
  case (N_EMPTY, N_ASSERT)
    empty = .true.
  case (N_LIT, N_ANY, N_CLASS)
    empty = .false.
  case (N_GROUP)
    empty = nullable(p, p%child(node))
  case (N_REPEAT)
    empty = p%val1(node) == 0
    if (.not.empty) empty = nullable(p, p%child(node))
  case (N_CAT)
    empty = .true.
    c = p%child(node)
    do while (c /= 0)
      if (.not.nullable(p, c)) then
        empty = .false.
        return
      endif
      c = p%sibling(c)
    enddo
  case (N_ALT)
    empty = .false.
    c = p%child(node)
    do while (c /= 0)
      if (nullable(p, c)) then
        empty = .true.
        return
      endif
      c = p%sibling(c)
    enddo
  case default
    empty = .true.
  endselect
  endfunction nullable

  pure recursive subroutine compile_node(p, node)
  !< Compile a node into the program.
  type(parser), intent(inout) :: p      !< Parser.
  integer,      intent(in)    :: node   !< The node.
  integer                     :: c      !< Child.
  integer                     :: k      !< Counter.
  integer, allocatable        :: jumps(:) !< Jumps to the end of an alternation.
  integer                     :: split  !< A split to patch.
  integer                     :: head   !< Head of a loop.
  integer                     :: reg    !< Register of a loop.
  integer                     :: check  !< Check at the end of the first copy of a loop body.
  integer                     :: head2  !< Head of the second copy of a loop body.
  integer                     :: nopt   !< Optional copies of a bounded repeat.
  integer, allocatable        :: exits(:) !< Splits to patch to the end of a bounded repeat.

  if (p%error /= 0) return
  select case (p%kind(node))
  case (N_EMPTY)
  case (N_LIT)
    if (p%nocase .and. ((p%val1(node) >= 65 .and. p%val1(node) <= 90) .or. (p%val1(node) >= 97 .and. p%val1(node) <= 122))) &
      then
      call emit(p, OP_CHARI, int(fold(int(p%val1(node), I4P))))
    else
      call emit(p, OP_CHAR, p%val1(node))
    endif
  case (N_ANY)
    call emit(p, merge(OP_ANYNL, OP_ANY, p%dotall))
  case (N_CLASS)
    call emit(p, OP_CLASS, p%val1(node))
  case (N_ASSERT)
    call emit(p, OP_ASSERT, p%val1(node))
  case (N_GROUP)
    if (p%val1(node) > 0) call emit(p, OP_SAVE, 2 * p%val1(node))
    call compile_node(p, p%child(node))
    if (p%val1(node) > 0) call emit(p, OP_SAVE, 2 * p%val1(node) + 1)
  case (N_CAT)
    c = p%child(node)
    do while (c /= 0)
      call compile_node(p, c)
      c = p%sibling(c)
    enddo
  case (N_ALT)
    allocate(jumps(0))
    c = p%child(node)
    do while (c /= 0)
      if (p%sibling(c) /= 0) then
        call emit(p, OP_SPLIT)
        split = p%npc
        call compile_node(p, c)
        call emit(p, OP_JMP)
        jumps = [jumps, p%npc]
        if (p%error /= 0) return
        p%arg1(split) = split + 1
        p%arg2(split) = p%npc + 1
      else
        call compile_node(p, c)
      endif
      c = p%sibling(c)
    enddo
    if (p%error /= 0) return
    do k = 1, size(jumps)
      p%arg1(jumps(k)) = p%npc + 1
    enddo
  case (N_REPEAT)
    c = p%child(node)
    do k = 1, p%val1(node)
      call compile_node(p, c)
    enddo
    if (p%val2(node) < 0 .and. .not.nullable(p, c)) then ! a loop: head: split body, exit; body; jmp head
      call emit(p, OP_SPLIT)
      head = p%npc
      call compile_node(p, c)
      call emit(p, OP_JMP, head)
      if (p%error /= 0) return
      call set_split(p, head, head + 1, p%npc + 1, p%val3(node) == 1)
    elseif (p%val2(node) < 0) then
      ! a loop whose body can match empty: an empty iteration ends it, keeping its captures, as Python does. The body is
      ! compiled twice and the iterations alternate between the copies: the end of an iteration and the end of the empty
      ! one after it, at the same position, are then different instructions, so the VM does not merge them
      reg = 2 * (p%ngroups + 1) + p%nregs
      p%nregs = p%nregs + 1
      call emit(p, OP_SPLIT)
      head = p%npc
      call emit(p, OP_MARK, reg)
      call compile_node(p, c)
      call emit(p, OP_CHECK, reg)
      check = p%npc
      call emit(p, OP_SPLIT)
      head2 = p%npc
      call emit(p, OP_MARK, reg)
      call compile_node(p, c)
      call emit(p, OP_CHECK, reg, 0, head)
      if (p%error /= 0) return
      p%arg2(check) = p%npc + 1
      p%arg3(check) = head2
      p%arg2(p%npc) = p%npc + 1
      call set_split(p, head, head + 1, p%npc + 1, p%val3(node) == 1)
      call set_split(p, head2, head2 + 1, p%npc + 1, p%val3(node) == 1)
    else ! (max - min) nested optional copies, all exiting to the end
      nopt = p%val2(node) - p%val1(node)
      allocate(exits(nopt))
      do k = 1, nopt
        call emit(p, OP_SPLIT)
        exits(k) = p%npc
        call compile_node(p, c)
      enddo
      if (p%error /= 0) return
      do k = 1, nopt
        call set_split(p, exits(k), exits(k) + 1, p%npc + 1, p%val3(node) == 1)
      enddo
    endif
  endselect
  endsubroutine compile_node

  pure subroutine set_split(p, pc, body, out, greedy)
  !< Set the targets of a split: the body first if greedy, the exit first if lazy.
  type(parser), intent(inout) :: p      !< Parser.
  integer,      intent(in)    :: pc     !< The split.
  integer,      intent(in)    :: body   !< The body.
  integer,      intent(in)    :: out    !< The exit.
  logical,      intent(in)    :: greedy !< Greedy.

  if (greedy) then
    p%arg1(pc) = body
    p%arg2(pc) = out
  else
    p%arg1(pc) = out
    p%arg2(pc) = body
  endif
  endsubroutine set_split

  pure function itoa(n) result(text)
  !< Return an integer as text.
  integer, intent(in)           :: n    !< Integer.
  character(len=:), allocatable :: text !< Text.
  character(len=12)             :: buffer !< Buffer.

  write(buffer, '(i0)') n
  text = trim(buffer)
  endfunction itoa
endmodule stringifor_regex
