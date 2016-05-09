!< StringiFor, Strings Fortran, yet another stringify Fortran module
module stringifor
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor, Strings Fortran, yet another stringify Fortran module
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
save
public :: string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: string
  !< OOP designed string class.
  private
  character(len=:), allocatable :: raw !< Raw data.
  contains
    ! public methods
    procedure, pass(self) :: free       !< Free dynamic memory.
    procedure, pass(self) :: chars      !< Return the raw characters data.
    procedure, pass(self) :: upper      !< Return a string with all uppercase characters.
    procedure, pass(self) :: lower      !< Return a string with all lowercase characters.
    procedure, pass(self) :: capitalize !< Return a string with its first character capitalized and the rest lowercased.
    procedure, pass(self) :: end_with   !< Return true if a string ends with a specified suffix.
    procedure, pass(self) :: start_with !< Return true if a string starts with a specified prefix.
    procedure, pass(self) :: partition  !< Split string at separator and return the 3 parts (before, the separator and after).
    procedure, pass(self) :: replace    !< Return a string with all occurrences of substring old replaced by new.
    procedure, pass(self) :: split      !< Return a list of substring in the string, using sep as the delimiter string.
    procedure, pass(self) :: strip      !< Return a copy of the string with the leading and trailing characters removed.
    procedure, pass(self) :: swapcase   !< Return a copy of the string with uppercase chars converted to lowercase and vice versa.
    procedure, pass(self) :: unique     !< Reduce to one (unique) multiple (sequential) occurrences of a substring into a string.
    ! inquire
    procedure, pass(self) :: is_allocated !< Return true if the string is allocated.
    procedure, pass(self) :: is_upper     !< Return true if all characters in the string are uppercase.
    procedure, pass(self) :: is_lower     !< Return true if all characters in the string are lowercase.
    procedure, pass(self) :: is_digit     !< Return true if all characters in the string are digits.
    ! operators
    generic :: assignment(=) => string_assign_string, &
                                string_assign_character             !< Assignment operator overloading.
    generic :: operator(//) => string_concat_string,    &
                               string_concat_character, &
                               character_concat_string              !< Concatenation operator overloading.
    generic :: operator(.cat.) => string_concat_string_string,    &
                                  string_concat_character_string, &
                                  character_concat_string_string    !< Concatenation operator (string output) overloading.
    ! builtins replacements
    procedure, pass(self) :: sadjustl  !< Adjustl replacement.
    procedure, pass(self) :: sadjustr  !< Adjustr replacement.
    procedure, pass(self) :: scount    !< Count replacement.
    procedure, pass(self) :: sindex    !< Index replacement.
    procedure, pass(self) :: slen      !< Len replacement.
    procedure, pass(self) :: slen_trim !< Len_trim replacement.
    procedure, nopass     :: srepeat   !< Repeat replacement.
    procedure, pass(self) :: sscan     !< Scan replacement.
    procedure, pass(self) :: strim     !< Trim replacement.
    procedure, pass(self) :: sverify   !< Verify replacement.
    ! IO
#ifndef __GFORTRAN__
    generic :: read(formatted) => read_formatted_       !< Formatted input.
    generic :: write(formatted) => write_formatted_     !< Formatted output.
    generic :: read(unformatted) => read_unformatted_   !< Unformatted input.
    generic :: write(unformatted) => write_unformatted_ !< Unformatted output.
#else
    procedure, pass(dtv) :: read_formatted => read_formatted_   !< Formatted input.
    procedure, pass(dtv) :: read_formatted_internal             !< Formatted input from internal.
    procedure, pass(dtv) :: write_formatted => write_formatted_ !< Formatted output.
    procedure, pass(dtv) :: write_formatted_internal            !< Formatted output to internal.
#endif
    ! private methods
    procedure, private, pass(lhs)  :: string_assign_string           !< Assignment operator from string input.
    procedure, private, pass(lhs)  :: string_assign_character        !< Assignment operator from character input.
    procedure, private, pass(lhs)  :: string_concat_string           !< Concatenation with string.
    procedure, private, pass(lhs)  :: string_concat_character        !< Concatenation with character.
    procedure, private, pass(rhs)  :: character_concat_string        !< Concatenation with character (inverted).
    procedure, private, pass(lhs)  :: string_concat_string_string    !< Concatenation with string (string output).
    procedure, private, pass(lhs)  :: string_concat_character_string !< Concatenation with character (string output).
    procedure, private, pass(rhs)  :: character_concat_string_string !< Concatenation with character (inverted, string output).
    procedure, private, pass(dtv)  :: read_formatted_                !< Formatted input.
    procedure, private, pass(dtv)  :: write_formatted_               !< Formatted output.
    procedure, private, pass(dtv)  :: read_unformatted_              !< Unformatted input.
    procedure, private, pass(dtv)  :: write_unformatted_             !< Unformatted output.
    procedure, private, pass(self) :: replace_one_occurrence         !< Replace the first occurrence of substring old by new.
endtype string

character(len=26), parameter :: upper_alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' !< Upper case alphabet.
character(len=26), parameter :: lower_alphabet = 'abcdefghijklmnopqrstuvwxyz' !< Lower case alphabet.
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  ! public methods
  elemental subroutine free(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Free dynamic memory.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(inout) :: self !< The string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) deallocate(self%raw)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine free

  pure function chars(self) result(raw)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the raw characters data.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in)     :: self !< The string.
  character(len=:), allocatable :: raw  !< Raw characters data.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    raw = self%raw
  else
    raw = ''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction chars

  elemental function upper(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a string with all uppercase characters.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self  !< The string.
  type(string)              :: upper !< Upper case string.
  integer                   :: n1    !< Characters counter.
  integer                   :: n2    !< Characters counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    upper = self
    do n1=1, len(self%raw)
      n2 = index(lower_alphabet, self%raw(n1:n1))
      if (n2>0) upper%raw(n1:n1) = upper_alphabet(n2:n2)
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction upper

  elemental function lower(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a string with all lowercase characters.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self  !< The string.
  type(string)              :: lower !< Upper case string.
  integer                   :: n1    !< Characters counter.
  integer                   :: n2    !< Characters counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    lower = self
    do n1=1, len(self%raw)
      n2 = index(upper_alphabet, self%raw(n1:n1))
      if (n2>0) lower%raw(n1:n1) = lower_alphabet(n2:n2)
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction lower

  elemental function capitalize(self) result(capitalized)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a string with its first character capitalized and the rest lowercased.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self        !< The string.
  type(string)              :: capitalized !< Upper case string.
  integer                   :: c           !< Character counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    capitalized = self%lower()
    c = index(lower_alphabet, capitalized%raw(1:1))
    if (c>0) capitalized%raw(1:1) = upper_alphabet(c:c)
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction capitalize

  elemental function end_with(self, suffix, start, end)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if a string ends with a specified suffix.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self     !< The string.
  character(len=*), intent(in)           :: suffix   !< Searched suffix.
  integer,          intent(in), optional :: start    !< Start position into the string.
  integer,          intent(in), optional :: end      !< End position into the string.
  logical                                :: end_with !< Result of the test.
  integer                                :: start_   !< Start position into the string, local variable.
  integer                                :: end_     !< End position into the string, local variable.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  end_with = .false.
  if (allocated(self%raw)) then
    start_ = 1             ; if (present(start)) start_ = start
    end_   = len(self%raw) ; if (present(end))   end_   = end
    if (len(suffix)<=len(self%raw(start_:end_))) then
      end_with = index(self%raw(start_:end_), suffix)==(len(self%raw(start_:end_)) - len(suffix) + 1)
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction end_with

  elemental function start_with(self, prefix, start, end)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if a string starts with a specified prefix.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self       !< The string.
  character(len=*), intent(in)           :: prefix     !< Searched prefix.
  integer,          intent(in), optional :: start      !< Start position into the string.
  integer,          intent(in), optional :: end        !< End position into the string.
  logical                                :: start_with !< Result of the test.
  integer                                :: start_     !< Start position into the string, local variable.
  integer                                :: end_       !< End position into the string, local variable.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  start_with = .false.
  if (allocated(self%raw)) then
    start_ = 1             ; if (present(start)) start_ = start
    end_   = len(self%raw) ; if (present(end))   end_   = end
    if (len(prefix)<=len(self%raw(start_:end_))) then
      start_with = index(self%raw(start_:end_), prefix)==1
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction start_with

  pure function partition(self, sep) result(partitions)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Split string at separator and return the 3 parts (before, the separator and after).
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)  :: self            !< The string.
  character(len=*), intent(in)  :: sep             !< Separator.
  type(string)                  :: partitions(1:3) !< Partions: before the separator, the separator itsels and after the separator.
  integer                       :: c               !< Character counter.
#ifdef __GFORTRAN__
  character(len=:), allocatable :: temporary       !< Temporary storage, workaround for GNU bug.
#endif
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    partitions(1) = self
    partitions(2) = sep
    partitions(3) = ''
    if (len(sep)>=len(self%raw)) return
    c = index(self%raw, sep)
    if (c>0) then
#ifdef __GFORTRAN__
      temporary = self%raw
      partitions(1)%raw = temporary(1:c-1)
      partitions(2)%raw = temporary(c:c+len(sep)-1)
      partitions(3)%raw = temporary(c+len(sep):)
#else
      partitions(1)%raw = self%raw(1:c-1)
      partitions(2)%raw = self%raw(c:c+len(sep)-1)
      partitions(3)%raw = self%raw(c+len(sep):)
#endif
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction partition

  elemental function replace(self, old, new, count) result(replaced)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a string with all occurrences of substring old replaced by new.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self      !< The string.
  character(len=*), intent(in)           :: old       !< Old substring.
  character(len=*), intent(in)           :: new       !< New substring.
  integer,          intent(in), optional :: count     !< Number of old occurences to be replaced.
  type(string)                           :: replaced  !< The string with old replaced by new.
  integer                                :: r         !< Counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    replaced = self
    r = 0
    do
      if (index(replaced%raw, old)>0) then
        replaced = replaced%replace_one_occurrence(old=old, new=new)
        r = r + 1
        if (present(count)) then
          if (r>=count) exit
        endif
      else
        exit
      endif
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction replace

  pure subroutine split(self, sep, tokens)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a list of substring in the string, using sep as the delimiter string.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),             intent(in)  :: self           !< The string.
  character(len=*),          intent(in)  :: sep            !< Separator.
  type(string), allocatable, intent(out) :: tokens(:)      !< Tokens substring.
  integer                                :: No             !< Number of occurrences of sep.
  integer                                :: t              !< Character counter.
  type(string)                           :: temporary      !< Temporary storage.
  type(string), allocatable              :: temp_toks(:,:) !< Temporary tokens substring.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    temporary = self%unique(sep)
    No = temporary%scount(sep)
    allocate(temp_toks(3, No))
    temp_toks(:, 1) = temporary%partition(sep)
    if (No>1) then
      do t=2, No
        temp_toks(:, t) = temp_toks(3, t-1)%partition(sep)
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
      do t=2, No
        if (t==No) then
          tokens(t-1) = temp_toks(1, t)
          tokens(t  ) = temp_toks(3, t)
        else
          tokens(t-1) = temp_toks(1, t)
        endif
      enddo
    else
      allocate(tokens(No-1))
      do t=2, No
        tokens(t-1) = temp_toks(1, t)
      enddo
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine split

  elemental function strip(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a copy of the string with the leading and trailing characters removed.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self  !< The string.
  type(string)              :: strip !< The stripped string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    strip = self%sadjustl()
    strip = strip%strim()
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction strip

  elemental function swapcase(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a copy of the string with uppercase characters converted to lowercase and vice versa.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  type(string)              :: swapcase !< Upper case string.
  integer                   :: n1       !< Characters counter.
  integer                   :: n2       !< Characters counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    swapcase = self
    do n1=1, len(self%raw)
      n2 = index(upper_alphabet, self%raw(n1:n1))
      if (n2>0) then
        swapcase%raw(n1:n1) = lower_alphabet(n2:n2)
      else
        n2 = index(lower_alphabet, self%raw(n1:n1))
        if (n2>0) swapcase%raw(n1:n1) = upper_alphabet(n2:n2)
      endif
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction swapcase

  elemental function unique(self, substring) result(uniq)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Reduce to one (unique) multiple (sequential) occurrences of a substring into a string.
  !<
  !< For example the string ' ab-cre-cre-ab' is reduce to 'ab-cre-ab' if the substring is '-cre'.
  !< @note Eventual multiple trailing white space are not reduced to one occurrence.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)  :: self      !< The string.
  character(len=*), intent(in)  :: substring !< Substring which multiple occurences must be reduced to one.
  type(string)                  :: uniq      !< String parsed.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    uniq = self
    do
      if (.not.uniq%sindex(repeat(substring, 2))>0) exit
      uniq = uniq%replace(old=repeat(substring, 2), new=substring)
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction unique

  ! inquire
  elemental function is_allocated(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if the string is allocated.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  logical                   :: is_allocated !< Result of the test.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  is_allocated = allocated(self%raw)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction is_allocated

  elemental function is_digit(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if all characters in the string are digits.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  logical                   :: is_digit !< Result of the test.
  integer                   :: c        !< Character counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  is_digit = .false.
  if (allocated(self%raw)) then
    do c=1, len(self%raw)
      select case (self%raw(c:c))
      case ('0':'9')
        is_digit = .true.
      case default
        is_digit = .false.
        exit
      end select
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction is_digit

  elemental function is_upper(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if all characters in the string are uppercase.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  logical                   :: is_upper !< Result of the test.
  integer                   :: c        !< Character counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  is_upper = .false.
  if (allocated(self%raw)) then
    is_upper = .true.
    do c=1, len(self%raw)
      if (index(lower_alphabet, self%raw(c:c))>0) then
        is_upper = .false.
        exit
      endif
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction is_upper

  elemental function is_lower(self)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return true if all characters in the string are lowercase.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  logical                   :: is_lower !< Result of the test.
  integer                   :: c        !< Character counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  is_lower = .false.
  if (allocated(self%raw)) then
    is_lower = .true.
    do c=1, len(self%raw)
      if (index(upper_alphabet, self%raw(c:c))>0) then
        is_lower = .false.
        exit
      endif
    enddo
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction is_lower

  ! builtins replacements
  elemental function sadjustl(self) result(adjusted)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Left adjust a string by removing leading spaces.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  type(string)              :: adjusted !< Adjusted string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  adjusted = self
  if (allocated(adjusted%raw)) adjusted%raw = adjustl(adjusted%raw)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sadjustl

  elemental function sadjustr(self) result(adjusted)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Right adjust a string by removing leading spaces.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self     !< The string.
  type(string)              :: adjusted !< Adjusted string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  adjusted = self
  if (allocated(adjusted%raw)) adjusted%raw = adjustr(adjusted%raw)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sadjustr

  elemental function scount(self, substring, ignore_isolated) result(No)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Count the number of occurences of a substring into a string.
  !<
  !< @note If `ignore_isolated` is set to true the eventual "isolated" occurences are ignored: an isolated occurrences are those
  !< occurrences happening at the start of string (thus not having a left companion) or at the end of the string (thus not having a
  !< right companion).
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in)           :: self             !< The string.
  character(*),  intent(in)           :: substring        !< Substring.
  logical,       intent(in), optional :: ignore_isolated  !< Ignore "isolated" occurrences.
  integer                             :: No               !< Number of occurrences.
  logical                             :: ignore_isolated_ !< Ignore "isolated" occurrences, local variable.
  integer                             :: c1               !< Counter.
  integer                             :: c2               !< Counter.
#ifdef __GFORTRAN__
  character(len=:), allocatable       :: temporary        !< Temporary storage, workaround for GNU bug.
#endif
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  No = 0
  if (allocated(self%raw)) then
    if (len(substring)>len(self%raw)) return
    ignore_isolated_ = .false. ; if (present(ignore_isolated)) ignore_isolated_ = ignore_isolated
#ifdef __GFORTRAN__
    temporary = self%raw
#endif
    c1 = 1
    do
#ifdef __GFORTRAN__
      c2 = index(string=temporary(c1:), substring=substring)
#else
      c2 = index(string=self%raw(c1:), substring=substring)
#endif
      if (c2==0) return
      if (.not.(ignore_isolated_.and.(c1==1.or.c1+c2-1==len(self%raw)-len(substring)+1))) then
        No = No + 1
      endif
      c1 = c1 + c2 - 1 + len(substring)
    enddo
  endif
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction scount

  elemental function sindex(self, substring, back) result(i)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
  !< If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
  !< the start of the last occurrence rather than the first.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self      !< The string.
  character(len=*), intent(in)           :: substring !< Searched substring.
  logical,          intent(in), optional :: back      !< Start of the last occurrence rather than the first.
  integer                                :: i         !< Result of the search.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    i = index(string=self%raw, substring=substring, back=back)
  else
    i = 0
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sindex

  elemental function slen(self) result(l)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the length of a string.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self !< The string.
  integer                   :: l    !< String length.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    l = len(string=self%raw)
  else
    l = 0
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction slen

  elemental function slen_trim(self) result(l)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the length of a string, ignoring any trailing blanks.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self !< The string.
  integer                   :: l    !< String length.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    l = len_trim(string=self%raw)
  else
    l = 0
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction slen_trim

  elemental function srepeat(rstring, ncopies) result(repeated)
  !---------------------------------------------------------------------------------------------------------------------------------
  !<
  !---------------------------------------------------------------------------------------------------------------------------------
  character(len=*), intent(in) :: rstring  !< String to be repeated.
  integer,          intent(in) :: ncopies  !< Number of string copies.
  type(string)                 :: repeated !< Repeated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  repeated%raw = repeat(string=rstring, ncopies=ncopies)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction srepeat

  elemental function sscan(self, set, back) result(i)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self  !< The string.
  character(len=*), intent(in)           :: set   !< Searched set.
  logical,          intent(in), optional :: back  !< Start of the last occurrence rather than the first.
  integer                                :: i     !< Result of the search.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    i = scan(string=self%raw, set=set, back=back)
  else
    i = 0
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sscan

  elemental function strim(self) result(trimmed)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Remove leading spaces.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in) :: self    !< The string.
  type(string)              :: trimmed !< Trimmed string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  trimmed = self
  if (allocated(trimmed%raw)) trimmed%raw = trim(trimmed%raw)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction strim

  elemental function sverify(self, set, back) result(i)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
  !< in `set`. If all characters of `string` are found in `set`, the result is zero.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)           :: self  !< The string.
  character(len=*), intent(in)           :: set   !< Searched set.
  logical,          intent(in), optional :: back  !< Start of the last occurrence rather than the first.
  integer                                :: i     !< Result of the search.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    i = verify(string=self%raw, set=set, back=back)
  else
    i = 0
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sverify

  ! private methods
  elemental subroutine string_assign_string(lhs, rhs)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Assignment operator from string input.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(inout) :: lhs !< Left hand side.
  type(string),  intent(in)    :: rhs !< Right hand side.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(rhs%raw)) lhs%raw = rhs%raw
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine string_assign_string

  elemental subroutine string_assign_character(lhs, rhs)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Assignment operator from character input.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: lhs !< Left hand side.
  character(len=*), intent(in)    :: rhs !< Right hand side.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  lhs%raw = rhs
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine string_assign_character

  pure function string_concat_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with string.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in)     :: lhs    !< Left hand side.
  type(string),  intent(in)     :: rhs    !< Right hand side.
  character(len=:), allocatable :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  concat = ''
  if (allocated(lhs%raw)) concat = lhs%raw
  if (allocated(rhs%raw)) concat = concat//rhs%raw
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_string

  pure function string_concat_character(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)  :: lhs    !< Left hand side.
  character(len=*), intent(in)  :: rhs    !< Right hand side.
  character(len=:), allocatable :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(lhs%raw)) then
    concat = lhs%raw//rhs
  else
    concat = rhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_character

  pure function character_concat_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character (inverted).
  !---------------------------------------------------------------------------------------------------------------------------------
  character(len=*), intent(in)  :: lhs    !< Left hand side.
  class(string),    intent(in)  :: rhs    !< Right hand side.
  character(len=:), allocatable :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(rhs%raw)) then
    concat = lhs//rhs%raw
  else
    concat = lhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction character_concat_string

  elemental function string_concat_string_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with string.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in)     :: lhs       !< Left hand side.
  type(string),  intent(in)     :: rhs       !< Right hand side.
  type(string)                  :: concat    !< Concatenated string.
  character(len=:), allocatable :: temporary !< Temporary concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  temporary = ''
  if (allocated(lhs%raw)) temporary = lhs%raw
  if (allocated(rhs%raw)) temporary = temporary//rhs%raw
  if (temporary/='') concat%raw = temporary
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_string_string

  elemental function string_concat_character_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)  :: lhs    !< Left hand side.
  character(len=*), intent(in)  :: rhs    !< Right hand side.
  type(string)                  :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(lhs%raw)) then
    concat%raw = lhs%raw//rhs
  else
    concat%raw = rhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_character_string

  elemental function character_concat_string_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character (inverted).
  !---------------------------------------------------------------------------------------------------------------------------------
  character(len=*), intent(in)  :: lhs    !< Left hand side.
  class(string),    intent(in)  :: rhs    !< Right hand side.
  type(string)                  :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(rhs%raw)) then
    concat%raw = lhs//rhs%raw
  else
    concat%raw = lhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction character_concat_string_string

  subroutine read_formatted_(dtv, unit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted input.
  !<
  !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  character(len=100)              :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  read(unit, "(A)", iostat=iostat, iomsg=iomsg)temporary
  dtv%raw = trim(temporary)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_formatted_

  subroutine read_formatted_internal(dtv, iunit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted input from internal.
  !<
  !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: dtv       !< The string.
  character(len=*), intent(in)    :: iunit     !< Internal unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  character(len=100)              :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  read(iunit, "(A)", iostat=iostat, iomsg=iomsg)temporary
  dtv%raw = trim(temporary)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_formatted_internal

  subroutine write_formatted_(dtv, unit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted output.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)    :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(dtv%raw)) then
    write(unit, "(A)", iostat=iostat, iomsg=iomsg)dtv%raw
  else
    write(unit, "(A)", iostat=iostat, iomsg=iomsg)''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_formatted_

  subroutine write_formatted_internal(dtv, iunit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted output to internal.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)    :: dtv       !< The string.
  character(len=*), intent(inout) :: iunit     !< Interanl unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(dtv%raw)) then
    write(iunit, "(A)", iostat=iostat, iomsg=iomsg)dtv%raw
  else
    write(iunit, "(A)", iostat=iostat, iomsg=iomsg)''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_formatted_internal

  subroutine read_unformatted_(dtv, unit, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Unformatted input.
  !<
  !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  character(len=100)              :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  read(unit, iostat=iostat, iomsg=iomsg)temporary
  dtv%raw = trim(temporary)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_unformatted_

  subroutine write_unformatted_(dtv, unit, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Unformatted output.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)    :: dtv    !< The string.
  integer,          intent(in)    :: unit   !< Logical unit.
  integer,          intent(out)   :: iostat !< IO status code.
  character(len=*), intent(inout) :: iomsg  !< IO status message.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(dtv%raw)) then
    write(unit, iostat=iostat, iomsg=iomsg)dtv%raw
  else
    write(unit, iostat=iostat, iomsg=iomsg)''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_unformatted_

  elemental function replace_one_occurrence(self, old, new) result(replaced)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Return a string with the first occurrence of substring old replaced by new.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)  :: self      !< The string.
  character(len=*), intent(in)  :: old       !< Old substring.
  character(len=*), intent(in)  :: new       !< New substring.
  type(string)                  :: replaced  !< The string with old replaced by new.
  integer                       :: pos       !< Position from which replace old.
#ifdef __GFORTRAN__
  character(len=:), allocatable :: temporary !< Temporary storage, workaround for GNU bug.
#endif
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(self%raw)) then
    replaced = self
    pos = index(string=self%raw, substring=old)
    if (pos>0) then
#ifdef __GFORTRAN__
      temporary = self%raw
      if (pos==1) then
        replaced%raw = new//temporary(len(old)+1:)
      else
        replaced%raw = temporary(1:pos-1)//new//temporary(pos+len(old):)
      endif
#else
      if (pos==1) then
        replaced%raw = new//self%raw(len(old)+1:)
      else
        replaced%raw = self%raw(1:pos-1)//new//self%raw(pos+len(old):)
      endif
#endif
    endif
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction replace_one_occurrence
endmodule stringifor
