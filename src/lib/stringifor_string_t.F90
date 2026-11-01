!< StringiFor, definition of `string` type.
module stringifor_string_t
!< StringiFor, definition of `string` type.
use, intrinsic :: iso_fortran_env, only : iostat_eor
use, intrinsic :: ieee_arithmetic, only : ieee_positive_inf, ieee_quiet_nan, ieee_value
use befor64, only : b64_decode, b64_encode
use face, only : colorize
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
use stringifor_numbers, only : decimal_to_r4, decimal_to_r8, settle_r4, settle_r8, shortest_digits
use stringifor_utf8, only : REPLACEMENT_CHARACTER, is_ascii, utf8_byte_pos, utf8_char_pos, utf8_decode, &
                            utf8_encode, utf8_encoded_len, utf8_first_error, utf8_in_set, utf8_nth_unit, &
                            utf8_scan, utf8_subpart_len, utf8_unit_index, utf8_unit_len, utf8_units, &
                            utf8_unit_width, utf8_width, utf8_space_len, utf8_white_space

implicit none
private
save
! expose StingiFor overloaded builtins and operators
! public :: adjustl, adjustr, count, index, len, len_trim, repeat, scan, trim, verify
public :: adjustl, adjustr, count, index, len_trim, repeat, scan, trim, verify
! expose StingiFor objects
public :: CK
public :: SF_BYTES, SF_CHARS, SF_COLUMNS
public :: from_codepoints
public :: shortest
public :: glob
public :: strjoin
public :: strless, strless_natural, strless_nocase
public :: strsort, strsort_less
public :: string

integer, parameter :: CK = selected_char_kind('DEFAULT') !< Default character kind.
integer, parameter :: SF_BYTES = 1 !< Unit of the `by=` arguments: positions and lengths in bytes (the default).
integer, parameter :: SF_CHARS = 2 !< Unit of the `by=` arguments: in characters (UTF-8 units).
integer, parameter :: SF_COLUMNS = 3 !< Unit of the `by=` width arguments: in display columns of a terminal.

type :: string
  !< OOP designed string class.
  character(kind=CK, len=:), allocatable :: raw !< Raw data.
  contains
    ! public methods
    ! builtins replacements
    procedure, pass(self) :: adjustl  => sadjustl                 !< Adjustl replacement.
    procedure, pass(self) :: adjustr  => sadjustr                 !< Adjustr replacement.
    procedure, pass(self) :: count    => scount                   !< Count replacement.
    generic               :: index    => sindex_string_string, &
                                         sindex_string_character  !< Index replacement.
    procedure, pass(self) :: len      => slen                     !< Len replacement.
    procedure, pass(self) :: len_trim => slen_trim                !< Len_trim replacement.
    generic               :: repeat   => srepeat_string_string, &
                                         srepeat_character_string !< Repeat replacement.
    generic               :: scan     => sscan_string_string,    &
                                         sscan_string_character   !< Scan replacement.
    procedure, pass(self) :: trim     => strim                    !< Trim replacement.
    generic               :: verify   => sverify_string_string, &
                                         sverify_string_character !< Verify replacement.
    ! auxiliary methods
    procedure, pass(self) :: basedir          !< Return the base directory name of a string containing a file name.
    procedure, pass(self) :: basename         !< Return the base file name of a string containing a file name.
    procedure, pass(self) :: camelcase        !< Return a string with all words capitalized without spaces.
    procedure, pass(self) :: capitalize       !< Return a string with its first character capitalized and the rest lowercased.
    procedure, pass(self) :: center           !< Return the string centered in a given width.
    procedure, pass(self) :: byte_pos         !< Return the byte position of the first byte of a character.
    procedure, pass(self) :: char_pos         !< Return the character holding a byte.
    procedure, pass(self) :: chars            !< Return the raw characters data.
    procedure, pass(self) :: codepoints       !< Return the codepoints of the string, one per unit.
    generic               :: colorize => &
                             colorize_str     !< Colorize and stylize strings.
    generic               :: common_prefix =>         &
                             common_prefix_string,    &
                             common_prefix_character, &
                             common_prefix_strings    !< Return the longest common prefix shared with other string(s).
    generic               :: compare_version =>        &
                             compare_version_string,   &
                             compare_version_character !< Compare two version numbers, return -1, 0 or 1.
    procedure, pass(self) :: compact          !< Return the words of the string separated by one separator, whitespace collapsed.
    procedure, pass(self) :: decode           !< Decode string.
    generic               :: edit_distance => &
                             edit_distance_character, &
                             edit_distance_string !< Return the Levenshtein distance from another string.
    procedure, pass(self) :: encode           !< Encode string.
    procedure, pass(self) :: escape           !< Escape backslashes (or custom escape character).
    procedure, pass(self) :: escape_c         !< Return the string with C escapes for what is not printable.
    procedure, pass(self) :: escape_xml       !< Return the string with the XML markup characters escaped.
    procedure, pass(self) :: escapes_error    !< Return the position of the first malformed C escape, 0 if none.
    procedure, pass(self) :: expand_tabs      !< Return a string with the tabs expanded to spaces.
    procedure, pass(self) :: extension        !< Return the extension of a string containing a file name.
    procedure, pass(self) :: fill             !< Pad string on the left (or right) with zeros (or other char) to fill width.
    procedure, pass(self) :: free             !< Free dynamic memory.
    generic               :: glob =>         &
                             glob_character, &
                             glob_string      !< Glob search, finds all the pathnames matching a given pattern.
    procedure, pass(self) :: hex              !< Return the hexadecimal representation of the integer into the string.
    generic               :: insert =>      &
                             insert_string, &
                             insert_character !< Insert substring into string at a specified position.
    generic               :: join =>       &
                             join_strings, &
                             join_characters  !< Return a string that is a join of an array of strings or characters.
    generic               :: strjoin =>   &
                             strjoin_strings, &
                             strjoin_characters, &
                             strjoin_strings_array, &
                             strjoin_characters_array  !< Return a string that is a join of an array of strings or characters;
                                                       !< Return join 1D string array of an 2D array of strings or characters in columns or rows.
    procedure, pass(self) :: justify          !< Return the words of the string packed into fully justified lines.
    procedure, pass(self) :: len_last_word    !< Return the length of the last word of the string.
    procedure, pass(self) :: ljust            !< Return the string left justified in a given width.
    procedure, pass(self) :: lower            !< Return a string with all lowercase characters.
    procedure, pass(self) :: lstrip           !< Return a string with the leading characters removed.
    procedure, pass(self) :: partition        !< Split string at separator and return the 3 parts (before, the separator and after).
    procedure, pass(self) :: quote            !< Return the string quoted, the inner quotes doubled.
    procedure, pass(self) :: read_file        !< Read a file a single string stream.
    procedure, pass(self) :: read_line        !< Read line (record) from a connected unit.
    procedure, pass(self) :: read_lines       !< Read (all) lines (records) from a connected unit as a single ascii stream.
    generic               :: read_number => &
                             read_number_I1P,&
#ifndef _NVF
                             read_number_I2P,&
#endif
                             read_number_I4P,&
                             read_number_I8P,&
#if defined PENF_R16P
                             read_number_R16P,&
#endif
                             read_number_R8P,&
                             read_number_R4P  !< Cast string to number, with an error status.
    procedure, pass(self) :: replace          !< Return a string with all occurrences of substring old replaced by new.
    procedure, pass(self) :: reverse          !< Return a reversed string.
    procedure, pass(self) :: reverse_words    !< Return a string with the words order reversed.
    procedure, pass(self) :: rjust            !< Return the string right justified in a given width.
    procedure, pass(self) :: rstrip           !< Return a string with the trailing characters removed.
    procedure, pass(self) :: search           !< Search for *tagged* record into string.
    procedure, pass(self) :: slice            !< Return the raw characters data sliced.
    procedure, pass(self) :: snakecase        !< Return a string with all words lowercase separated by "_".
    procedure, pass(self) :: split            !< Return a list of substring in the string, using sep as the delimiter string.
    procedure, pass(self) :: split_chunked    !< Return a list of substring in the string, using sep as the delimiter string.
    procedure, pass(self) :: squeeze          !< Return a string with the runs of a repeated character reduced to one.
    procedure, pass(self) :: startcase        !< Return a string with all words capitalized, e.g. title case.
    procedure, pass(self) :: strip            !< Return a string with the leading and trailing characters removed.
    procedure, pass(self) :: swapcase         !< Return a string with uppercase chars converted to lowercase and vice versa.
    procedure, pass(self) :: tempname         !< Return a safe temporary name suitable for temporary file or directories.
    generic               :: to_number =>   &
                             to_integer_I1P,&
#ifndef _NVF
                             to_integer_I2P,&
#endif
                             to_integer_I4P,&
                             to_integer_I8P,&
#if defined PENF_R16P
                             to_real_R16P,  &
#endif
                             to_real_R8P,   &
                             to_real_R4P      !< Cast string to number.
    procedure, pass(self) :: to_valid_utf8    !< Return the string with the ill-formed UTF-8 replaced.
    procedure, pass(self) :: transliterate    !< Return a string with the characters of a set replaced by the ones of another.
    procedure, pass(self) :: unescape         !< Unescape double backslashes (or custom escaped character).
    procedure, pass(self) :: unescape_c       !< Return the string with its C escapes expanded.
    procedure, pass(self) :: unescape_xml     !< Return the string with its XML references expanded.
    procedure, pass(self) :: unique           !< Reduce to one (unique) multiple occurrences of a substring into a string.
    procedure, pass(self) :: unquote          !< Return the string unquoted, the inner doubled quotes undoubled.
    procedure, pass(self) :: upper            !< Return a string with all uppercase characters.
    procedure, pass(self) :: width => display_width !< Return the display width of the string, in terminal columns.
    procedure, pass(self) :: utf8_error       !< Return the position of the first ill-formed UTF-8 byte, 0 if none.
    procedure, pass(self) :: write_file       !< Write a single string stream into file.
    procedure, pass(self) :: write_line       !< Write line (record) to a connected unit.
    procedure, pass(self) :: write_lines      !< Write lines (records) to a connected unit.
    procedure, pass(self) :: xml_error        !< Return the position of the first malformed XML reference, 0 if none.
    ! inquire methods
    procedure, pass(self) :: end_with     !< Return true if a string ends with a specified suffix.
    procedure, pass(self) :: has_bom      !< Return true if the string starts with a UTF-8 byte order mark.
    procedure, pass(self) :: is_allocated !< Return true if the string is allocated.
    procedure, pass(self) :: is_alnum     !< Return true if all characters in the string are letters or digits.
    procedure, pass(self) :: is_alpha     !< Return true if all characters in the string are letters.
    procedure, pass(self) :: is_digit     !< Return true if all characters in the string are digits.
    procedure, pass(self) :: is_integer   !< Return true if the string contains an integer.
    procedure, pass(self) :: is_lower     !< Return true if all characters in the string are lowercase.
    procedure, pass(self) :: is_number    !< Return true if the string contains a number (real or integer).
    procedure, pass(self) :: is_punct     !< Return true if all characters in the string are punctuation characters.
    procedure, pass(self) :: is_real      !< Return true if the string contains an real.
    procedure, pass(self) :: is_space     !< Return true if all characters in the string are whitespace.
    procedure, pass(self) :: is_upper     !< Return true if all characters in the string are uppercase.
    procedure, pass(self) :: is_utf8      !< Return true if the string is well-formed UTF-8.
    procedure, pass(self) :: is_xdigit    !< Return true if all characters in the string are hexadecimal digits.
    procedure, pass(self) :: match        !< Return true if the string matches a wildcard pattern.
    procedure, pass(self) :: start_with   !< Return true if a string starts with a specified prefix.
    ! operators
    generic :: assignment(=) => string_assign_string,      &
                                string_assign_character,   &
                                string_assign_integer_I1P, &
                                string_assign_integer_I2P, &
                                string_assign_integer_I4P, &
                                string_assign_integer_I8P, &
#if defined PENF_R16P
                                string_assign_real_R16P,   &
#endif
                                string_assign_real_R8P,    &
                                string_assign_real_R4P              !< Assignment operator overloading.
    generic :: operator(//) => string_concat_string,    &
                               string_concat_character, &
                               character_concat_string              !< Concatenation operator overloading.
    generic :: operator(.cat.) => string_concat_string_string,    &
                                  string_concat_character_string, &
                                  character_concat_string_string    !< Concatenation operator (string output) overloading.
    generic :: operator(==) => string_eq_string,    &
                               string_eq_character, &
                               character_eq_string                  !< Equal operator overloading.
    generic :: operator(/=) => string_ne_string,    &
                               string_ne_character, &
                               character_ne_string                  !< Not equal operator overloading.
    generic :: operator(<) => string_lt_string,    &
                              string_lt_character, &
                              character_lt_string                   !< Lower than operator overloading.
    generic :: operator(<=) => string_le_string,    &
                               string_le_character, &
                               character_le_string                  !< Lower equal than operator overloading.
    generic :: operator(>=) => string_ge_string,    &
                               string_ge_character, &
                               character_ge_string                  !< Greater equal than operator overloading.
    generic :: operator(>) => string_gt_string,    &
                              string_gt_character, &
                              character_gt_string                   !< Greater than operator overloading.
    ! IO
    generic :: read(formatted) => read_formatted       !< Formatted input.
    generic :: write(formatted) => write_formatted     !< Formatted output.
    generic :: read(unformatted) => read_unformatted   !< Unformatted input.
    generic :: write(unformatted) => write_unformatted !< Unformatted output.
    ! private methods
    ! builtins replacements
    procedure, private, pass(self) :: sindex_string_string     !< Index replacement.
    procedure, private, pass(self) :: sindex_string_character  !< Index replacement.
    procedure, private, pass(self) :: srepeat_string_string    !< Repeat replacement.
    procedure, private, nopass     :: srepeat_character_string !< Repeat replacement.
    procedure, private, pass(self) :: sscan_string_string      !< Scan replacement.
    procedure, private, pass(self) :: sscan_string_character   !< Scan replacement.
    procedure, private, pass(self) :: sverify_string_string    !< Verify replacement.
    procedure, private, pass(self) :: sverify_string_character !< Verify replacement.
    ! auxiliary methods
    procedure, private, pass(self) :: colorize_str     !< Colorize and stylize strings.
    procedure, private, pass(self) :: common_prefix_string      !< Longest common prefix shared with a string.
    procedure, private, pass(self) :: common_prefix_character   !< Longest common prefix shared with a character.
    procedure, private, pass(self) :: common_prefix_strings     !< Longest common prefix shared with an array of strings.
    procedure, private, pass(self) :: compare_version_string    !< Compare version number with a string one.
    procedure, private, pass(self) :: compare_version_character !< Compare version number with a character one.
    procedure, private, pass(self) :: glob_character   !< Glob search (character output).
    procedure, private, pass(self) :: glob_string      !< Glob search (string output).
    procedure, private, pass(self) :: insert_string    !< Insert substring into string at a specified position.
    procedure, private, pass(self) :: insert_character !< Insert substring into string at a specified position.
    procedure, private, pass(self) :: join_strings     !< Return join string of an array of strings.
    procedure, private, pass(self) :: join_characters  !< Return join string of an array of characters.
    procedure, private, nopass ::     strjoin_strings  !< Return join string of an array of strings.
    procedure, private, nopass ::     strjoin_characters        !< Return join string of an array of strings.
    procedure, private, nopass ::     strjoin_strings_array     !< Return join 1D string array of an 2D array of strings in columns or rows.
    procedure, private, nopass ::     strjoin_characters_array  !< Return join 1D string array of an 2D array of characters in columns or rows.
    procedure, private, pass(self) :: to_integer_I1P   !< Cast string to integer.
#ifndef _NVF
    procedure, private, pass(self) :: to_integer_I2P   !< Cast string to integer.
#endif
    procedure, private, pass(self) :: to_integer_I4P   !< Cast string to integer.
    procedure, private, pass(self) :: to_integer_I8P   !< Cast string to integer.
    procedure, private, pass(self) :: to_real_R4P      !< Cast string to real.
    procedure, private, pass(self) :: to_real_R8P      !< Cast string to real.
    procedure, private, pass(self) :: to_real_R16P     !< Cast string to real.
    procedure, private, pass(self) :: edit_distance_character !< Levenshtein distance from a character.
    procedure, private, pass(self) :: edit_distance_string    !< Levenshtein distance from a string.
    procedure, private, pass(self) :: read_number_I1P  !< Cast string to integer, with an error status.
#ifndef _NVF
    procedure, private, pass(self) :: read_number_I2P  !< Cast string to integer, with an error status.
#endif
    procedure, private, pass(self) :: read_number_I4P  !< Cast string to integer, with an error status.
    procedure, private, pass(self) :: read_number_I8P  !< Cast string to integer, with an error status.
    procedure, private, pass(self) :: read_number_R4P  !< Cast string to real, with an error status.
    procedure, private, pass(self) :: read_number_R8P  !< Cast string to real, with an error status.
    procedure, private, pass(self) :: read_number_R16P !< Cast string to real, with an error status.
    ! assignments
    procedure, private, pass(lhs) :: string_assign_string      !< Assignment operator from string input.
    procedure, private, pass(lhs) :: string_assign_character   !< Assignment operator from character input.
    procedure, private, pass(lhs) :: string_assign_integer_I1P !< Assignment operator from integer input.
    procedure, private, pass(lhs) :: string_assign_integer_I2P !< Assignment operator from integer input.
    procedure, private, pass(lhs) :: string_assign_integer_I4P !< Assignment operator from integer input.
    procedure, private, pass(lhs) :: string_assign_integer_I8P !< Assignment operator from integer input.
    procedure, private, pass(lhs) :: string_assign_real_R4P    !< Assignment operator from real input.
    procedure, private, pass(lhs) :: string_assign_real_R8P    !< Assignment operator from real input.
    procedure, private, pass(lhs) :: string_assign_real_R16P   !< Assignment operator from real input.
    ! concatenation operators
    procedure, private, pass(lhs) :: string_concat_string           !< Concatenation with string.
    procedure, private, pass(lhs) :: string_concat_character        !< Concatenation with character.
    procedure, private, pass(rhs) :: character_concat_string        !< Concatenation with character (inverted).
    procedure, private, pass(lhs) :: string_concat_string_string    !< Concatenation with string (string output).
    procedure, private, pass(lhs) :: string_concat_character_string !< Concatenation with character (string output).
    procedure, private, pass(rhs) :: character_concat_string_string !< Concatenation with character (inverted, string output).
    ! logical operators
    procedure, private, pass(lhs) :: string_eq_string    !< Equal to string logical operator.
    procedure, private, pass(lhs) :: string_eq_character !< Equal to character logical operator.
    procedure, private, pass(rhs) :: character_eq_string !< Equal to character (inverted) logical operator.
    procedure, private, pass(lhs) :: string_ne_string    !< Not equal to string logical operator.
    procedure, private, pass(lhs) :: string_ne_character !< Not equal to character logical operator.
    procedure, private, pass(rhs) :: character_ne_string !< Not equal to character (inverted) logical operator.
    procedure, private, pass(lhs) :: string_lt_string    !< Lower than to string logical operator.
    procedure, private, pass(lhs) :: string_lt_character !< Lower than to character logical operator.
    procedure, private, pass(rhs) :: character_lt_string !< Lower than to character (inverted) logical operator.
    procedure, private, pass(lhs) :: string_le_string    !< Lower equal than to string logical operator.
    procedure, private, pass(lhs) :: string_le_character !< Lower equal than to character logical operator.
    procedure, private, pass(rhs) :: character_le_string !< Lower equal than to character (inverted) logical operator.
    procedure, private, pass(lhs) :: string_ge_string    !< Greater equal than to string logical operator.
    procedure, private, pass(lhs) :: string_ge_character !< Greater equal than to character logical operator.
    procedure, private, pass(rhs) :: character_ge_string !< Greater equal than to character (inverted) logical operator.
    procedure, private, pass(lhs) :: string_gt_string    !< Greater than to string logical operator.
    procedure, private, pass(lhs) :: string_gt_character !< Greater than to character logical operator.
    procedure, private, pass(rhs) :: character_gt_string !< Greater than to character (inverted) logical operator.
    ! IO
    procedure, private, pass(dtv) :: read_formatted                !< Formatted input.
    procedure, private, pass(dtv) :: read_delimited                !< Read a delimited input.
    procedure, private, pass(dtv) :: read_undelimited              !< Read an undelimited input.
    procedure, private, pass(dtv) :: read_undelimited_listdirected !< Read an undelimited list directed input.
    procedure, private, pass(dtv) :: write_formatted               !< Formatted output.
    procedure, private, pass(dtv) :: read_unformatted              !< Unformatted input.
    procedure, private, pass(dtv) :: write_unformatted             !< Unformatted output.
endtype string

! internal parameters
integer,                    parameter :: CASE_SHIFT     = iachar('a') - iachar('A')    !< ASCII distance of the cases.
! powers of ten exactly representable, for the correctly rounded fast path of the number casting (Clinger)
real(R8P), parameter :: P10_R8P(0:22) = [1.e0_R8P,  1.e1_R8P,  1.e2_R8P,  1.e3_R8P,  1.e4_R8P,  1.e5_R8P,  1.e6_R8P,  &
                                         1.e7_R8P,  1.e8_R8P,  1.e9_R8P,  1.e10_R8P, 1.e11_R8P, 1.e12_R8P, 1.e13_R8P, &
                                         1.e14_R8P, 1.e15_R8P, 1.e16_R8P, 1.e17_R8P, 1.e18_R8P, 1.e19_R8P, 1.e20_R8P, &
                                         1.e21_R8P, 1.e22_R8P] !< 1e0..1e22.
real(R4P), parameter :: P10_R4P(0:10) = [1.e0_R4P, 1.e1_R4P, 1.e2_R4P, 1.e3_R4P, 1.e4_R4P, 1.e5_R4P, &
                                         1.e6_R4P, 1.e7_R4P, 1.e8_R4P, 1.e9_R4P, 1.e10_R4P] !< 1e0..1e10.
integer,                    parameter :: SPECIAL_NAN    = 1                            !< A string holding a NaN.
integer,                    parameter :: SPECIAL_INF    = 2                            !< A string holding an infinity.
character(kind=CK, len=1),  parameter :: SPACE          = ' '                          !< Space character.
character(kind=CK, len=1),  parameter :: TAB            = achar(9)                     !< Tab character.
character(kind=CK, len=1),  parameter :: UIX_DIR_SEP    = char(47)                     !< Unix/Linux directories separator (/).
character(kind=CK, len=1),  parameter :: BACKSLASH      = char(92)                     !< Backslash character.
character(kind=CK, len=3),  parameter :: BOM            = char(239)//char(187)//char(191) !< UTF-8 byte order mark, U+FEFF.

interface shortest
  !< Shortest text of a real that reads back as exactly that number.
  module procedure shortest_R4P, shortest_R8P
endinterface shortest

interface glob
  !< Overloading glob procedure.
  !<```fortran
  !< type(string)                  :: astring
  !< character(len=:), allocatable :: alist_chr(:)
  !< type(string),     allocatable :: alist_str(:)
  !< integer, parameter            :: Nf=5
  !< character(14)                 :: files(1:Nf)
  !< integer                       :: file_unit
  !< integer                       :: f
  !< integer                       :: ff
  !< logical                       :: test_passed
  !< do f=1, Nf
  !<    files(f) = astring%tempname(prefix='foo-')
  !<    open(newunit=file_unit, file=files(f))
  !<    write(file_unit, *)f
  !<    close(unit=file_unit)
  !< enddo
  !< call glob(self=astring, pattern='foo-*', list=alist_chr)
  !< call glob(self=astring, pattern='foo-*', list=alist_str)
  !< do f=1, Nf
  !<    open(newunit=file_unit, file=files(f))
  !<    close(unit=file_unit, status='delete')
  !< enddo
  !< test_passed = .false.
  !< outer_chr: do f=1, size(alist_chr, dim=1)
  !<    do ff=1, Nf
  !<       test_passed = alist_chr(f) == files(ff)
  !<       if (test_passed) cycle outer_chr
  !<    enddo
  !< enddo outer_chr
  !< if (test_passed) then
  !<    test_passed = .false.
  !<    outer_str: do f=1, size(alist_str, dim=1)
  !<       do ff=1, Nf
  !<          test_passed = alist_str(f) == files(ff)
  !<          if (test_passed) cycle outer_str
  !<       enddo
  !<    enddo outer_str
  !< endif
  !< print '(L1)', test_passed
  !<```
  !=> T <<<
  module procedure glob_character, glob_string
endinterface glob

interface strjoin
  module procedure strjoin_strings, strjoin_characters, strjoin_strings_array, strjoin_characters_array
endinterface strjoin

! builtin overloading
interface adjustl
  !< Builtin adjustl overloading.
  module procedure sadjustl_character
endinterface adjustl

interface adjustr
  !< Builtin adjustr overloading.
  module procedure sadjustr_character
endinterface adjustr

interface count
  !< Builtin count overloading.
  module procedure count_substring
endinterface

interface index
  !< Builtin index overloading.
  module procedure sindex_string_string, sindex_string_character, sindex_character_string
endinterface index

!interface len
!  !< Builtin len overloading.
!  module procedure slen
!endinterface len

interface len_trim
  !< Builtin len_trim overloading.
  module procedure slen_trim
endinterface len_trim

interface repeat
  !< Builtin repeat overloading.
  module procedure srepeat_string_string
endinterface repeat

interface scan
  !< Builtin scan overloading.
  module procedure sscan_string_string, sscan_string_character, sscan_character_string
endinterface scan

interface trim
  !< Builtin trim overloading.
  module procedure strim
endinterface trim

interface verify
  !< Builtin verify overloading.
  module procedure sverify_string_string, sverify_string_character, sverify_character_string
endinterface verify


abstract interface
  pure function strsort_less(a, b) result(is_less)
  !< Order of [[strsort]]: true if `a` is before `b`.
  import :: CK
  character(kind=CK, len=*), intent(in) :: a       !< A string.
  character(kind=CK, len=*), intent(in) :: b       !< Another string.
  logical                               :: is_less !< True if a is before b.
  endfunction strsort_less
endinterface
contains
   ! public non TBP

   ! creator
   pure function string_(c)
   !< Return a string given a character input.
   !<
   !<```fortran
   !< print "(L1)", string('Hello World')//''=='Hello World'
   !<```
   !=> T <<<
   character(*), intent(in) :: c       !< Character.
   type(string)             :: string_ !< String.

   string_%raw = c
   endfunction string_

   elemental function edit_distance_string(self, other, by) result(distance)
   !< Return the Levenshtein distance from another string: the fewest insertions, deletions and substitutions between them.
   !<
   !< @note The cost is the product of the two lengths, the memory the shorter of them. A string not allocated is empty.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: another
   !< logical      :: test_passed(4)
   !< astring = 'kitten'
   !< another = 'sitting'
   !< test_passed(1) = astring%edit_distance(another)==3
   !< test_passed(2) = astring%edit_distance('kitten')==0
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(3) = astring%edit_distance('cafe')==2
   !< test_passed(4) = astring%edit_distance('cafe', by=SF_CHARS)==1
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self     !< The string.
   type(string),  intent(in)           :: other    !< The other string.
   integer,       intent(in), optional :: by       !< Unit of the distance: SF_BYTES (default) or SF_CHARS.
   integer                             :: distance !< The distance.

   if (allocated(other%raw)) then
      distance = self%edit_distance_character(other%raw, by)
   else
      distance = self%edit_distance_character('', by)
   endif
   endfunction edit_distance_string

   elemental function edit_distance_character(self, other, by) result(distance)
   !< Return the Levenshtein distance from a character. See [[string:edit_distance]].
   !<
   !< @note The doctest is not necessary, this being tested by the string one.
   class(string),             intent(in)           :: self     !< The string.
   character(kind=CK, len=*), intent(in)           :: other    !< The other string.
   integer,                   intent(in), optional :: by       !< Unit of the distance: SF_BYTES (default) or SF_CHARS.
   integer                                         :: distance !< The distance.
   integer(I4P), allocatable                       :: a(:)     !< Units of the string.
   integer(I4P), allocatable                       :: b(:)     !< Units of the other.
   integer                                         :: i        !< Counter.
   type(string)                                    :: wrapped  !< The other, as a string.

   by_units: block
      logical :: chars !< Count in characters.

      chars = .false.
      if (present(by)) chars = by==SF_CHARS
      if (chars) then
         if (allocated(self%raw)) then
            a = self%codepoints()
         else
            allocate(a(0))
         endif
         wrapped%raw = other
         b = wrapped%codepoints()
      else
         if (allocated(self%raw)) then
            a = [(iachar(self%raw(i:i)), i=1, len(self%raw))]
         else
            allocate(a(0))
         endif
         b = [(iachar(other(i:i)), i=1, len(other))]
      endif
   endblock by_units
   if (size(a)<size(b)) then
      distance = levenshtein(b, a)
   else
      distance = levenshtein(a, b)
   endif
   contains
      pure function levenshtein(long, short) result(cost)
      !< Return the distance, keeping one row as long as the shorter sequence.
      integer(I4P), intent(in) :: long(:)  !< The longer sequence.
      integer(I4P), intent(in) :: short(:) !< The shorter sequence.
      integer                  :: cost     !< The distance.
      integer                  :: row(0:size(short)) !< Distances from the prefix of long.
      integer                  :: diagonal !< The previous row, one column to the left.
      integer                  :: above    !< The previous row, this column.
      integer                  :: l        !< Counter.
      integer                  :: m        !< Counter.

      row = [(m, m=0, size(short))]
      do l=1, size(long)
         diagonal = row(0)
         row(0) = l
         do m=1, size(short)
            above = row(m)
            row(m) = min(above + 1, row(m-1) + 1, diagonal + merge(0, 1, long(l)==short(m)))
            diagonal = above
         enddo
      enddo
      cost = row(size(short))
      endfunction levenshtein
   endfunction edit_distance_character

   elemental function shortest_R8P(number) result(astring)
   !< Return the shortest text that reads back as exactly this number, in the layout of Python's `repr`.
   !<
   !< @note Assigning a real to a string writes all the digits of the kind: `+0.10000000000000001E+000`. This writes `0.1`.
   !< Plain notation for a decimal exponent from -4 to 15, otherwise `1e+23`; `nan`, `inf` and `-inf` for the special values.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = shortest(0.1_R8P)
   !< test_passed(1) = astring%raw=='0.1'
   !< astring = shortest(1.e23_R8P)
   !< test_passed(2) = astring%raw=='1e+23'
   !< astring = shortest(100._R8P)
   !< test_passed(3) = astring%raw=='100.0'
   !< test_passed(4) = astring%to_number(1._R8P)==100._R8P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   real(R8P), intent(in) :: number  !< The number.
   type(string)          :: astring !< The text.
   integer(I8P)          :: bits    !< Bits of the number.
   integer(I8P)          :: digits  !< Decimal digits.
   integer               :: biased  !< Biased exponent.
   integer               :: exponent !< Decimal exponent.

   bits = transfer(number, bits)
   biased = int(ibits(bits, 52, 11))
   if (biased==2047.or.iand(bits, huge(bits))==0_I8P) then
      call shortest_special(biased==2047, ibits(bits, 0, 52)/=0_I8P, btest(bits, 63), astring)
      return
   endif
   call shortest_digits(ibits(bits, 0, 52), biased, 52, digits, exponent)
   call shortest_layout(digits, exponent, btest(bits, 63), astring)
   endfunction shortest_R8P

   elemental function shortest_R4P(number) result(astring)
   !< Return the shortest text that reads back as exactly this number, in the layout of Python's `repr`.
   !<
   !< @note The doctest is not necessary, this being tested by the R8P one and by the oracle.
   real(R4P), intent(in) :: number  !< The number.
   type(string)          :: astring !< The text.
   integer(I4P)          :: bits    !< Bits of the number.
   integer(I8P)          :: digits  !< Decimal digits.
   integer               :: biased  !< Biased exponent.
   integer               :: exponent !< Decimal exponent.

   bits = transfer(number, bits)
   biased = ibits(bits, 23, 8)
   if (biased==255.or.iand(bits, huge(bits))==0_I4P) then
      call shortest_special(biased==255, ibits(bits, 0, 23)/=0_I4P, btest(bits, 31), astring)
      return
   endif
   call shortest_digits(int(ibits(bits, 0, 23), I8P), biased, 23, digits, exponent)
   call shortest_layout(digits, exponent, btest(bits, 31), astring)
   endfunction shortest_R4P

   pure subroutine shortest_special(not_finite, has_fraction, negative, astring)
   !< Return the text of a zero, an infinity or a NaN.
   logical,      intent(in)  :: not_finite   !< An infinity or a NaN, else a zero.
   logical,      intent(in)  :: has_fraction !< With a not finite: a NaN.
   logical,      intent(in)  :: negative     !< The sign bit.
   type(string), intent(out) :: astring      !< The text.

   if (not_finite.and.has_fraction) then
      astring%raw = 'nan'
   elseif (not_finite) then
      astring%raw = merge('-inf', ' inf', negative)
      astring%raw = trim(adjustl(astring%raw))
   else
      astring%raw = merge('-0.0', ' 0.0', negative)
      astring%raw = trim(adjustl(astring%raw))
   endif
   endsubroutine shortest_special

   pure subroutine shortest_layout(digits, exponent, negative, astring)
   !< Lay out digits * 10**exponent as Python's `repr` does.
   integer(I8P), intent(in)  :: digits   !< Decimal digits, no trailing zeros.
   integer,      intent(in)  :: exponent !< Decimal exponent.
   logical,      intent(in)  :: negative !< The sign bit.
   type(string), intent(out) :: astring  !< The text.
   character(len=20)         :: text     !< The digits.
   character(len=:), allocatable :: body !< The text without its sign.
   integer                   :: n        !< Number of digits.
   integer                   :: point    !< Decimal exponent of the first digit, plus 1.
   integer                   :: magnitude !< Absolute value of the exponent field.
   character(len=8)          :: field    !< The exponent field.

   write(text, '(i0)') digits
   n = len_trim(text)
   point = n + exponent
   if (point>=-3.and.point<=16) then
      if (point<=0) then
         body = '0.'//repeat('0', -point)//text(1:n)
      elseif (point>=n) then
         body = text(1:n)//repeat('0', point-n)//'.0'
      else
         body = text(1:point)//'.'//text(point+1:n)
      endif
   else
      magnitude = abs(point - 1)
      write(field, '(i0)') magnitude
      if (magnitude<10) field = '0'//trim(field)
      body = text(1:1)
      if (n>1) body = body//'.'//text(2:n)
      body = body//'e'//merge('-', '+', point - 1<0)//trim(field)
   endif
   if (negative) body = '-'//body
   astring%raw = body
   endsubroutine shortest_layout

   pure function from_codepoints(codes) result(astring)
   !< Return a string given its codepoints, encoded in UTF-8: the inverse of [[string:codepoints]].
   !<
   !< @note A value in -255..-128 gives back the raw byte (the ill-formed bytes of [[string:codepoints]]), so
   !< `from_codepoints(astring%codepoints())` is `astring` for any bytes. Any other value that is not a Unicode scalar
   !< value (a surrogate U+D800..U+DFFF, a value above U+10FFFF or a negative one) gives U+FFFD.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = from_codepoints([104, 233, 20320])
   !< test_passed(1) = astring%raw=='h'//char(195)//char(169)//char(228)//char(189)//char(160)
   !< astring = from_codepoints([97, -255])
   !< test_passed(2) = astring%raw=='a'//char(255)
   !< astring = from_codepoints([55296])
   !< test_passed(3) = astring%raw==char(239)//char(191)//char(189)
   !< astring = 'x'//char(192)//char(175)//'y'
   !< astring = from_codepoints(astring%codepoints())
   !< test_passed(4) = astring%raw=='x'//char(192)//char(175)//'y'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   integer(I4P), intent(in) :: codes(:) !< Codepoints.
   type(string)             :: astring  !< String.
   integer                  :: c        !< Codepoint counter.
   integer                  :: i        !< Byte position.
   integer                  :: n        !< Bytes of a codepoint.

   n = 0
   do c=1, size(codes)
      n = n + utf8_encoded_len(codes(c))
   enddo
   allocate(character(kind=CK, len=n) :: astring%raw)
   i = 1
   do c=1, size(codes)
      n = utf8_encoded_len(codes(c))
      astring%raw(i:i+n-1) = utf8_encode(codes(c))
      i = i + n
   enddo
   endfunction from_codepoints

   pure subroutine strsort(strings, index, less)
   !< Sort an array of strings in place: a stable merge sort, O(n log n) comparisons.
   !<
   !< The order is `less`, a `pure logical function less(a, b)` of two characters (see [[strsort_less]]); by default
   !< [[strless]], the byte order, which is the codepoint order for well-formed UTF-8. [[strless_nocase]] ignores the ASCII
   !< case, [[strless_natural]] compares the runs of digits as numbers (`file2` before `file10`). Strings that are equal
   !< for `less` keep their order. A not allocated string sorts as an empty one and stays not allocated.
   !<
   !< `index`, if passed, returns the permutation: the string now at position `i` was at position `index(i)`.
   !<
   !<```fortran
   !< type(string) :: names(5)
   !< integer      :: perm(5)
   !< logical      :: test_passed(3)
   !< names = [string('file10'), string('File2'), string('file2'), string('b'), string('file1')]
   !< call strsort(names, index=perm)
   !< test_passed(1) = all(names == [string('File2'), string('b'), string('file1'), string('file10'), string('file2')]).and. &
   !<                  all(perm == [2, 4, 5, 1, 3])
   !< call strsort(names, less=strless_natural)
   !< test_passed(2) = all(names == [string('File2'), string('b'), string('file1'), string('file2'), string('file10')])
   !< call strsort(names, less=strless_nocase)
   !< test_passed(3) = all(names == [string('b'), string('file1'), string('file10'), string('File2'), string('file2')])
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   type(string), intent(in out)           :: strings(:) !< The strings, sorted on exit.
   integer,      intent(out),    optional :: index(:)   !< Permutation: the string at i was at index(i); size(strings).
   procedure(strsort_less),      optional :: less       !< Order, default byte order.
   integer,      allocatable              :: order(:)   !< Permutation being sorted.
   integer,      allocatable              :: merged(:)  !< Merge buffer.
   logical,      allocatable              :: null(:)    !< The string was not allocated.
   type(string), allocatable              :: sorted(:)  !< The strings in their new order.
   integer                                :: n          !< Number of strings.
   integer                                :: width      !< Length of the runs being merged.
   integer                                :: first      !< First element of the left run.
   integer                                :: middle     !< Last element of the left run.
   integer                                :: last       !< Last element of the right run.
   integer                                :: l          !< Position in the left run.
   integer                                :: r          !< Position in the right run.
   integer                                :: o          !< Position in the merge buffer.
   integer                                :: i          !< Counter.
   procedure(strsort_less),      pointer  :: is_less    !< The order used.

   is_less => strless
   if (present(less)) is_less => less
   n = size(strings, dim=1)
   allocate(order(n), merged(n), null(n))
   order = [(i, i=1, n)]
   do i=1, n
      null(i) = .not.allocated(strings(i)%raw)
      if (null(i)) strings(i)%raw = ''
   enddo
   width = 1
   do while (width < n) ! bottom-up: merge the runs of length width two by two
      first = 1
      do while (first <= n)
         middle = min(first + width - 1, n)
         last = min(first + 2 * width - 1, n)
         l = first
         r = middle + 1
         o = first
         do while (l <= middle .and. r <= last)
            if (is_less(strings(order(r))%raw, strings(order(l))%raw)) then ! the left element first on ties: stable
               merged(o) = order(r)
               r = r + 1
            else
               merged(o) = order(l)
               l = l + 1
            endif
            o = o + 1
         enddo
         merged(o:o+middle-l) = order(l:middle)
         o = o + middle - l + 1
         merged(o:o+last-r) = order(r:last)
         order(first:last) = merged(first:last)
         first = first + 2 * width
      enddo
      width = 2 * width
   enddo
   allocate(sorted(n))
   do i=1, n
      if (.not.null(order(i))) call move_alloc(from=strings(order(i))%raw, to=sorted(i)%raw)
   enddo
   do i=1, n
      if (allocated(strings(i)%raw)) deallocate(strings(i)%raw)
      if (allocated(sorted(i)%raw)) call move_alloc(from=sorted(i)%raw, to=strings(i)%raw)
   enddo
   if (present(index)) index = order
   endsubroutine strsort

   pure function strless(a, b) result(is_less)
   !< Return true if `a` is before `b` in byte order: the order of [[strsort]] by default.
   !<
   !< @note The bytes compare as unsigned values and a prefix is before the longer string, as Python `bytes` (the
   !< intrinsic `<` pads the shorter string with blanks instead). For well-formed UTF-8 it is the codepoint order.
   !<
   !<```fortran
   !< logical :: test_passed(3)
   !< test_passed(1) = strless('a', 'a'//achar(9))
   !< test_passed(2) = strless('z', char(195)//char(169))
   !< test_passed(3) = .not.strless('ab', 'ab')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: a       !< A string.
   character(kind=CK, len=*), intent(in) :: b       !< Another string.
   logical                               :: is_less !< True if a is before b.
   integer                               :: i       !< Byte counter.

   do i=1, min(len(a), len(b))
      if (a(i:i) /= b(i:i)) then
         is_less = iand(ichar(a(i:i)), 255) < iand(ichar(b(i:i)), 255)
         return
      endif
   enddo
   is_less = len(a) < len(b)
   endfunction strless

   pure function strless_nocase(a, b) result(is_less)
   !< Return true if `a` is before `b` in byte order with the ASCII letters lowercased: an order for [[strsort]].
   !<
   !< @note Strings that differ in the case of their letters only are equal, so [[strsort]] keeps their order.
   !<
   !<```fortran
   !< logical :: test_passed(3)
   !< test_passed(1) = strless_nocase('Apple', 'banana')
   !< test_passed(2) = .not.strless_nocase('ABC', 'abc').and..not.strless_nocase('abc', 'ABC')
   !< test_passed(3) = strless('Z', '_').and..not.strless_nocase('Z', '_') ! '_' is between 'Z' and 'z'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: a       !< A string.
   character(kind=CK, len=*), intent(in) :: b       !< Another string.
   logical                               :: is_less !< True if a is before b.
   integer                               :: i       !< Byte counter.
   integer                               :: ca      !< Byte of a, lowercased.
   integer                               :: cb      !< Byte of b, lowercased.

   do i=1, min(len(a), len(b))
      ca = iand(ichar(a(i:i)), 255)
      cb = iand(ichar(b(i:i)), 255)
      if (ca >= 65 .and. ca <= 90) ca = ca + CASE_SHIFT
      if (cb >= 65 .and. cb <= 90) cb = cb + CASE_SHIFT
      if (ca /= cb) then
         is_less = ca < cb
         return
      endif
   enddo
   is_less = len(a) < len(b)
   endfunction strless_nocase

   pure function strless_natural(a, b) result(is_less)
   !< Return true if `a` is before `b` in natural order: an order for [[strsort]], with `file2` before `file10`.
   !<
   !< @note The strings are compared run by run, a run being a maximal sequence of ASCII digits or of other bytes. Two runs
   !< of digits compare as numbers, of any size (`007` equals `7`); other runs compare in byte order, as [[strless]],
   !< and a run of digits compares with another run by its first byte. When all the runs are equal the string with fewer
   !< runs is first. Strings that differ only in leading zeros are equal, so [[strsort]] keeps their order.
   !<
   !<```fortran
   !< logical :: test_passed(4)
   !< test_passed(1) = strless_natural('file2', 'file10')
   !< test_passed(2) = strless_natural('v1.9.1', 'v1.10.0')
   !< test_passed(3) = .not.strless_natural('a007', 'a7').and..not.strless_natural('a7', 'a007')
   !< test_passed(4) = strless_natural('x99999999999999999999998', 'x99999999999999999999999')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: a       !< A string.
   character(kind=CK, len=*), intent(in) :: b       !< Another string.
   logical                               :: is_less !< True if a is before b.
   integer                               :: i       !< Start of the current run of a.
   integer                               :: j       !< Start of the current run of b.
   integer                               :: ie      !< End of the run of a.
   integer                               :: je      !< End of the run of b.
   integer                               :: is      !< First significant digit of a run of a.
   integer                               :: js      !< First significant digit of a run of b.
   integer                               :: k       !< Byte counter.

   i = 1
   j = 1
   do while (i <= len(a) .and. j <= len(b))
      ie = run_end(a, i)
      je = run_end(b, j)
      if (is_digit_char(a(i:i)) .and. is_digit_char(b(j:j))) then ! two numbers
         is = i
         do while (is < ie .and. a(is:is) == '0')
            is = is + 1
         enddo
         js = j
         do while (js < je .and. b(js:js) == '0')
            js = js + 1
         enddo
         if (ie - is /= je - js) then ! more significant digits, larger number
            is_less = ie - is < je - js
            return
         endif
         do k=0, ie - is
            if (a(is+k:is+k) /= b(js+k:js+k)) then
               is_less = a(is+k:is+k) < b(js+k:js+k)
               return
            endif
         enddo
      elseif (a(i:ie) /= b(j:je) .or. ie - i /= je - j) then ! two runs, compared as bytes
         is_less = strless(a(i:ie), b(j:je))
         return
      endif
      i = ie + 1
      j = je + 1
   enddo
   is_less = i > len(a) .and. j <= len(b)
   contains
      pure function run_end(raw, first) result(last)
      !< Return the last byte of the run starting at first: a run of digits, or of other bytes.
      character(kind=CK, len=*), intent(in) :: raw   !< Bytes.
      integer,                   intent(in) :: first !< First byte of the run.
      integer                               :: last  !< Last byte of the run.
      logical                               :: digit !< The run is of digits.

      digit = is_digit_char(raw(first:first))
      last = first
      do while (last < len(raw))
         if (is_digit_char(raw(last+1:last+1)) .neqv. digit) exit
         last = last + 1
      enddo
      endfunction run_end
   endfunction strless_natural

   ! builtins replacements
   pure function sadjustl_character(s) result(adjusted)
   !< Left adjust a string by removing leading spaces (character output).
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = '   Hello World!'
   !< print "(L1)", adjustl(astring)=='Hello World!   '
   !<```
   !=> T <<<
   class(string), intent(in)              :: s        !< String.
   character(kind=CK, len=:), allocatable :: adjusted !< Adjusted string.

   if (allocated(s%raw)) adjusted = adjustl(s%raw)
   endfunction sadjustl_character

   pure function sadjustr_character(s) result(adjusted)
   !< Right adjust a string by removing leading spaces (character output).
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'Hello World!   '
   !< print "(L1)", adjustr(astring)=='   Hello World!'
   !<```
   !=> T <<<
   class(string), intent(in)              :: s        !< String.
   character(kind=CK, len=:), allocatable :: adjusted !< Adjusted string.

   if (allocated(s%raw)) adjusted = adjustr(s%raw)
   endfunction sadjustr_character

   elemental function count_substring(s, substring, overlapping) result(No)
   !< Count the number of occurences of a substring into a string.
   !<
   !< @note The occurrences are not overlapping, counted from left to right (as Python `str.count`), unless `overlapping` is
   !< true. A null substring has no occurrences.
   !<
   !<```fortran
   !< logical :: test_passed(6)
   !< test_passed(1) = count('hello', substring='ll')==1
   !< test_passed(2) = count('aaaa', substring='a')==4
   !< test_passed(3) = count('aaaa', substring='aa')==2
   !< test_passed(4) = count('abc', substring='')==0
   !< test_passed(5) = count('aaaa', substring='aa', overlapping=.true.)==3
   !< test_passed(6) = count('abab', substring='ab', overlapping=.true.)==2
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(*), intent(in)           :: s           !< String.
   character(*), intent(in)           :: substring   !< Substring.
   logical,      intent(in), optional :: overlapping !< Count the overlapping occurrences too.
   integer(I4P)                       :: No          !< Number of occurrences.
   integer(I4P)                       :: c1          !< Counters.
   integer(I4P)                       :: c2          !< Counters.
   integer(I4P)                       :: step        !< Advance after an occurrence.

   No = 0
   if (len(substring)==0.or.len(substring)>len(s)) return
   step = len(substring)
   if (present(overlapping)) then
     if (overlapping) step = 1
   endif
   c1 = 1
   do
     c2 = index(string=s(c1:), substring=substring)
     if (c2==0) return
     No = No + 1
     c1 = c1 + c2 - 1 + step
   enddo
   endfunction count_substring

   elemental function sindex_character_string(s, substring, back, occurrence) result(i)
   !< Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
   !< If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
   !< the start of the last occurrence rather than the first.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(2)
   !< string1 = 'llo'
   !< test_passed(1) = index(s='Hello World Hello!', substring=string1)==index(string='Hello World Hello!', substring='llo')
   !< test_passed(2) = index(s='Hello World Hello!', substring=string1, back=.true.)==index(string='Hello World Hello!', &
   !<                                                                                       substring='llo', back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)           :: s          !< String.
   type(string),              intent(in)           :: substring  !< Searched substring.
   logical,                   intent(in), optional :: back       !< Start of the last occurrence rather than the first.
   integer,                   intent(in), optional :: occurrence !< Number of the occurrence, default 1.
   integer                                         :: i          !< Result of the search.

   i = 0
   if (allocated(substring%raw)) then
     if (present(occurrence)) then
       i = find_occurrence(raw=s, substring=substring%raw, occurrence=occurrence, back=back)
     else
       i = index(string=s, substring=substring%raw, back=back)
     endif
   endif
   endfunction sindex_character_string

   elemental function sscan_character_string(s, set, back) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(2)
   !< string1 = 'llo'
   !< test_passed(1) = scan(s='Hello World Hello!', set=string1)==scan(string='Hello World Hello!', set='llo')
   !< test_passed(2) = scan(s='Hello World Hello!', set=string1, back=.true.)==scan(string='Hello World Hello!', &
   !<                                                                               set='llo', back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)           :: s    !< String.
   type(string),              intent(in)           :: set  !< Searched set.
   logical,                   intent(in), optional :: back !< Start of the last occurrence rather than the first.
   integer                                         :: i    !< Result of the search.

   if (allocated(set%raw)) then
     i = utf8_scan(raw=s, set=set%raw, back=back, inside=.true.)
   else
     i = 0
   endif
   endfunction sscan_character_string

   elemental function sverify_character_string(s, set, back) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
   !< in `set`. If all characters of `string` are found in `set`, the result is zero.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(2)
   !< string1 = 'ell'
   !< test_passed(1) = verify(s='Hello World Hello!', set=string1)==verify(string='Hello World Hello!', set='llo')
   !< test_passed(2) = verify(s='Hello World Hello!', set=string1, back=.true.)==verify(string='Hello World Hello!', set='llo', &
   !<                                                                                   back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)           :: s    !< String.
   type(string),              intent(in)           :: set  !< Searched set.
   logical,                   intent(in), optional :: back !< Start of the last occurrence rather than the first.
   integer                                         :: i    !< Result of the search.

   if (allocated(set%raw)) then
     i = utf8_scan(raw=s, set=set%raw, back=back, inside=.false.)
   else
     i = 0
   endif
   endfunction sverify_character_string

   ! public methods

   ! builtins replacements
   elemental function sadjustl(self) result(adjusted)
   !< Left adjust a string by removing leading spaces.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = '   Hello World!'
   !< print "(L1)", astring%adjustl()//''=='Hello World!   '
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   type(string)              :: adjusted !< Adjusted string.

   adjusted = self
   if (allocated(adjusted%raw)) adjusted%raw = adjustl(adjusted%raw)
   endfunction sadjustl

   elemental function sadjustr(self) result(adjusted)
   !< Right adjust a string by removing leading spaces.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'Hello World!   '
   !< print "(L1)", astring%adjustr()//''=='   Hello World!'
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   type(string)              :: adjusted !< Adjusted string.

   adjusted = self
   if (allocated(adjusted%raw)) adjusted%raw = adjustr(adjusted%raw)
   endfunction sadjustr

   elemental function scount(self, substring, ignore_isolated, overlapping) result(No)
   !< Count the number of occurences of a substring into a string.
   !<
   !< @note The occurrences are not overlapping, counted from left to right (as Python `str.count`), unless `overlapping` is
   !< true: `'aaaa'` holds 2 occurrences of `'aa'`, 3 overlapping ones.
   !<
   !< @note If `ignore_isolated` is set to true the eventual "isolated" occurences are ignored: an isolated occurrences are those
   !< occurrences happening at the start of string (thus not having a left companion) or at the end of the string (thus not having a
   !< right companion).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(6)
   !< astring = '   Hello World  !    '
   !< test_passed(1) = astring%count(substring=' ')==10
   !< astring = 'Hello World  !    '
   !< test_passed(2) = astring%count(substring=' ', ignore_isolated=.true.)==6
   !< astring = '    Hello World  !'
   !< test_passed(3) = astring%count(substring=' ', ignore_isolated=.true.)==6
   !< astring = '   Hello World  !    '
   !< test_passed(4) = astring%count(substring=' ', ignore_isolated=.true.)==8
   !< test_passed(5) = astring%count(substring='')==0
   !< astring = 'aaaa'
   !< test_passed(6) = astring%count('aa')==2.and.astring%count('aa', overlapping=.true.)==3
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: self             !< The string.
   character(*),  intent(in)              :: substring        !< Substring.
   logical,       intent(in), optional    :: ignore_isolated  !< Ignore "isolated" occurrences.
   logical,       intent(in), optional    :: overlapping      !< Count the overlapping occurrences too.
   integer                                :: No               !< Number of occurrences.
   logical                                :: ignore_isolated_ !< Ignore "isolated" occurrences, local variable.
   integer                                :: c1               !< Counter.
   integer                                :: c2               !< Counter.
   integer                                :: step             !< Advance after an occurrence.

   No = 0
   if (allocated(self%raw)) then
      if (len(substring)==0.or.len(substring)>len(self%raw)) return
      ignore_isolated_ = .false. ; if (present(ignore_isolated)) ignore_isolated_ = ignore_isolated
      step = len(substring)
      if (present(overlapping)) then
         if (overlapping) step = 1
      endif
      c1 = 1
      do
         c2 = index(string=self%raw(c1:), substring=substring)
         if (c2==0) return
         if (.not.ignore_isolated_) then
            No = No + 1
         else
            if (.not.((c1==1.and.c2==1) .or. (c1==len(self%raw)-len(substring)+1))) then
               No = No + 1
            endif
         endif
         c1 = c1 + c2 - 1 + step
      enddo
   endif
   endfunction scount

   elemental function sindex_string_string(self, substring, back, occurrence, by) result(i)
   !< Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
   !< If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
   !< the start of the last occurrence rather than the first.
   !<
   !< @note With `occurrence=k` the start of the k-th occurrence is returned (counted from the end if `back` is true), zero if
   !< there are fewer: the occurrences are not overlapping, as for [[string:count]].
   !<
   !<```fortran
   !< type(string) :: string1
   !< type(string) :: string2
   !< logical      :: test_passed(4)
   !< string1 = 'Hello World Hello!'
   !< string2 = 'llo'
   !< test_passed(1) = string1%index(substring=string2)==index(string='Hello World Hello!', substring='llo')
   !< test_passed(2) = string1%index(substring=string2, back=.true.)==index(string='Hello World Hello!', substring='llo', &
   !<                                                                       back=.true.)
   !< string1 = 'ab-ab-ab'
   !< string2 = 'ab'
   !< test_passed(3) = string1%index(string2, occurrence=2)==4.and.string1%index(string2, occurrence=4)==0
   !< test_passed(4) = string1%index(string2, back=.true., occurrence=2)==4
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self       !< The string.
   type(string),  intent(in)           :: substring  !< Searched substring.
   logical,       intent(in), optional :: back       !< Start of the last occurrence rather than the first.
   integer,       intent(in), optional :: occurrence !< Number of the occurrence, default 1.
   integer,       intent(in), optional :: by         !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                             :: i          !< Result of the search.

   i = 0
   if (allocated(self%raw).and.allocated(substring%raw)) then
      if (present(occurrence)) then
         i = find_occurrence(raw=self%raw, substring=substring%raw, occurrence=occurrence, back=back)
      else
         i = index(string=self%raw, substring=substring%raw, back=back)
      endif
      i = to_unit(self%raw, i, by)
   endif
   endfunction sindex_string_string

   elemental function sindex_string_character(self, substring, back, occurrence, by) result(i)
   !< Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
   !< If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
   !< the start of the last occurrence rather than the first.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(2)
   !< string1 = 'Hello World Hello!'
   !< test_passed(1) = string1%index(substring='llo')==index(string='Hello World Hello!', substring='llo')
   !< test_passed(2) = string1%index(substring='llo', back=.true.)==index(string='Hello World Hello!', substring='llo', back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   character(kind=CK, len=*), intent(in)           :: substring  !< Searched substring.
   logical,                   intent(in), optional :: back       !< Start of the last occurrence rather than the first.
   integer,                   intent(in), optional :: occurrence !< Number of the occurrence, default 1.
   integer,                   intent(in), optional :: by         !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                                         :: i          !< Result of the search.

   i = 0
   if (allocated(self%raw)) then
      if (present(occurrence)) then
         i = find_occurrence(raw=self%raw, substring=substring, occurrence=occurrence, back=back)
      else
         i = index(string=self%raw, substring=substring, back=back)
      endif
      i = to_unit(self%raw, i, by)
   endif
   endfunction sindex_string_character

   elemental function slen(self, by) result(l)
   !< Return the length of a string, in bytes or, with `by=SF_CHARS`, in characters.
   !<
   !< @note A character is a unit: a well-formed UTF-8 sequence, or a byte that is not part of one.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'Hello World!   '
   !< test_passed(1) = astring%len()==len('Hello World!   ')
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(2) = astring%len()==5
   !< test_passed(3) = astring%len(by=SF_CHARS)==4
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self !< The string.
   integer,       intent(in), optional :: by   !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                             :: l    !< String length.

   l = 0
   if (allocated(self%raw)) then
      l = len(string=self%raw)
      if (present(by)) then
         if (by==SF_CHARS) l = utf8_units(self%raw)
      endif
   endif
   endfunction slen

   elemental function slen_trim(self) result(l)
   !< Return the length of a string, ignoring any trailing blanks.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'Hello World!   '
   !< print "(L1)", astring%len_trim()==len_trim('Hello World!   ')
   !<```
   !=> T <<<
   class(string), intent(in) :: self !< The string.
   integer                   :: l    !< String length.

   if (allocated(self%raw)) then
      l = len_trim(string=self%raw)
   else
      l = 0
   endif
   endfunction slen_trim

   elemental function srepeat_string_string(self, ncopies) result(repeated)
   !< Concatenates several copies of an input string.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'x'
   !< print "(L1)", astring%repeat(5)//''=='xxxxx'
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< String to be repeated.
   integer,       intent(in) :: ncopies  !< Number of string copies.
   type(string)              :: repeated !< Repeated string.
#ifdef _NVF
   character(9999)           :: nvf_bug  !< Work around for NVFortran bug.
#endif

#ifdef _NVF
   nvf_bug = self%raw
   repeated%raw = repeat(string=trim(nvf_bug), ncopies=ncopies)
#else
   repeated%raw = repeat(string=self%raw, ncopies=ncopies)
#endif
   endfunction srepeat_string_string

   elemental function srepeat_character_string(rstring, ncopies) result(repeated)
   !< Concatenates several copies of an input string.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'y'
   !< print "(L1)", astring%repeat('x', 5)//''=='xxxxx'
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: rstring  !< String to be repeated.
   integer,                   intent(in) :: ncopies  !< Number of string copies.
   type(string)                          :: repeated !< Repeated string.

   repeated%raw = repeat(string=rstring, ncopies=ncopies)
   endfunction srepeat_character_string

   elemental function sscan_string_string(self, set, back, by) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.
   !<
   !<```fortran
   !< type(string) :: string1
   !< type(string) :: string2
   !< logical      :: test_passed(2)
   !< string1 = 'Hello World Hello!'
   !< string2 = 'llo'
   !< test_passed(1) = string1%scan(set=string2)==scan(string='Hello World Hello!', set='llo')
   !< test_passed(2) = string1%scan(set=string2, back=.true.)==scan(string='Hello World Hello!', set='llo', back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self  !< The string.
   type(string),  intent(in)           :: set   !< Searched set.
   logical,       intent(in), optional :: back  !< Start of the last occurrence rather than the first.
   integer,       intent(in), optional :: by    !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                             :: i     !< Result of the search.

   if (allocated(self%raw).and.allocated(set%raw)) then
     i = utf8_scan(raw=self%raw, set=set%raw, back=back, inside=.true.)
     i = to_unit(self%raw, i, by)
   else
     i = 0
   endif
   endfunction sscan_string_string

   elemental function sscan_string_character(self, set, back, by) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.
   !<
   !< @note The string and the set are made of units: a well-formed UTF-8 sequence, or a byte that is not part of one. A
   !< unit matches a member of the set only as a whole (`a`//U+00E3 has no member of the set U+00E9, though both start with
   !< the byte C3), and the result is the byte position of the first byte of the unit found.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(4)
   !< string1 = 'Hello World Hello!'
   !< test_passed(1) = string1%scan(set='llo')==scan(string='Hello World Hello!', set='llo')
   !< test_passed(2) = string1%scan(set='llo', back=.true.)==scan(string='Hello World Hello!', set='llo', back=.true.)
   !< string1 = 'a'//char(195)//char(163)
   !< test_passed(3) = string1%scan(set=char(195)//char(169))==0
   !< test_passed(4) = string1%scan(set='x'//char(195)//char(163))==2
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self  !< The string.
   character(kind=CK, len=*), intent(in)           :: set   !< Searched set.
   logical,                   intent(in), optional :: back  !< Start of the last occurrence rather than the first.
   integer,                   intent(in), optional :: by    !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                                         :: i     !< Result of the search.

   if (allocated(self%raw)) then
     i = utf8_scan(raw=self%raw, set=set, back=back, inside=.true.)
     i = to_unit(self%raw, i, by)
   else
     i = 0
   endif
   endfunction sscan_string_character

   elemental function strim(self) result(trimmed)
   !< Remove trailing spaces.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'Hello World!   '
   !< print "(L1)", astring%trim()==trim('Hello World!   ')
   !<```
   !=> T <<<
   class(string), intent(in) :: self    !< The string.
   type(string)              :: trimmed !< Trimmed string.

   trimmed = self
   if (allocated(trimmed%raw)) trimmed%raw = trim(trimmed%raw)
   endfunction strim

   elemental function sverify_string_string(self, set, back, by) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
   !< in `set`. If all characters of `string` are found in `set`, the result is zero.
   !<
   !<```fortran
   !< type(string) :: string1
   !< type(string) :: string2
   !< logical      :: test_passed(2)
   !< string1 = 'Hello World Hello!'
   !< string2 = 'llo'
   !< test_passed(1) = string1%verify(set=string2)==verify(string='Hello World Hello!', set='llo')
   !< test_passed(2) = string1%verify(set=string2, back=.true.)==verify(string='Hello World Hello!', set='llo', back=.true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self  !< The string.
   type(string),  intent(in)           :: set   !< Searched set.
   logical,       intent(in), optional :: back  !< Start of the last occurrence rather than the first.
   integer,       intent(in), optional :: by    !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                             :: i     !< Result of the search.

   if (allocated(self%raw).and.allocated(set%raw)) then
     i = utf8_scan(raw=self%raw, set=set%raw, back=back, inside=.false.)
     i = to_unit(self%raw, i, by)
   else
     i = 0
   endif
   endfunction sverify_string_string

   elemental function sverify_string_character(self, set, back, by) result(i)
   !< Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
   !< in `set`. If all characters of `string` are found in `set`, the result is zero.
   !<
   !< @note The string and the set are made of units: a well-formed UTF-8 sequence, or a byte that is not part of one. A
   !< unit matches a member of the set only as a whole (`a`//U+00E3 has no member of the set U+00E9, though both start with
   !< the byte C3), and the result is the byte position of the first byte of the unit found.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(4)
   !< string1 = 'Hello World Hello!'
   !< test_passed(1) = string1%verify(set='llo')==verify(string='Hello World Hello!', set='llo')
   !< test_passed(2) = string1%verify(set='llo', back=.true.)==verify(string='Hello World Hello!', set='llo', back=.true.)
   !< string1 = 'a'//char(195)//char(169)
   !< test_passed(3) = string1%verify(set='a', back=.true.)==2
   !< test_passed(4) = string1%verify(set='a'//char(195)//char(169))==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self  !< The string.
   character(kind=CK, len=*), intent(in)           :: set   !< Searched set.
   logical,                   intent(in), optional :: back  !< Start of the last occurrence rather than the first.
   integer,                   intent(in), optional :: by    !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                                         :: i     !< Result of the search.

   if (allocated(self%raw)) then
     i = utf8_scan(raw=self%raw, set=set, back=back, inside=.false.)
     i = to_unit(self%raw, i, by)
   else
     i = 0
   endif
   endfunction sverify_string_character

   ! auxiliary methods
   elemental function basedir(self, sep)
   !< Return the base directory name of a string containing a file name.
   !<
   !< @note A file name without a directory has a null base directory.
   !<
   !<```fortran
   !< type(string) :: string1
   !< logical      :: test_passed(5)
   !< string1 = '/bar/foo.tar.bz2'
   !< test_passed(1) = string1%basedir()//''=='/bar'
   !< string1 = './bar/foo.tar.bz2'
   !< test_passed(2) = string1%basedir()//''=='./bar'
   !< string1 = 'bar/foo.tar.bz2'
   !< test_passed(3) = string1%basedir()//''=='bar'
   !< string1 = '\bar\foo.tar.bz2'
   !< test_passed(4) = string1%basedir(sep='\')//''=='\bar'
   !< string1 = 'foo.tar.bz2'
   !< test_passed(5) = string1%basedir()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self    !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep     !< Directory separator.
   type(string)                                    :: basedir !< Base directory name.
   character(kind=CK, len=:), allocatable          :: sep_    !< Separator, default value.
   integer                                         :: pos     !< Character position.

   if (allocated(self%raw)) then
     sep_ = UIX_DIR_SEP ; if (present(sep)) sep_ = sep
     pos = index(self%raw, sep_, back=.true.)
     basedir%raw = self%raw(1:max(pos-1, 0))
   endif
   endfunction basedir

   elemental function basename(self, sep, extension, strip_last_extension)
   !< Return the base file name of a string containing a file name.
   !<
   !< Optionally, the extension is also stripped if provided or the last one if required, e.g.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(5)
   !< astring = 'bar/foo.tar.bz2'
   !< test_passed(1) = astring%basename()//''=='foo.tar.bz2'
   !< test_passed(2) = astring%basename(extension='.tar.bz2')//''=='foo'
   !< test_passed(3) = astring%basename(strip_last_extension=.true.)//''=='foo.tar'
   !< astring = '\bar\foo.tar.bz2'
   !< test_passed(4) = astring%basename(sep='\')//''=='foo.tar.bz2'
   !< astring = 'bar'
   !< test_passed(5) = astring%basename(strip_last_extension=.true.)//''=='bar'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self                 !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep                  !< Directory separator.
   character(kind=CK, len=*), intent(in), optional :: extension            !< File extension.
   logical,                   intent(in), optional :: strip_last_extension !< Flag to enable the stripping of last extension.
   type(string)                                    :: basename             !< Base file name.
   character(kind=CK, len=:), allocatable          :: sep_                 !< Separator, default value.
   integer                                         :: pos                  !< Character position.

   if (allocated(self%raw)) then
      sep_ = UIX_DIR_SEP ; if (present(sep)) sep_ = sep
      basename = self
      pos = index(basename%raw, sep_, back=.true.)
      if (pos>0) basename%raw = self%raw(pos+1:)
      if (present(extension)) then
         pos = index(basename%raw, extension, back=.true.)
         if (pos>0) basename%raw = basename%raw(1:pos-1)
      elseif (present(strip_last_extension)) then
         if (strip_last_extension) then
            pos = index(basename%raw, '.', back=.true.)
            if (pos>0) basename%raw = basename%raw(1:pos-1)
         endif
      endif
   endif
   endfunction basename

   elemental function camelcase(self, sep)
   !< Return a string with all words capitalized without spaces.
   !<
   !< @note Multiple subsequent separators are collapsed to one occurence.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = 'caMeL caSe var'
   !< test_passed(1) = astring%camelcase()//''=='CamelCaseVar'
   !< astring = '   '
   !< test_passed(2) = astring%camelcase()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: camelcase !< Camel case string.
   type(string), allocatable                       :: tokens(:) !< String tokens.

   if (allocated(self%raw)) then
     call self%split(tokens=tokens, sep=sep)
     tokens = tokens%capitalize()
     camelcase = camelcase%join(array=tokens)
   endif
   endfunction camelcase

   elemental function capitalize(self) result(capitalized)
   !< Return a string with its first character capitalized and the rest lowercased.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = 'say all Hello WorLD!'
   !< test_passed(1) = astring%capitalize()//''=='Say all hello world!'
   !< astring = ''
   !< test_passed(2) = astring%capitalize()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self        !< The string.
   type(string)              :: capitalized !< Upper case string.

   if (allocated(self%raw)) then
     capitalized = self%lower()
     if (len(capitalized%raw)>0) then
       capitalized%raw(1:1) = upper_char(capitalized%raw(1:1))
     endif
   endif
   endfunction capitalize

   elemental function center(self, width, fill_char, by) result(centered)
   !< Return the string centered in a string of length `width`, padded with `fill_char` (default a space).
   !<
   !< @note As Python `str.center`: a string not shorter than `width` is returned unchanged; when the padding is odd the extra
   !< fill character goes on the left if `width` is odd, on the right otherwise.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: centered
   !< logical      :: test_passed(6)
   !< astring = 'abc'
   !< test_passed(1) = astring%center(7, '*')//''=='**abc**'
   !< centered = astring%center(6)
   !< test_passed(2) = centered%len()==6.and.centered//''==' abc'
   !< test_passed(3) = astring%center(2)//''=='abc'
   !< astring = 'ab'
   !< test_passed(4) = astring%center(5, '-')//''=='--ab-'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(5) = astring%center(6, '*', by=SF_CHARS)//''=='*'//'caf'//char(195)//char(169)//'*'
   !< astring = char(228)//char(189)//char(160)
   !< test_passed(6) = astring%center(6, '*', by=SF_COLUMNS)//''=='**'//char(228)//char(189)//char(160)//'**'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   integer,                   intent(in)           :: width      !< Width of the result.
   character(kind=CK, len=1), intent(in), optional :: fill_char  !< Fill character, default a space.
   integer,                   intent(in), optional :: by         !< Unit of width: SF_BYTES (default) or SF_CHARS.
   type(string)                                    :: centered   !< The string centered.
   character(kind=CK, len=1)                       :: fill_char_ !< Fill character, local variable.
   integer                                         :: size_      !< Length of the string, in the unit of width.
   integer                                         :: margin     !< Number of fill characters.
   integer                                         :: left       !< Number of fill characters on the left.

   if (allocated(self%raw)) then
      size_ = measure(self%raw, by)
      fill_char_ = SPACE ; if (present(fill_char)) fill_char_ = fill_char
      margin = width - size_
      if (margin<=0) then
         centered = self
      else
         left = margin / 2 + iand(iand(margin, width), 1)
         centered%raw = repeat(fill_char_, left)//self%raw//repeat(fill_char_, margin - left)
      endif
   endif
   endfunction center

   pure function codepoints(self) result(codes)
   !< Return the codepoints of the string, one per unit (a well-formed UTF-8 sequence, or a byte that is not part of one).
   !<
   !< @note A byte that is not part of a well-formed UTF-8 sequence (Unicode Table 3-7: an overlong form, a surrogate, a
   !< value above U+10FFFF, a truncated sequence, a stray continuation byte) is returned as minus its value, -255..-128:
   !< the result is never confused with a codepoint, and [[from_codepoints]] gives back the same bytes. A null or not
   !< allocated string gives an empty array.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'h'//char(195)//char(169)//char(228)//char(189)//char(160)
   !< test_passed(1) = all(astring%codepoints()==[104, 233, 20320])
   !< astring = 'a'//char(255)//char(192)//char(175)
   !< test_passed(2) = all(astring%codepoints()==[97, -255, -192, -175])
   !< astring = char(240)//char(159)//char(152)//char(128)
   !< test_passed(3) = all(astring%codepoints()==[128512])
   !< astring = ''
   !< test_passed(4) = size(astring%codepoints())==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer(I4P), allocatable :: codes(:) !< Codepoints.
   integer                   :: c        !< Codepoint counter.
   integer                   :: i        !< Byte position.
   integer                   :: n        !< Bytes of a unit.

   if (.not.allocated(self%raw)) then
      allocate(codes(0))
      return
   endif
   allocate(codes(utf8_units(self%raw)))
   i = 1
   do c=1, size(codes)
      call utf8_decode(self%raw, i, codes(c), n)
      i = i + n
   enddo
   endfunction codepoints

   elemental function byte_pos(self, char_pos) result(position)
   !< Return the byte position of the first byte of the character number `char_pos`.
   !<
   !< @note A character is a unit: a well-formed UTF-8 sequence, or a byte that is not part of one. One past the last
   !< character gives `len+1`; any other position out of the string gives 0. The inverse is [[string:char_pos]].
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(195)//char(169)//'!'
   !< test_passed(1) = astring%byte_pos(4)==4
   !< test_passed(2) = astring%byte_pos(5)==6
   !< test_passed(3) = astring%byte_pos(6)==7
   !< test_passed(4) = astring%byte_pos(7)==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer,       intent(in) :: char_pos !< Character number.
   integer                   :: position !< Byte position.

   if (allocated(self%raw)) then
      position = utf8_byte_pos(self%raw, char_pos)
   else
      position = merge(1, 0, char_pos==1)
   endif
   endfunction byte_pos

   elemental function char_pos(self, byte_pos) result(position)
   !< Return the number of the character holding the byte at `byte_pos`.
   !<
   !< @note A character is a unit: a well-formed UTF-8 sequence, or a byte that is not part of one. `len+1` gives the
   !< number of characters + 1; any other position out of the string gives 0. The inverse is [[string:byte_pos]].
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(195)//char(169)//'!'
   !< test_passed(1) = astring%char_pos(4)==4
   !< test_passed(2) = astring%char_pos(5)==4
   !< test_passed(3) = astring%char_pos(6)==5
   !< test_passed(4) = astring%char_pos(7)==6
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer,       intent(in) :: byte_pos !< Byte position.
   integer                   :: position !< Character number.

   if (allocated(self%raw)) then
      position = utf8_char_pos(self%raw, byte_pos)
   else
      position = merge(1, 0, byte_pos==1)
   endif
   endfunction char_pos

   pure function chars(self) result(raw)
   !< Return the raw characters data.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'say all Hello WorLD!'
   !< print '(L1)', astring%chars()=='say all Hello WorLD!'
   !<```
   !=> T <<<
   class(string), intent(in)              :: self !< The string.
   character(kind=CK, len=:), allocatable :: raw  !< Raw characters data.

   if (allocated(self%raw)) then
     raw = self%raw
   else
     raw = ''
   endif
   endfunction chars

   pure function colorize_str(self, color_fg, color_bg, style) result(colorized)
   !< Colorize and stylize strings, DEFAULT kind.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'say all Hello WorLD!'
   !< print '(L1)', astring%colorize(color_fg='red')=='[31msay all Hello WorLD![0m'
   !<```
   !=> T <<<
   class(string),    intent(in)           :: self      !< The string.
   character(len=*), intent(in), optional :: color_fg  !< Foreground color definition.
   character(len=*), intent(in), optional :: color_bg  !< Background color definition.
   character(len=*), intent(in), optional :: style     !< Style definition.
   character(len=:), allocatable          :: colorized !< Colorized string.

   colorized = colorize(string=self%chars(), color_fg=color_fg, color_bg=color_bg, style=style)
   endfunction colorize_str

   elemental function common_prefix_string(self, other) result(prefix)
   !< Return the longest common prefix shared with another string.
   !<
   !< @note An unallocated `other` shares only the null prefix.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(3)
   !< astring = 'src/lib/stringifor.F90'
   !< anotherstring = 'src/lib/stringifor_string_t.F90'
   !< test_passed(1) = astring%common_prefix(anotherstring)//''=='src/lib/stringifor'
   !< anotherstring = 'docs/index.md'
   !< test_passed(2) = astring%common_prefix(anotherstring)//''==''
   !< call anotherstring%free
   !< test_passed(3) = astring%common_prefix(anotherstring)//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self   !< The string.
   type(string),  intent(in) :: other  !< Other string.
   type(string)              :: prefix !< Longest common prefix.

   if (allocated(other%raw)) then
      prefix = self%common_prefix_character(other=other%raw)
   else
      prefix = self%common_prefix_character(other='')
   endif
   endfunction common_prefix_string

   elemental function common_prefix_character(self, other) result(prefix)
   !< Return the longest common prefix shared with a character.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: prefix
   !< logical      :: test_passed(4)
   !< astring = 'flower'
   !< test_passed(1) = astring%common_prefix('flow')//''=='flow'
   !< test_passed(2) = astring%common_prefix('flight')//''=='fl'
   !< test_passed(3) = astring%common_prefix('dog')//''==''
   !< call astring%free
   !< prefix = astring%common_prefix('flow')
   !< test_passed(4) = prefix%is_allocated().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: self   !< The string.
   character(kind=CK, len=*), intent(in) :: other  !< Other string.
   type(string)                          :: prefix !< Longest common prefix.
   integer                               :: c      !< Character counter.

   if (allocated(self%raw)) then
      c = 0
      do while (c<min(len(self%raw), len(other)))
         if (self%raw(c+1:c+1)/=other(c+1:c+1)) exit
         c = c + 1
      enddo
      prefix%raw = self%raw(1:c)
   endif
   endfunction common_prefix_character

   pure function common_prefix_strings(self, array) result(prefix)
   !< Return the longest common prefix shared with all the elements of an array of strings.
   !<
   !< @note An unallocated element of `array` shares only the null prefix.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: strings(3)
   !< logical      :: test_passed(3)
   !< strings(1) = 'flower'
   !< strings(2) = 'flow'
   !< strings(3) = 'flight'
   !< astring = strings(1)%common_prefix(array=strings)
   !< test_passed(1) = astring//''=='fl'
   !< astring = strings(1)%common_prefix(array=strings(1:2))
   !< test_passed(2) = astring//''=='flow'
   !< strings(1) = 'dog'
   !< strings(2) = 'racecar'
   !< strings(3) = 'car'
   !< astring = strings(1)%common_prefix(array=strings)
   !< test_passed(3) = astring//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   type(string),  intent(in) :: array(1:) !< Array of other strings.
   type(string)              :: prefix    !< Longest common prefix.
   integer                   :: a         !< Counter.

   if (allocated(self%raw)) then
      prefix = self
      do a=1, size(array, dim=1)
         prefix = prefix%common_prefix_string(other=array(a))
      enddo
   endif
   endfunction common_prefix_strings

   elemental function compact(self, sep, unicode) result(compacted)
   !< Return the words of the string separated by `sep` (default a space): every run of whitespace becomes one separator, the
   !< leading and trailing whitespace is removed.
   !<
   !< @note As Python `sep.join(s.split())`; the whitespace is the one of [[string:is_space]], ASCII or, with
   !< `unicode=.true.`, Unicode White_Space. A null `sep` removes it.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = '  one'//achar(9)//' two'//new_line('a')//'three  '
   !< test_passed(1) = astring%compact()//''=='one two three'
   !< test_passed(2) = astring%compact(sep=', ')//''=='one, two, three'
   !< test_passed(3) = astring%compact(sep='')//''=='onetwothree'
   !< astring = 'one'//char(227)//char(128)//char(128)//'two'//char(194)//char(160)
   !< test_passed(4) = astring%compact(unicode=.true.)//''=='one two'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator of the words, default a space.
   logical,                   intent(in), optional :: unicode   !< The whitespace is Unicode White_Space, not ASCII.
   type(string)                                    :: compacted !< The compacted string.
   logical                                         :: unicode_  !< The whitespace is Unicode White_Space, local variable.
   integer                                         :: n         !< Length of a whitespace unit, 0 if not whitespace.
   character(kind=CK, len=:), allocatable          :: buffer    !< Buffer, only its first length characters are used.
   integer                                         :: length    !< Length of the result.
   integer                                         :: first     !< First character of a word.
   integer                                         :: c         !< Character counter.

   if (allocated(self%raw)) then
      unicode_ = .false. ; if (present(unicode)) unicode_ = unicode
      length = 0
      c = 1
      do
         if (unicode_) then
            do while (c<=len(self%raw))
               n = utf8_space_len(self%raw, c)
               if (n==0) exit
               c = c + n
            enddo
         else
            do while (c<=len(self%raw))
               if (.not.is_space_char(self%raw(c:c))) exit
               c = c + 1
            enddo
         endif
         if (c>len(self%raw)) exit
         first = c
         if (unicode_) then
            do while (c<=len(self%raw)) ! a continuation byte never starts a whitespace unit: stepping by bytes is safe
               if (utf8_space_len(self%raw, c)>0) exit
               c = c + 1
            enddo
         else
            do while (c<=len(self%raw))
               if (is_space_char(self%raw(c:c))) exit
               c = c + 1
            enddo
         endif
         if (length>0) then
            if (present(sep)) then
               call append_to_buffer(buffer=buffer, length=length, piece=sep)
            else
               call append_to_buffer(buffer=buffer, length=length, piece=SPACE)
            endif
         endif
         call append_to_buffer(buffer=buffer, length=length, piece=self%raw(first:c-1))
      enddo
      if (length>0) then
         compacted%raw = buffer(1:length)
      else
         compacted%raw = ''
      endif
   endif
   endfunction compact

   elemental function compare_version_string(self, other, sep) result(order)
   !< Compare the version number into the string with the one into another string.
   !<
   !< See [[string:compare_version_character]] for the comparison rules.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(2)
   !< astring = '1.2.0'
   !< anotherstring = '1.10'
   !< test_passed(1) = astring%compare_version(anotherstring)==-1
   !< test_passed(2) = anotherstring%compare_version(astring)==1
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self  !< The string.
   type(string),              intent(in)           :: other !< Other version.
   character(kind=CK, len=*), intent(in), optional :: sep   !< Fields separator, default ".".
   integer                                         :: order !< -1 if self<other, 0 if self==other, 1 if self>other.

   order = self%compare_version_character(other=other%chars(), sep=sep)
   endfunction compare_version_string

   elemental function compare_version_character(self, other, sep) result(order)
   !< Compare the version number into the string with the one into a character.
   !<
   !< The versions are compared field by field, the fields being separated by `sep`: two fields made only of digits are compared
   !< as integers of arbitrary size (leading zeros are ignored), otherwise they are compared lexically. Missing or null fields count
   !< as zero, thus `1.0` is equal to `1.0.0`.
   !<
   !< @note The comparison is not *semantic versioning* aware: a pre-release tag is compared lexically, thus `1.0.0-rc1` is greater
   !< than `1.0.0`.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(8)
   !< astring = '1.01'
   !< test_passed(1) = astring%compare_version('1.001')==0
   !< astring = '1.0'
   !< test_passed(2) = astring%compare_version('1.0.0')==0
   !< astring = '0.1'
   !< test_passed(3) = astring%compare_version('1.1')==-1
   !< astring = '1.10'
   !< test_passed(4) = astring%compare_version('1.9')==1
   !< astring = '1-2-3'
   !< test_passed(5) = astring%compare_version('1-2-4', sep='-')==-1
   !< astring = '1.99999999999999999999999'
   !< test_passed(6) = astring%compare_version('1.100000000000000000000000')==-1
   !< astring = '1.2.b'
   !< test_passed(7) = astring%compare_version('1.2.a')==1
   !< astring = '1.'
   !< test_passed(8) = astring%compare_version('1')==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self  !< The string.
   character(kind=CK, len=*), intent(in)           :: other !< Other version.
   character(kind=CK, len=*), intent(in), optional :: sep   !< Fields separator, default ".".
   integer                                         :: order !< -1 if self<other, 0 if self==other, 1 if self>other.
   character(kind=CK, len=:), allocatable          :: sep_  !< Separator, default value.

   sep_ = '.'
   if (present(sep)) then
      if (len(sep)>0) sep_ = sep
   endif
   order = compare_versions(version_a=self%chars(), version_b=other, sep=sep_)
   endfunction compare_version_character

   elemental function decode(self, codec) result(decoded)
   !< Return a string decoded accordingly the codec.
   !<
   !< @note Only BASE64 codec is currently available.
   !<
   !< @note The decoded string has exactly the length encoded into the code: the padding characters `=` are honored (and they
   !< can be omitted), the eventual leading/trailing white spaces and null characters of the decoded data are preserved. An
   !< invalid code, namely one with a length that cannot be produced by an encoding, is decoded to a null string.
   !<
   !< @note An unknown codec gives a not allocated string, to be checked by means of `is_allocated`.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: decoded
   !< logical      :: test_passed(11)
   !< astring = 'SG93IGFyZSB5b3U/'
   !< test_passed(1) = astring%decode(codec='base64')//''=='How are you?'
   !< astring = 'SGVsbG8gV29ybGQ='
   !< test_passed(2) = astring%decode(codec='base64')//''=='Hello World'
   !< astring = 'aGVsbG8gd29ybGQhIQ=='
   !< test_passed(3) = astring%decode(codec='base64')//''=='hello world!!'
   !< astring = 'SGVsbG8gV29ybGQ'
   !< test_passed(4) = astring%decode(codec='base64')//''=='Hello World'
   !< astring = '  spaces kept  '
   !< astring = astring%encode(codec='base64')
   !< test_passed(5) = astring%decode(codec='base64')//''=='  spaces kept  '
   !< test_passed(6) = len(astring%decode(codec='base64')//'')==15
   !< astring = 'YQ=='
   !< test_passed(7) = astring%decode(codec='base64')//''=='a'
   !< astring = 'YWJjZ'
   !< test_passed(8) = len(astring%decode(codec='base64')//'')==0
   !< astring = ''
   !< test_passed(9) = len(astring%decode(codec='base64')//'')==0
   !< astring = 'SGVsbG8gV29ybGQ='
   !< decoded = astring%decode(codec='BASE64')
   !< test_passed(10) = decoded%is_allocated().and.decoded=='Hello World'
   !< decoded = astring%decode(codec='rot13')
   !< test_passed(11) = .not.decoded%is_allocated()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: self    !< The string.
   character(kind=CK, len=*), intent(in)  :: codec   !< Encoding codec.
   type(string)                           :: decoded !< Decoded string.
   type(string)                           :: codec_u !< Encoding codec in upper case string.
   character(kind=CK, len=:), allocatable :: code    !< Code to be decoded, padded to a multiple of 4 characters.
   integer                                :: pads    !< Number of padding characters.
   integer                                :: length  !< Length of the decoded string.

   if (allocated(self%raw)) then
     codec_u = codec
     select case(codec_u%upper()//'')
     case('BASE64')
       code = trim(self%raw)
       if (mod(len(code), 4)>0) code = code//repeat('=', 4-mod(len(code), 4))
       pads = len(code) - verify(code, '=', back=.true.)
       length = (len(code)/4)*3 - pads
       if (length>0.and.pads<=2) then
         allocate(character(kind=CK, len=length) :: decoded%raw)
         call b64_decode(code=code, s=decoded%raw)
       else
         decoded%raw = ''
       endif
     endselect
   endif
   endfunction decode

   elemental function encode(self, codec) result(encoded)
   !< Return a string encoded accordingly the codec.
   !<
   !< @note Only BASE64 codec is currently available.
   !<
   !< @note An unknown codec gives a not allocated string, to be checked by means of `is_allocated`.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: encoded
   !< logical      :: test_passed(3)
   !< astring = 'How are you?'
   !< test_passed(1) = astring%encode(codec='base64')//''=='SG93IGFyZSB5b3U/'
   !< encoded = astring%encode(codec='BASE64')
   !< test_passed(2) = encoded%is_allocated().and.encoded=='SG93IGFyZSB5b3U/'
   !< encoded = astring%encode(codec='rot13')
   !< test_passed(3) = .not.encoded%is_allocated()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: self    !< The string.
   character(kind=CK, len=*), intent(in) :: codec   !< Encoding codec.
   type(string)                          :: encoded !< Encoded string.
   type(string)                          :: codec_u !< Encoding codec in upper case string.

   if (allocated(self%raw)) then
     codec_u = codec
     select case(codec_u%upper()//'')
     case('BASE64')
       call b64_encode(s=self%raw, code=encoded%raw)
     endselect
   endif
   endfunction encode

   elemental function escape(self, to_escape, esc) result(escaped)
   !< Escape backslashes (or custom escape character).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = '^\s \d+\s*'
   !< test_passed(1) = astring%escape(to_escape='\')//''=='^\\s \\d+\\s*'
   !< test_passed(2) = astring%escape(to_escape='\', esc='|')//''=='^|\s |\d+|\s*'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=1), intent(in)           :: to_escape !< Character to be escaped.
   character(kind=CK, len=*), intent(in), optional :: esc       !< Character used to escape.
   type(string)                                    :: escaped   !< Escaped string.

   if (allocated(self%raw)) then
     if (present(esc)) then
       escaped%raw = replace_substring(raw=self%raw, old=to_escape, new=esc//to_escape)
     else
       escaped%raw = replace_substring(raw=self%raw, old=to_escape, new=BACKSLASH//to_escape)
     endif
   endif
   endfunction escape

   elemental function escape_c(self, ascii) result(escaped)
   !< Return the string with C escapes for what is not printable: the inverse of [[string:unescape_c]].
   !<
   !< @note A backslash becomes `\\`; BEL, BS, TAB, LF, VT, FF and CR become `\a \b \t \n \v \f \r`; the other ASCII
   !< controls and DEL become `\xHH`; a byte that is not part of a well-formed UTF-8 sequence becomes `\xHH`; a
   !< well-formed non-ASCII character becomes `\uXXXX` (up to U+FFFF) or `\UXXXXXXXX`, hexadecimal digits in lowercase.
   !< The result is printable ASCII, and `unescape_c` gives back the same bytes, whatever they are. With `ascii=.false.`
   !< the well-formed non-ASCII characters are kept as they are, except the C1 controls U+0080..U+009F. Quotes are
   !< not escaped.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(195)//char(169)//achar(9)//'!'
   !< test_passed(1) = astring%escape_c()=='caf'//char(92)//'u00e9'//char(92)//'t!'
   !< test_passed(2) = astring%escape_c(ascii=.false.)=='caf'//char(195)//char(169)//char(92)//'t!'
   !< astring = 'a'//char(255)//char(92)
   !< test_passed(3) = astring%escape_c()=='a'//char(92)//'xff'//char(92)//char(92)
   !< astring = char(240)//char(159)//char(152)//char(128)
   !< test_passed(4) = astring%escape_c()==char(92)//'U0001f600'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self    !< The string.
   logical,       intent(in), optional :: ascii   !< Escape every non-ASCII character (default), or only the C1 controls.
   type(string)                        :: escaped !< Escaped string.
   logical                             :: ascii_  !< Escape every non-ASCII character, local variable.
   integer                             :: i       !< Byte position in the string.
   integer                             :: o       !< Byte position in the result.
   integer                             :: n       !< Bytes of a unit.
   integer                             :: b       !< Byte value.
   integer(I4P)                        :: code    !< Codepoint of a unit.
   integer                             :: pass    !< 1: measure the result, 2: fill it.
   character(kind=CK, len=10)          :: token   !< What a unit becomes.
   integer                             :: t       !< Length of the token.

   if (.not.allocated(self%raw)) return
   ascii_ = .true. ; if (present(ascii)) ascii_ = ascii
   do pass=1, 2
      i = 1
      o = 0
      do while (i <= len(self%raw))
         b = iand(ichar(self%raw(i:i)), 255)
         n = 1
         t = 2
         select case (b)
         case (92)
            token = BACKSLASH//BACKSLASH
         case (7)
            token = BACKSLASH//'a'
         case (8)
            token = BACKSLASH//'b'
         case (9)
            token = BACKSLASH//'t'
         case (10)
            token = BACKSLASH//'n'
         case (11)
            token = BACKSLASH//'v'
         case (12)
            token = BACKSLASH//'f'
         case (13)
            token = BACKSLASH//'r'
         case (0:6, 14:31, 127)
            token = BACKSLASH//'x'//hex_lower(b, 2)
            t = 4
         case (32:91, 93:126)
            token = self%raw(i:i)
            t = 1
         case default
            call utf8_decode(self%raw, i, code, n)
            if (code < 0) then
               token = BACKSLASH//'x'//hex_lower(b, 2)
               t = 4
            elseif (.not.ascii_ .and. code > 159) then
               token = self%raw(i:i+n-1)
               t = n
            elseif (code <= 65535) then
               token = BACKSLASH//'u'//hex_lower(code, 4)
               t = 6
            else
               token = BACKSLASH//'U'//hex_lower(code, 8)
               t = 10
            endif
         endselect
         if (pass == 2) escaped%raw(o+1:o+t) = token(1:t)
         o = o + t
         i = i + n
      enddo
      if (pass == 1) allocate(character(kind=CK, len=o) :: escaped%raw)
   enddo
   endfunction escape_c

   elemental function escape_xml(self, attribute) result(escaped)
   !< Return the string with the XML markup characters escaped: the inverse of [[string:unescape_xml]].
   !<
   !< @note `& < > " '` become `&amp; &lt; &gt; &quot; &apos;`, so the result can be the content of an element or the
   !< value of an attribute, in single or double quotes. With `attribute=.true.` TAB, LF and CR also become `&#9; &#10;
   !< &#13;`: a parser turns them into spaces in an attribute value, and a CR into a LF in an element. Every other byte
   !< is kept, so `unescape_xml` gives back the same bytes, whatever they are; the C0 controls other than TAB, LF and CR
   !< cannot be written in XML 1.0, not even as references, so a string holding one gives text that is not XML 1.0.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'a<b & "c"'
   !< test_passed(1) = astring%escape_xml()=='a&lt;b &amp; &quot;c&quot;'
   !< astring = 'it''s'//achar(10)
   !< test_passed(2) = astring%escape_xml()=='it&apos;s'//achar(10)
   !< test_passed(3) = astring%escape_xml(attribute=.true.)=='it&apos;s&#10;'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self       !< The string.
   logical,       intent(in), optional :: attribute  !< Also escape TAB, LF and CR, for an attribute value.
   type(string)                        :: escaped    !< Escaped string.
   logical                             :: attribute_ !< Also escape TAB, LF and CR, local variable.
   character(kind=CK, len=8)           :: markup     !< The bytes to escape.
   integer                             :: i          !< Byte position in the string.
   integer                             :: o          !< Byte position in the result.
   integer                             :: pass       !< 1: measure the result, 2: fill it.
   character(kind=CK, len=6)           :: token      !< What a byte becomes.
   integer                             :: t          !< Length of the token.

   if (.not.allocated(self%raw)) return
   attribute_ = .false. ; if (present(attribute)) attribute_ = attribute
   markup = '&<>"'//"'"//achar(9)//achar(10)//achar(13)
   if (scan(self%raw, markup(1:merge(8, 5, attribute_))) == 0) then
      escaped%raw = self%raw
      return
   endif
   do pass=1, 2
      o = 0
      do i=1, len(self%raw)
         t = 1
         select case (self%raw(i:i))
         case ('&')
            token = '&amp;'
            t = 5
         case ('<')
            token = '&lt;'
            t = 4
         case ('>')
            token = '&gt;'
            t = 4
         case ('"')
            token = '&quot;'
            t = 6
         case ("'")
            token = '&apos;'
            t = 6
         case (achar(9))
            token = self%raw(i:i)
            if (attribute_) then
               token = '&#9;'
               t = 4
            endif
         case (achar(10))
            token = self%raw(i:i)
            if (attribute_) then
               token = '&#10;'
               t = 5
            endif
         case (achar(13))
            token = self%raw(i:i)
            if (attribute_) then
               token = '&#13;'
               t = 5
            endif
         case default
            token = self%raw(i:i)
         endselect
         if (pass == 2) escaped%raw(o+1:o+t) = token(1:t)
         o = o + t
      enddo
      if (pass == 1) allocate(character(kind=CK, len=o) :: escaped%raw)
   enddo
   endfunction escape_xml

   elemental function escapes_error(self) result(position)
   !< Return the byte position of the first malformed C escape, 0 if there is none (see [[string:unescape_c]]).
   !<
   !< @note Malformed is a backslash at the end, an unknown escape (`\q`), `\x` without 2 hexadecimal digits, `\u`
   !< without 4, `\U` without 8, a surrogate or a value above U+10FFFF in `\u` or `\U`, an octal escape above `\377`.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'ok'//char(92)//'n'//char(92)//'u00e9'
   !< test_passed(1) = astring%escapes_error()==0
   !< astring = 'ab'//char(92)//'q'
   !< test_passed(2) = astring%escapes_error()==3
   !< astring = char(92)//'n'//char(92)//'ud800'
   !< test_passed(3) = astring%escapes_error()==3
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer                   :: position !< Position of the backslash of the first malformed escape, 0 if none.
   integer                   :: i        !< Byte position.
   integer                   :: n        !< Length of an escape, 0 if malformed.
   integer(I4P)              :: value    !< Value of an escape.
   logical                   :: is_byte  !< True if the value is a byte, false if it is a codepoint.

   position = 0
   if (.not.allocated(self%raw)) return
   i = index(self%raw, BACKSLASH)
   if (i == 0) return
   do while (i <= len(self%raw))
      if (self%raw(i:i) == BACKSLASH) then
         call parse_c_escape(self%raw, i, value, is_byte, n)
         if (n == 0) then
            position = i
            return
         endif
         i = i + n
      else
         i = i + 1
      endif
   enddo
   endfunction escapes_error

   elemental function expand_tabs(self, tab_size, by) result(expanded)
   !< Return a string with every tab replaced by the spaces up to the next tab stop, every `tab_size` columns (default 8).
   !<
   !< @note As Python `str.expandtabs`: the column restarts after a new line or a carriage return; a `tab_size` not positive
   !< removes the tabs.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'a'//achar(9)//'bc'//achar(9)//'d'
   !< test_passed(1) = astring%expand_tabs()//''=='a       bc      d'
   !< test_passed(2) = astring%expand_tabs(4)//''=='a   bc  d'
   !< astring = 'abcd'//achar(9)//'e'//new_line('a')//achar(9)//'f'
   !< test_passed(3) = astring%expand_tabs(4)//''=='abcd    e'//new_line('a')//'    f'
   !< astring = 'caf'//char(195)//char(169)//achar(9)//'x'
   !< test_passed(4) = astring%expand_tabs(8, by=SF_CHARS)//''=='caf'//char(195)//char(169)//'    x'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: self      !< The string.
   integer,       intent(in), optional    :: tab_size  !< Columns between tab stops, default 8.
   integer,       intent(in), optional    :: by        !< Unit of a column: SF_BYTES (default), SF_CHARS, SF_COLUMNS.
   type(string)                           :: expanded  !< The string with the tabs expanded.
   character(kind=CK, len=:), allocatable :: buffer    !< Buffer, only its first length characters are used.
   integer                                :: tab_size_ !< Columns between tab stops, local variable.
   integer                                :: length    !< Length of the result.
   integer                                :: column    !< Column of the next character, from 0.
   integer                                :: spaces    !< Spaces replacing a tab.
   integer                                :: c         !< Byte position.
   integer                                :: n         !< First byte of the next character (by=SF_CHARS).
   logical                                :: by_char   !< A column is a character.
   logical                                :: by_column !< Columns are display columns.
   integer(I4P)                           :: code      !< Codepoint of a character.
   integer                                :: m         !< Bytes of a character.

   if (allocated(self%raw)) then
      tab_size_ = 8 ; if (present(tab_size)) tab_size_ = tab_size
      by_char = .false.
      by_column = .false.
      if (present(by)) then
         by_char = by==SF_CHARS
         by_column = by==SF_COLUMNS
      endif
      length = 0
      column = 0
      n = 0 ! by=SF_CHARS: the first byte of the next character
      do c=1, len(self%raw)
         select case(self%raw(c:c))
         case(TAB)
            if (tab_size_>0) then
               spaces = tab_size_ - mod(column, tab_size_)
               call append_to_buffer(buffer=buffer, length=length, piece=repeat(SPACE, spaces))
               column = column + spaces
            endif
         case(achar(10, kind=CK), achar(13, kind=CK))
            call append_to_buffer(buffer=buffer, length=length, piece=self%raw(c:c))
            column = 0
         case default
            call append_to_buffer(buffer=buffer, length=length, piece=self%raw(c:c))
            if (by_column) then
               if (c>=n) then ! the first byte of a character: its display width
                  call utf8_decode(self%raw, c, code, m)
                  column = column + utf8_unit_width(code)
                  n = c + m
               endif
            elseif (.not.by_char) then
               column = column + 1
            elseif (c>=n) then ! the first byte of a character: one column for the whole character
               column = column + 1
               n = c + unit_length(self%raw, c)
            endif
         endselect
      enddo
      if (length>0) then
         expanded%raw = buffer(1:length)
      else
         expanded%raw = ''
      endif
   endif
   endfunction expand_tabs

   elemental function extension(self)
   !< Return the extension of a string containing a file name.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = '/bar/foo.tar.bz2'
   !< print '(L1)', astring%extension()//''=='.bz2'
   !<```
   !=> T <<<
   class(string), intent(in)              :: self      !< The string.
   type(string)                           :: extension !< Extension file name.
   integer                                :: pos       !< Character position.

   if (allocated(self%raw)) then
      extension = ''
      pos = index(self%raw, '.', back=.true.)
      if (pos>0) extension%raw = self%raw(pos:)
   endif
   endfunction extension

   elemental function fill(self, width, right, filling_char, by) result(filled)
   !< Pad string on the left (or right) with zeros (or other char) to fill width.
   !<
   !< @note A string already as wide as (or wider than) `width` is returned unchanged.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(7)
   !< astring = 'this is string example....wow!!!'
   !< test_passed(1) = astring%fill(width=40)//''=='00000000this is string example....wow!!!'
   !< test_passed(2) = astring%fill(width=50)//''=='000000000000000000this is string example....wow!!!'
   !< test_passed(3) = astring%fill(width=50, right=.true.)//''=='this is string example....wow!!!000000000000000000'
   !< test_passed(4) = astring%fill(width=40, filling_char='*')//''=='********this is string example....wow!!!'
   !< test_passed(5) = astring%fill(width=32)//''=='this is string example....wow!!!'
   !< test_passed(6) = astring%fill(width=5)//''=='this is string example....wow!!!'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(7) = astring%fill(width=5, by=SF_CHARS)//''=='0'//'caf'//char(195)//char(169)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self          !< The string.
   integer,                   intent(in)           :: width         !< Final width of filled string.
   logical,                   intent(in), optional :: right         !< Fill on the right instead of left.
   character(kind=CK, len=1), intent(in), optional :: filling_char  !< Filling character (default "0").
   integer,                   intent(in), optional :: by            !< Unit of width: SF_BYTES (default) or SF_CHARS.
   type(string)                                    :: filled        !< Filled string.
   logical                                         :: right_        !< Fill on the right instead of left, local variable.
   character(kind=CK, len=1)                       :: filling_char_ !< Filling character (default "0"), local variable.
   integer                                         :: size_         !< Length of the string, in the unit of width.

   if (allocated(self%raw)) then
      size_ = measure(self%raw, by)
      if (width>size_) then
         right_ = .false. ; if (present(right)) right_ = right
         filling_char_ = '0' ; if (present(filling_char)) filling_char_ = filling_char
         if (.not.right_) then
            filled%raw = repeat(filling_char_, width-size_)//self%raw
         else
            filled%raw = self%raw//repeat(filling_char_, width-size_)
         endif
      else
         filled%raw = self%raw
      endif
   endif
   endfunction fill

   elemental subroutine free(self)
   !< Free dynamic memory.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'this is string example....wow!!!'
   !< call astring%free
   !< print '(L1)', astring%is_allocated().eqv..false.
   !<```
   !=> T <<<
   class(string), intent(inout) :: self !< The string.

   if (allocated(self%raw)) deallocate(self%raw)
   endsubroutine free

   subroutine glob_character(self, pattern, list)
   !< Glob search (character output), finds all the pathnames matching a given pattern according to the rules used by the Unix shell.
   !<
   !< @note Method not portable: works only on Unix/GNU Linux OS.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: alist_chr(:)
   !< integer, parameter            :: Nf=5
   !< character(14)                 :: files(1:Nf)
   !< integer                       :: file_unit
   !< integer                       :: f
   !< integer                       :: ff
   !< logical                       :: test_passed
   !< do f=1, Nf
   !<    files(f) = astring%tempname(prefix='foo-')
   !<    open(newunit=file_unit, file=files(f))
   !<    write(file_unit, *)f
   !<    close(unit=file_unit)
   !< enddo
   !< call astring%glob(pattern='foo-*', list=alist_chr)
   !< do f=1, Nf
   !<    open(newunit=file_unit, file=files(f))
   !<    close(unit=file_unit, status='delete')
   !< enddo
   !< test_passed = .false.
   !< outer_chr: do f=1, size(alist_chr, dim=1)
   !<    do ff=1, Nf
   !<       test_passed = alist_chr(f) == files(ff)
   !<       if (test_passed) cycle outer_chr
   !<    enddo
   !< enddo outer_chr
   !< print '(L1)', test_passed
   !<```
   !=> T <<<
   class(string),                 intent(in)  :: self           !< The string.
   character(*),                  intent(in)  :: pattern        !< Given pattern.
   character(len=:), allocatable, intent(out) :: list(:)        !< List of matching pathnames.
   type(string), allocatable                  :: list_(:)       !< List of matching pathnames.
   integer(I4P)                               :: max_len        !< Maximum length.
   integer(I4P)                               :: matches_number !< Matches number.
   integer(I4P)                               :: m              !< Counter.

   call self%glob(pattern=pattern, list=list_)
   if (allocated(list_)) then
      matches_number = size(list_, dim=1)
      max_len = 0
      do m=1, matches_number
         max_len = max(max_len, list_(m)%len())
      enddo
      allocate(character(max_len) :: list(1:matches_number))
      do m=1, matches_number
         list(m) = list_(m)%chars()
      enddo
   endif
   endsubroutine glob_character

   subroutine glob_string(self, pattern, list)
   !< Glob search (string output), finds all the pathnames matching a given pattern according to the rules used by the Unix shell.
   !<
   !< @note Method not portable: works only on Unix/GNU Linux OS (it runs `ls` through the shell).
   !<
   !< @note If no pathname matches the pattern `list` is allocated with zero size.
   !<
   !< @note Only the wildcards `*`, `?` and `[...]` are special: every other character of the pattern is passed to the shell
   !< escaped, so spaces, `;`, `$`, quotes or a leading `-` are part of the names searched, never shell syntax. A pattern
   !< holding a new line matches nothing. A matching directory is listed itself, not its content. Match a list of names
   !< already in memory with [[string:match]].
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< type(string),     allocatable :: alist_str(:)
   !< character(len=:), allocatable :: alist_chr(:)
   !< logical                       :: test_passed(2)
   !< call astring%glob(pattern='no-file-has-this-name-*', list=alist_str)
   !< test_passed(1) = allocated(alist_str).and.size(alist_str, dim=1)==0
   !< call astring%glob(pattern='no-file-has-this-name-*', list=alist_chr)
   !< test_passed(2) = allocated(alist_chr).and.size(alist_chr, dim=1)==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< type(string),     allocatable :: alist_str(:)
   !< character(len=:), allocatable :: files(:)
   !< character(len=:), allocatable :: directory
   !< integer                       :: file_unit
   !< integer                       :: f
   !< logical                       :: is_injected
   !< logical                       :: test_passed(5)
   !< files = [character(len=20) :: astring%tempname(prefix='glob test-'), astring%tempname(prefix='glob test-'), &
   !<          astring%tempname(prefix='-glob-')]
   !< do f=1, size(files, dim=1)
   !<    open(newunit=file_unit, file=files(f))
   !<    close(unit=file_unit)
   !< enddo
   !< call astring%glob(pattern='glob test-*.tmp', list=alist_str)
   !< test_passed(1) = size(alist_str, dim=1)==2
   !< if (test_passed(1)) test_passed(1) = all(alist_str==files(1).or.alist_str==files(2))
   !< call astring%glob(pattern=files(3), list=alist_str)
   !< test_passed(2) = size(alist_str, dim=1)==1
   !< call astring%glob(pattern='glob test-*; touch glob-injected', list=alist_str)
   !< inquire(file='glob-injected', exist=is_injected)
   !< test_passed(3) = size(alist_str, dim=1)==0.and..not.is_injected
   !< do f=1, size(files, dim=1)
   !<    open(newunit=file_unit, file=files(f))
   !<    close(unit=file_unit, status='delete')
   !< enddo
   !< directory = astring%tempname(is_file=.false., prefix='glob-dir-')
   !< call execute_command_line('mkdir '//directory)
   !< call astring%glob(pattern=directory, list=alist_str)
   !< test_passed(4) = size(alist_str, dim=1)==1
   !< if (test_passed(4)) test_passed(4) = alist_str(1)==directory
   !< call execute_command_line('rmdir '//directory)
   !< call astring%glob(pattern='', list=alist_str)
   !< test_passed(5) = size(alist_str, dim=1)==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: self     !< The string.
   character(*),              intent(in)  :: pattern  !< Given pattern.
   type(string), allocatable, intent(out) :: list(:)  !< List of matching pathnames.
   type(string)                           :: tempfile !< Safe temporary file.
   character(len=:), allocatable          :: tempname !< Safe temporary name.
   character(len=:), allocatable          :: tempdir  !< Directory of the temporary file.
   integer(I4P)                           :: tempunit !< Unit of temporary file.
   integer                                :: length   !< Length of the TMPDIR environment variable.
   integer                                :: status   !< Status of the TMPDIR environment variable.

   if (len_trim(adjustl(pattern))==0.or.index(pattern, new_line('a'))>0.or.index(pattern, achar(0))>0) then
      allocate(list(0))
      return
   endif
   call get_environment_variable('TMPDIR', length=length, status=status)
   if (status==0.and.length>0) then
      allocate(character(len=length) :: tempdir)
      call get_environment_variable('TMPDIR', value=tempdir)
      tempdir = tempdir//'/'
   else
      tempdir = '/tmp/'
   endif
   tempname = self%tempname(prefix='stringifor-glob-', path=tempdir)
   call execute_command_line('ls -1d -- '//shell_escape(trim(adjustl(pattern)))//' > '//shell_escape(tempname)// &
                             ' 2> /dev/null')
   call tempfile%read_file(file=tempname)
   if (tempfile%len_trim()>0) call tempfile%split(sep=new_line('a'), tokens=list)
   if (.not.allocated(list)) allocate(list(0)) ! no matches
   open(newunit=tempunit, file=tempname)
   close(unit=tempunit, status='delete')
   endsubroutine glob_string

   elemental function hex(self, bits, uppercase) result(hexed)
   !< Return the hexadecimal representation of the integer number into the string.
   !<
   !< Negative numbers are represented in two's complement on `bits` bits. The number is truncated to its `bits` lowest bits and
   !< the leading zeros are removed.
   !<
   !< @note If the string does not contain an integer the result is not allocated.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: hexed
   !< logical      :: test_passed(7)
   !< astring = 26
   !< test_passed(1) = astring%hex()//''=='1a'
   !< astring = -1
   !< test_passed(2) = astring%hex(bits=32)//''=='ffffffff'
   !< test_passed(3) = astring%hex()//''=='ffffffffffffffff'
   !< astring = 0
   !< test_passed(4) = astring%hex()//''=='0'
   !< astring = '255'
   !< test_passed(5) = astring%hex(uppercase=.true.)//''=='FF'
   !< astring = 4096
   !< test_passed(6) = astring%hex(bits=8)//''=='0'
   !< astring = 'not a number'
   !< hexed = astring%hex()
   !< test_passed(7) = hexed%is_allocated().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self                           !< The string.
   integer,       intent(in), optional :: bits                           !< Width of the representation, in [4, 64], default 64.
   logical,       intent(in), optional :: uppercase                      !< Use uppercase digits, default lowercase.
   type(string)                        :: hexed                          !< Hexadecimal representation.
   character(kind=CK, len=16), parameter :: DIGITS_L = '0123456789abcdef' !< Lowercase hexadecimal digits.
   character(kind=CK, len=16), parameter :: DIGITS_U = '0123456789ABCDEF' !< Uppercase hexadecimal digits.
   character(kind=CK, len=16)          :: alphabet                       !< Hexadecimal digits used.
   character(kind=CK, len=16)          :: buffer                         !< Digits buffer.
   integer(I8P)                        :: number                         !< The number into the string.
   integer                             :: nibbles                        !< Number of hexadecimal digits.
   integer                             :: d                              !< Digit value.
   integer                             :: n                              !< Counter.

   if (allocated(self%raw)) then
      if (self%is_integer()) then
         number = self%to_number(kind=1_I8P)
         nibbles = 16 ; if (present(bits)) nibbles = max(1, min(16, bits/4))
         alphabet = DIGITS_L
         if (present(uppercase)) then
            if (uppercase) alphabet = DIGITS_U
         endif
         do n=1, nibbles
            d = int(iand(ishft(number, -4*(n-1)), 15_I8P)) + 1
            buffer(nibbles-n+1:nibbles-n+1) = alphabet(d:d)
         enddo
         n = verify(buffer(1:nibbles), '0') ; if (n==0) n = nibbles
         hexed%raw = buffer(n:nibbles)
      endif
   endif
   endfunction hex

   elemental function insert_character(self, substring, pos, by) result(inserted)
   !< Insert substring into string at a specified position.
   !<
   !< @note With `by=SF_CHARS` the position counts characters (UTF-8 units) instead of bytes.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(6)
   !< astring = 'this is string example wow!!!'
   !< acharacter = '... '
   !< test_passed(1) = astring%insert(substring=acharacter, pos=1)//''=='... this is string example wow!!!'
   !< test_passed(2) = astring%insert(substring=acharacter, pos=23)//''=='this is string example...  wow!!!'
   !< test_passed(3) = astring%insert(substring=acharacter, pos=29)//''=='this is string example wow!!!... '
   !< test_passed(4) = astring%insert(substring=acharacter, pos=-1)//''=='... this is string example wow!!!'
   !< test_passed(5) = astring%insert(substring=acharacter, pos=100)//''=='this is string example wow!!!... '
   !< astring = 'caf'//char(195)//char(169)//'s'
   !< test_passed(6) = astring%insert(substring='+', pos=4, by=SF_CHARS)//''=='caf+'//char(195)//char(169)//'s'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(in) :: self      !< The string.
   character(len=*), intent(in) :: substring !< Substring.
   integer,          intent(in) :: pos       !< Position from which insert substring.
   integer, intent(in), optional :: by       !< Unit of pos: SF_BYTES (default) or SF_CHARS.
   type(string)                 :: inserted  !< Inserted string.
   integer                      :: safepos   !< Safe position from which insert substring.

   if (allocated(self%raw)) then
      inserted = self
      safepos = byte_safe_position(self%raw, pos, by)
      if (safepos==1) then
         inserted%raw = substring//self%raw
      elseif (safepos==len(self%raw)) then
         inserted%raw = self%raw//substring
      else
         inserted%raw = self%raw(1:safepos-1)//substring//self%raw(safepos:)
      endif
   else
      inserted%raw = substring
   endif
   endfunction insert_character

   elemental function insert_string(self, substring, pos, by) result(inserted)
   !< Insert substring into string at a specified position.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(5)
   !< astring = 'this is string example wow!!!'
   !< anotherstring = '... '
   !< test_passed(1) = astring%insert(substring=anotherstring, pos=1)//''=='... this is string example wow!!!'
   !< test_passed(2) = astring%insert(substring=anotherstring, pos=23)//''=='this is string example...  wow!!!'
   !< test_passed(3) = astring%insert(substring=anotherstring, pos=29)//''=='this is string example wow!!!... '
   !< test_passed(4) = astring%insert(substring=anotherstring, pos=-1)//''=='... this is string example wow!!!'
   !< test_passed(5) = astring%insert(substring=anotherstring, pos=100)//''=='this is string example wow!!!... '
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   type(string),  intent(in) :: substring !< Substring.
   integer,       intent(in) :: pos       !< Position from which insert substring.
   integer, intent(in), optional :: by    !< Unit of pos: SF_BYTES (default) or SF_CHARS.
   type(string)              :: inserted  !< Inserted string.
   integer                   :: safepos   !< Safe position from which insert substring.

   if (allocated(self%raw)) then
      inserted = self
      if (allocated(substring%raw)) then
         safepos = byte_safe_position(self%raw, pos, by)
         if (safepos==1) then
            inserted%raw = substring%raw//self%raw
         elseif (safepos==len(self%raw)) then
            inserted%raw = self%raw//substring%raw
         else
            inserted%raw = self%raw(1:safepos-1)//substring%raw//self%raw(safepos:)
         endif
      endif
   else
      if (allocated(substring%raw)) inserted%raw = substring%raw
   endif
   endfunction insert_string

   pure function join_strings(self, array, sep) result(join)
   !< Return a string that is a join of an array of strings.
   !<
   !< The join-separator is set equals to self if self has a value or it is set to a null string ''. This value can be overridden
   !< passing a custom separator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: strings(3)
   !< logical      :: test_passed(5)
   !< strings(1) = 'one'
   !< strings(2) = 'two'
   !< strings(3) = 'three'
   !< test_passed(1) = (astring%join(array=strings)//''==strings(1)//strings(2)//strings(3))
   !< test_passed(2) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2)//'-'//strings(3))
   !< call strings(1)%free
   !< strings(2) = 'two'
   !< strings(3) = 'three'
   !< test_passed(3) = (astring%join(array=strings, sep='-')//''==strings(2)//'-'//strings(3))
   !< strings(1) = 'one'
   !< strings(2) = 'two'
   !< call strings(3)%free
   !< test_passed(4) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2))
   !< strings(1) = 'one'
   !< call strings(2)%free
   !< strings(3) = 'three'
   !< test_passed(5) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(3))
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   type(string),              intent(in)           :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: join      !< The join of array.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.

   if (allocated(self%raw)) then
      sep_ = self%raw
   else
      sep_ = ''
   endif
   if (present(sep)) sep_ = sep
   join%raw = join_raws(array=array, sep=sep_)
   endfunction join_strings

   pure function join_characters(self, array, sep) result(join)
   !< Return a string that is a join of an array of characters.
   !<
   !< The join-separator is set equals to self if self has a value or it is set to a null string ''. This value can be overridden
   !< passing a custom separator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< character(5) :: characters(3)
   !< logical      :: test_passed(6)
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(1) = (astring%join(array=characters)//''==characters(1)//characters(2)//characters(3))
   !< test_passed(2) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2)//'-'//characters(3))
   !< characters(1) = ''
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(3) = (astring%join(array=characters, sep='-')//''==characters(2)//'-'//characters(3))
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = ''
   !< test_passed(4) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2))
   !< characters(1) = 'one'
   !< characters(2) = ''
   !< characters(3) = 'three'
   !< test_passed(5) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(3))
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< astring = '_'
   !< test_passed(6) = (astring%join(array=characters)//''==characters(1)//'_'//characters(2)//'_'//characters(3))
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in)           :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: join      !< The join of array.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.

   if (allocated(self%raw)) then
      sep_ = self%raw
   else
      sep_ = ''
   endif
   if (present(sep)) sep_ = sep
   join%raw = join_chars(array=array, sep=sep_, is_trim=.false.)
   endfunction join_characters

   pure function strjoin_strings(array, sep) result(join)
   !< Return a string that is a join of an array of strings.
   !<
   !< The join-separator is set equals to a null string '' if custom separator isn't specified.
   !<
   !<```fortran
   !< type(string)     :: strings(3)
   !< logical          :: test_passed(5)
   !< strings(1) = 'one'
   !< strings(2) = 'two'
   !< strings(3) = 'three'
   !< test_passed(1) = (strjoin(array=strings)//''==strings(1)//strings(2)//strings(3))
   !< test_passed(2) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(2)//'-'//strings(3))
   !< call strings(1)%free
   !< strings(2) = 'two'
   !< strings(3) = 'three'
   !< test_passed(3) = (strjoin(array=strings, sep='-')//''==strings(2)//'-'//strings(3))
   !< strings(1) = 'one'
   !< strings(2) = 'two'
   !< call strings(3)%free
   !< test_passed(4) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(2))
   !< strings(1) = 'one'
   !< call strings(2)%free
   !< strings(3) = 'three'
   !< test_passed(5) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(3))
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: join      !< The join of array.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.

   sep_ = ''
   if (present(sep)) sep_ = sep
   join%raw = join_raws(array=array, sep=sep_)
   endfunction strjoin_strings

  pure function strjoin_characters(array, sep, is_trim) result(join)
   !< Return a string that is a join of an array of characters.
   !<
   !< The join-separator is set equals to a null string '' if custom separator isn't specified.
   !< The trim function is applied to array items if optional logical is_trim variable isn't set to .false.
   !<
   !<```fortran
   !< character(5) :: characters(3)
   !< logical      :: test_passed(13)
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(1) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2))//trim(characters(3)))
   !< test_passed(2) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2))//'-'//trim(characters(3)))
   !< test_passed(3) = ( strjoin(array=characters, is_trim=.false.)//''==characters(1)//characters(2)//characters(3))
   !< test_passed(4) = ( strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2)//'-'//characters(3))
   !< characters(1) = ''
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(5) = (strjoin(array=characters)//''==trim(characters(2))//trim(characters(3)))
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = ''
   !< test_passed(6) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2)))
   !< characters(1) = 'one'
   !< characters(2) = ''
   !< characters(3) = 'three'
   !< test_passed(7) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(3)))
   !< characters(1) = ''
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(8) = (strjoin(array=characters, sep='-')//''==trim(characters(2))//'-'//trim(characters(3)))
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = ''
   !< test_passed(9) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2)))
   !< characters(1) = 'one'
   !< characters(2) = ''
   !< characters(3) = 'three'
   !< test_passed(10) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(3)))
   !< characters(1) = ''
   !< characters(2) = 'two'
   !< characters(3) = 'three'
   !< test_passed(11) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(2)//'-'//characters(3))
   !< characters(1) = 'one'
   !< characters(2) = 'two'
   !< characters(3) = ''
   !< test_passed(12) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2))
   !< characters(1) = 'one'
   !< characters(2) = ''
   !< characters(3) = 'three'
   !< test_passed(13) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(3))
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)           :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   logical,                   intent(in), optional :: is_trim   !< Flag to setup trim character or not
   type(string)                                    :: join      !< The join of array.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.
   logical                                         :: is_trim_  !< Flag to setup trim character or not

   sep_ = ''
   if (present(sep)) sep_ = sep
   is_trim_ = .true. ; if (present(is_trim)) is_trim_ = is_trim
   join%raw = join_chars(array=array, sep=sep_, is_trim=is_trim_)
   endfunction strjoin_characters

   pure function strjoin_strings_array(array, sep, is_col) result(join)
   !< Return a string that is a join of columns or rows of an array of strings.
   !<
   !< The join-separator is set equals to a null string '' if custom separator isn't specified.
   !< The is_col is setup the direction of join: within default columns (.true.) or rows(.false.).
   !<
   !<```fortran
   !< type(string), allocatable :: strings_arr(:, :)
   !< logical                   :: test_passed(5)
   !<
   !< strings_arr = reshape( source = &
   !<                        [string('one'), string('two'), string('three'),  &
   !<                         string('ONE'), string('TWO'), string('THREE')], &
   !<                        shape = [3, 2] )
   !<
   !< test_passed(1) = all( strjoin(array=strings_arr) == &
   !<                       reshape([string('onetwothree'), string('ONETWOTHREE')], &
   !<                       shape = [2]) )
   !<
   !< test_passed(2) = all( strjoin(array=strings_arr, sep='_') == &
   !<                       reshape([string('one_two_three'), string('ONE_TWO_THREE')], &
   !<                       shape = [2]) )
   !<
   !<  test_passed(3) = all( strjoin(array=strings_arr, is_col=.false.) == &
   !<                        reshape([string('oneONE'), string('twoTWO'), string('threeTHREE')], &
   !<                        shape = [3]) )
   !<
   !<  test_passed(4) = all( strjoin(array=strings_arr, sep='_', is_col=.false.) == &
   !<                        reshape([string('one_ONE'), string('two_TWO'), string('three_THREE')], &
   !<                        shape = [3]) )
   !<
   !< call strings_arr(2, 1)%free
   !< test_passed(5) = all( strjoin(array=strings_arr, sep='_', is_col=.false.) == &
   !<                  reshape([string('one_ONE'), string('TWO'), string('three_THREE')], &
   !<                  shape = [3]) )
   !<
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: array(1:, 1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep  !< Separator.
   logical,                   intent(in), optional :: is_col  !< Direction: 'columns' if .true. or 'rows' if .false.
   type(string),              allocatable          :: join(:)       !< The join of array.
   type(string),              allocatable          :: slice(:)      !< The column or row slice of array
   character(kind=CK, len=:), allocatable          :: sep_          !< Separator, default value.
   logical                                         :: is_col_       !< Direction, default value.
   integer                                         :: a, join_size, slice_size  !< Counter, sizes of join vector and of slice of array

   sep_    = ''     ; if (present(sep)) sep_ = sep
   is_col_ = .true. ; if (present(is_col)) is_col_ = is_col

   if (is_col_) then
       join_size  = size(array, dim=2)
       slice_size = size(array, dim=1)

       if (.not.allocated(join))  allocate(join(join_size))
       if (.not.allocated(slice)) allocate(slice(slice_size))
       do a = 1, join_size
           slice(:) = array(:, a)
           join(a)  = strjoin_strings(slice, sep_)
       end do
   else
       join_size  = size(array, dim=1)
       slice_size = size(array, dim=2)

       if (.not.allocated(join))  allocate(join(join_size))
       if (.not.allocated(slice)) allocate(slice(slice_size))
       do a = 1, join_size
           slice(:) = array(a, :)
           join(a)  = strjoin_strings(slice, sep_)
       end do
   endif
   endfunction strjoin_strings_array

  pure function strjoin_characters_array(array, sep, is_trim, is_col) result(join)
   !< Return a string that is a join of columns or rows of an array of characters.
   !<
   !< The join-separator is set equals to a null string '' if custom separator isn't specified.
   !< The trim function is applied to array items if optional logical is_trim variable isn't set to .false.
   !< The is_col is setup the direction of join: within default columns (.true.) or rows(.false.).
   !<
   !<```fortran
   !< character(len=10)         :: chars_arr(3, 2)
   !< logical                   :: test_passed(9)
   !< chars_arr(:, 1) = ['one       ', 'two       ', 'three     ']
   !< chars_arr(:, 2) = ['ONE       ', 'TWO       ', 'THREE     ']
   !<
   !< test_passed(1) = all( strjoin(array=chars_arr) == &
   !<                       reshape([string('onetwothree'), string('ONETWOTHREE')], &
   !<                       shape = [2]) )
   !<
   !< test_passed(2) = all( strjoin(array=chars_arr, is_trim=.false.) ==  &
   !<                       reshape([string('one       two       three     '),  &
   !<                                string('ONE       TWO       THREE     ')], &
   !<                       shape = [2]) )
   !<
   !< test_passed(3) = all( strjoin(array=chars_arr, sep='_') == &
   !<                       reshape([string('one_two_three'), string('ONE_TWO_THREE')], &
   !<                       shape = [2]) )
   !<
   !< test_passed(4) = all( strjoin(array=chars_arr, sep='_', is_trim=.false.) ==  &
   !<                       reshape([string('one       _two       _three     '),  &
   !<                                string('ONE       _TWO       _THREE     ')], &
   !<                       shape = [2]) )
   !<
   !< test_passed(5) = all( strjoin(array=chars_arr, is_col=.false.) == &
   !<                       reshape([string('oneONE'), string('twoTWO'), string('threeTHREE')], &
   !<                       shape = [3]) )
   !<
   !< test_passed(6) = all( strjoin(array=chars_arr, is_trim=.false., is_col=.false.) ==  &
   !<                       reshape([string('one       ONE       '),  &
   !<                                string('two       TWO       '),  &
   !<                                string('three     THREE     ')], &
   !<                       shape = [3]) )
   !<
   !< test_passed(7) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) == &
   !<                       reshape([string('one_ONE'), string('two_TWO'), string('three_THREE')], &
   !<                       shape = [3]) )
   !<
   !< test_passed(8) = all( strjoin(array=chars_arr, sep='_', is_trim=.false., is_col=.false.) ==  &
   !<                       reshape([string('one       _ONE       '),  &
   !<                                string('two       _TWO       '),  &
   !<                                string('three     _THREE     ')], &
   !<                       shape = [3]) )
   !<
   !< chars_arr(2,1) = ''
   !< test_passed(9) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) ==  &
   !<                       reshape([string('one_ONE'),  &
   !<                                string('TWO'),  &
   !<                                string('three_THREE')], &
   !<                       shape = [3]) )
   !<
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)           :: array(1:, 1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   logical,                   intent(in), optional :: is_trim   !< Flag to setup trim character or not
   logical,                   intent(in), optional :: is_col    !< Direction: 'columns' if .true. or 'rows' if .false.
   type(string),              allocatable          :: join(:)   !< The join of array.
   character(kind=CK, len=:), allocatable          :: slice(:)  !< The column or row slice of array
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.
   logical                                         :: is_trim_  !< Flag to setup trim character or not
   logical                                         :: is_col_   !< Direction, default value.
   integer                                         :: a, join_size, slice_size  !< Counter, sizes of join vector and of slice of array
   integer                                         :: item_len  !< Length of array item (all items of character array have equal lengths)

   item_len = len(array(1,1)) !< all items of character array have equal lengths
   sep_     = ''     ; if (present(sep)) sep_ = sep
   is_trim_ = .true. ; if (present(is_trim)) is_trim_ = is_trim
   is_col_  = .true. ; if (present(is_col)) is_col_ = is_col

   if (is_col_) then
       join_size  = size(array, dim=2)
       slice_size = size(array, dim=1)

       if (.not.allocated(join))  allocate(join(join_size))
       if (.not.allocated(slice)) allocate(character(len=item_len) :: slice(slice_size))
       do a = 1, join_size
           slice(:) = array(:, a)
           join(a)  = strjoin_characters(slice, sep_, is_trim_)
       end do
   else
       join_size  = size(array, dim=1)
       slice_size = size(array, dim=2)

       if (.not.allocated(join))  allocate(join(join_size))
       if (.not.allocated(slice)) allocate(character(len=item_len) :: slice(slice_size))
       do a = 1, join_size
           slice(:) = array(a, :)
           join(a)  = strjoin_characters(slice, sep_, is_trim_)
       end do
   endif
   endfunction strjoin_characters_array

   pure subroutine justify(self, lines, width, by)
   !< Return the words of the string packed into fully justified lines of (at least) `width` characters.
   !<
   !< The words (separated by spaces) are greedily packed into lines; the blanks are evenly distributed between the words of each
   !< line, the leftmost gaps taking the extra ones. The last line and the lines made of one word are left-justified and padded
   !< with trailing blanks.
   !<
   !< @note A word longer than `width` is not broken: it is placed alone into a line longer than `width`.
   !<
   !< @note If the string is not allocated or it has no words `lines` has zero size.
   !<
   !< @note This is a subroutine, like [[string:split]]: a function returning the lines would need an assignment to an
   !< unallocated array, that is not allowed for a type with a defined assignment.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string), allocatable :: lines(:)
   !< logical                   :: test_passed(10)
   !< astring = 'This is an example of text justification.'
   !< call astring%justify(lines=lines, width=16)
   !< test_passed(1) = size(lines, dim=1)==3
   !< test_passed(2) = lines(1)//''=='This    is    an'
   !< test_passed(3) = lines(2)//''=='example  of text'
   !< test_passed(4) = lines(3)//''=='justification.  '
   !< astring = '  What must be   acknowledgment shall be '
   !< call astring%justify(lines=lines, width=16)
   !< test_passed(5) = lines(1)//''=='What   must   be'
   !< test_passed(6) = lines(2)//''=='acknowledgment  '
   !< test_passed(7) = lines(3)//''=='shall be        '
   !< call astring%justify(lines=lines, width=4)
   !< test_passed(8) = size(lines, dim=1)==6.and.lines(4)//''=='acknowledgment'
   !< astring = '   '
   !< call astring%justify(lines=lines, width=16)
   !< test_passed(9) = size(lines, dim=1)==0
   !< astring = 'caf'//char(195)//char(169)//' au lait'
   !< call astring%justify(lines=lines, width=4, by=SF_CHARS)
   !< test_passed(10) = lines(1)//''=='caf'//char(195)//char(169).and.lines(2)//''=='au  '
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: self      !< The string.
   type(string), allocatable, intent(out) :: lines(:)  !< Justified lines.
   integer,                   intent(in)  :: width     !< Width of the justified lines.
   integer,         intent(in), optional  :: by        !< Unit of width: SF_BYTES (default) or SF_CHARS.
   type(string), allocatable              :: words(:)  !< Words of the string.
   type(string), allocatable              :: buffer(:) !< Lines buffer.
   character(kind=CK, len=:), allocatable :: line      !< Current line.
   integer                                :: Nw        !< Number of words.
   integer                                :: Nl        !< Number of lines.
   integer                                :: first     !< First word of current line.
   integer                                :: last      !< Last word of current line.
   integer                                :: length    !< Length of current line with words separated by one blank.
   integer                                :: gaps      !< Number of gaps between the words of current line.
   integer                                :: blanks    !< Number of blanks to be distributed into the gaps.
   integer                                :: Nb        !< Number of blanks of current gap.
   integer                                :: g         !< Counter.

   Nl = 0
   Nw = 0
   if (allocated(self%raw)) then
      if (len_trim(self%raw)>0) then
         call self%split(tokens=words)
         Nw = size(words, dim=1)
      endif
   endif
   allocate(buffer(1:Nw))
   last = 0
   do while (last<Nw)
      first = last + 1
      last = first
      length = measure(words(first)%raw, by)
      do while (last<Nw)
         if (length+1+measure(words(last+1)%raw, by)>width) exit
         last = last + 1
         length = length + 1 + measure(words(last)%raw, by)
      enddo
      gaps = last - first
      line = words(first)%raw
      if (last==Nw.or.gaps==0) then
         do g=1, gaps
            line = line//SPACE//words(first+g)%raw
         enddo
         if (measure(line, by)<width) line = line//repeat(SPACE, width-measure(line, by))
      else
         blanks = width - (length - gaps)
         do g=1, gaps
            Nb = blanks/gaps ; if (g<=mod(blanks, gaps)) Nb = Nb + 1
            line = line//repeat(SPACE, Nb)//words(first+g)%raw
         enddo
      endif
      Nl = Nl + 1
      buffer(Nl)%raw = line
   enddo
   allocate(lines(1:Nl))
   do g=1, Nl
      lines(g)%raw = buffer(g)%raw
   enddo
   endsubroutine justify

   elemental function len_last_word(self, sep, by) result(length)
   !< Return the length of the last word of the string.
   !<
   !< @note The trailing separators are ignored. With `by=SF_CHARS` the length counts characters (UTF-8 units).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(7)
   !< astring = 'Hello World'
   !< test_passed(1) = astring%len_last_word()==5
   !< astring = '   fly me   to   the moon  '
   !< test_passed(2) = astring%len_last_word()==4
   !< astring = 'joyboy'
   !< test_passed(3) = astring%len_last_word()==6
   !< astring = 'src/lib/stringifor//'
   !< test_passed(4) = astring%len_last_word(sep='/')==10
   !< astring = '    '
   !< test_passed(5) = astring%len_last_word()==0
   !< call astring%free
   !< test_passed(6) = astring%len_last_word()==0
   !< astring = 'un caf'//char(195)//char(169)
   !< test_passed(7) = astring%len_last_word()==5.and.astring%len_last_word(by=SF_CHARS)==4
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self   !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep    !< Separator.
   integer,                   intent(in), optional :: by     !< Unit of the result: SF_BYTES (default) or SF_CHARS.
   integer                                         :: length !< Length of the last word.
   character(kind=CK, len=:), allocatable          :: sep_   !< Separator, default value.
   integer                                         :: last   !< Position of the last character of the last word.
   integer                                         :: s      !< Position of the last separator before the last word.

   length = 0
   if (allocated(self%raw)) then
      sep_ = SPACE
      if (present(sep)) then
         if (len(sep)>0) sep_ = sep
      endif
      last = len(self%raw)
      do while (last>=len(sep_))
         if (self%raw(last-len(sep_)+1:last)/=sep_) exit
         last = last - len(sep_)
      enddo
      s = index(self%raw(1:last), sep_, back=.true.)
      if (s>0) then
         length = last - (s + len(sep_) - 1)
      else
         length = last
      endif
      if (present(by)) then
         if (by==SF_CHARS) length = utf8_units(self%raw(last-length+1:last))
      endif
   endif
   endfunction len_last_word

   elemental function ljust(self, width, fill_char, by) result(justified)
   !< Return the string left justified in a string of length `width`, padded with `fill_char` (default a space).
   !<
   !< @note As Python `str.ljust`: a string not shorter than `width` is returned unchanged.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: centered
   !< logical      :: test_passed(4)
   !< astring = 'abc'
   !< test_passed(1) = astring%ljust(6, '.')//''=='abc...'
   !< centered = astring%ljust(6)
   !< test_passed(2) = centered%len()==6.and.centered//''=='abc'
   !< test_passed(3) = astring%ljust(2)//''=='abc'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(4) = astring%ljust(5, '.', by=SF_CHARS)//''=='caf'//char(195)//char(169)//'.'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   integer,                   intent(in)           :: width      !< Width of the result.
   character(kind=CK, len=1), intent(in), optional :: fill_char  !< Fill character, default a space.
   integer,                   intent(in), optional :: by         !< Unit of width: SF_BYTES (default) or SF_CHARS.
   type(string)                                    :: justified  !< The string justified.
   character(kind=CK, len=1)                       :: fill_char_ !< Fill character, local variable.
   integer                                         :: size_      !< Length of the string, in the unit of width.

   if (allocated(self%raw)) then
      size_ = measure(self%raw, by)
      fill_char_ = SPACE ; if (present(fill_char)) fill_char_ = fill_char
      if (width<=size_) then
         justified = self
      else
         justified%raw = self%raw//repeat(fill_char_, width - size_)
      endif
   endif
   endfunction ljust

   elemental function lstrip(self, remove, whitespace, unicode) result(stripped)
   !< Return a copy of the string with the leading characters removed: spaces by default, the characters of the set `remove`
   !< if passed, plus the whitespace of [[string:is_space]] if `whitespace` is true (as Python `str.lstrip`).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '  xx-ab-xx  '
   !< test_passed(1) = astring%lstrip()//'|'=='xx-ab-xx  |'
   !< test_passed(2) = astring%lstrip(remove=' x')//''=='-ab-xx'
   !< test_passed(3) = astring%lstrip(remove='')//''==astring//''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   character(kind=CK, len=*), intent(in), optional :: remove     !< Set of characters to be removed, default space.
   logical,                   intent(in), optional :: whitespace !< Remove the whitespace too.
   logical,                   intent(in), optional :: unicode    !< The whitespace is Unicode White_Space, not ASCII.
   type(string)                                    :: stripped   !< The stripped string.

   if (allocated(self%raw)) &
      stripped%raw = strip_set(raw=self%raw, set=strip_characters(remove=remove, whitespace=whitespace, unicode=unicode), &
                               left=.true., right=.false.)
   endfunction lstrip

   elemental function lower(self)
   !< Return a string with all lowercase characters.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 'Hello WorLD!'
   !< test_passed(1) = astring%lower()//''=='hello world!'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self  !< The string.
   type(string)              :: lower !< Upper case string.
   integer                   :: n1    !< Characters counter.

   if (allocated(self%raw)) then
      lower = self
      do n1=1, len(self%raw)
         lower%raw(n1:n1) = lower_char(self%raw(n1:n1))
      enddo
   endif
   endfunction lower

   pure function partition(self, sep) result(partitions)
   !< Split string at separator and return the 3 parts (before, the separator and after).
   !<
   !< @note As Python `str.partition`: if the separator is not found the parts are the string and two null strings. The
   !< default separator is a space.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: strings(3)
   !< logical      :: test_passed(5)
   !< astring = 'Hello WorLD!'
   !< strings = astring%partition(sep='lo Wo')
   !< test_passed(1) = (strings(1)//''=='Hel'.and.strings(2)//''=='lo Wo'.and.strings(3)//''=='rLD!')
   !< strings = astring%partition(sep='Hello')
   !< test_passed(2) = (strings(1)//''==''.and.strings(2)//''=='Hello'.and.strings(3)//''==' WorLD!')
   !< astring = 'Hello WorLD!'
   !< strings = astring%partition()
   !< test_passed(3) = (strings(1)//''=='Hello'.and.strings(2)//''==' '.and.strings(3)//''=='WorLD!')
   !< strings = astring%partition(sep='xyz')
   !< test_passed(4) = (strings(1)//''=='Hello WorLD!'.and.strings(2)//''==''.and.strings(3)//''=='')
   !< astring = 'ab'
   !< strings = astring%partition(sep='ab')
   !< test_passed(5) = (strings(1)//''==''.and.strings(2)//''=='ab'.and.strings(3)//''=='')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self            !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep             !< Separator.
   type(string)                                    :: partitions(1:3) !< Partions: before the separator, the separator itsels and
                                                                      !< after the separator.
   character(kind=CK, len=:), allocatable          :: sep_            !< Separator, default value.
   integer                                         :: c               !< Character counter.

   if (allocated(self%raw)) then
      sep_ = SPACE ; if (present(sep)) sep_ = sep

      partitions(1) = self
      partitions(2) = ''
      partitions(3) = ''
      c = index(self%raw, sep_)
      if (c>0) then
         partitions(1)%raw = self%raw(1:c-1)
         partitions(2)%raw = self%raw(c:c+len(sep_)-1)
         partitions(3)%raw = self%raw(c+len(sep_):)
      endif
   endif
   endfunction partition

   elemental function quote(self, quote_char) result(quoted)
   !< Return the string between `quote_char` (default `"`), every `quote_char` inside it doubled.
   !<
   !< @note The quoting of Fortran list-directed output and of CSV, undone by [[string:unquote]].
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'say "hi"'
   !< test_passed(1) = astring%quote()//''=='"say ""hi"""'
   !< test_passed(2) = astring%quote("'")//''=="'say ""hi""'"
   !< astring = astring%quote()
   !< test_passed(3) = astring%unquote()//''=='say "hi"'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self        !< The string.
   character(kind=CK, len=1), intent(in), optional :: quote_char  !< Quote character, default `"`.
   type(string)                                    :: quoted      !< The quoted string.
   character(kind=CK, len=1)                       :: quote_char_ !< Quote character, local variable.

   if (allocated(self%raw)) then
      quote_char_ = '"' ; if (present(quote_char)) quote_char_ = quote_char
      quoted%raw = quote_char_//replace_substring(raw=self%raw, old=quote_char_, new=quote_char_//quote_char_)//quote_char_
   endif
   endfunction quote

   subroutine read_file(self, file, is_fast, form, iostat, iomsg, skip_bom)
   !< Read a file as a single string stream.
   !<
   !< @note All the lines are stored into the string self as a single ascii stream. Each line (record) is separated by a `new_line`
   !< character.
   !<
   !< @note For unformatted read only `access='stream'` is supported with new_line as line terminator.
   !<
   !< @note *Fast* file reading allows a very efficient reading of streamed file, but it dumps file as single streamed string.
   !<
   !< @note With `skip_bom=.true.` a leading UTF-8 byte order mark (EF BB BF, see [[string:has_bom]]) is dropped.
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string), allocatable :: strings(:)
   !< type(string)              :: line(3)
   !< integer                   :: iostat
   !< character(len=99)         :: iomsg
   !< integer                   :: scratch
   !< integer                   :: l
   !< logical                   :: test_passed(9)
   !< line(1) = ' Hello World!   '
   !< line(2) = 'How are you?  '
   !< line(3) = '   All say: "Fine thanks"'
   !< open(newunit=scratch, file='read_file_test.tmp')
   !< write(scratch, "(A)") line(1)%chars()
   !< write(scratch, "(A)") line(2)%chars()
   !< write(scratch, "(A)") line(3)%chars()
   !< close(scratch)
   !< call astring%read_file(file='read_file_test.tmp', iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+1) = (strings(l)==line(l))
   !< enddo
   !< open(newunit=scratch, file='read_file_test.tmp', form='UNFORMATTED', access='STREAM')
   !< write(scratch) line(1)%chars()//new_line('a')
   !< write(scratch) line(2)%chars()//new_line('a')
   !< write(scratch) line(3)%chars()//new_line('a')
   !< close(scratch)
   !< call astring%read_file(file='read_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+5) = (strings(l)==line(l))
   !< enddo
   !< open(newunit=scratch, file='read_file_test.tmp', form='UNFORMATTED', access='STREAM')
   !< close(scratch, status='DELETE')
   !< call astring%read_file(file='read_file_test.tmp', iostat=iostat)
   !< test_passed(9) = (iostat/=0)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(inout)           :: self       !< The string.
   character(len=*), intent(in)              :: file       !< File name.
   logical,          intent(in),    optional :: is_fast    !< Flag to enable (super) fast file reading.
   character(len=*), intent(in),    optional :: form       !< Format of unit.
   integer,          intent(out),   optional :: iostat     !< IO status code.
   character(len=*), intent(inout), optional :: iomsg      !< IO status message.
   logical,          intent(in),    optional :: skip_bom   !< Drop a leading UTF-8 byte order mark.
   logical                                   :: is_fast_   !< Flag to enable (super) fast file reading, local variable.
   type(string)                              :: form_      !< Format of unit, local variable.
   integer                                   :: iostat_    !< IO status code, local variable.
   character(len=:), allocatable             :: iomsg_     !< IO status message, local variable.
   integer                                   :: unit       !< Logical unit.
   logical                                   :: does_exist !< Check if file exist.
   integer(I8P)                              :: filesize   !< Size of the file for fast reading.

   iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
   inquire(file=file, iomsg=iomsg_, iostat=iostat_, exist=does_exist)
   if (does_exist) then
      is_fast_ = .false. ; if (present(is_fast)) is_fast_ = is_fast
      if (is_fast_) then
         open(newunit=unit, file=file, access='STREAM', form='UNFORMATTED', iomsg=iomsg_, iostat=iostat_)
         if (iostat_==0) then
            inquire(unit=unit, size=filesize)
            if (allocated(self%raw)) deallocate(self%raw)
            allocate(character(kind=CK, len=filesize):: self%raw)
            read(unit=unit, iostat=iostat_, iomsg=iomsg_) self%raw
            close(unit)
            if (present(skip_bom)) then
               if (skip_bom.and.self%has_bom()) self%raw = self%raw(4:)
            endif
         endif
      else
         form_ = 'FORMATTED' ; if (present(form)) form_ = form ; form_ = form_%upper()
         select case(form_%chars())
         case('FORMATTED')
            open(newunit=unit, file=file, status='OLD', action='READ', iomsg=iomsg_, iostat=iostat_, err=10)
         case('UNFORMATTED')
            open(newunit=unit, file=file, status='OLD', action='READ', form='UNFORMATTED', access='STREAM', &
                 iomsg=iomsg_, iostat=iostat_, err=10)
         endselect
         call self%read_lines(unit=unit, form=form, iomsg=iomsg_, iostat=iostat_, skip_bom=skip_bom)
         10 close(unit)
      endif
   else
      iostat_ = 1
      iomsg_ = 'file not found'
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg)) iomsg = iomsg_
   endsubroutine read_file

   subroutine read_line(self, unit, form, iostat, iomsg)
   !< Read line (record) from a connected unit.
   !<
   !< The line is read as an ascii stream read until the eor is reached.
   !<
   !< @note `iostat` is zero when a line has been read, an empty one included: the string is then set to the line. At the end
   !< of the file `iostat` is the end-of-file code and the string is left unchanged, as it is on an error.
   !<
   !< @note For unformatted read only `access='stream'` is supported with new_line as line terminator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< integer      :: iostat
   !< integer      :: scratch
   !< integer      :: l
   !< logical      :: test_passed(6)
   !< open(newunit=scratch, status='SCRATCH')
   !< write(scratch, "(A)") 'first'
   !< write(scratch, "(A)") ''
   !< write(scratch, "(A)") 'third'
   !< rewind(scratch)
   !< astring = 'untouched'
   !< call astring%read_line(unit=scratch, iostat=iostat)
   !< test_passed(1) = (iostat==0.and.astring=='first')
   !< call astring%read_line(unit=scratch, iostat=iostat)
   !< test_passed(2) = (iostat==0.and.astring%len()==0)
   !< call astring%read_line(unit=scratch, iostat=iostat)
   !< test_passed(3) = (iostat==0.and.astring=='third')
   !< call astring%read_line(unit=scratch, iostat=iostat)
   !< test_passed(4) = (is_iostat_end(iostat).and.astring=='third')
   !< close(scratch)
   !< open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
   !< write(scratch) 'first'//new_line('a')//new_line('a')//'last, not terminated'
   !< rewind(scratch)
   !< l = 0
   !< do
   !<   call astring%read_line(unit=scratch, iostat=iostat, form='unformatted')
   !<   if (iostat/=0) exit
   !<   l = l + 1
   !< enddo
   !< test_passed(5) = (l==3.and.astring=='last, not terminated')
   !< test_passed(6) = is_iostat_end(iostat)
   !< close(scratch)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(string)      :: astring
   !< type(string)      :: line(3)
   !< integer           :: iostat
   !< character(len=99) :: iomsg
   !< integer           :: scratch
   !< integer           :: l
   !< logical           :: test_passed(6)
   !< line(1) = ' Hello World!   '
   !< line(2) = 'How are you?  '
   !< line(3) = '   All say: "Fine thanks"'
   !< open(newunit=scratch, status='SCRATCH')
   !< write(scratch, "(A)") line(1)%chars()
   !< write(scratch, "(A)") line(2)%chars()
   !< write(scratch, "(A)") line(3)%chars()
   !< rewind(scratch)
   !< l = 0
   !< iostat = 0
   !< do
   !<   l = l + 1
   !<   call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg)
   !<   if (iostat/=0.and..not.is_iostat_eor(iostat)) then
   !<     exit
   !<   else
   !<     test_passed(l) = (astring==line(l))
   !<   endif
   !< enddo
   !< close(scratch)
   !< open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
   !< write(scratch) line(1)%chars()//new_line('a')
   !< write(scratch) line(2)%chars()//new_line('a')
   !< write(scratch) line(3)%chars()//new_line('a')
   !< rewind(scratch)
   !< l = 0
   !< iostat = 0
   !< do
   !<   l = l + 1
   !<   call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg, form='UnfORMatteD')
   !<   if (iostat/=0.and..not.is_iostat_eor(iostat)) then
   !<     exit
   !<   else
   !<     test_passed(l+3) = (astring==line(l))
   !<   endif
   !< enddo
   !< close(scratch)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(inout)           :: self      !< The string.
   integer,          intent(in)              :: unit      !< Logical unit.
   character(len=*), intent(in),    optional :: form      !< Format of unit.
   integer,          intent(out),   optional :: iostat    !< IO status code.
   character(len=*), intent(inout), optional :: iomsg     !< IO status message.
   type(string)                              :: form_     !< Format of unit, local variable.
   integer                                   :: iostat_   !< IO status code, local variable.
   character(len=:),          allocatable    :: iomsg_    !< IO status message, local variable.
   character(kind=CK, len=:), allocatable    :: line      !< Line storage, a buffer of which only line_len chars are used.
   integer                                   :: line_len  !< Length of the line read.
   character(kind=CK, len=1024)              :: chunk     !< Chunk of the line read by a single statement.
   integer                                   :: chunk_len !< Length of the chunk read.
   character(kind=CK, len=1)                 :: ch        !< Character storage.

   form_ = 'FORMATTED' ; if (present(form)) form_ = form ; form_ = form_%upper()
   iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
   line_len = 0
   select case(form_%chars())
   case('FORMATTED')
      do
         chunk_len = 0
         read(unit, "(A)", advance='no', size=chunk_len, iostat=iostat_, iomsg=iomsg_) chunk
         if (iostat_==0.or.is_iostat_eor(iostat_).or.is_iostat_end(iostat_)) &
            call append_to_buffer(buffer=line, length=line_len, piece=chunk(1:chunk_len))
         if (iostat_/=0) exit
      enddo
   case('UNFORMATTED')
      do
         read(unit, iostat=iostat_, iomsg=iomsg_) ch
         if (iostat_/=0) exit
         if (ch==new_line('a')) then
            iostat_ = iostat_eor
            exit
         endif
         call append_to_buffer(buffer=line, length=line_len, piece=ch)
      enddo
   endselect
   if (is_iostat_eor(iostat_)) iostat_ = 0                 ! the end of the record is the regular end of a line
   if (is_iostat_end(iostat_).and.line_len>0) iostat_ = 0 ! last line without line terminator
   if (iostat_==0) then
      if (line_len>0) then
         self%raw = line(1:line_len)
      else
         self%raw = ''
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg)) iomsg = iomsg_
   endsubroutine read_line

   subroutine read_lines(self, unit, form, iostat, iomsg, skip_bom)
   !< Read (all) lines (records) from a connected unit as a single ascii stream.
   !<
   !< @note All the lines are stored into the string self as a single ascii stream. Each line (record) is separated by a `new_line`
   !< character. The line is read as an ascii stream read until the eor is reached.
   !<
   !< @note The connected unit is rewinded. At a successful exit current record is at eof, at the beginning otherwise.
   !<
   !< @note With `skip_bom=.true.` a leading UTF-8 byte order mark (EF BB BF, see [[string:has_bom]]) is dropped.
   !<
   !< @note For unformatted read only `access='stream'` is supported with new_line as line terminator.
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string), allocatable :: strings(:)
   !< type(string)              :: line(3)
   !< integer                   :: iostat
   !< character(len=99)         :: iomsg
   !< integer                   :: scratch
   !< integer                   :: l
   !< logical                   :: test_passed(8)
   !<
   !< line(1) = ' Hello World!   '
   !< line(2) = 'How are you?  '
   !< line(3) = '   All say: "Fine thanks"'
   !< open(newunit=scratch, status='SCRATCH')
   !< write(scratch, "(A)") line(1)%chars()
   !< write(scratch, "(A)") line(2)%chars()
   !< write(scratch, "(A)") line(3)%chars()
   !< call astring%read_lines(unit=scratch, iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+1) = (strings(l)==line(l))
   !< enddo
   !< close(scratch)
   !< open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
   !< write(scratch) line(1)%chars()//new_line('a')
   !< write(scratch) line(2)%chars()//new_line('a')
   !< write(scratch) line(3)%chars()//new_line('a')
   !< call astring%read_lines(unit=scratch, form='unformatted', iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+5) = (strings(l)==line(l))
   !< enddo
   !< close(scratch)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(inout)           :: self      !< The string.
   integer,          intent(in)              :: unit      !< Logical unit.
   character(len=*), intent(in),    optional :: form      !< Format of unit.
   integer,          intent(out),   optional :: iostat    !< IO status code.
   character(len=*), intent(inout), optional :: iomsg     !< IO status message.
   logical,          intent(in),    optional :: skip_bom  !< Drop a leading UTF-8 byte order mark.
   integer                                   :: iostat_   !< IO status code, local variable.
   character(len=:), allocatable             :: iomsg_    !< IO status message, local variable.
   character(kind=CK, len=:), allocatable    :: lines     !< Lines storage, a buffer of which only lines_len chars are used.
   integer                                   :: lines_len !< Length of the lines read.
   type(string)                              :: line      !< Line storage.

   iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
   rewind(unit)
   iostat_ = 0
   lines_len = 0
   do
      line%raw = ''
      call line%read_line(unit=unit, form=form, iostat=iostat_, iomsg=iomsg_)
      if (iostat_/=0) exit
      call append_to_buffer(buffer=lines, length=lines_len, piece=line%raw)
      call append_to_buffer(buffer=lines, length=lines_len, piece=new_line('a'))
   enddo
   if (lines_len>0) self%raw = lines(1:lines_len)
   if (present(skip_bom)) then
      if (skip_bom.and.self%has_bom()) self%raw = self%raw(4:)
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg)) iomsg = iomsg_
   endsubroutine read_lines

   elemental function replace(self, old, new, count) result(replaced)
   !< Return a string with all occurrences of substring old replaced by new.
   !<
   !< @note The occurrences are not overlapping, found from left to right, and the replaced text is not searched again
   !< (as Python `str.replace`): `'aaaa'` with `'aa'` replaced by `'a'` gives `'aa'`. If `count` is passed only the first
   !< `count` occurrences are replaced, none if `count<=0`. A null `old` substring leaves the string unchanged.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(8)
   !< astring = 'When YOU are sad YOU should think to me :-)'
   !< test_passed(1) = (astring%replace(old='YOU', new='THEY')//''=='When THEY are sad THEY should think to me :-)')
   !< test_passed(2) = (astring%replace(old='YOU', new='THEY', count=1)//''=='When THEY are sad YOU should think to me :-)')
   !< astring = repeat(new_line('a')//'abcd', 20)
   !< astring = astring%replace(old=new_line('a'), new='|cr|')
   !< astring = astring%replace(old='|cr|', new=new_line('a')//'    ')
   !< test_passed(3) = (astring//''==repeat(new_line('a')//'    '//'abcd', 20))
   !< astring = 'abcd  efg    hlmn'
   !< astring = astring%replace(old='', new='-')
   !< test_passed(4) = (astring//''=='abcd  efg    hlmn')
   !< astring = 'aaa'
   !< test_passed(5) = (astring%replace(old='a', new='aa')//''=='aaaaaa')
   !< astring = 'aaaa'
   !< test_passed(6) = (astring%replace(old='aa', new='a')//''=='aa')
   !< astring = 'abab'
   !< test_passed(7) = (astring%replace(old='ab', new='x', count=0)//''=='abab')
   !< test_passed(8) = (astring%replace(old='ab', new='')//''=='')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self     !< The string.
   character(kind=CK, len=*), intent(in)           :: old      !< Old substring.
   character(kind=CK, len=*), intent(in)           :: new      !< New substring.
   integer,                   intent(in), optional :: count    !< Number of old occurences to be replaced.
   type(string)                                    :: replaced !< The string with old replaced by new.

   if (allocated(self%raw)) then
      if (len(old)==0) then
         replaced = self
      else
         replaced%raw = replace_substring(raw=self%raw, old=old, new=new, count=count)
      endif
   endif
   endfunction replace

   elemental function reverse(self) result(reversed)
   !< Return a reversed string.
   !<
   !< @note The units are reversed, a unit being a well-formed UTF-8 sequence or a byte that is not part of one: the bytes
   !< of a character keep their order, so the result of a well-formed string is well-formed.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'abcdefghilmnopqrstuvz'
   !< test_passed(1) = (astring%reverse()//''=='zvutsrqponmlihgfedcba')
   !< astring = '0123456789'
   !< test_passed(2) = (astring%reverse()//''=='9876543210')
   !< astring = 'ab'//char(228)//char(189)//char(160)//char(195)//char(169)
   !< test_passed(3) = (astring%reverse()//''==char(195)//char(169)//char(228)//char(189)//char(160)//'ba')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   type(string)              :: reversed !< The reversed string.
   integer                   :: length   !< Length of the string.
   integer                   :: c        !< Counter.
   integer                   :: n        !< Bytes of a unit.

   if (allocated(self%raw)) then
      reversed = self
      length = len(self%raw)
      if (is_ascii(self%raw)) then ! one byte per unit: the plain byte loop
         do c=1, length
            reversed%raw(c:c) = self%raw(length-c+1:length-c+1)
         enddo
         return
      endif
      c = 1
      do while (c<=length)
         n = 1
         if (iand(ichar(self%raw(c:c)), 255)>127) n = utf8_unit_len(self%raw, c)
         reversed%raw(length-c-n+2:length-c+1) = self%raw(c:c+n-1)
         c = c + n
      enddo
   endif
   endfunction reverse

   elemental function reverse_words(self, sep) result(reversed)
   !< Return a string with the words order reversed.
   !<
   !< @note Multiple subsequent separators are collapsed to one occurence, leading and trailing ones are removed.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(5)
   !< astring = 'the sky is blue'
   !< test_passed(1) = astring%reverse_words()//''=='blue is sky the'
   !< astring = '  hello world  '
   !< test_passed(2) = astring%reverse_words()//''=='world hello'
   !< astring = 'a good   example'
   !< test_passed(3) = astring%reverse_words()//''=='example good a'
   !< astring = 'src/lib/stringifor'
   !< test_passed(4) = astring%reverse_words(sep='/')//''=='stringifor/lib/src'
   !< astring = '   '
   !< test_passed(5) = astring%reverse_words()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: reversed  !< The string with words order reversed.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.
   type(string), allocatable                       :: tokens(:) !< String tokens.
   integer                                         :: Nt        !< Number of tokens.

   if (allocated(self%raw)) then
      sep_ = SPACE ; if (present(sep)) sep_ = sep
      call self%split(tokens=tokens, sep=sep_)
      Nt = size(tokens, dim=1)
      if (Nt>0) then
         reversed = reversed%join(array=tokens(Nt:1:-1), sep=sep_)
      else
         reversed = ''
      endif
   endif
   endfunction reverse_words

   elemental function rjust(self, width, fill_char, by) result(justified)
   !< Return the string right justified in a string of length `width`, padded with `fill_char` (default a space).
   !<
   !< @note As Python `str.rjust`: a string not shorter than `width` is returned unchanged.
   !<
   !< @note With `by=SF_CHARS` the width counts characters (UTF-8 units) instead of bytes, with `by=SF_COLUMNS` the
   !< display columns of a terminal (see [[string:width]]).
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: centered
   !< logical      :: test_passed(4)
   !< astring = 'abc'
   !< test_passed(1) = astring%rjust(6, '.')//''=='...abc'
   !< centered = astring%rjust(6)
   !< test_passed(2) = centered%len()==6.and.centered//''=='   abc'
   !< test_passed(3) = astring%rjust(2)//''=='abc'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(4) = astring%rjust(5, '.', by=SF_CHARS)//''=='.'//'caf'//char(195)//char(169)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   integer,                   intent(in)           :: width      !< Width of the result.
   character(kind=CK, len=1), intent(in), optional :: fill_char  !< Fill character, default a space.
   integer,                   intent(in), optional :: by         !< Unit of width: SF_BYTES (default) or SF_CHARS.
   type(string)                                    :: justified  !< The string justified.
   character(kind=CK, len=1)                       :: fill_char_ !< Fill character, local variable.
   integer                                         :: size_      !< Length of the string, in the unit of width.

   if (allocated(self%raw)) then
      size_ = measure(self%raw, by)
      fill_char_ = SPACE ; if (present(fill_char)) fill_char_ = fill_char
      if (width<=size_) then
         justified = self
      else
         justified%raw = repeat(fill_char_, width - size_)//self%raw
      endif
   endif
   endfunction rjust

   elemental function rstrip(self, remove, whitespace, unicode) result(stripped)
   !< Return a copy of the string with the trailing characters removed: spaces by default, the characters of the set `remove`
   !< if passed, plus the whitespace of [[string:is_space]] if `whitespace` is true (as Python `str.rstrip`).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '  xx-ab-xx'//achar(9)//new_line('a')
   !< test_passed(1) = '|'//astring%rstrip(whitespace=.true.)=='|  xx-ab-xx'
   !< test_passed(2) = astring%rstrip(remove='x', whitespace=.true.)//''=='  xx-ab-'
   !< test_passed(3) = astring%rstrip()//''==astring//''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   character(kind=CK, len=*), intent(in), optional :: remove     !< Set of characters to be removed, default space.
   logical,                   intent(in), optional :: whitespace !< Remove the whitespace too.
   logical,                   intent(in), optional :: unicode    !< The whitespace is Unicode White_Space, not ASCII.
   type(string)                                    :: stripped   !< The stripped string.

   if (allocated(self%raw)) &
      stripped%raw = strip_set(raw=self%raw, set=strip_characters(remove=remove, whitespace=whitespace, unicode=unicode), &
                               left=.false., right=.true.)
   endfunction rstrip

   function search(self, tag_start, tag_end, in_string, in_character, istart, iend) result(tag)
   !< Search for *tagged* record into string, return the first record found (if any) matching the tags.
   !<
   !< Optionally, returns the indexes of tag start/end, thus this is not an `elemental` function.
   !<
   !< @note The tagged record is searched into self if allocated otherwise into `in_string` if passed or, eventually, into
   !< `in_character` is passed. If tag is not found the return string is not allocated and the start/end indexes (if requested) are
   !< zero.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< type(string)                  :: anotherstring
   !< character(len=:), allocatable :: acharacter
   !< integer                       :: istart
   !< integer                       :: iend
   !< logical                       :: test_passed(5)
   !< astring = '<test> <first> hello </first> <first> not the first </first> </test>'
   !< anotherstring = astring%search(tag_start='<first>', tag_end='</first>')
   !< test_passed(1) = anotherstring//''=='<first> hello </first>'
   !< astring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
   !< anotherstring = astring%search(tag_start='<a>', tag_end='</a>')
   !< test_passed(2) = anotherstring//''=='<a> <a> <a> the nested a </a> </a> </a>'
   !< call astring%free
   !< anotherstring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
   !< astring = astring%search(in_string=anotherstring, tag_start='<a>', tag_end='</a>')
   !< test_passed(3) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
   !< call astring%free
   !< acharacter = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
   !< astring = astring%search(in_character=acharacter, tag_start='<a>', tag_end='</a>')
   !< test_passed(4) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
   !< acharacter = '<test> <first> hello </first> <sec> <sec>not the first</sec> </sec> </test>'
   !< astring = astring%search(in_character=acharacter, tag_start='<sec>', tag_end='</sec>', istart=istart, iend=iend)
   !< test_passed(5) = astring//''==acharacter(31:67)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)            :: self         !< The string.
   character(kind=CK, len=*), intent(in)            :: tag_start    !< Start tag.
   character(kind=CK, len=*), intent(in)            :: tag_end      !< End tag.
   type(string),              intent(in),  optional :: in_string    !< Search into this string.
   character(kind=CK, len=*), intent(in),  optional :: in_character !< Search into this character string.
   integer,                   intent(out), optional :: istart       !< Starting index of tag inside the string.
   integer,                   intent(out), optional :: iend         !< Ending index of tag inside the string.
   type(string)                                     :: tag          !< First tag found.
   character(kind=CK, len=:), allocatable           :: raw          !< Raw string into which search the tag.
   integer                                          :: istart_      !< Starting index of tag inside the string, local variable.
   integer                                          :: iend_        !< Ending index of tag inside the string, local variable.
   integer                                          :: nested_tags  !< Number of nested tags inside tag.
   integer                                          :: t            !< Counter.

   raw = ''
   if (present(in_string)) then
      raw = in_string%raw
   elseif (present(in_character)) then
      raw = in_character
   else
      if (allocated(self%raw)) raw = self%raw
   endif
   istart_ = 0
   iend_ = 0
   if (raw/='') then
      istart_ = index(raw, tag_start)
      iend_ = index(raw, tag_end)
      if (istart_>0.and.iend_>0) then
         iend_ = iend_ + len(tag_end) - 1
         tag%raw = raw(istart_:iend_)
         nested_tags = tag%count(tag_start)
         if (nested_tags>1) then
            do t=2, nested_tags
               iend_ = iend_ + len(tag_end) - 1 + index(raw(iend_+1:), tag_end)
            enddo
            tag%raw = raw(istart_:iend_)
         endif
      endif
   endif
   if (present(istart)) istart = istart_
   if (present(iend)) iend = iend_
   endfunction search

   pure function slice(self, first, last, stride, istart, iend, by) result(raw)
   !< Return the raw characters data sliced.
   !<
   !< The slice is `first:last:stride`, like a Fortran array section, both bounds being included. All the arguments are optional:
   !< `stride` defaults to 1, `first` and `last` default to the string bounds, namely `1:len` for a positive stride and `len:1`
   !< for a negative one. The bounds are clamped into the string ones, thus a slice never goes out of bounds: it is null if the
   !< clamped section is empty, if `stride` is zero or if the string is not allocated.
   !<
   !< @note With `by=SF_CHARS` first, last and stride count characters (UTF-8 units), which are never cut.
   !<
   !< @note `istart` and `iend` are deprecated aliases of `first` and `last`, kept for backward compatibility of keyword calls:
   !< they are ignored if `first` and `last` are passed.
   !<
   !<```fortran
   !< type(string) :: astring
   !< astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
   !< print "(A)", astring%slice(11,25)
   !<```
   !=> Brown fox Jumps <<<
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(14)
   !< astring = 'Hello World'
   !< test_passed(1) = astring%slice(first=1, last=5)=='Hello'
   !< test_passed(2) = astring%slice(first=7)=='World'
   !< test_passed(3) = astring%slice(last=5)=='Hello'
   !< test_passed(4) = astring%slice()=='Hello World'
   !< test_passed(5) = astring%slice(stride=2)=='HloWrd'
   !< test_passed(6) = astring%slice(stride=-1)=='dlroW olleH'
   !< test_passed(7) = astring%slice(first=5, last=1, stride=-2)=='olH'
   !< test_passed(8) = astring%slice(first=-3, last=100)=='Hello World'
   !< test_passed(9) = len(astring%slice(first=7, last=5))==0
   !< test_passed(10) = len(astring%slice(stride=0))==0
   !< test_passed(11) = astring%slice(istart=1, iend=5)=='Hello'
   !< call astring%free
   !< test_passed(12) = len(astring%slice(first=1, last=5))==0
   !< astring = 'caf'//char(195)//char(169)//'!'
   !< test_passed(13) = astring%slice(first=4, last=4, by=SF_CHARS)==char(195)//char(169)
   !< test_passed(14) = astring%slice(stride=-1, by=SF_CHARS)=='!'//char(195)//char(169)//'fac'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: self    !< The string.
   integer,       intent(in), optional    :: first   !< Slice first index, default 1 (len for negative stride).
   integer,       intent(in), optional    :: last    !< Slice last index, default len (1 for negative stride).
   integer,       intent(in), optional    :: stride  !< Slice stride, default 1.
   integer,       intent(in), optional    :: istart  !< Deprecated alias of first.
   integer,       intent(in), optional    :: iend    !< Deprecated alias of last.
   integer,       intent(in), optional    :: by      !< Unit of first, last and stride: SF_BYTES (default) or SF_CHARS.
   character(kind=CK, len=:), allocatable :: raw     !< Raw characters data.
   integer                                :: first_  !< Slice first index, local variable.
   integer                                :: last_   !< Slice last index, local variable.
   integer                                :: stride_ !< Slice stride, local variable.
   integer                                :: length  !< Length of the slice.
   integer                                :: c       !< Character counter.
   integer, allocatable                   :: starts(:) !< First byte of each unit, then len+1 (by=SF_CHARS).
   integer                                :: size_   !< Length of the string in the unit asked.
   integer                                :: i       !< Byte position.
   integer                                :: o       !< Byte position in the result.
   logical                                :: by_char !< Positions in characters.

   stride_ = 1 ; if (present(stride)) stride_ = stride
   if (allocated(self%raw).and.stride_/=0) then
      by_char = .false.
      if (present(by)) by_char = by==SF_CHARS.and..not.is_ascii(self%raw)
      size_ = len(self%raw)
      if (by_char) then ! the units, as a list of their first bytes
         size_ = utf8_units(self%raw)
         allocate(starts(size_+1))
         i = 1
         do c=1, size_
            starts(c) = i
            i = i + unit_length(self%raw, i)
         enddo
         starts(size_+1) = len(self%raw) + 1
      endif
      if (stride_>0) then
         first_ = 1
         last_ = size_
      else
         first_ = size_
         last_ = 1
      endif
      if (present(istart)) first_ = istart
      if (present(iend)) last_ = iend
      if (present(first)) first_ = first
      if (present(last)) last_ = last
      if (stride_>0) then
         first_ = max(first_, 1)
         last_ = min(last_, size_)
      else
         first_ = min(first_, size_)
         last_ = max(last_, 1)
      endif
      length = max(0, (last_ - first_ + stride_)/stride_)
      if (by_char.and.length>0) then ! the units first_, first_+stride_, ...: two passes, measure then fill
         o = 0
         do c=1, length
            i = first_ + (c - 1) * stride_
            o = o + starts(i+1) - starts(i)
         enddo
         allocate(character(kind=CK, len=o) :: raw)
         o = 0
         do c=1, length
            i = first_ + (c - 1) * stride_
            raw(o+1:o+starts(i+1)-starts(i)) = self%raw(starts(i):starts(i+1)-1)
            o = o + starts(i+1) - starts(i)
         enddo
      elseif (length>0) then
         if (stride_==1) then
            raw = self%raw(first_:last_)
         else
            allocate(character(kind=CK, len=length) :: raw)
            do c=1, length
               raw(c:c) = self%raw(first_+(c-1)*stride_:first_+(c-1)*stride_)
            enddo
         endif
      endif
   endif
   if (.not.allocated(raw)) raw = ''
   endfunction slice

   elemental function snakecase(self, sep)
   !< Return a string with all words lowercase separated by "_".
   !<
   !< @note Multiple subsequent separators are collapsed to one occurence.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
   !< test_passed(1) = astring%snakecase()//''=='the_quick_brown_fox_jumps_over_the_lazy_dog.'
   !< astring = '   '
   !< test_passed(2) = astring%snakecase()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: snakecase !< Snake case string.
   type(string), allocatable                       :: tokens(:) !< String tokens.

   if (allocated(self%raw)) then
      call self%split(tokens=tokens, sep=sep)
      tokens = tokens%lower()
      snakecase = snakecase%join(array=tokens, sep='_')
   endif
   endfunction snakecase

   pure subroutine split(self, tokens, sep, max_tokens, keep_empty)
   !< Return a list of substring in the string, using sep as the delimiter string.
   !<
   !< @note Multiple subsequent separators are collapsed to one occurrence.
   !<
   !< @note With `keep_empty=.true.` nothing is collapsed and the empty fields are tokens (as Python `str.split(sep)`): `'a,,b'`
   !< gives `'a'`, `''` and `'b'`, a null string gives one null token; `max_tokens` is then the number of splits, the last token
   !< being the rest of the string.
   !<
   !< @note If `max_tokens` is passed the returned number of tokens is either `max_tokens` or `max_tokens + 1`.
   !<
   !< @note A string made only of separators has no tokens (`tokens` is allocated with size 0).
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string), allocatable :: strings(:)
   !< logical                   :: test_passed(14)
   !< astring = '+ab-++cre-++cre-ab+'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(1) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
   !< astring = 'ab-++cre-++cre-ab+'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(2) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
   !< astring = 'ab-++cre-++cre-ab'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(3) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
   !< astring = 'Hello '//new_line('a')//'World!'
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(4) = (strings(1)//''=='Hello '.and.strings(2)//''=='World!')
   !< astring = 'Hello World!'
   !< call astring%split(tokens=strings)
   !< test_passed(5) = (strings(1)//''=='Hello'.and.strings(2)//''=='World!')
   !< astring = '+ab-'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(6) = (strings(1)//''=='ab-')
   !< astring = '+ab-'
   !< call astring%split(tokens=strings, sep='-')
   !< test_passed(7) = (strings(1)//''=='+ab')
   !< astring = '+ab-+cd-'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(8) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
   !< astring = 'ab-+cd-+'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(9) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
   !< astring = '+ab-+cd-+'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(10) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
   !< astring = '1-2-3-4-5-6-7-8'
   !< call astring%split(tokens=strings, sep='-', max_tokens=3)
   !< test_passed(11) = (strings(1)//''=='1'.and.strings(2)//''=='2'.and.strings(3)//''=='3'.and.strings(4)//''=='4-5-6-7-8')
   !< astring = '+++'
   !< call astring%split(tokens=strings, sep='+')
   !< test_passed(12) = (size(strings, dim=1)==0)
   !< astring = ',a,,b,'
   !< call astring%split(tokens=strings, sep=',', keep_empty=.true.)
   !< test_passed(13) = size(strings, dim=1)==5
   !< if (test_passed(13)) test_passed(13) = all(strings==['  ', 'a ', '  ', 'b ', '  ']).and.all(strings%len()==[0, 1, 0, 1, 0])
   !< call astring%split(tokens=strings, sep=',', max_tokens=2, keep_empty=.true.)
   !< test_passed(14) = size(strings, dim=1)==3
   !< if (test_passed(14)) test_passed(14) = strings(1)//''==''.and.strings(2)//''=='a'.and.strings(3)//''==',b,'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   type(string), allocatable, intent(out)          :: tokens(:)  !< Tokens substring.
   character(kind=CK, len=*), intent(in), optional :: sep        !< Separator.
   integer,                   intent(in), optional :: max_tokens !< Fix the maximum number of returned tokens.
   logical,                   intent(in), optional :: keep_empty !< Keep the empty fields, collapsing nothing.
   character(kind=CK, len=:), allocatable          :: sep_       !< Separator, default value.
   character(kind=CK, len=:), allocatable          :: uniq       !< The string with the sequential separators collapsed.
   integer,                   allocatable          :: pos(:)     !< Positions of the separators into uniq.
   integer                                         :: No         !< Number of occurrences of sep.
   integer                                         :: first      !< Index of the first token from the head field.
   integer                                         :: c          !< Character counter.
   integer                                         :: t          !< Counter.
   logical                                         :: has_head   !< The field before the first separator is a token.
   logical                                         :: has_tail   !< The field after the last separator is a token.

   if (allocated(self%raw)) then
     sep_ = SPACE ; if (present(sep)) sep_ = sep
     if (present(keep_empty)) then
       if (keep_empty) then ! split at every separator (at the first max_tokens ones), the empty fields being tokens
         No = count_substring(self%raw, sep_)
         if (present(max_tokens)) then
           if (max_tokens < No.and.max_tokens > 0) No = max_tokens
         endif
         allocate(tokens(No+1))
         c = 1
         do t=1, No
           first = c - 1 + index(self%raw(c:), sep_) ! first character of the separator
           tokens(t)%raw = self%raw(c:first-1)
           c = first + len(sep_)
         enddo
         tokens(No+1)%raw = self%raw(c:)
         return
       endif
     endif

     uniq = unique_substring(raw=self%raw, substring=sep_)
     No = count_substring(uniq, sep_)
     if (No==0) then
       allocate(tokens(1))
       tokens(1) = self
       return
     endif
     if (uniq==sep_.and.len(uniq)==len(sep_)) then ! only separators: no tokens
       allocate(tokens(0))
       return
     endif
     if (present(max_tokens)) then
       if (max_tokens < No.and.max_tokens > 0) No = max_tokens
     endif

     allocate(pos(No))
     c = 1
     do t=1, No
       pos(t) = c - 1 + index(uniq(c:), sep_)
       c = pos(t) + len(sep_)
     enddo
     ! the head and the tail fields are tokens only if they are not blank, the inner fields always are
     has_head = uniq(1:pos(1)-1)/=''
     has_tail = uniq(pos(No)+len(sep_):)/=''
     allocate(tokens(No - 1 + merge(1, 0, has_head) + merge(1, 0, has_tail)))
     first = 0
     if (has_head) then
       tokens(1)%raw = uniq(1:pos(1)-1)
       first = 1
     endif
     do t=2, No
       tokens(first+t-1)%raw = uniq(pos(t-1)+len(sep_):pos(t)-1)
     enddo
     if (has_tail) tokens(size(tokens, dim=1))%raw = uniq(pos(No)+len(sep_):)
   endif
   endsubroutine split

   pure subroutine split_chunked(self, tokens, chunks, sep)
   !< Return a list of substring in the string, using sep as the delimiter string, chunked (memory-efficient) algorithm.
   !<
   !< @note Multiple subsequent separators are collapsed to one occurrence.
   !<
   !< @note The split is performed in chunks of `#chunks` to avoid excessive memory consumption.
   !<
   !< @note As [[string:split]], a string made only of separators has no tokens (`tokens` is allocated with size 0) and a
   !< null string has one null token.
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string), allocatable :: strings(:)
   !< logical                   :: test_passed(3)
   !< astring = '-1-2-3-4-5-6-7-8-'
   !< call astring%split_chunked(tokens=strings, sep='-', chunks=3)
   !< test_passed(1) = (strings(1)//''=='1'.and.strings(2)//''=='2'.and.strings(3)//''=='3'.and.strings(4)//''=='4'.and. &
   !<                   strings(5)//''=='5'.and.strings(6)//''=='6'.and.strings(7)//''=='7'.and.strings(8)//''=='8')
   !< astring = '--'
   !< call astring%split_chunked(tokens=strings, sep='-', chunks=2)
   !< test_passed(2) = size(strings)==0
   !< astring = ''
   !< call astring%split_chunked(tokens=strings, sep='-', chunks=2)
   !< test_passed(3) = size(strings)==1
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   type(string), allocatable, intent(out)          :: tokens(:) !< Tokens substring.
   integer,                   intent(in)           :: chunks    !< Number of chunks.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.
   integer                                         :: Nt        !< Number of actual tokens.
   integer                                         :: t         !< Counter.
   logical                                         :: isok

   if (allocated(self%raw)) then
     sep_ = SPACE ; if (present(sep)) sep_ = sep

     Nt = self%count(sep_)
     if (self%start_with(prefix=sep_)) Nt = Nt - 1
     if (self%end_with(suffix=sep_)) Nt = Nt - 1
     t = 0
     call self%split(tokens=tokens, sep=sep_, max_tokens=chunks)
     if (size(tokens, dim=1)==0) return ! only separators: no token
     do
       t = size(tokens, dim=1)
       if (t > Nt) exit
       call split_last_token(tokens=tokens, max_tokens=chunks,isok=isok)
       if(isok)then
       else
            exit
       endif
     enddo

     t = size(tokens, dim=1)
     if (tokens(t)%count(sep_) > 0) then
        call split_last_token(tokens=tokens,isok=isok)
     endif
   endif

   contains
      pure subroutine split_last_token(tokens, max_tokens,isok)
      !< Split last token.
      type(string), allocatable, intent(inout)        :: tokens(:)      !< Tokens substring.
      integer,                   intent(in), optional :: max_tokens     !< Max tokens returned.
      type(string), allocatable                       :: tokens_(:)     !< Temporary tokens.
      type(string), allocatable                       :: tokens_swap(:) !< Swap tokens.
      integer                                         :: Nt_            !< Number of last created tokens.
      logical,intent(out)                             :: isok

      isok=.true.
      call tokens(t)%split(tokens=tokens_, sep=sep_, max_tokens=max_tokens)
      if (allocated(tokens_)) then
        Nt_ = size(tokens_, dim=1)
        if (Nt_ >= 1) then
          allocate(tokens_swap(1:t-1+Nt_))
          tokens_swap(1:t-1) = tokens(1:t-1)
          tokens_swap(t:)    = tokens_(:)
          call move_alloc(from=tokens_swap, to=tokens)
        endif
        if (Nt_ == 1) then
            isok=.false.
        end if
        deallocate(tokens_)
      endif
      endsubroutine split_last_token
   endsubroutine split_chunked

   elemental function squeeze(self, set) result(squeezed)
   !< Return a string with every run of a repeated character reduced to one, only for the characters of `set` if passed.
   !<
   !< @note As `tr -s`. To reduce the runs of a substring see [[string:unique]]. A character is a unit, a well-formed
   !< UTF-8 sequence or a byte that is not part of one, and `set` is a set of units.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'bookkeeper  --  aa'
   !< test_passed(1) = astring%squeeze()//''=='bokeper - a'
   !< test_passed(2) = astring%squeeze(set=' -')//''=='bookkeeper - aa'
   !< astring = 'n'//char(195)//char(169)//char(195)//char(169)//'e'
   !< test_passed(3) = astring%squeeze()//''=='n'//char(195)//char(169)//'e'
   !< test_passed(4) = astring%squeeze(set=char(195))//''==astring//''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self     !< The string.
   character(kind=CK, len=*), intent(in), optional :: set      !< Characters whose runs are reduced, default all.
   type(string)                                    :: squeezed !< The squeezed string.
   character(kind=CK, len=:), allocatable          :: buffer   !< Buffer, the result being never longer than the string.
   integer                                         :: length   !< Length of the result.
   integer                                         :: c        !< Byte position of the current unit.
   integer                                         :: n        !< Bytes of the current unit.
   integer                                         :: p        !< Byte position of the previous unit.
   integer                                         :: m        !< Bytes of the previous unit (0: none).
   logical                                         :: is_run   !< The unit repeats the previous one and is squeezed.

   if (allocated(self%raw)) then
      if (is_ascii(self%raw)) then ! one byte per unit (a non-ASCII member of set never matches one)
         call squeeze_bytes(self%raw, squeezed%raw, set)
         return
      endif
      allocate(character(kind=CK, len=len(self%raw)) :: buffer)
      length = 0
      m = 0
      p = 1
      c = 1
      do while (c<=len(self%raw))
         n = 1
         if (iand(ichar(self%raw(c:c)), 255)>127) n = utf8_unit_len(self%raw, c)
         is_run = .false.
         if (m==n) then
            if (self%raw(c:c+n-1)==self%raw(p:p+m-1)) then
               is_run = .true.
               if (present(set)) is_run = utf8_in_set(self%raw, c, n, set)
            endif
         endif
         if (.not.is_run) then
            buffer(length+1:length+n) = self%raw(c:c+n-1)
            length = length + n
         endif
         p = c
         m = n
         c = c + n
      enddo
      squeezed%raw = buffer(1:length)
   endif
   endfunction squeeze

   elemental function startcase(self, sep)
   !< Return a string with all words capitalized, e.g. title case.
   !<
   !< @note Multiple subsequent separators are collapsed to one occurence.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
   !< test_passed(1) = astring%startcase()//''=='The Quick Brown Fox Jumps Over The Lazy Dog.'
   !< astring = '   '
   !< test_passed(2) = astring%startcase()//''==''
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self      !< The string.
   character(kind=CK, len=*), intent(in), optional :: sep       !< Separator.
   type(string)                                    :: startcase !< Start case string.
   character(kind=CK, len=:), allocatable          :: sep_      !< Separator, default value.
   type(string), allocatable                       :: tokens(:) !< String tokens.

   if (allocated(self%raw)) then
      sep_ = SPACE ; if (present(sep)) sep_ = sep
      call self%split(tokens=tokens, sep=sep_)
      tokens = tokens%capitalize()
      startcase = startcase%join(array=tokens, sep=sep_)
   endif
   endfunction startcase

   elemental function strip(self, remove_nulls, remove, whitespace, unicode)
   !< Return a copy of the string with the leading and trailing characters removed.
   !<
   !< By default the leading and trailing spaces are removed. If `remove` is passed, it is the set of characters to be removed:
   !< all the leading and trailing characters of the string belonging to the set are removed, in any order they occur. If
   !< `whitespace` is true, the whitespace of [[string:is_space]] (space, tab, new line, vertical tab, form feed, carriage
   !< return) is removed too, as Python `str.strip()`; with `unicode=.true.` it is the Unicode White_Space instead (see
   !< [[string:is_space]]), `unicode` having no effect without `whitespace`. To strip one side only see [[string:lstrip]]
   !< and [[string:rstrip]].
   !<
   !< @note `remove` is a set of units, a well-formed UTF-8 sequence or a byte that is not part of one: a character is
   !< removed as a whole or not at all.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(14)
   !< astring = '  Hello World!   '
   !< test_passed(1) = astring%strip()//''=='Hello World!'
   !< astring = '   hello   '
   !< test_passed(2) = astring%strip(remove=' h')//''=='ello'
   !< astring = 'xxyHello Worldyx'
   !< test_passed(3) = astring%strip(remove='xy')//''=='Hello World'
   !< test_passed(4) = astring%strip(remove='')//''=='xxyHello Worldyx'
   !< astring = 'xyxy'
   !< test_passed(5) = astring%strip(remove='xy')//''==''
   !< astring = '  ab'//char(0)//char(0)
   !< test_passed(6) = astring%strip(remove_nulls=.true.)//''=='ab'
   !< astring = ''
   !< test_passed(7) = astring%strip(remove=' ')//''==''
   !< astring = '--a-b--'
   !< test_passed(8) = astring%strip(remove='-')//''=='a-b'
   !< astring = achar(9)//' a b'//new_line('a')
   !< test_passed(9) = astring%strip(whitespace=.true.)//''=='a b'
   !< test_passed(10) = astring%strip(remove='b', whitespace=.true.)//''=='a'
   !< astring = char(195)//char(169)//'a'//char(195)//char(169)
   !< test_passed(11) = astring%strip(remove=char(195)//char(169))//''=='a'
   !< astring = char(195)//char(163)//'a'
   !< test_passed(12) = astring%strip(remove=char(195)//char(169))//''==char(195)//char(163)//'a'
   !< astring = char(227)//char(128)//char(128)//'a b'//char(194)//char(160)//achar(10)
   !< test_passed(13) = astring%strip(whitespace=.true., unicode=.true.)//''=='a b'
   !< test_passed(14) = astring%strip(whitespace=.true.)//''==char(227)//char(128)//char(128)//'a b'//char(194)//char(160)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self         !< The string.
   logical,                   intent(in), optional :: remove_nulls !< Remove null characters at the end.
   character(kind=CK, len=*), intent(in), optional :: remove       !< Set of characters to be removed, default space.
   logical,                   intent(in), optional :: whitespace   !< Remove the whitespace too.
   logical,                   intent(in), optional :: unicode      !< The whitespace is Unicode White_Space, not ASCII.
   type(string)                                    :: strip        !< The stripped string.
   integer                                         :: c            !< Counter.

   if (allocated(self%raw)) then
      strip%raw = strip_set(raw=self%raw, set=strip_characters(remove=remove, whitespace=whitespace, unicode=unicode), &
                            left=.true., right=.true.)
      if (present(remove_nulls)) then
         if (remove_nulls) then
            c = index(strip%raw, char(0))
            if (c>0) strip%raw = strip%raw(1:c-1)
         endif
      endif
   endif
   endfunction strip

   elemental function swapcase(self)
   !< Return a copy of the string with uppercase characters converted to lowercase and vice versa.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = '  Hello World!   '
   !< test_passed(1) = astring%swapcase()//''=='  hELLO wORLD!   '
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   type(string)              :: swapcase !< Upper case string.
   integer                   :: n1       !< Characters counter.

   if (allocated(self%raw)) then
      swapcase = self
      do n1=1, len(self%raw)
         if (is_upper_char(self%raw(n1:n1))) then
            swapcase%raw(n1:n1) = lower_char(self%raw(n1:n1))
         else
            swapcase%raw(n1:n1) = upper_char(self%raw(n1:n1))
         endif
      enddo
   endif
   endfunction swapcase

   function tempname(self, is_file, prefix, path)
   !< Return a safe temporary name suitable for temporary file or directories.
   !<
   !<```fortran
   !< type(string) :: astring
   !< character(len=:), allocatable :: tmpname
   !< logical                       :: test_passed(5)
   !< tmpname = astring%tempname()
   !< inquire(file=tmpname, exist=test_passed(1))
   !< test_passed(1) = .not.test_passed(1)
   !< tmpname = astring%tempname(is_file=.false.)
   !< inquire(file=tmpname, exist=test_passed(2))
   !< test_passed(2) = .not.test_passed(2)
   !< tmpname = astring%tempname(path='./')
   !< inquire(file=tmpname, exist=test_passed(3))
   !< test_passed(3) = .not.test_passed(3)
   !< astring = 'me-'
   !< tmpname = astring%tempname()
   !< inquire(file=tmpname, exist=test_passed(4))
   !< test_passed(4) = .not.test_passed(4)
   !< tmpname = astring%tempname(prefix='you-')
   !< inquire(file=tmpname, exist=test_passed(5))
   !< test_passed(5) = .not.test_passed(5)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self                   !< The string.
   logical,       intent(in), optional :: is_file                !< True if tempname should be used for file (the default).
   character(*),  intent(in), optional :: prefix                 !< Name prefix, otherwise self is used (if allocated).
   character(*),  intent(in), optional :: path                   !< Path where file/directory should be used, default `./`.
   character(len=:), allocatable       :: tempname               !< Safe (unique) temporary name.
   logical                             :: is_file_               !< True if tempname should be used for file (the default).
   character(len=:), allocatable       :: prefix_                !< Name prefix, otherwise self is used (if allocated).
   character(len=:), allocatable       :: path_                  !< Path where file/directory should be used, default `./`.
   logical, save                       :: is_initialized=.false. !< Status of random seed initialization.
   real(R4P)                           :: random_real            !< Random number (real).
   integer(I4P)                        :: random_integer         !< Random number (integer).
   logical                             :: is_hold                !< Flag to check if a safe tempname has been found.

   is_file_ = .true. ; if (present(is_file)) is_file_ = is_file
   path_ = '' ; if (present(path)) path_ = path
   prefix_ = ''
   if (present(prefix)) then
      prefix_ = prefix
   elseif (allocated(self%raw)) then
      prefix_ = self%raw
   endif
   if (.not.is_initialized) then
      call random_seed
      is_initialized = .true.
   endif
   tempname = repeat(' ', len(path_) + len(prefix_) + 10) ! [path_] + [prefix_] + 6 random chars + [.tmp]
   do
      call random_number(random_real)
      random_integer = transfer(random_real, random_integer)
      random_integer = iand(random_integer, 16777215_I4P)
      if (is_file_)  then
         write(tempname, '(A,Z6.6,A)') path_//prefix_, random_integer, '.tmp'
      else
         write(tempname, '(A,Z6.6)') path_//prefix_, random_integer
         tempname = trim(tempname)
      endif
      inquire(file=tempname, exist=is_hold)
      if (.not.is_hold) exit
   enddo
   endfunction tempname

   elemental function to_integer_I1P(self, kind) result(to_number)
   !< Cast string to integer (I1P).
   !<
   !< @note A string that is not an integer gives 0, see [[string:is_integer]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< integer(I1P) :: integer_
   !< logical      :: test_passed(1)
   !< astring = '127'
   !< integer_ = astring%to_number(kind=1_I1P)
   !< test_passed(1) = integer_==127_I1P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   integer(I1P),  intent(in) :: kind      !< Mold parameter for kind detection.
   integer(I1P)              :: to_number !< The number into the string.

   call self%read_number_I1P(number=to_number)
   endfunction to_integer_I1P

#ifndef _NVF
   elemental function to_integer_I2P(self, kind) result(to_number)
   !< Cast string to integer (I2P).
   !<
   !< @note A string that is not an integer gives 0, see [[string:is_integer]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< integer(I2P) :: integer_
   !< logical      :: test_passed(1)
   !< astring = '127'
   !< integer_ = astring%to_number(kind=1_I2P)
   !< test_passed(1) = integer_==127_I2P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   integer(I2P),  intent(in) :: kind      !< Mold parameter for kind detection.
   integer(I2P)              :: to_number !< The number into the string.

   call self%read_number_I2P(number=to_number)
   endfunction to_integer_I2P
#endif

   elemental function to_integer_I4P(self, kind) result(to_number)
   !< Cast string to integer (I4P).
   !<
   !< @note A string that is not an integer gives 0, see [[string:is_integer]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< integer(I4P) :: integer_
   !< logical      :: test_passed(2)
   !< astring = '127'
   !< integer_ = astring%to_number(kind=1_I4P)
   !< test_passed(1) = integer_==127_I4P
   !< astring = '12x'
   !< integer_ = astring%to_number(kind=1_I4P)
   !< test_passed(2) = integer_==0_I4P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   integer(I4P),  intent(in) :: kind      !< Mold parameter for kind detection.
   integer(I4P)              :: to_number !< The number into the string.

   call self%read_number_I4P(number=to_number)
   endfunction to_integer_I4P

   elemental function to_integer_I8P(self, kind) result(to_number)
   !< Cast string to integer (I8P).
   !<
   !< @note A string that is not an integer gives 0, see [[string:is_integer]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< integer(I8P) :: integer_
   !< logical      :: test_passed(1)
   !< astring = '127'
   !< integer_ = astring%to_number(kind=1_I8P)
   !< test_passed(1) = integer_==127_I8P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   integer(I8P),  intent(in) :: kind      !< Mold parameter for kind detection.
   integer(I8P)              :: to_number !< The number into the string.

   call self%read_number_I8P(number=to_number)
   endfunction to_integer_I8P

   elemental function to_real_R4P(self, kind) result(to_number)
   !< Cast string to real (R4P).
   !<
   !< @note A string that is not a number gives a quiet NaN, see [[string:is_number]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< real(R4P)    :: real_
   !< logical      :: test_passed(1)
   !< astring = '3.4e9'
   !< real_ = astring%to_number(kind=1._R4P)
   !< test_passed(1) = real_==3.4e9_R4P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   real(R4P),     intent(in) :: kind      !< Mold parameter for kind detection.
   real(R4P)                 :: to_number !< The number into the string.

   call self%read_number_R4P(number=to_number)
   endfunction to_real_R4P

   elemental function to_real_R8P(self, kind) result(to_number)
   !< Cast string to real (R8P).
   !<
   !< @note A string that is not a number gives a quiet NaN, see [[string:is_number]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< real(R8P)    :: real_
   !< logical      :: test_passed(2)
   !< astring = '3.4e9'
   !< real_ = astring%to_number(kind=1._R8P)
   !< test_passed(1) = real_==3.4e9_R8P
   !< astring = '12x'
   !< real_ = astring%to_number(kind=1._R8P)
   !< test_passed(2) = real_/=real_
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   real(R8P),     intent(in) :: kind      !< Mold parameter for kind detection.
   real(R8P)                 :: to_number !< The number into the string.

   call self%read_number_R8P(number=to_number)
   endfunction to_real_R8P

   elemental function to_real_R16P(self, kind) result(to_number)
   !< Cast string to real (R16P).
   !<
   !< @note A string that is not a number gives a quiet NaN, see [[string:is_number]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< real(R16P)   :: real_
   !< logical      :: test_passed(1)
   !< astring = '3.4e9'
   !< real_ = astring%to_number(kind=1._R16P)
   !< test_passed(1) = real_==3.4e9_R16P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self      !< The string.
   real(R16P),    intent(in) :: kind      !< Mold parameter for kind detection.
   real(R16P)                :: to_number !< The number into the string.

   call self%read_number_R16P(number=to_number)
   endfunction to_real_R16P

   elemental subroutine read_number_I1P(self, number, iostat, iomsg)
   !< Cast string to integer (I1P), with an error status.
   !<
   !< @note If the string is not an integer `number` is 0 and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_integer]].
   !<
   !< @note The doctest is not necessary, this being tested by the I4P one.
   class(string),    intent(in)              :: self    !< The string.
   integer(I1P),     intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: exponent !< Decimal exponent of the number.

   number = 0_I1P
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.true., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast)
      if (is_fast) then ! a plain integer in the range of the kind: exact, the read statement is not needed
         if (negative) mantissa = -mantissa
         if (mantissa>=-int(huge(number), I8P)-1_I8P.and.mantissa<=int(huge(number), I8P)) then
            number = int(mantissa, kind=I1P)
            if (present(iostat)) iostat = 0
            return
         endif
      endif
      iomsg_ = 'the string is not an integer'
      if (self%is_integer()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = 0_I1P
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_I1P

#ifndef _NVF
   elemental subroutine read_number_I2P(self, number, iostat, iomsg)
   !< Cast string to integer (I2P), with an error status.
   !<
   !< @note If the string is not an integer `number` is 0 and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_integer]].
   !<
   !< @note The doctest is not necessary, this being tested by the I4P one.
   class(string),    intent(in)              :: self    !< The string.
   integer(I2P),     intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: exponent !< Decimal exponent of the number.

   number = 0_I2P
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.true., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast)
      if (is_fast) then ! a plain integer in the range of the kind: exact, the read statement is not needed
         if (negative) mantissa = -mantissa
         if (mantissa>=-int(huge(number), I8P)-1_I8P.and.mantissa<=int(huge(number), I8P)) then
            number = int(mantissa, kind=I2P)
            if (present(iostat)) iostat = 0
            return
         endif
      endif
      iomsg_ = 'the string is not an integer'
      if (self%is_integer()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = 0_I2P
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_I2P
#endif

   elemental subroutine read_number_I4P(self, number, iostat, iomsg)
   !< Cast string to integer (I4P), with an error status.
   !<
   !< @note If the string is not an integer `number` is 0 and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_integer]].
   !<
   !<```fortran
   !< use penf
   !< type(string)      :: astring
   !< integer(I4P)      :: integer_
   !< integer           :: iostat
   !< character(len=99) :: iomsg
   !< logical           :: test_passed(4)
   !< astring = '127'
   !< call astring%read_number(integer_, iostat=iostat)
   !< test_passed(1) = integer_==127_I4P.and.iostat==0
   !< astring = '12x'
   !< call astring%read_number(integer_, iostat=iostat, iomsg=iomsg)
   !< test_passed(2) = integer_==0_I4P.and.iostat>0.and.trim(iomsg)=='the string is not an integer'
   !< astring = '99999999999'
   !< call astring%read_number(integer_, iostat=iostat)
   !< test_passed(3) = integer_==0_I4P.and.iostat/=0
   !< call astring%free
   !< call astring%read_number(integer_, iostat=iostat)
   !< test_passed(4) = iostat>0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(in)              :: self    !< The string.
   integer(I4P),     intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: exponent !< Decimal exponent of the number.

   number = 0_I4P
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.true., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast)
      if (is_fast) then ! a plain integer in the range of the kind: exact, the read statement is not needed
         if (negative) mantissa = -mantissa
         if (mantissa>=-int(huge(number), I8P)-1_I8P.and.mantissa<=int(huge(number), I8P)) then
            number = int(mantissa, kind=I4P)
            if (present(iostat)) iostat = 0
            return
         endif
      endif
      iomsg_ = 'the string is not an integer'
      if (self%is_integer()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = 0_I4P
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_I4P

   elemental subroutine read_number_I8P(self, number, iostat, iomsg)
   !< Cast string to integer (I8P), with an error status.
   !<
   !< @note If the string is not an integer `number` is 0 and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_integer]].
   !<
   !< @note The doctest is not necessary, this being tested by the I4P one.
   class(string),    intent(in)              :: self    !< The string.
   integer(I8P),     intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: exponent !< Decimal exponent of the number.

   number = 0_I8P
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.true., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast)
      if (is_fast) then ! a plain integer in the range of the kind: exact, the read statement is not needed
         if (negative) mantissa = -mantissa
         if (mantissa>=-int(huge(number), I8P)-1_I8P.and.mantissa<=int(huge(number), I8P)) then
            number = int(mantissa, kind=I8P)
            if (present(iostat)) iostat = 0
            return
         endif
      endif
      iomsg_ = 'the string is not an integer'
      if (self%is_integer()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = 0_I8P
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_I8P

   elemental subroutine read_number_R4P(self, number, iostat, iomsg)
   !< Cast string to real (R4P), with an error status.
   !<
   !< @note If the string is not a number `number` is a quiet NaN and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_number]].
   !<
   !< @note The doctest is not necessary, this being tested by the R8P one.
   class(string),    intent(in)              :: self    !< The string.
   real(R4P),        intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: truncated !< Digits were dropped past the 18th.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: special  !< Kind of a special value (nan, inf).
   integer                                   :: exponent !< Decimal exponent of the number.

   number = ieee_value(number, ieee_quiet_nan)
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.false., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast, truncated=truncated)
      if (is_fast) then ! mantissa<=2**24 and |exponent|<=10: one exact operation, correctly rounded (Clinger)
         if (.not.truncated.and.mantissa<=16777216_I8P.and.abs(exponent)<=10) then
            number = real(mantissa, kind=R4P)
            if (exponent>=0) then
               number = number * P10_R4P(exponent)
            else
               number = number / P10_R4P(-exponent)
            endif
            if (negative) number = -number
            if (present(iostat)) iostat = 0
            return
         endif
         number = decimal_to_r4(mantissa, exponent) ! correctly rounded, whatever the digits and the power of ten
         ! digits dropped: the number is between mantissa and mantissa+1; if they round apart, all the digits settle it
         if (truncated) then
            ! the bits, not the reals: ifx and nvfortran compare a subnormal as zero by default
            if (transfer(number, 1_I4P)/=transfer(decimal_to_r4(mantissa + 1_I8P, exponent), 1_I4P)) &
               number = settle_r4(self%raw, exponent, number)
         endif
         if (negative) number = -number
         if (present(iostat)) iostat = 0
         return
      endif
      call parse_special_number(raw=self%raw, special=special, negative=negative)
      if (special/=0) then
         if (special==SPECIAL_NAN) then
            number = ieee_value(number, ieee_quiet_nan)
         else
            number = ieee_value(number, ieee_positive_inf)
         endif
         if (negative) number = -number
         if (present(iostat)) iostat = 0
         return
      endif
      iomsg_ = 'the string is not a number'
      if (self%is_number()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = ieee_value(number, ieee_quiet_nan)
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_R4P

   elemental subroutine read_number_R8P(self, number, iostat, iomsg)
   !< Cast string to real (R8P), with an error status.
   !<
   !< @note If the string is not a number `number` is a quiet NaN and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_number]].
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astrings(4)
   !< real(R8P)    :: reals(4)
   !< integer      :: iostats(4)
   !< logical      :: test_passed(4)
   !< astrings(1) = '3.4e9'
   !< astrings(2) = '12'
   !< astrings(3) = 'twelve'
   !< astrings(4) = '1.5-101'
   !< call astrings%read_number(reals, iostat=iostats)
   !< test_passed(1) = reals(1)==3.4e9_R8P.and.iostats(1)==0
   !< test_passed(2) = reals(2)==12._R8P.and.iostats(2)==0
   !< test_passed(3) = reals(3)/=reals(3).and.iostats(3)>0
   !< test_passed(4) = reals(4)==1.5e-101_R8P.and.iostats(4)==0
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(in)              :: self    !< The string.
   real(R8P),        intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.
   logical                                   :: is_fast  !< The fast path applies.
   logical                                   :: truncated !< Digits were dropped past the 18th.
   logical                                   :: negative !< The number is negative.
   integer(I8P)                              :: mantissa !< Decimal digits of the number, as an integer.
   integer                                   :: special  !< Kind of a special value (nan, inf).
   integer                                   :: exponent !< Decimal exponent of the number.

   number = ieee_value(number, ieee_quiet_nan)
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_number_fast(raw=self%raw, is_integer=.false., negative=negative, mantissa=mantissa, exponent=exponent, &
                             is_ok=is_fast, truncated=truncated)
      if (is_fast) then ! mantissa<=2**53 and |exponent|<=22: one exact operation, correctly rounded (Clinger)
         if (.not.truncated.and.mantissa<=9007199254740992_I8P.and.abs(exponent)<=22) then
            number = real(mantissa, kind=R8P)
            if (exponent>=0) then
               number = number * P10_R8P(exponent)
            else
               number = number / P10_R8P(-exponent)
            endif
            if (negative) number = -number
            if (present(iostat)) iostat = 0
            return
         endif
         number = decimal_to_r8(mantissa, exponent) ! correctly rounded, whatever the digits and the power of ten
         ! digits dropped: the number is between mantissa and mantissa+1; if they round apart, all the digits settle it
         if (truncated) then
            ! the bits, not the reals: ifx and nvfortran compare a subnormal as zero by default
            if (transfer(number, 1_I8P)/=transfer(decimal_to_r8(mantissa + 1_I8P, exponent), 1_I8P)) &
               number = settle_r8(self%raw, exponent, number)
         endif
         if (negative) number = -number
         if (present(iostat)) iostat = 0
         return
      endif
      call parse_special_number(raw=self%raw, special=special, negative=negative)
      if (special/=0) then
         if (special==SPECIAL_NAN) then
            number = ieee_value(number, ieee_quiet_nan)
         else
            number = ieee_value(number, ieee_positive_inf)
         endif
         if (negative) number = -number
         if (present(iostat)) iostat = 0
         return
      endif
      iomsg_ = 'the string is not a number'
      if (self%is_number()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = ieee_value(number, ieee_quiet_nan)
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_R8P

   elemental subroutine read_number_R16P(self, number, iostat, iomsg)
   !< Cast string to real (R16P), with an error status.
   !<
   !< @note If the string is not a number `number` is a quiet NaN and `iostat` is positive: unlike `to_number`, the failure is
   !< reported. As the `read` statement, `iomsg` is changed only on failure. See [[string:is_number]].
   !<
   !< @note The doctest is not necessary, this being tested by the R8P one.
   class(string),    intent(in)              :: self    !< The string.
   real(R16P),       intent(out)             :: number  !< The number into the string.
   integer,          intent(out),   optional :: iostat  !< IO status code: 0 on success, positive otherwise.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message, set on failure.
   integer                                   :: iostat_ !< IO status code, local variable.
   integer                                   :: special  !< Kind of a special value (nan, inf).
   logical                                   :: negative !< The number is negative.
   character(len=99)                         :: iomsg_  !< IO status message, local variable.

   number = ieee_value(number, ieee_quiet_nan)
   iostat_ = 1
   iomsg_ = 'the string is not allocated'
   if (allocated(self%raw)) then
      call parse_special_number(raw=self%raw, special=special, negative=negative)
      if (special/=0) then
         if (special==SPECIAL_NAN) then
            number = ieee_value(number, ieee_quiet_nan)
         else
            number = ieee_value(number, ieee_positive_inf)
         endif
         if (negative) number = -number
         if (present(iostat)) iostat = 0
         return
      endif
      iomsg_ = 'the string is not a number'
      if (self%is_number()) then
         read(self%raw, *, iostat=iostat_, iomsg=iomsg_) number
         if (iostat_/=0) number = ieee_value(number, ieee_quiet_nan)
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg).and.iostat_/=0) iomsg = iomsg_
   endsubroutine read_number_R16P

   elemental function to_valid_utf8(self, replacement) result(valid)
   !< Return the string with every ill-formed UTF-8 sequence replaced, by U+FFFD by default.
   !<
   !< @note Each maximal subpart of an ill-formed sequence (the longest prefix of a well-formed sequence found there, or
   !< a single byte that cannot start one) is replaced by one `replacement`, as Unicode recommends (chapter 3.9) and
   !< Python's `errors='replace'` does: `E4 BD` (a truncated 3-byte sequence) gives one U+FFFD, `C0 AF` (an overlong
   !< form) gives two. A well-formed string is returned unchanged.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'a'//char(228)//char(189)//'b'
   !< astring = astring%to_valid_utf8()
   !< test_passed(1) = astring%raw=='a'//char(239)//char(191)//char(189)//'b'
   !< astring = char(192)//char(175)
   !< astring = astring%to_valid_utf8(replacement='?')
   !< test_passed(2) = astring%raw=='??'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(3) = astring%to_valid_utf8()==astring
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self         !< The string.
   character(kind=CK, len=*), intent(in), optional :: replacement  !< Replacement of an ill-formed sequence (U+FFFD).
   type(string)                                    :: valid        !< The valid string.
   character(kind=CK, len=:), allocatable          :: replacement_ !< Replacement, local variable.
   integer                                         :: i            !< Byte position in the string.
   integer                                         :: o            !< Byte position in the result.
   integer                                         :: n            !< Bytes of a unit.
   integer                                         :: pass         !< 1: measure the result, 2: fill it.

   if (.not.allocated(self%raw)) return
   if (utf8_first_error(self%raw) == 0) then
      valid%raw = self%raw
      return
   endif
   replacement_ = REPLACEMENT_CHARACTER ; if (present(replacement)) replacement_ = replacement
   do pass=1, 2
      i = 1
      o = 0
      do while (i <= len(self%raw))
         n = utf8_unit_len(self%raw, i)
         if (n == 1 .and. iand(ichar(self%raw(i:i)), 255) > 127) then
            n = utf8_subpart_len(self%raw, i)
            if (pass == 2) valid%raw(o+1:o+len(replacement_)) = replacement_
            o = o + len(replacement_)
         else
            if (pass == 2) valid%raw(o+1:o+n) = self%raw(i:i+n-1)
            o = o + n
         endif
         i = i + n
      enddo
      if (pass == 1) allocate(character(kind=CK, len=o) :: valid%raw)
   enddo
   endfunction to_valid_utf8

   elemental function transliterate(self, old_set, new_set) result(transliterated)
   !< Return a string with every character of `old_set` replaced by the character at the same position in `new_set`.
   !<
   !< @note As GNU `tr`: if `new_set` is shorter than `old_set` its last character replaces the remaining ones, if it is null
   !< the characters of `old_set` are deleted. A character repeated in `old_set` is replaced as its first occurrence. A
   !< character is a unit, a well-formed UTF-8 sequence or a byte that is not part of one: `old_set` and `new_set` are
   !< sequences of units, and the result can be longer than the string.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(5)
   !< astring = 'hello world'
   !< test_passed(1) = astring%transliterate('lo', 'LO')//''=='heLLO wOrLd'
   !< test_passed(2) = astring%transliterate('elo', 'x')//''=='hxxxx wxrxd'
   !< test_passed(3) = astring%transliterate('lo', '')//''=='he wrd'
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(4) = astring%transliterate(char(195)//char(169), 'e')//''=='cafe'
   !< test_passed(5) = astring%transliterate('a'//char(195)//char(169), char(206)//char(177)//'E')//''== &
   !<                  'c'//char(206)//char(177)//'fE'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: self           !< The string.
   character(kind=CK, len=*), intent(in)  :: old_set        !< Characters to replace.
   character(kind=CK, len=*), intent(in)  :: new_set        !< Replacing characters.
   type(string)                           :: transliterated !< The transliterated string.
   character(kind=CK, len=:), allocatable :: buffer         !< Buffer, the result being never longer than the string.
   integer                                :: length         !< Length of the result.
   integer                                :: c              !< Byte position of the current unit.
   integer                                :: n              !< Bytes of the current unit.
   integer                                :: i              !< Ordinal of the unit in old_set.
   integer                                :: first          !< Position of the replacing unit in new_set.
   integer                                :: m              !< Bytes of the replacing unit.

   if (.not.allocated(self%raw)) return
   if (is_ascii(old_set).and.is_ascii(new_set)) then ! ASCII sets: one byte for one byte, a non-ASCII unit kept
      allocate(character(kind=CK, len=len(self%raw)) :: buffer)
      length = 0
      do c=1, len(self%raw)
         i = index(old_set, self%raw(c:c))
         if (i==0) then
            length = length + 1
            buffer(length:length) = self%raw(c:c)
         elseif (len(new_set)>0) then
            length = length + 1
            buffer(length:length) = new_set(min(i, len(new_set)):min(i, len(new_set)))
         endif
      enddo
   else ! sets of units: a unit replaced by one of up to 4 bytes
      allocate(character(kind=CK, len=4*len(self%raw)) :: buffer)
      length = 0
      c = 1
      do while (c<=len(self%raw))
         n = 1
         if (iand(ichar(self%raw(c:c)), 255)>127) n = utf8_unit_len(self%raw, c)
         i = utf8_unit_index(self%raw, c, n, old_set)
         if (i==0) then
            buffer(length+1:length+n) = self%raw(c:c+n-1)
            length = length + n
         elseif (len(new_set)>0) then
            call utf8_nth_unit(new_set, i, first, m)
            buffer(length+1:length+m) = new_set(first:first+m-1)
            length = length + m
         endif
         c = c + n
      enddo
   endif
   transliterated%raw = buffer(1:length)
   endfunction transliterate

   elemental function unescape(self, to_unescape, unesc) result(unescaped)
   !< Unescape double backslashes (or custom escaped character).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '^\\s \\d+\\s*'
   !< test_passed(1) = (astring%unescape(to_unescape='\')//''=='^\s \d+\s*')
   !< test_passed(2) = (astring%unescape(to_unescape='s')//''=='^\s \\d+\s*')
   !< astring = '^|\s |\d+|\s*'
   !< test_passed(3) = (astring%unescape(to_unescape='\', unesc='|')//''=='^\s \d+\s*')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self        !< The string.
   character(kind=CK, len=1), intent(in)           :: to_unescape !< Character to be unescaped.
   character(kind=CK, len=*), intent(in), optional :: unesc       !< Character used to unescape.
   type(string)                                    :: unescaped   !< Escaped string.

   if (allocated(self%raw)) then
     if (present(unesc)) then
       unescaped%raw = replace_substring(raw=self%raw, old=unesc//to_unescape, new=to_unescape)
     else
       unescaped%raw = replace_substring(raw=self%raw, old=BACKSLASH//to_unescape, new=to_unescape)
     endif
   endif
   endfunction unescape

   elemental function unescape_c(self) result(unescaped)
   !< Return the string with its C escapes expanded: the inverse of [[string:escape_c]].
   !<
   !< @note The escapes are `\\ \' \" \a \b \f \n \r \t \v`, `\e` (ESC), `\0`..`\377` (1 to 3 octal digits) and `\xHH`
   !< (exactly 2 hexadecimal digits), each giving one **byte**, and `\uXXXX` (exactly 4 hexadecimal digits) and
   !< `\UXXXXXXXX` (exactly 8), each giving a **codepoint** encoded in UTF-8. The backslash of a malformed escape (see
   !< [[string:escapes_error]]) is kept as it is and the text after it is read normally.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(92)//'u00e9'//char(92)//'t!'
   !< test_passed(1) = astring%unescape_c()=='caf'//char(195)//char(169)//achar(9)//'!'
   !< astring = char(92)//'x41'//char(92)//'101'//char(92)//char(92)
   !< test_passed(2) = astring%unescape_c()=='AA'//char(92)
   !< astring = char(92)//'q'//char(92)//'x4'
   !< test_passed(3) = astring%unescape_c()==astring
   !< astring = 'a'//char(255)//char(9)
   !< astring = astring%escape_c()
   !< test_passed(4) = astring%unescape_c()=='a'//char(255)//char(9)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: self      !< The string.
   type(string)                           :: unescaped !< Unescaped string.
   character(kind=CK, len=:), allocatable :: buffer    !< Result, at most as long as the string.
   integer                                :: i         !< Byte position in the string.
   integer                                :: o         !< Byte position in the result.
   integer                                :: n         !< Length of an escape, 0 if malformed.
   integer(I4P)                           :: value     !< Value of an escape.
   logical                                :: is_byte   !< True if the value is a byte, false if it is a codepoint.

   if (.not.allocated(self%raw)) return
   if (index(self%raw, BACKSLASH) == 0) then
      unescaped%raw = self%raw
      return
   endif
   allocate(character(kind=CK, len=len(self%raw)) :: buffer) ! every escape is at least as long as what it gives
   i = 1
   o = 0
   do while (i <= len(self%raw))
      n = 0
      if (self%raw(i:i) == BACKSLASH) call parse_c_escape(self%raw, i, value, is_byte, n)
      if (n == 0) then ! a plain byte, or the backslash of a malformed escape
         o = o + 1
         buffer(o:o) = self%raw(i:i)
         i = i + 1
      elseif (is_byte) then
         o = o + 1
         buffer(o:o) = char(value)
         i = i + n
      else
         buffer(o+1:o+utf8_encoded_len(value)) = utf8_encode(value)
         o = o + utf8_encoded_len(value)
         i = i + n
      endif
   enddo
   unescaped%raw = buffer(1:o)
   endfunction unescape_c

   elemental function unescape_xml(self) result(unescaped)
   !< Return the string with its XML references expanded: the inverse of [[string:escape_xml]].
   !<
   !< @note The references are the 5 predefined entities `&amp; &lt; &gt; &quot; &apos;` and the character references
   !< `&#N;` (decimal) and `&#xH;` (hexadecimal, any number of digits), whose value must be a Unicode scalar value other
   !< than 0; a character reference gives its **codepoint** encoded in UTF-8. Names are case-sensitive. A malformed
   !< reference (see [[string:xml_error]]), as `&nbsp;` (an entity of HTML, not of XML), is kept as it is and the text
   !< after its `&` is read normally. Nothing else changes: line ends are not normalized, and CDATA sections and markup
   !< are not recognized.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'a&lt;b &amp; caf&#233;&#x21;'
   !< test_passed(1) = astring%unescape_xml()=='a<b & caf'//char(195)//char(169)//'!'
   !< astring = 'AT&T &nbsp; &#0;'
   !< test_passed(2) = astring%unescape_xml()==astring
   !< astring = 'x="'//char(255)//achar(10)//'"'
   !< astring = astring%escape_xml(attribute=.true.)
   !< test_passed(3) = astring%unescape_xml()=='x="'//char(255)//achar(10)//'"'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: self      !< The string.
   type(string)                           :: unescaped !< Unescaped string.
   character(kind=CK, len=:), allocatable :: buffer    !< Result, at most as long as the string.
   integer                                :: i         !< Byte position in the string.
   integer                                :: o         !< Byte position in the result.
   integer                                :: n         !< Length of a reference, 0 if malformed.
   integer(I4P)                           :: value     !< Codepoint of a reference.

   if (.not.allocated(self%raw)) return
   if (index(self%raw, '&') == 0) then
      unescaped%raw = self%raw
      return
   endif
   allocate(character(kind=CK, len=len(self%raw)) :: buffer) ! every reference is at least as long as what it gives
   i = 1
   o = 0
   do while (i <= len(self%raw))
      n = 0
      if (self%raw(i:i) == '&') call parse_xml_reference(self%raw, i, value, n)
      if (n == 0) then ! a plain byte, or the ampersand of a malformed reference
         o = o + 1
         buffer(o:o) = self%raw(i:i)
         i = i + 1
      else
         buffer(o+1:o+utf8_encoded_len(value)) = utf8_encode(value)
         o = o + utf8_encoded_len(value)
         i = i + n
      endif
   enddo
   unescaped%raw = buffer(1:o)
   endfunction unescape_xml

   elemental function unique(self, substring) result(uniq)
   !< Reduce to one (unique) multiple (sequential) occurrences of a substring into a string.
   !<
   !< For example the string ' ab-cre-cre-ab' is reduce to 'ab-cre-ab' if the substring is '-cre'.
   !<
   !< @note The leftmost occurrence of the doubled substring is reduced to one until none is left, so the result never
   !< contains the doubled substring. A null substring leaves the string unchanged.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '+++ab-++cre-++cre-ab+++++'
   !< test_passed(1) = astring%unique(substring='+')//''=='+ab-+cre-+cre-ab+'
   !< astring = 'ab   '
   !< test_passed(2) = astring%unique()//''=='ab '
   !< astring = 'abab'
   !< test_passed(3) = astring%unique(substring='')//''=='abab'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   character(kind=CK, len=*), intent(in), optional :: substring  !< Substring which multiple occurences must be reduced to one.
   type(string)                                    :: uniq       !< String parsed.

   if (allocated(self%raw)) then
     if (present(substring)) then
       uniq%raw = unique_substring(raw=self%raw, substring=substring)
     else
       uniq%raw = unique_substring(raw=self%raw, substring=SPACE)
     endif
   endif
   endfunction unique

   elemental function unquote(self) result(unquoted)
   !< Return the string without its quotes, if it starts and ends with the same quote character (`'` or `"`), the doubled
   !< quote characters inside it undoubled; any other string unchanged.
   !<
   !< @note The inverse of [[string:quote]].
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = '"say ""hi"""'
   !< test_passed(1) = astring%unquote()//''=='say "hi"'
   !< astring = "'it''s'"
   !< test_passed(2) = astring%unquote()//''=="it's"
   !< astring = '"unbalanced'
   !< test_passed(3) = astring%unquote()//''=='"unbalanced'
   !< astring = '""'
   !< test_passed(4) = astring%unquote()//''==''.and.astring%len()==2
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   type(string)              :: unquoted !< The unquoted string.
   integer                   :: n        !< Length of the string.

   if (allocated(self%raw)) then
      unquoted = self
      n = len(self%raw)
      if (n>=2) then
         if ((self%raw(1:1)=='"'.or.self%raw(1:1)=="'").and.self%raw(n:n)==self%raw(1:1)) then
            if (n==2) then
               unquoted%raw = ''
            else
               unquoted%raw = replace_substring(raw=self%raw(2:n-1), old=self%raw(1:1)//self%raw(1:1), new=self%raw(1:1))
            endif
         endif
      endif
   endif
   endfunction unquote

   elemental function upper(self)
   !< Return a string with all uppercase characters.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 'Hello WorLD!'
   !< test_passed(1) = astring%upper()//''=='HELLO WORLD!'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self  !< The string.
   type(string)              :: upper !< Upper case string.
   integer                   :: n1    !< Characters counter.

   if (allocated(self%raw)) then
      upper = self
      do n1=1, len(self%raw)
         upper%raw(n1:n1) = upper_char(self%raw(n1:n1))
      enddo
   endif
   endfunction upper

   elemental function display_width(self) result(columns)
   !< Return the display width of the string, in the columns of a terminal (as `wcswidth`), bound as `width()`.
   !<
   !< @note Each unit (a well-formed UTF-8 sequence, or a byte that is not part of one) takes: 0 columns for a C0 or C1
   !< control or DEL, and for a zero-width character (General_Category Mn, Me, Cf except U+00AD, the Hangul jamo medial
   !< vowels and final consonants); 2 columns for East_Asian_Width W and F; 1 column otherwise, an ill-formed byte
   !< included. The tables come from the Unicode Character Database 17.0.0. Grapheme clusters are not considered: an emoji
   !< ZWJ sequence counts each of its emoji.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(1) = astring%width()==4
   !< astring = char(228)//char(189)//char(160)//char(229)//char(165)//char(189)
   !< test_passed(2) = astring%width()==4
   !< astring = 'e'//char(204)//char(129)
   !< test_passed(3) = astring%width()==1
   !< astring = 'a'//achar(9)//'b'
   !< test_passed(4) = astring%width()==2
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self    !< The string.
   integer                   :: columns !< Display width.

   columns = 0
   if (allocated(self%raw)) columns = utf8_width(self%raw)
   endfunction display_width

   elemental function utf8_error(self) result(position)
   !< Return the byte position of the first byte that is not part of a well-formed UTF-8 sequence, 0 if there is none.
   !<
   !< @note Well-formed is Unicode Table 3-7: no overlong form, no surrogate, nothing above U+10FFFF, no truncated
   !< sequence, no stray continuation byte. A null or not allocated string gives 0.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(1) = astring%utf8_error()==0
   !< astring = 'ab'//char(237)//char(160)//char(128)
   !< test_passed(2) = astring%utf8_error()==3
   !< astring = 'x'//char(228)//char(189)
   !< test_passed(3) = astring%utf8_error()==2
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer                   :: position !< Position of the first ill-formed byte, 0 if none.

   position = 0
   if (allocated(self%raw)) position = utf8_first_error(self%raw)
   endfunction utf8_error

   elemental function xml_error(self) result(position)
   !< Return the byte position of the first malformed XML reference, 0 if there is none (see [[string:unescape_xml]]).
   !<
   !< @note Malformed is an `&` that does not start a predefined entity (`&amp; &lt; &gt; &quot; &apos;`) or a character
   !< reference (`&#N;`, `&#xH;`) whose value is a Unicode scalar value other than 0: a bare `&`, a missing `;`, an
   !< entity of HTML or of a DTD (`&nbsp;`), `&#X41;` (the `x` must be lowercase), a surrogate, a value above U+10FFFF.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '&lt;a&gt; &#x1F600;'
   !< test_passed(1) = astring%xml_error()==0
   !< astring = 'Q&amp;A, R&D'
   !< test_passed(2) = astring%xml_error()==11
   !< astring = '&#xD800;'
   !< test_passed(3) = astring%xml_error()==1
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   integer                   :: position !< Position of the ampersand of the first malformed reference, 0 if none.
   integer                   :: i        !< Byte position.
   integer                   :: n        !< Length of a reference, 0 if malformed.
   integer(I4P)              :: value    !< Codepoint of a reference.

   position = 0
   if (.not.allocated(self%raw)) return
   i = index(self%raw, '&')
   if (i == 0) return
   do while (i <= len(self%raw))
      if (self%raw(i:i) == '&') then
         call parse_xml_reference(self%raw, i, value, n)
         if (n == 0) then
            position = i
            return
         endif
         i = i + n
      else
         i = i + 1
      endif
   enddo
   endfunction xml_error

   subroutine write_file(self, file, form, iostat, iomsg, bom)
   !< Write a single string stream into file.
   !<
   !< @note For unformatted read only `access='stream'` is supported with new_line as line terminator.
   !<
   !< @note With `bom=.true.` the file starts with a UTF-8 byte order mark (EF BB BF), unless the string starts with one.
   !<
   !<```fortran
   !< type(string)              :: astring
   !< type(string)              :: anotherstring
   !< type(string), allocatable :: strings(:)
   !< type(string)              :: line(3)
   !< integer                   :: iostat
   !< character(len=99)         :: iomsg
   !< integer                   :: scratch
   !< integer                   :: l
   !< logical                   :: test_passed(8)
   !< line(1) = ' Hello World!   '
   !< line(2) = 'How are you?  '
   !< line(3) = '   All say: "Fine thanks"'
   !< anotherstring = anotherstring%join(array=line, sep=new_line('a'))
   !< call anotherstring%write_file(file='write_file_test.tmp', iostat=iostat, iomsg=iomsg)
   !< call astring%read_file(file='write_file_test.tmp', iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+1) = (strings(l)==line(l))
   !< enddo
   !< call anotherstring%write_file(file='write_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
   !< call astring%read_file(file='write_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
   !< call astring%split(tokens=strings, sep=new_line('a'))
   !< test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
   !< do l=1, size(strings, dim=1)
   !<   test_passed(l+5) = (strings(l)==line(l))
   !< enddo
   !< open(newunit=scratch, file='write_file_test.tmp')
   !< close(unit=scratch, status='delete')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),    intent(in)              :: self    !< The string.
   character(len=*), intent(in)              :: file    !< File name.
   character(len=*), intent(in),    optional :: form    !< Format of unit.
   integer,          intent(out),   optional :: iostat  !< IO status code.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message.
   logical,          intent(in),    optional :: bom     !< Start the file with a UTF-8 byte order mark (if the string has none).
   type(string)                              :: form_   !< Format of unit, local variable.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=:), allocatable             :: iomsg_  !< IO status message, local variable.
   integer                                   :: unit    !< Logical unit.

   iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
   form_ = 'FORMATTED' ; if (present(form)) form_ = form ; form_ = form_%upper()
   select case(form_%chars())
   case('FORMATTED')
      open(newunit=unit, file=file, action='WRITE', iomsg=iomsg_, iostat=iostat_, err=10)
   case('UNFORMATTED')
      open(newunit=unit, file=file, action='WRITE', form='UNFORMATTED', access='STREAM', iomsg=iomsg_, iostat=iostat_, err=10)
   endselect
   if (present(bom)) then
      if (bom.and..not.self%has_bom()) call write_bom(unit=unit, form=form_%chars(), iostat=iostat_, iomsg=iomsg_)
   endif
   call self%write_lines(unit=unit, form=form, iomsg=iomsg_, iostat=iostat_)
   10 close(unit)
   if (present(iostat)) iostat = iostat_
   if (present(iomsg)) iomsg = iomsg_
   endsubroutine write_file

   subroutine write_line(self, unit, form, iostat, iomsg)
   !< Write line (record) to a connected unit.
   !<
   !< @note If the connected unit is unformatted a `new_line()` character is added at the end (if necessary) to mark the end of line.
   !<
   !< @note There is no doctests, this being tested by means of [[string:write_file]] doctests.
   class(string),    intent(in)              :: self    !< The string.
   integer,          intent(in)              :: unit    !< Logical unit.
   character(len=*), intent(in),    optional :: form    !< Format of unit.
   integer,          intent(out),   optional :: iostat  !< IO status code.
   character(len=*), intent(inout), optional :: iomsg   !< IO status message.
   type(string)                              :: form_   !< Format of unit, local variable.
   integer                                   :: iostat_ !< IO status code, local variable.
   character(len=:), allocatable             :: iomsg_  !< IO status message, local variable.

   iostat_ = 0
   iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
   if (allocated(self%raw)) then
      form_ = 'FORMATTED' ; if (present(form)) form_ = form ; form_ = form_%upper()
      select case(form_%chars())
      case('FORMATTED')
         write(unit, "(A)", iostat=iostat_, iomsg=iomsg_) self%raw
      case('UNFORMATTED')
         if (self%end_with(new_line('a'))) then
            write(unit, iostat=iostat_, iomsg=iomsg_) self%raw
         else
            write(unit, iostat=iostat_, iomsg=iomsg_) self%raw//new_line('a')
         endif
      endselect
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg)) iomsg = iomsg_
   endsubroutine write_line

   subroutine write_lines(self, unit, form, iostat, iomsg)
   !< Write lines (records) to a connected unit.
   !<
   !< This method checks if self contains more than one line (records) and writes them as lines (records).
   !<
   !< @note If the connected unit is unformatted a `new_line()` character is added at the end (if necessary) to mark the end of line.
   !<
   !< @note There is no doctests, this being tested by means of [[string:write_file]] doctests.
   class(string),    intent(in)              :: self     !< The string.
   integer,          intent(in)              :: unit     !< Logical unit.
   character(len=*), intent(in),    optional :: form     !< Format of unit.
   integer,          intent(out),   optional :: iostat   !< IO status code.
   character(len=*), intent(inout), optional :: iomsg    !< IO status message.
   type(string), allocatable                 :: lines(:) !< Lines.
   integer                                   :: l        !< Counter.

   if (allocated(self%raw)) then
      call self%split(tokens=lines, sep=new_line('a'))
      do l=1, size(lines, dim=1)
         call lines(l)%write_line(unit=unit, form=form, iostat=iostat, iomsg=iomsg)
      enddo
   endif
   endsubroutine write_lines

   ! inquire
   elemental function end_with(self, suffix, start, end, ignore_null_eof)
   !< Return true if a string ends with a specified suffix.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(5)
   !< astring = 'Hello WorLD!'
   !< test_passed(1) = astring%end_with(suffix='LD!').eqv..true.
   !< test_passed(2) = astring%end_with(suffix='lD!').eqv..false.
   !< test_passed(3) = astring%end_with(suffix='orLD!', start=5).eqv..true.
   !< test_passed(4) = astring%end_with(suffix='orLD!', start=8, end=12).eqv..true.
   !< test_passed(5) = astring%end_with(suffix='!').eqv..true.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self             !< The string.
   character(kind=CK, len=*), intent(in)           :: suffix           !< Searched suffix.
   integer,                   intent(in), optional :: start            !< Start position into the string.
   integer,                   intent(in), optional :: end              !< End position into the string.
   logical,                   intent(in), optional :: ignore_null_eof  !< Ignore null character at the end of file.
   logical                                         :: end_with         !< Result of the test.
   integer                                         :: start_           !< Start position into the string, local variable.
   integer                                         :: end_             !< End position into the string, local variable.
   logical                                         :: ignore_null_eof_ !< Ignore null character at the end of file, local variable.

   end_with = .false.
   if (allocated(self%raw)) then
      start_           = 1             ; if (present(start))           start_           = start
      end_             = len(self%raw) ; if (present(end))             end_             = end
      ignore_null_eof_ = .false.       ; if (present(ignore_null_eof)) ignore_null_eof_ = ignore_null_eof
      if (ignore_null_eof_.and.end_>0) then ! .and. does not short-circuit: raw(0:0) would be read
         if (self%raw(end_:end_) == char(0)) end_ = end_ - 1
      endif
      if (len(suffix) <= len(self%raw(start_:end_))) then
         end_with = self%raw(end_-len(suffix)+1:end_) == suffix
      endif
   endif
   endfunction end_with

   elemental function is_allocated(self)
   !< Return true if the string is allocated.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< test_passed(1) = astring%is_allocated().eqv..false.
   !< astring = 'hello'
   !< test_passed(2) = astring%is_allocated().eqv..true.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   logical                   :: is_allocated !< Result of the test.

   is_allocated = allocated(self%raw)
   endfunction is_allocated

   elemental function has_bom(self)
   !< Return true if the string starts with a UTF-8 byte order mark (the bytes EF BB BF, U+FEFF).
   !<
   !< @note Some editors, mostly on Windows, start UTF-8 files with it; [[string:read_file]] and [[string:read_lines]] drop
   !< it with `skip_bom=.true.`, [[string:write_file]] writes it with `bom=.true.`.
   !<
   !<```fortran
   !< type(string) :: astring
   !< integer      :: scratch
   !< logical      :: test_passed(7)
   !< astring = char(239)//char(187)//char(191)//'text'
   !< test_passed(1) = astring%has_bom()
   !< astring = 'text'
   !< test_passed(2) = .not.astring%has_bom()
   !< astring = ''
   !< test_passed(3) = .not.astring%has_bom()
   !< astring = 'line one'//new_line('a')//'line two'
   !< call astring%write_file(file='has_bom_test.tmp', bom=.true.)
   !< call astring%read_file(file='has_bom_test.tmp')
   !< test_passed(4) = astring%has_bom()
   !< call astring%read_file(file='has_bom_test.tmp', skip_bom=.true.)
   !< test_passed(5) = astring%start_with('line one').and.(.not.astring%has_bom())
   !< call astring%read_file(file='has_bom_test.tmp', is_fast=.true., skip_bom=.true.)
   !< test_passed(6) = astring%start_with('line one')
   !< call astring%write_file(file='has_bom_test.tmp', bom=.true.) ! a string without a BOM: written once
   !< astring = char(239)//char(187)//char(191)//'x'
   !< call astring%write_file(file='has_bom_test.tmp', bom=.true.) ! a string with a BOM: not doubled
   !< call astring%read_file(file='has_bom_test.tmp', skip_bom=.true.)
   !< test_passed(7) = astring%start_with('x')
   !< open(newunit=scratch, file='has_bom_test.tmp')
   !< close(scratch, status='delete')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self    !< The string.
   logical                   :: has_bom !< Result of the test.

   has_bom = .false.
   if (allocated(self%raw)) then
      if (len(self%raw)>=3) has_bom = self%raw(1:3)==BOM
   endif
   endfunction has_bom

   elemental function is_alnum(self)
   !< Return true if all characters in the string are letters or digits.
   !<
   !< @note The letters and the digits are the ASCII ones. A null or not allocated string gives false.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'Fortran2023'
   !< test_passed(1) = astring%is_alnum()
   !< astring = 'Fortran 2023'
   !< test_passed(2) = .not.astring%is_alnum()
   !< astring = ''
   !< test_passed(3) = .not.astring%is_alnum()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self !< The string.
   logical                   :: is_alnum !< Result of the test.
   integer                   :: c        !< Character counter.

   is_alnum = .false.
   if (allocated(self%raw)) then
      do c=1, len(self%raw)
         is_alnum = is_lower_char(self%raw(c:c)).or.is_upper_char(self%raw(c:c)).or.is_digit_char(self%raw(c:c))
         if (.not.is_alnum) exit
      enddo
   endif
   endfunction is_alnum

   elemental function is_alpha(self)
   !< Return true if all characters in the string are letters.
   !<
   !< @note The letters are the ASCII ones. A null or not allocated string gives false.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = 'Fortran'
   !< test_passed(1) = astring%is_alpha()
   !< astring = 'Fortran2023'
   !< test_passed(2) = .not.astring%is_alpha()
   !< astring = ''
   !< test_passed(3) = .not.astring%is_alpha()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self !< The string.
   logical                   :: is_alpha !< Result of the test.
   integer                   :: c        !< Character counter.

   is_alpha = .false.
   if (allocated(self%raw)) then
      do c=1, len(self%raw)
         is_alpha = is_lower_char(self%raw(c:c)).or.is_upper_char(self%raw(c:c))
         if (.not.is_alpha) exit
      enddo
   endif
   endfunction is_alpha

   elemental function is_digit(self)
   !< Return true if all characters in the string are digits.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(2)
   !< astring = '   -1212112.3 '
   !< test_passed(1) = astring%is_digit().eqv..false.
   !< astring = '12121123'
   !< test_passed(2) = astring%is_digit().eqv..true.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   logical                   :: is_digit !< Result of the test.
   integer                   :: c        !< Character counter.

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
   endfunction is_digit

   elemental function is_integer(self, allow_spaces)
   !< Return true if the string contains an integer.
   !<
   !< The regular expression is `\s*[\+\-]?\d+([eE]\+?\d+)?\s*`. The parse algorithm is done in stages:
   !<
   !< | S0  | S1      | S2  | S3   | S4  | S5  | S6  |
   !< |-----|---------|-----|------|-----|-----|-----|
   !< |`\s*`|`[\+\-]?`|`\d+`|`[eE]`|`\+?`|`\d+`|`\s*`|
   !<
   !< Exit on stages-parsing results in:
   !<
   !< | S0 | S1 | S2 | S3 | S4 | S5 | S6 |
   !< |----|----|----|----|----|----|----|
   !< |  F |  F |  T |  F |  F |  T |  T |
   !<
   !< @note This implementation is courtesy of
   !< [tomedunn](https://github.com/tomedunn/fortran-string-utility-module/blob/master/src/string_utility_module.f90#L294)
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(6)
   !< astring = '   -1212112 '
   !< test_passed(1) = astring%is_integer().eqv..true.
   !< astring = '   -1212112'
   !< test_passed(2) = astring%is_integer(allow_spaces=.false.).eqv..false.
   !< astring = '-1212112   '
   !< test_passed(3) = astring%is_integer(allow_spaces=.false.).eqv..false.
   !< astring = '+2e20'
   !< test_passed(4) = astring%is_integer().eqv..true.
   !< astring = ' -2E13 '
   !< test_passed(5) = astring%is_integer().eqv..true.
   !< astring = ' -2 E13 '
   !< test_passed(6) = astring%is_integer().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self          !< The string.
   logical,       intent(in), optional :: allow_spaces  !< Allow leading-trailing spaces.
   logical                             :: is_integer    !< Result of the test.
   logical                             :: allow_spaces_ !< Allow leading-trailing spaces, local variable.
   integer                             :: stage         !< Stages counter.
   integer                             :: c             !< Character counter.

   if (allocated(self%raw)) then
      allow_spaces_ = .true. ; if (present(allow_spaces)) allow_spaces_ = allow_spaces
      stage = 0
      is_integer = .true.
      do c=1, len(self%raw)
         select case(self%raw(c:c))
         case(SPACE, TAB)
            select case(stage)
            case(0, 6)
               is_integer = allow_spaces_
            case(2, 5)
               is_integer = allow_spaces_
               stage = 6
            case default
               is_integer = .false.
            endselect
         case('-')
            select case(stage)
            case(0)
               stage = 1
            case default
               is_integer = .false.
            end select
         case('+')
            select case(stage)
            case(0)
               stage = 1
            case(3)
               stage = 4
            case default
               is_integer = .false.
            endselect
         case('0':'9')
            select case(stage)
            case(0:1)
               stage = 2
            case(3:4)
               stage = 5
            case default
               continue
            endselect
         case ('e','E')
            select case(stage)
            case(2)
               stage = 3
            case default
               is_integer = .false.
            endselect
         case default
            is_integer = .false.
         endselect
         if (.not.is_integer) exit
      enddo
   endif
   if (is_integer) then
      select case(stage)
      case(2, 5, 6)
         is_integer = .true.
      case default
         is_integer = .false.
      end select
   endif
   endfunction is_integer

   elemental function is_lower(self)
   !< Return true if all characters in the string are lowercase.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = ' Hello World'
   !< test_passed(1) = astring%is_lower().eqv..false.
   !< astring = ' HELLO WORLD'
   !< test_passed(2) = astring%is_lower().eqv..false.
   !< astring = ' hello world'
   !< test_passed(3) = astring%is_lower().eqv..true.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   logical                   :: is_lower !< Result of the test.
   integer                   :: c        !< Character counter.

   is_lower = .false.
   if (allocated(self%raw)) then
      is_lower = .true.
      do c=1, len(self%raw)
         if (is_upper_char(self%raw(c:c))) then
            is_lower = .false.
            exit
         endif
      enddo
   endif
   endfunction is_lower

   elemental function is_number(self, allow_spaces)
   !< Return true if the string contains a number (real or integer).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(7)
   !< astring = '   -1212112 '
   !< test_passed(1) = astring%is_number().eqv..true.
   !< astring = '   -121.2112 '
   !< test_passed(2) = astring%is_number().eqv..true.
   !< astring = '   -1212112'
   !< test_passed(3) = astring%is_number(allow_spaces=.false.).eqv..false.
   !< astring = '-12121.12   '
   !< test_passed(4) = astring%is_number(allow_spaces=.false.).eqv..false.
   !< astring = '+2e20'
   !< test_passed(5) = astring%is_number().eqv..true.
   !< astring = ' -2.4E13 '
   !< test_passed(6) = astring%is_number().eqv..true.
   !< astring = ' -2 E13 '
   !< test_passed(7) = astring%is_number().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self         !< The string.
   logical,       intent(in), optional :: allow_spaces !< Allow leading-trailing spaces.
   logical                             :: is_number    !< Result of the test.

   is_number = (self%is_integer(allow_spaces=allow_spaces).or.self%is_real(allow_spaces=allow_spaces))
   endfunction is_number

   elemental function is_punct(self)
   !< Return true if all characters in the string are punctuation characters.
   !<
   !< @note The punctuation characters are the printable ASCII ones that are not letters, digits or space (as C `ispunct`).
   !< A null or not allocated string gives false.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '!?(),.;'
   !< test_passed(1) = astring%is_punct()
   !< astring = '!? ok'
   !< test_passed(2) = .not.astring%is_punct()
   !< astring = ''
   !< test_passed(3) = .not.astring%is_punct()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self !< The string.
   logical                   :: is_punct !< Result of the test.
   integer                   :: c        !< Character counter.

   is_punct = .false.
   if (allocated(self%raw)) then
      do c=1, len(self%raw)
         is_punct = is_punct_char(self%raw(c:c))
         if (.not.is_punct) exit
      enddo
   endif
   endfunction is_punct

   elemental function is_real(self, allow_spaces)
   !< Return true if the string contains a real.
   !<
   !< A real must have a decimal point or an exponent (or both): a string containing an integer, e.g. `42`, is not a real, see
   !< [[string:is_integer]] and [[string:is_number]].
   !<
   !< The regular expression is `\s*[\+\-]?\d*(\.\d*([deDE][\+\-]?\d+)?|[deDE][\+\-]?\d+)\s*`. The parse algorithm is done in
   !< stages:
   !<
   !< | S0  | S1      | S2  | S3  | S4  | S5     | S6      | S7  | S8  |
   !< |-----|---------|-----|-----|-----|--------|---------|-----|-----|
   !< |`\s*`|`[\+\-]?`|`\d*`|`\.?`|`\d*`|`[deDE]`|`[\+\-]?`|`\d*`|`\s*`|
   !<
   !< Exit on stages-parsing results in:
   !<
   !< | S0 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
   !< |----|----|----|----|----|----|----|----|----|
   !< |  F |  F |  F |  T |  T |  F |  F |  T |  T |
   !<
   !< The exit on S8 is true only if a decimal point or an exponent has been parsed.
   !<
   !< @note This implementation is courtesy of
   !< [tomedunn](https://github.com/tomedunn/fortran-string-utility-module/blob/master/src/string_utility_module.f90#L614)
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(12)
   !< astring = '   -1212112.d0 '
   !< test_passed(1) = astring%is_real().eqv..true.
   !< astring = '   -1212112.d0'
   !< test_passed(2) = astring%is_real(allow_spaces=.false.).eqv..false.
   !< astring = '-1212112.d0   '
   !< test_passed(3) = astring%is_real(allow_spaces=.false.).eqv..false.
   !< astring = '+2.e20'
   !< test_passed(4) = astring%is_real().eqv..true.
   !< astring = ' -2.01E13 '
   !< test_passed(5) = astring%is_real().eqv..true.
   !< astring = ' -2.01 E13 '
   !< test_passed(6) = astring%is_real().eqv..false.
   !< astring = '42'
   !< test_passed(7) = astring%is_real().eqv..false.
   !< astring = ' -42  '
   !< test_passed(8) = astring%is_real().eqv..false.
   !< astring = '42.'
   !< test_passed(9) = astring%is_real().eqv..true.
   !< astring = '.5'
   !< test_passed(10) = astring%is_real().eqv..true.
   !< astring = '2e20'
   !< test_passed(11) = astring%is_real().eqv..true.
   !< call astring%free
   !< test_passed(12) = astring%is_real().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self              !< The string.
   logical,       intent(in), optional :: allow_spaces      !< Allow leading-trailing spaces.
   logical                             :: is_real           !< Result of the test.
   logical                             :: allow_spaces_     !< Allow leading-trailing spaces, local variable.
   logical                             :: has_leading_digit !< Check the presence of leading digits.
   logical                             :: has_real_marker   !< Check the presence of decimal point or exponent.
   integer                             :: stage             !< Stages counter.
   integer                             :: c                 !< Character counter.
   integer                             :: exp_digits        !< Digits of an exponent without its letter.
   integer                             :: special           !< Kind of a special value (nan, inf).
   logical                             :: negative          !< A special value is negative.

   is_real = .false.
   exp_digits = 0
   stage = 0
   has_leading_digit = .false.
   has_real_marker = .false.
   if (allocated(self%raw)) then
      allow_spaces_ = .true. ; if (present(allow_spaces)) allow_spaces_ = allow_spaces
      call parse_special_number(raw=self%raw, special=special, negative=negative)
      if (special/=0) then
         is_real = allow_spaces_.or.(index(SPACE//TAB, self%raw(1:1))==0 &
                                     .and.index(SPACE//TAB, self%raw(len(self%raw):len(self%raw)))==0)
         return
      endif
      is_real = .true.
      do c=1, len(self%raw)
         select case(self%raw(c:c))
         case(SPACE, TAB)
            select case(stage)
            case(0, 8)
               is_real = allow_spaces_
               continue
            case(2:4, 7)
               is_real = allow_spaces_
               stage = 8
            case(9)
               is_real = allow_spaces_.and.exp_digits==3
               stage = 8
            case default
               is_real = .false.
            endselect
         case('+', '-')
            select case(stage)
            case(0)
               stage = 1
            case(5)
               stage = 6
            case(3:4) ! an exponent without its letter, as Fortran writes 1.5-301
               is_real = stage==4.or.has_leading_digit
               stage = 9
            case default
               is_real = .false.
            endselect
         case('0':'9')
            select case(stage)
            case(0:1)
               stage = 2
               has_leading_digit = .true.
            case(3)
               stage = 4
            case(5:6)
               stage = 7
            case(9)
               exp_digits = exp_digits + 1
               is_real = exp_digits<=3
            case default
               continue
            endselect
         case('.')
            select case(stage)
            case(0:2)
               stage = 3
               has_real_marker = .true.
            case default
               is_real = .false.
            endselect
         case('e','E','d','D')
            select case(stage)
            case(2:4)
               stage = 5
               has_real_marker = .true.
            case default
               is_real = .false.
            endselect
         case default
            is_real = .false.
         endselect
         if (.not.is_real) exit
      enddo
   endif
   if (is_real) then
      select case(stage)
      case(4, 7)
         is_real = .true.
      case(3)
         is_real = has_leading_digit
      case(9)
         is_real = exp_digits==3
      case(8)
         is_real = has_real_marker
      case default
         is_real = .false.
      endselect
   endif
   endfunction is_real

   elemental function is_space(self, unicode)
   !< Return true if all characters in the string are whitespace.
   !<
   !< @note The whitespace is space, tab, new line, vertical tab, form feed and carriage return (as C `isspace`). With
   !< `unicode=.true.` it is the characters with the Unicode White_Space property: these 6, U+0085 (NEL), U+00A0
   !< (no-break space), U+1680, U+2000..U+200A, U+2028, U+2029, U+202F, U+205F and U+3000 (ideographic space). A byte that
   !< is not part of a well-formed UTF-8 sequence is not whitespace. A null or not allocated string gives false.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = ' '//achar(9)//new_line('a')
   !< test_passed(1) = astring%is_space()
   !< astring = ' x '
   !< test_passed(2) = .not.astring%is_space()
   !< astring = ''
   !< test_passed(3) = .not.astring%is_space()
   !< astring = char(194)//char(160)//char(227)//char(128)//char(128)//' '
   !< test_passed(4) = astring%is_space(unicode=.true.).and..not.astring%is_space()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)           :: self     !< The string.
   logical,       intent(in), optional :: unicode  !< The whitespace is Unicode White_Space, not ASCII.
   logical                             :: is_space !< Result of the test.
   logical                             :: unicode_ !< The whitespace is Unicode White_Space, local variable.
   integer                             :: c        !< Byte counter.
   integer                             :: n        !< Length of a whitespace unit, 0 if not whitespace.

   is_space = .false.
   if (allocated(self%raw)) then
      unicode_ = .false. ; if (present(unicode)) unicode_ = unicode
      if (unicode_) then
         c = 1
         do while (c<=len(self%raw))
            n = utf8_space_len(self%raw, c)
            is_space = n>0
            if (.not.is_space) exit
            c = c + n
         enddo
      else
         do c=1, len(self%raw)
            is_space = is_space_char(self%raw(c:c))
            if (.not.is_space) exit
         enddo
      endif
   endif
   endfunction is_space

   elemental function is_upper(self)
   !< Return true if all characters in the string are uppercase.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = ' Hello World'
   !< test_passed(1) = astring%is_upper().eqv..false.
   !< astring = ' HELLO WORLD'
   !< test_passed(2) = astring%is_upper().eqv..true.
   !< astring = ' hello world'
   !< test_passed(3) = astring%is_upper().eqv..false.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self     !< The string.
   logical                   :: is_upper !< Result of the test.
   integer                   :: c        !< Character counter.

   is_upper = .false.
   if (allocated(self%raw)) then
      is_upper = .true.
      do c=1, len(self%raw)
         if (is_lower_char(self%raw(c:c))) then
            is_upper = .false.
            exit
         endif
      enddo
   endif
   endfunction is_upper

   elemental function is_utf8(self)
   !< Return true if the string is well-formed UTF-8.
   !<
   !< @note Well-formed is Unicode Table 3-7: no overlong form, no surrogate, nothing above U+10FFFF, no truncated
   !< sequence, no stray continuation byte. ASCII is well-formed UTF-8. A null or not allocated string gives true (as
   !< Python `str.isascii`): it has no ill-formed byte. [[string:utf8_error]] tells where the first error is.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(1) = astring%is_utf8()
   !< astring = 'caf'//char(233)
   !< test_passed(2) = .not.astring%is_utf8()
   !< astring = char(192)//char(175)
   !< test_passed(3) = .not.astring%is_utf8()
   !< astring = ''
   !< test_passed(4) = astring%is_utf8()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self    !< The string.
   logical                   :: is_utf8 !< Result of the test.

   is_utf8 = .true.
   if (allocated(self%raw)) is_utf8 = utf8_first_error(self%raw) == 0
   endfunction is_utf8

   elemental function is_xdigit(self)
   !< Return true if all characters in the string are hexadecimal digits.
   !<
   !< @note The hexadecimal digits are `0-9`, `a-f` and `A-F`. A null or not allocated string gives false.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(3)
   !< astring = '00ff7FA9'
   !< test_passed(1) = astring%is_xdigit()
   !< astring = '0x00ff'
   !< test_passed(2) = .not.astring%is_xdigit()
   !< astring = ''
   !< test_passed(3) = .not.astring%is_xdigit()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: self !< The string.
   logical                   :: is_xdigit !< Result of the test.
   integer                   :: c        !< Character counter.

   is_xdigit = .false.
   if (allocated(self%raw)) then
      do c=1, len(self%raw)
         is_xdigit = is_xdigit_char(self%raw(c:c))
         if (.not.is_xdigit) exit
      enddo
   endif
   endfunction is_xdigit

   elemental function match(self, pattern) result(is_match)
   !< Return true if the whole string matches a wildcard pattern.
   !<
   !< The wildcards are the ones of the shell (as Python `fnmatch.fnmatchcase`):
   !<
   !<+ `*` matches any sequence of characters, also empty;
   !<+ `?` matches any single character;
   !<+ `[seq]` matches any character of `seq`, where `a-z` is a range; `[!seq]` any character not in `seq`; a `]` just after
   !<  `[` or `[!` is a member of `seq`; a `[` without its closing `]` is a plain character.
   !<
   !< Any other character matches itself: the match is case-sensitive, there is no escape character (match a wildcard with a
   !< one-character class, `[*]`) and a leading dot is not special. A not allocated string matches nothing.
   !<
   !< A character is a unit, a well-formed UTF-8 sequence or a byte that is not part of one: `?` and a class match one
   !< unit, and a range compares codepoints (an ill-formed byte b counts as U+DC00+b, as Python's surrogateescape).
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(11)
   !< astring = 'data/report-2026.csv'
   !< test_passed(1) = astring%match('*.csv')
   !< test_passed(2) = astring%match('data/report-????.csv')
   !< test_passed(3) = astring%match('*-20[0-9][0-9].*')
   !< test_passed(4) = .not.astring%match('*.CSV')
   !< test_passed(5) = .not.astring%match('report*')
   !< test_passed(6) = astring%match('*[!a-z].csv')
   !< astring = 'a*b'
   !< test_passed(7) = astring%match('a[*]b').and..not.astring%match('a[*]c')
   !< astring = ''
   !< test_passed(8) = astring%match('*').and..not.astring%match('?')
   !< astring = '[x]'
   !< test_passed(9) = astring%match('[[]x]').and.astring%match('[[]x[]]').and..not.astring%match('[]x]*')
   !< astring = 'caf'//char(195)//char(169)
   !< test_passed(10) = astring%match('caf?').and..not.astring%match('caf??')
   !< test_passed(11) = astring%match('caf['//char(195)//char(160)//'-'//char(195)//char(191)//']')
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: self      !< The string.
   character(kind=CK, len=*), intent(in) :: pattern   !< Wildcard pattern.
   logical                               :: is_match  !< Result of the test.
   integer                               :: s         !< Character counter into the string.
   integer                               :: p         !< Character counter into the pattern.
   integer                               :: star_s    !< Character of the string matched by the last star.
   integer                               :: star_p    !< Position of the last star in the pattern.
   integer                               :: token_len !< Length of the pattern token matching a character.
   integer                               :: n         !< Bytes of the current unit of the string.

   is_match = .false.
   if (.not.allocated(self%raw)) return
   ! the classic backtracking on the last star: every other token matches exactly one unit
   s = 1
   p = 1
   star_p = 0
   star_s = 0
   do while (s<=len(self%raw))
      n = 1
      if (iand(ichar(self%raw(s:s)), 255)>127) n = utf8_unit_len(self%raw, s)
      if (p<=len(pattern)) then
         if (pattern(p:p)=='*') then
            star_p = p
            star_s = s
            p = p + 1
            cycle
         endif
         if (n==1.and.pattern(p:p)/='?'.and.pattern(p:p)/='['.and.iand(ichar(pattern(p:p)), 255)<128) then
            token_len = merge(1, 0, pattern(p:p)==self%raw(s:s)) ! ASCII literal: compared here, the common case
         else
            token_len = match_token(pattern=pattern, p=p, c=self%raw(s:s+n-1))
         endif
         if (token_len>0) then
            p = p + token_len
            s = s + n
            cycle
         endif
      endif
      if (star_p==0) return
      p = star_p + 1     ! let the last star match one more unit
      if (iand(ichar(self%raw(star_s:star_s)), 255)>127) then
         star_s = star_s + utf8_unit_len(self%raw, star_s)
      else
         star_s = star_s + 1
      endif
      s = star_s
   enddo
   do while (p<=len(pattern))
      if (pattern(p:p)/='*') return
      p = p + 1
   enddo
   is_match = .true.
   endfunction match

   elemental function start_with(self, prefix, start, end)
   !< Return true if a string starts with a specified prefix.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'Hello WorLD!'
   !< test_passed(1) = astring%start_with(prefix='Hello').eqv..true.
   !< test_passed(2) = astring%start_with(prefix='hell').eqv..false.
   !< test_passed(3) = astring%start_with(prefix='llo Wor', start=3).eqv..true.
   !< test_passed(4) = astring%start_with(prefix='lo W', start=4, end=7).eqv..true.
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)           :: self       !< The string.
   character(kind=CK, len=*), intent(in)           :: prefix     !< Searched prefix.
   integer,                   intent(in), optional :: start      !< Start position into the string.
   integer,                   intent(in), optional :: end        !< End position into the string.
   logical                                         :: start_with !< Result of the test.
   integer                                         :: start_     !< Start position into the string, local variable.
   integer                                         :: end_       !< End position into the string, local variable.

   start_with = .false.
   if (allocated(self%raw)) then
      start_ = 1             ; if (present(start)) start_ = start
      end_   = len(self%raw) ; if (present(end))   end_   = end
      if (len(prefix)<=len(self%raw(start_:end_))) then
         start_with = index(self%raw(start_:end_), prefix)==1
      endif
   endif
   endfunction start_with

   ! private methods

   ! assignments
   pure subroutine string_assign_string(lhs, rhs)
   !< Assignment operator from string input.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< type(string) :: notallocated
   !< logical      :: test_passed(2)
   !< astring = 'hello'
   !< anotherstring = astring
   !< test_passed(1) = astring%chars()==anotherstring%chars()
   !< anotherstring = notallocated
   !< test_passed(2) = .not.anotherstring%is_allocated()
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   type(string),  intent(in)    :: rhs !< Right hand side.

   if (allocated(rhs%raw)) then
     lhs%raw = rhs%raw
   elseif (allocated(lhs%raw)) then
     deallocate(lhs%raw)
   endif
   endsubroutine string_assign_string

   pure subroutine string_assign_character(lhs, rhs)
   !< Assignment operator from character input.
   !<
   !< @note The right hand side can be a part of the left hand side itself (`astring = astring%raw(2:)`): it is copied
   !< into the new data before the old data are freed.
   !<
   !<```fortran
   !< type(string) :: astring
   !< logical      :: test_passed(4)
   !< astring = 'hello'
   !< test_passed(1) = astring%chars()=='hello'
   !< astring = astring%raw(2:)
   !< test_passed(2) = astring%chars()=='ello'
   !< astring = astring%raw(1:2)//astring%raw
   !< test_passed(3) = astring%chars()=='elello'
   !< astring = astring%raw
   !< test_passed(4) = astring%chars()=='elello'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(inout) :: lhs  !< Left hand side.
   character(kind=CK, len=*), intent(in)    :: rhs  !< Right hand side.
   character(kind=CK, len=:), allocatable   :: copy !< New data, filled before the old ones are freed.

   if (allocated(lhs%raw)) then
      if (len(lhs%raw)==len(rhs)) then ! no reallocation: rhs is either distinct or the whole lhs%raw
         lhs%raw(:) = rhs
         return
      endif
   endif
   ! rhs may be a part of lhs%raw (`astring = astring%raw(2:)`): the old data are freed only after rhs is read
   allocate(character(kind=CK, len=len(rhs)) :: copy)
   copy(:) = rhs
#ifdef _NVF
   lhs%raw = copy ! nvfortran 26.9: move_alloc of a deferred-length character keeps the old length of `to`
#else
   call move_alloc(from=copy, to=lhs%raw)
#endif
   endsubroutine string_assign_character

   pure subroutine string_assign_integer_I1P(lhs, rhs)
   !< Assignment operator from integer input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 127_I1P
   !< test_passed(1) = astring%to_number(kind=1_I1P)==127_I1P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   integer(I1P),  intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_integer_I1P

   pure subroutine string_assign_integer_I2P(lhs, rhs)
   !< Assignment operator from integer input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 127_I2P
   !< test_passed(1) = astring%to_number(kind=1_I2P)==127_I2P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   integer(I2P),  intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_integer_I2P

   pure subroutine string_assign_integer_I4P(lhs, rhs)
   !< Assignment operator from integer input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 127_I4P
   !< test_passed(1) = astring%to_number(kind=1_I4P)==127_I4P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   integer(I4P),  intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_integer_I4P

   pure subroutine string_assign_integer_I8P(lhs, rhs)
   !< Assignment operator from integer input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 127_I8P
   !< test_passed(1) = astring%to_number(kind=1_I8P)==127_I8P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   integer(I8P),  intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_integer_I8P

   pure subroutine string_assign_real_R4P(lhs, rhs)
   !< Assignment operator from real input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 3.021e6_R4P
   !< test_passed(1) = astring%to_number(kind=1._R4P)==3.021e6_R4P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   real(R4P),     intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_real_R4P

   pure subroutine string_assign_real_R8P(lhs, rhs)
   !< Assignment operator from real input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 3.021e6_R8P
   !< test_passed(1) = astring%to_number(kind=1._R8P)==3.021e6_R8P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   real(R8P),     intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_real_R8P

   pure subroutine string_assign_real_R16P(lhs, rhs)
   !< Assignment operator from real input.
   !<
   !<```fortran
   !< use penf
   !< type(string) :: astring
   !< logical      :: test_passed(1)
   !< astring = 3.021e6_R8P
   !< test_passed(1) = astring%to_number(kind=1._R8P)==3.021e6_R8P
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(inout) :: lhs !< Left hand side.
   real(R16P),    intent(in)    :: rhs !< Right hand side.

   lhs%raw = trim(str(rhs))
   endsubroutine string_assign_real_R16P

   ! contatenation operators
   pure function string_concat_string(lhs, rhs) result(concat)
   !< Concatenation with string.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(1)
   !< astring = 'Hello '
   !< anotherstring = 'Bye bye'
   !< test_passed(1) = astring//anotherstring=='Hello Bye bye'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: lhs    !< Left hand side.
   type(string),  intent(in)              :: rhs    !< Right hand side.
   character(kind=CK, len=:), allocatable :: concat !< Concatenated string.

   concat = ''
   if (allocated(lhs%raw)) concat = lhs%raw
   if (allocated(rhs%raw)) concat = concat//rhs%raw
   endfunction string_concat_string

   pure function string_concat_character(lhs, rhs) result(concat)
   !< Concatenation with character.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(1)
   !< astring = 'Hello '
   !< acharacter = 'World!'
   !< test_passed(1) = astring//acharacter=='Hello World!'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: lhs    !< Left hand side.
   character(kind=CK, len=*), intent(in)  :: rhs    !< Right hand side.
   character(kind=CK, len=:), allocatable :: concat !< Concatenated string.

   if (allocated(lhs%raw)) then
      concat = lhs%raw//rhs
   else
      concat = rhs
   endif
   endfunction string_concat_character

   pure function character_concat_string(lhs, rhs) result(concat)
   !< Concatenation with character (inverted).
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(1)
   !< astring = 'Hello '
   !< acharacter = 'World!'
   !< test_passed(1) = acharacter//astring=='World!Hello '
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)  :: lhs    !< Left hand side.
   class(string),             intent(in)  :: rhs    !< Right hand side.
   character(kind=CK, len=:), allocatable :: concat !< Concatenated string.

   if (allocated(rhs%raw)) then
      concat = lhs//rhs%raw
   else
      concat = lhs
   endif
   endfunction character_concat_string

   elemental function string_concat_string_string(lhs, rhs) result(concat)
   !< Concatenation with string.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< type(string) :: yetanotherstring
   !< logical      :: test_passed(1)
   !< astring = 'Hello '
   !< anotherstring = 'Bye bye'
   !< yetanotherstring = astring.cat.anotherstring
   !< test_passed(1) = yetanotherstring%chars()=='Hello Bye bye'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in)              :: lhs       !< Left hand side.
   type(string),  intent(in)              :: rhs       !< Right hand side.
   type(string)                           :: concat    !< Concatenated string.
   character(kind=CK, len=:), allocatable :: temporary !< Temporary concatenated string.

   temporary = ''
   if (allocated(lhs%raw)) temporary = lhs%raw
   if (allocated(rhs%raw)) temporary = temporary//rhs%raw
   if (temporary/='') concat%raw = temporary
   endfunction string_concat_string_string

   elemental function string_concat_character_string(lhs, rhs) result(concat)
   !< Concatenation with character.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< type(string)                  :: yetanotherstring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(1)
   !< astring = 'Hello '
   !< acharacter = 'World!'
   !< yetanotherstring = astring.cat.acharacter
   !< test_passed(1) = yetanotherstring%chars()=='Hello World!'
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in)  :: lhs    !< Left hand side.
   character(kind=CK, len=*), intent(in)  :: rhs    !< Right hand side.
   type(string)                           :: concat !< Concatenated string.

   if (allocated(lhs%raw)) then
      concat%raw = lhs%raw//rhs
   else
      concat%raw = rhs
   endif
   endfunction string_concat_character_string

   elemental function character_concat_string_string(lhs, rhs) result(concat)
   !< Concatenation with character (inverted).
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< type(string)                  :: yetanotherstring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(1)
   !< astring = 'Hello '
   !< acharacter = 'World!'
   !< yetanotherstring = acharacter.cat.astring
   !< test_passed(1) = yetanotherstring%chars()=='World!Hello '
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in)  :: lhs    !< Left hand side.
   class(string),             intent(in)  :: rhs    !< Right hand side.
   type(string)                           :: concat !< Concatenated string.

   if (allocated(rhs%raw)) then
     concat%raw = lhs//rhs%raw
   else
     concat%raw = lhs
   endif
   endfunction character_concat_string_string

   ! logical operators
   elemental function string_eq_string(lhs, rhs) result(is_it)
   !< Equal to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(2)
   !< astring = '  one '
   !< anotherstring = 'two'
   !< test_passed(1) = ((astring==anotherstring).eqv..false.)
   !< astring = 'the same '
   !< anotherstring = 'the same '
   !< test_passed(2) = ((astring==anotherstring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw == rhs%raw
   endfunction string_eq_string

   elemental function string_eq_character(lhs, rhs) result(is_it)
   !< Equal to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = '  one '
   !< acharacter = 'three'
   !< test_passed(1) = ((astring==acharacter).eqv..false.)
   !< astring = 'the same '
   !< acharacter = 'the same '
   !< test_passed(2) = ((astring==acharacter).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw == rhs
   endfunction string_eq_character

   elemental function character_eq_string(lhs, rhs) result(is_it)
   !< Equal to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = '  one '
   !< acharacter = 'three'
   !< test_passed(1) = ((acharacter==astring).eqv..false.)
   !< astring = 'the same '
   !< acharacter = 'the same '
   !< test_passed(2) = ((acharacter==astring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = rhs%raw == lhs
   endfunction character_eq_string

   elemental function string_ne_string(lhs, rhs) result(is_it)
   !< Not equal to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(2)
   !< astring = '  one '
   !< anotherstring = 'two'
   !< test_passed(1) = ((astring/=anotherstring).eqv..true.)
   !< astring = 'the same '
   !< anotherstring = 'the same '
   !< test_passed(2) = ((astring/=anotherstring).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw /= rhs%raw
   endfunction string_ne_string

   elemental function string_ne_character(lhs, rhs) result(is_it)
   !< Not equal to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = '  one '
   !< acharacter = 'three'
   !< test_passed(1) = ((astring/=acharacter).eqv..true.)
   !< astring = 'the same '
   !< acharacter = 'the same '
   !< test_passed(2) = ((astring/=acharacter).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw /= rhs
   endfunction string_ne_character

   elemental function character_ne_string(lhs, rhs) result(is_it)
   !< Not equal to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = '  one '
   !< acharacter = 'three'
   !< test_passed(1) = ((acharacter/=astring).eqv..true.)
   !< astring = 'the same '
   !< acharacter = 'the same '
   !< test_passed(2) = ((acharacter/=astring).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = rhs%raw /= lhs
   endfunction character_ne_string

   elemental function string_lt_string(lhs, rhs) result(is_it)
   !< Lower than to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(2)
   !< astring = 'one'
   !< anotherstring = 'ONE'
   !< test_passed(1) = ((astring<anotherstring).eqv..false.)
   !< astring = 'ONE'
   !< anotherstring = 'one'
   !< test_passed(2) = ((astring<anotherstring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw < rhs%raw
   endfunction string_lt_string

   elemental function string_lt_character(lhs, rhs) result(is_it)
   !< Lower than to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((astring<acharacter).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((astring<acharacter).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw < rhs
   endfunction string_lt_character

   elemental function character_lt_string(lhs, rhs) result(is_it)
   !< Lower than to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((acharacter<astring).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((acharacter<astring).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs < rhs%raw
   endfunction character_lt_string

   elemental function string_le_string(lhs, rhs) result(is_it)
   !< Lower equal than to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(3)
   !< astring = 'one'
   !< anotherstring = 'ONE'
   !< test_passed(1) = ((astring<=anotherstring).eqv..false.)
   !< astring = 'ONE'
   !< anotherstring = 'one'
   !< test_passed(2) = ((astring<=anotherstring).eqv..true.)
   !< astring = 'ONE'
   !< anotherstring = 'ONE'
   !< test_passed(3) = ((astring<=anotherstring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw <= rhs%raw
   endfunction string_le_string

   elemental function string_le_character(lhs, rhs) result(is_it)
   !< Lower equal than to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(3)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((astring<=acharacter).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((astring<=acharacter).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'ONE'
   !< test_passed(3) = ((astring<=acharacter).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw <= rhs
   endfunction string_le_character

   elemental function character_le_string(lhs, rhs) result(is_it)
   !< Lower equal than to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(3)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((acharacter<=astring).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((acharacter<=astring).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'ONE'
   !< test_passed(3) = ((acharacter<=astring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs <= rhs%raw
   endfunction character_le_string

   elemental function string_ge_string(lhs, rhs) result(is_it)
   !< Greater equal than to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(3)
   !< astring = 'one'
   !< anotherstring = 'ONE'
   !< test_passed(1) = ((astring>=anotherstring).eqv..true.)
   !< astring = 'ONE'
   !< anotherstring = 'one'
   !< test_passed(2) = ((astring>=anotherstring).eqv..false.)
   !< astring = 'ONE'
   !< anotherstring = 'ONE'
   !< test_passed(3) = ((astring>=anotherstring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw >= rhs%raw
   endfunction string_ge_string

   elemental function string_ge_character(lhs, rhs) result(is_it)
   !< Greater equal than to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(3)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((astring>=acharacter).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((astring>=acharacter).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'ONE'
   !< test_passed(3) = ((astring>=acharacter).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw >= rhs
   endfunction string_ge_character

   elemental function character_ge_string(lhs, rhs) result(is_it)
   !< Greater equal than to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(3)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((acharacter>=astring).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((acharacter>=astring).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'ONE'
   !< test_passed(3) = ((acharacter>=astring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs >= rhs%raw
   endfunction character_ge_string

   elemental function string_gt_string(lhs, rhs) result(is_it)
   !< Greater than to string logical operator.
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: anotherstring
   !< logical      :: test_passed(2)
   !< astring = 'one'
   !< anotherstring = 'ONE'
   !< test_passed(1) = ((astring>anotherstring).eqv..true.)
   !< astring = 'ONE'
   !< anotherstring = 'one'
   !< test_passed(2) = ((astring>anotherstring).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string), intent(in) :: lhs   !< Left hand side.
   type(string),  intent(in) :: rhs   !< Right hand side.
   logical                   :: is_it !< Opreator test result.

   is_it = lhs%raw > rhs%raw
   endfunction string_gt_string

   elemental function string_gt_character(lhs, rhs) result(is_it)
   !< Greater than to character logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((astring>acharacter).eqv..true.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((astring>acharacter).eqv..false.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(in) :: lhs   !< Left hand side.
   character(kind=CK, len=*), intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs%raw > rhs
   endfunction string_gt_character

   elemental function character_gt_string(lhs, rhs) result(is_it)
   !< Greater than to character (inverted) logical operator.
   !<
   !<```fortran
   !< type(string)                  :: astring
   !< character(len=:), allocatable :: acharacter
   !< logical                       :: test_passed(2)
   !< astring = 'one'
   !< acharacter = 'ONE'
   !< test_passed(1) = ((acharacter>astring).eqv..false.)
   !< astring = 'ONE'
   !< acharacter = 'one'
   !< test_passed(2) = ((acharacter>astring).eqv..true.)
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   character(kind=CK, len=*), intent(in) :: lhs   !< Left hand side.
   class(string),             intent(in) :: rhs   !< Right hand side.
   logical                               :: is_it !< Opreator test result.

   is_it = lhs > rhs%raw
   endfunction character_gt_string

   ! IO
   subroutine read_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
   !< Formatted input.
   !<
   !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
   !<
   !< @bug Read listdirected with and without delimiters does not work.
   class(string),             intent(inout) :: dtv         !< The string.
   integer,                   intent(in)    :: unit        !< Logical unit.
   character(len=*),          intent(in)    :: iotype      !< Edit descriptor.
   integer,                   intent(in)    :: v_list(:)   !< Edit descriptor list.
   integer,                   intent(out)   :: iostat      !< IO status code.
   character(len=*),          intent(inout) :: iomsg       !< IO status message.
   character(len=len(iomsg))                :: local_iomsg !< Local variant of iomsg, so it doesn't get inappropriately redefined.
   character(kind=CK, len=1)                :: delim       !< String delimiter, if any.
   character(kind=CK, len=100)              :: temporary   !< Temporary storage string.

   if (iotype == 'LISTDIRECTED') then
      call get_next_non_blank_character_any_record(unit=unit, ch=delim, iostat=iostat, iomsg=iomsg)
      if (iostat/=0) return
      if (delim=='"'.OR.delim=="'") then
         call dtv%read_delimited(unit=unit, delim=delim, iostat=iostat, iomsg=local_iomsg)
      else
         ! step back before the non-blank
         read(unit, "(TL1)", iostat=iostat, iomsg=iomsg)
         if (iostat /= 0) return
         call dtv%read_undelimited_listdirected(unit=unit, iostat=iostat, iomsg=local_iomsg)
      endif
      if (is_iostat_eor(iostat)) then
         ! suppress IOSTAT_EOR
         iostat = 0
      elseif (iostat /= 0) then
         iomsg = local_iomsg
      endif
      return
   else
      read(unit, "(A)", iostat=iostat, iomsg=iomsg)temporary
      dtv%raw = trim(temporary)
   endif
   endsubroutine read_formatted

   subroutine read_delimited(dtv, unit, delim, iostat, iomsg)
   !< Read a delimited string from a unit connected for formatted input.
   !<
   !< If the closing delimiter is followed by end of record, then we return end of record.
   !<
   !< @note This does not need a doctest, it being tested by [[string::read_formatted]].
   class(string),             intent(inout) :: dtv       !< The string.
   integer,                   intent(in)    :: unit      !< Logical unit.
   character(kind=CK, len=1), intent(in)    :: delim     !< String delimiter.
   integer,                   intent(out)   :: iostat    !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg     !< IO status message.
   character(kind=CK, len=1)                :: ch        !< A character read.
   logical                                  :: was_delim !< Indicates that the last character read was a delimiter.

   was_delim = .false.
   dtv%raw = ''
   do
      read(unit, "(A)", iostat=iostat, iomsg=iomsg) ch
      if (is_iostat_eor(iostat)) then
         if (was_delim) then
           ! end of delimited string followed by end of record is end of the string. Pass back the
           ! end of record condition to the caller
           return
         else
           ! end of record without terminating delimiter - move along
           cycle
         endif
      elseif (iostat /= 0) THEN
        return
      endif
      if (ch == delim) then
         if (was_delim) then
            ! doubled delimiter is one delimiter in the value
            dtv%raw = dtv%raw // ch
            was_delim = .false.
         else
            ! need to test next character to see what is happening
            was_delim = .true.
         endif
      elseif (was_delim) then
         ! the previous character was actually the delimiter for the end of the string. Put back this character
         read(unit, "(TL1)", iostat=iostat, iomsg=iomsg)
         return
      else
         dtv%raw = dtv%raw // ch
      endif
   enddo
   endsubroutine read_delimited

  subroutine read_undelimited_listdirected(dtv, unit, iostat, iomsg)
  !< Read an undelimited (no leading apostrophe or double quote) character value according to the rules for list directed input.
  !<
  !< A blank, comma/semicolon (depending on the decimal mode), slash or end of record terminates the string.
  !<
  !< If input is terminated by end of record, then this procedure returns an end-of-record condition.
  class(string),    intent(inout) :: dtv           !< The string.
  integer,          intent(in)    :: unit          !< Logical unit.
  integer,          intent(out)   :: iostat        !< IO status code.
  character(len=*), intent(inout) :: iomsg         !< IO status message.
  logical                         :: decimal_point !<True if DECIMAL=POINT in effect.

  call get_decimal_mode(unit=unit, decimal_point=decimal_point, iostat=iostat, iomsg=iomsg)
  if (iostat /= 0) return
  call dtv%read_undelimited(unit=unit, terminators=' '//'/'//merge(CK_',', CK_';', decimal_point), iostat=iostat, iomsg=iomsg)
  endsubroutine read_undelimited_listdirected

  subroutine read_undelimited(dtv, unit, terminators, iostat, iomsg)
  !< Read an undelimited string up until end of record or a character from a set of terminators is encountered.
  !<
  !< If a terminator is encountered, the file position will be at that terminating character. If end of record is encountered, the
  !< file remains at end of record.
  class(string),             intent(inout) :: dtv         !< The string.
  integer,                   intent(in)    :: unit        !< Logical unit.
  character(kind=CK, len=*), intent(in)    :: terminators !< Characters that are considered to terminate the string.
                                                          !< Blanks in this string are meaningful.
  integer,                   intent(out)   :: iostat      !< IO status code.
  character(len=*),          intent(inout) :: iomsg       !< IO status message.
  character(kind=CK, len=1)                :: ch          !< A character read.

  dtv%raw = ''
  do
    read(unit, "(A)", iostat=iostat, iomsg=iomsg) ch
    if (is_iostat_eor(iostat)) then
      ! end of record just means end of string. We pass on the condition
      return
    elseif (iostat /= 0) then
      ! something odd happened
      return
    endif
    if (scan(ch, terminators) /= 0) then
      ! change the file position so that the next read sees the terminator
      read(unit, "(TL1)", iostat=iostat, iomsg=iomsg)
      if (iostat /= 0) return
      iostat = 0
      return
    endif
    ! we got a character - append it
    dtv%raw = dtv%raw // ch
  enddo
  endsubroutine read_undelimited

   subroutine write_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
   !< Formatted output.
   class(string),             intent(in)    :: dtv       !< The string.
   integer,                   intent(in)    :: unit      !< Logical unit.
   character(kind=CK, len=*), intent(in)    :: iotype    !< Edit descriptor.
   integer,                   intent(in)    :: v_list(:) !< Edit descriptor list.
   integer,                   intent(out)   :: iostat    !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg     !< IO status message.

   if (allocated(dtv%raw)) then
     write(unit, "(A)", iostat=iostat, iomsg=iomsg)dtv%raw
   else
     write(unit, "(A)", iostat=iostat, iomsg=iomsg)''
   endif
   endsubroutine write_formatted

   subroutine read_unformatted(dtv, unit, iostat, iomsg)
   !< Unformatted input.
   !<
   !< @note The string is stored as its length (an `I8P` integer) followed by its characters, see [[string:write_unformatted]].
   !<
   !<```fortran
   !< type(string) :: astring
   !< type(string) :: bstring
   !< type(string) :: cstring
   !< integer      :: scratch
   !< logical      :: test_passed(4)
   !< astring = repeat('a', 250)//'  '
   !< open(newunit=scratch, status='SCRATCH', form='UNFORMATTED')
   !< write(scratch) astring, bstring
   !< rewind(scratch)
   !< read(scratch) cstring, bstring
   !< close(scratch)
   !< test_passed(1) = cstring%len()==252.and.cstring==astring
   !< test_passed(2) = bstring%is_allocated().and.bstring%len()==0
   !< open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
   !< write(scratch) astring
   !< rewind(scratch)
   !< read(scratch) cstring
   !< close(scratch)
   !< test_passed(3) = cstring%len()==252
   !< test_passed(4) = cstring==astring
   !< print '(L1)', all(test_passed)
   !<```
   !=> T <<<
   class(string),             intent(inout) :: dtv    !< The string.
   integer,                   intent(in)    :: unit   !< Logical unit.
   integer,                   intent(out)   :: iostat !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg  !< IO status message.
   integer(I8P)                             :: length !< Length of the string.

   read(unit, iostat=iostat, iomsg=iomsg) length
   if (iostat/=0) return
   if (allocated(dtv%raw)) deallocate(dtv%raw)
   allocate(character(kind=CK, len=length) :: dtv%raw)
   read(unit, iostat=iostat, iomsg=iomsg) dtv%raw
   endsubroutine read_unformatted

   subroutine write_unformatted(dtv, unit, iostat, iomsg)
   !< Unformatted output.
   !<
   !< @note The string is stored as its length (an `I8P` integer) followed by its characters, a not allocated string being
   !< stored as a null one.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:read_unformatted]].
   class(string),             intent(in)    :: dtv    !< The string.
   integer,                   intent(in)    :: unit   !< Logical unit.
   integer,                   intent(out)   :: iostat !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg  !< IO status message.

   if (allocated(dtv%raw)) then
     write(unit, iostat=iostat, iomsg=iomsg) int(len(dtv%raw), I8P), dtv%raw
   else
     write(unit, iostat=iostat, iomsg=iomsg) 0_I8P
   endif
   endsubroutine write_unformatted

   ! non type-bound-procedures
   pure subroutine parse_special_number(raw, special, negative)
   !< Recognize `[blanks][sign]nan[(chars)][blanks]` and `[blanks][sign]inf|infinity[blanks]`, in any case, the special values
   !< the read statement accepts. `special` is SPECIAL_NAN, SPECIAL_INF, or 0 for anything else.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:read_number]] and by the oracle.
   character(kind=CK, len=*), intent(in)  :: raw      !< Raw characters data.
   integer,                   intent(out) :: special  !< Kind of the special value.
   logical,                   intent(out) :: negative !< The value is negative.
   integer                                :: first    !< First byte of the word.
   integer                                :: last     !< Last byte of the word.
   integer                                :: c        !< Character counter.
   integer                                :: code     !< Code of a character.

   special = 0
   negative = .false.
   first = 1
   last = len(raw)
   do while (first<=last)
      if (raw(first:first)/=SPACE.and.raw(first:first)/=TAB) exit
      first = first + 1
   enddo
   if (first>last) return
   do while (raw(last:last)==SPACE.or.raw(last:last)==TAB)
      last = last - 1
   enddo
   if (raw(first:first)=='+'.or.raw(first:first)=='-') then
      negative = raw(first:first)=='-'
      first = first + 1
   endif
   if (last-first<2) return
   if (index('nNiI', raw(first:first))==0) return ! the common answer, without building the lower case word
   if (is_word(raw(first:last), 'inf').or.is_word(raw(first:last), 'infinity')) then
      special = SPECIAL_INF
   elseif (is_word(raw(first:first+2), 'nan')) then
      if (last==first+2) then
         special = SPECIAL_NAN
      elseif (raw(first+3:first+3)=='('.and.raw(last:last)==')') then
         do c=first+4, last-1
            code = iachar(raw(c:c))
            if (.not.((code>=48.and.code<=57).or.(code>=65.and.code<=90).or.(code>=97.and.code<=122).or.code==95)) return
         enddo
         special = SPECIAL_NAN
      endif
   endif
   contains
      pure function is_word(text, word) result(same)
      !< Compare with a lower case word, ignoring the ASCII case of the text.
      character(kind=CK, len=*), intent(in) :: text !< The text.
      character(len=*),          intent(in) :: word !< The lower case word.
      logical                               :: same !< They are the same word.
      integer                               :: i    !< Counter.

      same = len(text)==len(word)
      if (.not.same) return
      do i=1, len(word)
         same = same.and.(text(i:i)==word(i:i).or.iachar(text(i:i))==iachar(word(i:i))-CASE_SHIFT)
      enddo
      endfunction is_word
   endsubroutine parse_special_number

   pure subroutine parse_number_fast(raw, is_integer, negative, mantissa, exponent, is_ok, truncated)
   !< Parse a plain decimal number, `[blanks][sign]digits[.digits][e|E|d|D[sign]digits][blanks]` (only the integer part if
   !< `is_integer`), into its sign, its digits as an integer and its decimal exponent. After a decimal point the exponent
   !< can also be a sign and exactly 3 digits, without the letter, the form E and ES edit descriptors write (`1.5-301`).
   !<
   !< `is_ok` is false for anything else: the caller then falls back to the read statement. The accepted strings are a subset
   !< of the ones accepted by [[string:is_number]] and by the read statement. An integer of more than 18 significant digits
   !< is not accepted; a real keeps the first 18, the exponent accounts for the others, and `truncated` tells whether any
   !< of those dropped was not zero: the number is then between mantissa and mantissa + 1, times the power of ten.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:read_number]] and by the differential test.
   character(kind=CK, len=*), intent(in)  :: raw          !< Raw characters data.
   logical,                   intent(in)  :: is_integer   !< Accept an integer only, no fraction nor exponent.
   logical,                   intent(out) :: negative     !< The number is negative.
   integer(I8P),              intent(out) :: mantissa     !< Significant digits, as an integer.
   integer,                   intent(out) :: exponent     !< Decimal exponent: the number is mantissa * 10**exponent.
   logical,                   intent(out) :: is_ok        !< The string is a plain decimal number.
   logical,                   intent(out), optional :: truncated !< Digits that are not zero were dropped.
   integer                                :: c            !< Character counter.
   integer                                :: d            !< Value of a digit.
   integer                                :: digits       !< Significant digits read.
   integer                                :: exp_value    !< Value of the exponent field.
   integer                                :: d_count      !< Digits of the exponent field.
   logical                                :: has_digit    !< A digit has been read.
   logical                                :: exp_negative !< The exponent field is negative.
   logical                                :: has_point    !< A decimal point has been read.
   logical                                :: dropped      !< Digits that are not zero were dropped.
   logical                                :: no_letter    !< The exponent has no letter, as in 1.5-301.

   has_point = .false.
   dropped = .false.
   if (present(truncated)) truncated = .false.
   negative = .false.
   mantissa = 0_I8P
   exponent = 0
   is_ok = .false.
   c = 1
   do while (c<=len(raw))
      if (raw(c:c)/=SPACE.and.raw(c:c)/=TAB) exit
      c = c + 1
   enddo
   if (c>len(raw)) return
   if (raw(c:c)=='+'.or.raw(c:c)=='-') then
      negative = raw(c:c)=='-'
      c = c + 1
   endif
   has_digit = .false.
   digits = 0
   do while (c<=len(raw)) ! digits of the integer part
      d = iachar(raw(c:c)) - iachar('0')
      if (d<0.or.d>9) exit
      has_digit = .true.
      if (mantissa>0.or.d>0) then ! the leading zeros are not significant
         digits = digits + 1
         if (digits>18) then
            if (is_integer) return
            dropped = dropped.or.d>0
            exponent = exponent + 1
         else
            mantissa = mantissa * 10 + d
         endif
      endif
      c = c + 1
   enddo
   if (.not.is_integer.and.c<=len(raw)) then
      if (raw(c:c)=='.') then
         has_point = .true.
         c = c + 1
         do while (c<=len(raw)) ! digits after the decimal point
            d = iachar(raw(c:c)) - iachar('0')
            if (d<0.or.d>9) exit
            has_digit = .true.
            if (mantissa>0.or.d>0) then ! the leading zeros are not significant
               digits = digits + 1
               if (digits>18) then
                  dropped = dropped.or.d>0
                  exponent = exponent + 1 ! this digit does not move the point
               else
                  mantissa = mantissa * 10 + d
               endif
            endif
            exponent = exponent - 1
            c = c + 1
         enddo
      endif
   endif
   if (.not.has_digit) return
   if (.not.is_integer.and.c<=len(raw)) then
      no_letter = has_point.and.(raw(c:c)=='+'.or.raw(c:c)=='-')
      if (no_letter.or.index('eEdD', raw(c:c))>0) then
         if (.not.no_letter) c = c + 1
         exp_negative = .false.
         if (c<=len(raw)) then
            if (raw(c:c)=='+'.or.raw(c:c)=='-') then
               exp_negative = raw(c:c)=='-'
               c = c + 1
            endif
         endif
         exp_value = 0
         d_count = 0
         has_digit = .false.
         do while (c<=len(raw))
            d = iachar(raw(c:c)) - iachar('0')
            if (d<0.or.d>9) exit
            has_digit = .true.
            d_count = d_count + 1
            if (exp_value<=99999) exp_value = exp_value * 10 + d ! far past the range of any kind: it saturates
            c = c + 1
         enddo
         if (.not.has_digit) return
         if (no_letter.and.d_count/=3) return
         if (exp_negative) exp_value = -exp_value
         exponent = exponent + exp_value
      endif
   endif
   do while (c<=len(raw))
      if (raw(c:c)/=SPACE.and.raw(c:c)/=TAB) return
      c = c + 1
   enddo
   is_ok = .true.
   if (present(truncated)) truncated = dropped
   endsubroutine parse_number_fast

   pure function find_occurrence(raw, substring, occurrence, back) result(pos)
   !< Return the start of the occurrence number `occurrence` of substring into raw, zero if there are fewer.
   !<
   !< The occurrences are not overlapping, counted from the start or, if `back` is true, from the end. A null substring is
   !< found by its first occurrence only, as the intrinsic `index`.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:index]].
   character(kind=CK, len=*), intent(in)           :: raw        !< Raw characters data.
   character(kind=CK, len=*), intent(in)           :: substring  !< Searched substring.
   integer,                   intent(in)           :: occurrence !< Number of the occurrence.
   logical,                   intent(in), optional :: back       !< Count from the end.
   integer                                         :: pos        !< Start of the occurrence, zero if not found.
   logical                                         :: back_      !< Count from the end, local variable.
   integer                                         :: n          !< Occurrences found.
   integer                                         :: c          !< First (last if back) character still searched.
   integer                                         :: p          !< Position of an occurrence.

   pos = 0
   if (occurrence<1) return
   back_ = .false. ; if (present(back)) back_ = back
   if (len(substring)==0) then
      if (occurrence==1) pos = index(raw, substring, back=back_)
      return
   endif
   n = 0
   if (back_) then
      c = len(raw)
      do
         p = index(raw(1:c), substring, back=.true.)
         if (p==0) return
         n = n + 1
         if (n==occurrence) exit
         c = p - 1
      enddo
   else
      c = 1
      do
         p = index(raw(c:), substring)
         if (p==0) return
         p = c + p - 1
         n = n + 1
         if (n==occurrence) exit
         c = p + len(substring)
      enddo
   endif
   pos = p
   endfunction find_occurrence

   pure function strip_characters(remove, whitespace, unicode) result(set)
   !< Return the set of characters to strip: `remove` (default a space), plus the whitespace if `whitespace` is true, the
   !< Unicode White_Space if `unicode` is true too.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:strip]].
   character(kind=CK, len=*), intent(in), optional :: remove     !< Set of characters to be removed, default space.
   logical,                   intent(in), optional :: whitespace !< Remove the whitespace too.
   logical,                   intent(in), optional :: unicode    !< The whitespace is Unicode White_Space, not ASCII.
   character(kind=CK, len=:), allocatable          :: set        !< Set of characters to strip.

   if (present(remove)) then
      set = remove
   else
      set = SPACE
   endif
   if (present(whitespace)) then
      if (whitespace) then
         set = set//SPACE//TAB//achar(10, kind=CK)//achar(11, kind=CK)//achar(12, kind=CK)//achar(13, kind=CK)
         if (present(unicode)) then
            if (unicode) set = set//utf8_white_space()
         endif
      endif
   endif
   endfunction strip_characters

   pure function strip_set(raw, set, left, right) result(stripped)
   !< Return raw without the leading (if left) and the trailing (if right) characters belonging to set.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:strip]], [[string:lstrip]] and [[string:rstrip]].
   character(kind=CK, len=*), intent(in)  :: raw      !< Raw characters data.
   character(kind=CK, len=*), intent(in)  :: set      !< Set of characters to strip.
   logical,                   intent(in)  :: left     !< Strip the leading characters.
   logical,                   intent(in)  :: right    !< Strip the trailing characters.
   character(kind=CK, len=:), allocatable :: stripped !< Raw stripped.
   integer                                :: first    !< First character kept.
   integer                                :: last     !< Last character kept.

   if (len(set)==0) then
      stripped = raw
      return
   endif
   first = 1
   last = len(raw)
   if (left) then
      first = utf8_scan(raw=raw, set=set, inside=.false.)
      if (first==0) first = len(raw) + 1
   endif
   if (right) then
      last = utf8_scan(raw=raw, set=set, back=.true., inside=.false.) ! the first byte of the last unit kept
      if (last>0) then
         if (iand(ichar(raw(last:last)), 255)>127) last = last + utf8_unit_len(raw, last) - 1
      endif
   endif
   if (first<=last) then
      stripped = raw(first:last)
   else
      stripped = ''
   endif
   endfunction strip_set

   elemental function is_digit_char(c) result(is_digit)
   !< Return true if the character is an ASCII digit.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_alnum]].
   character(kind=CK, len=1), intent(in) :: c        !< The character.
   logical                               :: is_digit !< Result of the test.

   is_digit = iachar(c)>=iachar('0').and.iachar(c)<=iachar('9')
   endfunction is_digit_char

   elemental function is_punct_char(c) result(is_punct)
   !< Return true if the character is printable ASCII and not a letter, a digit or a space (as C `ispunct`).
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_punct]].
   character(kind=CK, len=1), intent(in) :: c        !< The character.
   logical                               :: is_punct !< Result of the test.

   is_punct = iachar(c)>iachar(' ').and.iachar(c)<127.and. &
              .not.(is_lower_char(c).or.is_upper_char(c).or.is_digit_char(c))
   endfunction is_punct_char

   elemental function is_space_char(c) result(is_space)
   !< Return true if the character is a space, a tab, a new line, a vertical tab, a form feed or a carriage return.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_space]].
   character(kind=CK, len=1), intent(in) :: c        !< The character.
   logical                               :: is_space !< Result of the test.

   is_space = c==SPACE.or.(iachar(c)>=9.and.iachar(c)<=13)
   endfunction is_space_char

   elemental function is_xdigit_char(c) result(is_xdigit)
   !< Return true if the character is a hexadecimal digit.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_xdigit]].
   character(kind=CK, len=1), intent(in) :: c         !< The character.
   logical                               :: is_xdigit !< Result of the test.

   is_xdigit = is_digit_char(c).or.(iachar(c)>=iachar('a').and.iachar(c)<=iachar('f')).or. &
               (iachar(c)>=iachar('A').and.iachar(c)<=iachar('F'))
   endfunction is_xdigit_char

   elemental function is_lower_char(c) result(is_lower)
   !< Return true if the character is an ASCII lowercase letter.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_upper]] and [[string:lower]].
   character(kind=CK, len=1), intent(in) :: c        !< The character.
   logical                               :: is_lower !< Result of the test.

   is_lower = iachar(c)>=iachar('a').and.iachar(c)<=iachar('z')
   endfunction is_lower_char

   elemental function is_upper_char(c) result(is_upper)
   !< Return true if the character is an ASCII uppercase letter.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:is_lower]] and [[string:upper]].
   character(kind=CK, len=1), intent(in) :: c        !< The character.
   logical                               :: is_upper !< Result of the test.

   is_upper = iachar(c)>=iachar('A').and.iachar(c)<=iachar('Z')
   endfunction is_upper_char

   elemental function lower_char(c) result(lower)
   !< Return the lowercase of an ASCII uppercase letter, any other character unchanged.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:lower]].
   character(kind=CK, len=1), intent(in) :: c     !< The character.
   character(kind=CK, len=1)             :: lower !< Lowercase character.

   lower = c
   if (is_upper_char(c)) lower = achar(iachar(c) + CASE_SHIFT, kind=CK)
   endfunction lower_char

   elemental function upper_char(c) result(upper)
   !< Return the uppercase of an ASCII lowercase letter, any other character unchanged.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:upper]].
   character(kind=CK, len=1), intent(in) :: c     !< The character.
   character(kind=CK, len=1)             :: upper !< Uppercase character.

   upper = c
   if (is_lower_char(c)) upper = achar(iachar(c) - CASE_SHIFT, kind=CK)
   endfunction upper_char

   pure function match_token(pattern, p, c) result(token_len)
   !< Return the length of the token of a wildcard pattern starting at p if it matches the unit c, 0 otherwise.
   !<
   !< The token is `?`, a class `[seq]` or `[!seq]`, or a plain unit, see [[string:match]]; `*` is handled by the caller. A
   !< unit is a well-formed UTF-8 sequence or a byte that is not part of one; a range compares codepoints, an ill-formed
   !< byte b counting as U+DC00+b (as Python's surrogateescape).
   !<
   !< @note The doctest is not necessary, this being tested by [[string:match]].
   character(kind=CK, len=*), intent(in) :: pattern    !< Wildcard pattern.
   integer,                   intent(in) :: p          !< Position of the token into the pattern.
   character(kind=CK, len=*), intent(in) :: c          !< Unit to match.
   integer                               :: token_len  !< Length of the token if it matches c, 0 otherwise.
   integer                               :: first      !< First byte of the set of a class.
   integer                               :: last       !< Position of the closing bracket of a class.
   integer                               :: i          !< Byte position into the set.
   integer                               :: m          !< Bytes of a unit of the pattern.
   integer                               :: high       !< Position of the upper end of a range.
   integer                               :: code       !< Range code of c.
   logical                               :: is_negated !< The class is negated.
   logical                               :: is_member  !< The unit is a member of the set.

   token_len = 0
   select case(pattern(p:p))
   case('?')
      token_len = 1
   case('[')
      first = p + 1
      is_negated = .false.
      if (first<=len(pattern)) then
         if (pattern(first:first)=='!') then
            is_negated = .true.
            first = first + 1
         endif
      endif
      ! the first unit of the set is a member even if it is a ']': the closing bracket is searched after it
      last = 0
      if (first<=len(pattern)) then
         m = unit_length(pattern, first)
         if (first+m<=len(pattern)) last = index(pattern(first+m:), ']')
         if (last>0) last = first + m - 1 + last
      endif
      if (last==0) then ! no closing bracket: a plain '['
         if (c=='[') token_len = 1
         return
      endif
      code = -1 ! computed at the first range
      is_member = .false.
      i = first
      do while (i<last.and..not.is_member)
         m = unit_length(pattern, i)
         high = i + m + 1
         is_member = .false.
         if (high<last.and.pattern(i+m:i+m)=='-') then
            if (high+unit_length(pattern, high)-1<last) then ! a range
               if (code<0) code = range_code(c, 1)
               is_member = code>=range_code(pattern, i).and.code<=range_code(pattern, high)
               i = high + unit_length(pattern, high)
               cycle
            endif
         endif
         is_member = pattern(i:i+m-1)==c
         i = i + m
      enddo
      if (is_member.neqv.is_negated) token_len = last - p + 1
   case default
      if (iand(ichar(pattern(p:p)), 255)<128) then ! an ASCII byte of the pattern matches only itself
         if (len(c)==1) then
            if (c(1:1)==pattern(p:p)) token_len = 1
         endif
         return
      endif
      m = unit_length(pattern, p)
      if (pattern(p:p+m-1)==c) token_len = m
   endselect
   endfunction match_token

   pure function byte_safe_position(raw, pos, by) result(safepos)
   !< Return the insertion position of [[string:insert]] in bytes: pos clamped into 1..length (in the unit of `by`); the
   !< first character gives 1 (insert prepends), the last one len(raw) (insert appends), any other its first byte.
   character(kind=CK, len=*), intent(in)           :: raw     !< Bytes.
   integer,                   intent(in)           :: pos     !< Position, in the unit of `by`.
   integer,                   intent(in), optional :: by      !< Unit of pos.
   integer                                         :: safepos !< Position in bytes.
   integer                                         :: n       !< Number of characters.

   safepos = min(max(1, pos), len(raw))
   if (.not.present(by)) return
   if (by/=SF_CHARS) return
   n = utf8_units(raw)
   safepos = min(max(1, pos), n)
   if (safepos==1) return ! the same order of the tests as insert: the first character before the last one
   if (safepos==n) then
      safepos = len(raw)
   else
      safepos = utf8_byte_pos(raw, safepos)
   endif
   endfunction byte_safe_position

   pure function measure(raw, by) result(size_)
   !< Return the length of raw in the unit asked by `by`: bytes (SF_BYTES or absent), characters (SF_CHARS) or display
   !< columns (SF_COLUMNS).
   character(kind=CK, len=*), intent(in)           :: raw   !< Bytes.
   integer,                   intent(in), optional :: by    !< Unit asked.
   integer                                         :: size_ !< Length.

   size_ = len(raw)
   if (.not.present(by)) return
   if (by==SF_CHARS) size_ = utf8_units(raw)
   if (by==SF_COLUMNS) size_ = utf8_width(raw)
   endfunction measure

   pure function to_unit(raw, i, by) result(position)
   !< Return a byte position in the unit asked by `by`: unchanged for SF_BYTES (or absent), the character holding the
   !< byte for SF_CHARS; 0 stays 0.
   character(kind=CK, len=*), intent(in)           :: raw      !< Bytes.
   integer,                   intent(in)           :: i        !< Byte position, 0 for none.
   integer,                   intent(in), optional :: by       !< Unit asked.
   integer                                         :: position !< Position in that unit.

   position = i
   if (.not.present(by).or.i==0) return
   if (by==SF_CHARS) position = utf8_char_pos(raw, i)
   endfunction to_unit

   pure function unit_length(raw, i) result(n)
   !< Return the length of the unit starting at byte i: 1 for ASCII, else the length of the well-formed sequence, or 1.
   character(kind=CK, len=*), intent(in) :: raw !< Bytes.
   integer,                   intent(in) :: i   !< Position of the first byte.
   integer                               :: n   !< Length of the unit.

   n = 1
   if (iand(ichar(raw(i:i)), 255)>127) n = utf8_unit_len(raw, i)
   endfunction unit_length

   pure function range_code(raw, i) result(code)
   !< Return the code of the unit starting at byte i for the ranges of [[string:match]]: its codepoint, U+DC00+b for an
   !< ill-formed byte b (as Python's surrogateescape).
   character(kind=CK, len=*), intent(in) :: raw  !< Bytes.
   integer,                   intent(in) :: i    !< Position of the first byte.
   integer                               :: code !< Code.
   integer(I4P)                          :: cp   !< Codepoint, or -byte.
   integer                               :: n    !< Length of the unit.

   call utf8_decode(raw, i, cp, n)
   code = cp
   if (cp<0) code = 56320 - cp
   endfunction range_code

   pure function shell_escape(raw) result(escaped)
   !< Return raw with a backslash before every character that the POSIX shell could take as syntax.
   !<
   !< The letters, the digits, `._/-+,:@%=!` and the wildcards `*?[]` are left as they are: the shell still expands the
   !< wildcards, but spaces, `;`, `|`, `&`, `$`, quotes, parentheses, `~`, `#` and the like become plain characters.
   !<
   !< @note A new line cannot be escaped (a backslash before it continues the line): the caller must reject it.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:glob]].
   character(kind=CK, len=*), intent(in)  :: raw     !< Raw characters data.
   character(kind=CK, len=:), allocatable :: escaped !< Escaped characters data.
   character(kind=CK, len=*), parameter   :: SAFE = '._/-+,:@%=!*?[]' !< Characters kept as they are, with letters and digits.
   integer                                :: n       !< Number of characters to escape.
   integer                                :: c       !< Character counter into raw.
   integer                                :: e       !< Character counter into escaped.

   n = 0
   do c=1, len(raw)
      if (is_unsafe(raw(c:c))) n = n + 1
   enddo
   allocate(character(kind=CK, len=len(raw)+n) :: escaped)
   e = 0
   do c=1, len(raw)
      if (is_unsafe(raw(c:c))) then
         e = e + 1
         escaped(e:e) = BACKSLASH
      endif
      e = e + 1
      escaped(e:e) = raw(c:c)
   enddo

   contains
      elemental function is_unsafe(ch)
      !< Return true if the character must be escaped.
      character(kind=CK, len=1), intent(in) :: ch        !< The character.
      logical                               :: is_unsafe !< Result of the test.

      is_unsafe = .not.(is_lower_char(ch).or.is_upper_char(ch).or.(ch>='0'.and.ch<='9').or.index(SAFE, ch)>0)
      endfunction is_unsafe
   endfunction shell_escape

   pure subroutine append_to_buffer(buffer, length, piece)
   !< Append a piece to the first length characters of a buffer, doubling the buffer when it is full.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:read_line]] and [[string:read_lines]].
   character(kind=CK, len=:), allocatable, intent(inout) :: buffer !< Buffer, only its first length characters are used.
   integer,                                intent(inout) :: length !< Length of the used part of the buffer.
   character(kind=CK, len=*),              intent(in)    :: piece  !< Piece to append.
   character(kind=CK, len=:), allocatable                :: grown  !< Grown buffer.

   if (.not.allocated(buffer)) allocate(character(kind=CK, len=max(1024, len(piece))) :: buffer)
   if (length+len(piece)>len(buffer)) then
      allocate(character(kind=CK, len=max(2*len(buffer), length+len(piece))) :: grown)
      grown(1:length) = buffer(1:length)
      call move_alloc(from=grown, to=buffer)
   endif
   buffer(length+1:length+len(piece)) = piece
   length = length + len(piece)
   endsubroutine append_to_buffer

   pure function replace_substring(raw, old, new, count) result(replaced)
   !< Return raw with the occurrences of old replaced by new, in one pass.
   !<
   !< The occurrences are not overlapping, found from left to right, and the replaced text is not searched again.
   !< If `count` is passed only the first `count` occurrences are replaced, none if `count<=0`.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:replace]], [[string:escape]] and [[string:unescape]].
   character(kind=CK, len=*), intent(in)           :: raw      !< Raw characters data.
   character(kind=CK, len=*), intent(in)           :: old      !< Old substring, not null.
   character(kind=CK, len=*), intent(in)           :: new      !< New substring.
   integer,                   intent(in), optional :: count    !< Number of old occurences to be replaced.
   character(kind=CK, len=:), allocatable          :: replaced !< Raw with old replaced by new.
   integer                                         :: count_   !< Number of old occurences to be replaced, local variable.
   integer                                         :: n        !< Number of occurrences replaced.
   integer                                         :: pos      !< Position of an occurrence, relative to c.
   integer                                         :: c        !< Character counter into raw.
   integer                                         :: r        !< Character counter into replaced.

   count_ = huge(1) ; if (present(count)) count_ = count
   n = 0
   c = 1
   do while (n<count_)
      pos = index(raw(c:), old)
      if (pos==0) exit
      n = n + 1
      c = c + pos - 1 + len(old)
   enddo
   allocate(character(kind=CK, len=len(raw)+n*(len(new)-len(old))) :: replaced)
   c = 1
   r = 1
   do while (n>0)
      pos = index(raw(c:), old)
      replaced(r:r+pos-2) = raw(c:c+pos-2)
      r = r + pos - 1
      replaced(r:r+len(new)-1) = new
      r = r + len(new)
      c = c + pos - 1 + len(old)
      n = n - 1
   enddo
   replaced(r:) = raw(c:)
   endfunction replace_substring

   subroutine write_bom(unit, form, iostat, iomsg)
   !< Write a UTF-8 byte order mark at the start of the current record (formatted) or of the stream (unformatted).
   integer,          intent(in)    :: unit   !< Logical unit.
   character(len=*), intent(in)    :: form   !< Format of unit, FORMATTED or UNFORMATTED.
   integer,          intent(out)   :: iostat !< IO status code.
   character(len=*), intent(inout) :: iomsg  !< IO status message.

   if (form=='UNFORMATTED') then
      write(unit, iostat=iostat, iomsg=iomsg) BOM
   else
      write(unit, '(A)', advance='no', iostat=iostat, iomsg=iomsg) BOM
   endif
   endsubroutine write_bom

   pure subroutine squeeze_bytes(raw, squeezed, set)
   !< Return the bytes with every run of a repeated byte reduced to one, only for the bytes of `set` if passed: the byte
   !< loop of [[string:squeeze]], for ASCII text.
   character(kind=CK, len=*),              intent(in)           :: raw      !< Raw characters data.
   character(kind=CK, len=:), allocatable, intent(out)          :: squeezed !< Squeezed bytes.
   character(kind=CK, len=*),              intent(in), optional :: set      !< Bytes whose runs are reduced, default all.
   character(kind=CK, len=len(raw))                :: buffer   !< Buffer, the result being never longer.
   integer                                         :: length   !< Length of the result.
   integer                                         :: c        !< Byte counter.
   logical                                         :: is_run   !< The byte repeats the previous one and is squeezed.

   length = 0
   do c=1, len(raw)
      is_run = .false.
      if (c>1) then
         if (raw(c:c)==raw(c-1:c-1)) then
            is_run = .true.
            if (present(set)) is_run = index(set, raw(c:c))>0
         endif
      endif
      if (.not.is_run) then
         length = length + 1
         buffer(length:length) = raw(c:c)
      endif
   enddo
   squeezed = buffer(1:length)
   endsubroutine squeeze_bytes

   pure subroutine parse_c_escape(raw, i, value, is_byte, n)
   !< Parse the C escape starting with the backslash at byte i (see [[string:unescape_c]]).
   character(kind=CK, len=*), intent(in)  :: raw     !< Bytes.
   integer,                   intent(in)  :: i       !< Position of the backslash.
   integer(I4P),              intent(out) :: value   !< Byte or codepoint.
   logical,                   intent(out) :: is_byte !< True if value is a byte, false if it is a codepoint.
   integer,                   intent(out) :: n       !< Length of the escape, backslash included; 0 if malformed.
   integer                                :: digits  !< Digits of a numeric escape.
   logical                                :: is_hex  !< True if the hexadecimal digits are there.

   value = 0
   is_byte = .true.
   n = 0
   if (i + 1 > len(raw)) return
   select case (raw(i+1:i+1))
   case (BACKSLASH)
      value = 92
   case ("'")
      value = 39
   case ('"')
      value = 34
   case ('a')
      value = 7
   case ('b')
      value = 8
   case ('f')
      value = 12
   case ('n')
      value = 10
   case ('r')
      value = 13
   case ('t')
      value = 9
   case ('v')
      value = 11
   case ('e')
      value = 27
   case ('0':'7')
      digits = 0
      do while (digits < 3 .and. i + 1 + digits <= len(raw))
         if (verify(raw(i+1+digits:i+1+digits), '01234567') /= 0) exit
         value = value * 8 + (ichar(raw(i+1+digits:i+1+digits)) - ichar('0'))
         digits = digits + 1
      enddo
      if (value > 255) return
      n = 1 + digits
      return
   case ('x')
      call read_hex(raw, i + 2, 2, value, is_hex)
      if (.not.is_hex) return
      n = 4
      return
   case ('u')
      call read_hex(raw, i + 2, 4, value, is_hex)
      if (.not.is_hex) return
      if (value >= 55296 .and. value <= 57343) return
      is_byte = .false.
      n = 6
      return
   case ('U')
      call read_hex(raw, i + 2, 8, value, is_hex)
      if (.not.is_hex) return
      if ((value >= 55296 .and. value <= 57343) .or. value > 1114111) return
      is_byte = .false.
      n = 10
      return
   case default
      return
   endselect
   n = 2
   endsubroutine parse_c_escape

   pure subroutine parse_xml_reference(raw, i, value, n)
   !< Parse the XML reference starting with the ampersand at byte i (see [[string:unescape_xml]]).
   character(kind=CK, len=*), intent(in)  :: raw   !< Bytes.
   integer,                   intent(in)  :: i     !< Position of the ampersand.
   integer(I4P),              intent(out) :: value !< Codepoint.
   integer,                   intent(out) :: n     !< Length of the reference, `&` and `;` included; 0 if malformed.
   integer                                :: base  !< Base of a character reference: 10 or 16.
   integer                                :: first !< Position of the first digit.
   integer                                :: d     !< Byte position of a digit.
   integer                                :: h     !< Digit value.

   value = 0
   n = 0
   if (i + 3 > len(raw)) return ! the shortest reference is 4 bytes long
   if (raw(i+1:i+1) /= '#') then
      if (raw(i+1:i+3) == 'lt;') then
         value = 60
         n = 4
      elseif (raw(i+1:i+3) == 'gt;') then
         value = 62
         n = 4
      elseif (raw(i+1:min(i+4, len(raw))) == 'amp;') then
         value = 38
         n = 5
      elseif (raw(i+1:min(i+5, len(raw))) == 'quot;') then
         value = 34
         n = 6
      elseif (raw(i+1:min(i+5, len(raw))) == 'apos;') then
         value = 39
         n = 6
      endif
      return
   endif
   base = 10
   first = i + 2
   if (raw(i+2:i+2) == 'x') then
      base = 16
      first = i + 3
   endif
   d = first
   do while (d <= len(raw))
      h = index('0123456789abcdef', raw(d:d)) - 1
      if (h < 0 .and. base == 16) h = index('0123456789ABCDEF', raw(d:d)) - 1
      if (h < 0 .or. h >= base) exit
      if (value <= 1114111) value = value * base + h ! saturates above U+10FFFF, at most 1114111 * 16 + 15
      d = d + 1
   enddo
   if (d == first .or. d > len(raw)) return
   if (raw(d:d) /= ';') return
   if (value == 0 .or. value > 1114111 .or. (value >= 55296 .and. value <= 57343)) return
   n = d - i + 1
   endsubroutine parse_xml_reference

   pure subroutine read_hex(raw, first, digits, value, is_ok)
   !< Read exactly `digits` hexadecimal digits starting at byte `first`; false if they are not there.
   character(kind=CK, len=*), intent(in)  :: raw    !< Bytes.
   integer,                   intent(in)  :: first  !< Position of the first digit.
   integer,                   intent(in)  :: digits !< Number of digits, at most 8.
   integer(I4P),              intent(out) :: value  !< Value read, saturated at huge(value) above 7FFFFFFF.
   logical,                   intent(out) :: is_ok  !< True if the digits are there.
   integer                                :: d      !< Digit counter.
   integer                                :: h      !< Digit value.

   value = 0
   is_ok = .false.
   if (first + digits - 1 > len(raw)) return
   do d=first, first + digits - 1
      h = index('0123456789abcdef', raw(d:d)) - 1
      if (h < 0) h = index('0123456789ABCDEF', raw(d:d)) - 1
      if (h < 0) return
      if (value > 134217727) then ! a ninth significant digit would overflow: the value is far above U+10FFFF
         value = huge(value)
      else
         value = value * 16 + h
      endif
   enddo
   is_ok = .true.
   endsubroutine read_hex

   pure function hex_lower(value, digits) result(hex)
   !< Return a non-negative value in lowercase hexadecimal, zero-padded to `digits` digits.
   integer(I4P), intent(in) :: value  !< Value.
   integer,      intent(in) :: digits !< Digits.
   character(kind=CK, len=digits) :: hex !< Hexadecimal.
   integer(I4P)                   :: v   !< Remaining value.
   integer                        :: d   !< Digit counter.

   v = value
   do d=digits, 1, -1
      hex(d:d) = '0123456789abcdef'(iand(v, 15)+1:iand(v, 15)+1)
      v = ishft(v, -4)
   enddo
   endfunction hex_lower

   pure function unique_substring(raw, substring) result(uniq)
   !< Return raw with the sequential occurrences of substring reduced to one, in one pass.
   !<
   !< The result is the one of replacing the leftmost occurrence of `substring//substring` by `substring` until none is
   !< left: the characters are appended one by one to the result and, when the result ends with `substring//substring`,
   !< the last `substring` is removed. The leftmost occurrence being the first to end, the two are the same.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:unique]].
   character(kind=CK, len=*), intent(in)  :: raw       !< Raw characters data.
   character(kind=CK, len=*), intent(in)  :: substring !< Substring which sequential occurrences are reduced to one.
   character(kind=CK, len=:), allocatable :: uniq      !< Raw with the sequential occurrences reduced to one.
   character(kind=CK, len=:), allocatable :: buffer    !< Buffer, the result being never longer than raw.
   integer                                :: ls        !< Length of the substring.
   integer                                :: c         !< Character counter into raw.
   integer                                :: r         !< Length of the result into the buffer.

   ls = len(substring)
   if (ls==0.or.index(raw, substring//substring)==0) then
      uniq = raw
      return
   endif
   allocate(character(kind=CK, len=len(raw)) :: buffer)
   r = 0
   do c=1, len(raw)
      r = r + 1
      buffer(r:r) = raw(c:c)
      if (r>=2*ls) then
         if (buffer(r:r)==substring(ls:ls)) then
            if (buffer(r-2*ls+1:r-ls)==substring.and.buffer(r-ls+1:r)==substring) r = r - ls
         endif
      endif
   enddo
   uniq = buffer(1:r)
   endfunction unique_substring

   pure function join_raws(array, sep) result(join)
   !< Return the join of the allocated strings of an array, the not allocated ones being skipped.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:join]] and [[strjoin]].
   class(string),             intent(in)  :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in)  :: sep       !< Separator.
   character(kind=CK, len=:), allocatable :: join      !< The join of array.
   integer                                :: length    !< Length of the join.
   integer                                :: c         !< Character counter into join.
   integer                                :: a         !< Counter.
   logical                                :: is_first  !< The item is the first joined.

   length = -len(sep)
   do a=1, size(array, dim=1)
      if (allocated(array(a)%raw)) length = length + len(sep) + len(array(a)%raw)
   enddo
   allocate(character(kind=CK, len=max(0, length)) :: join)
   c = 0
   is_first = .true.
   do a=1, size(array, dim=1)
      if (.not.allocated(array(a)%raw)) cycle
      if (.not.is_first) then
         join(c+1:c+len(sep)) = sep
         c = c + len(sep)
      endif
      is_first = .false.
      join(c+1:c+len(array(a)%raw)) = array(a)%raw
      c = c + len(array(a)%raw)
   enddo
   endfunction join_raws

   pure function join_chars(array, sep, is_trim) result(join)
   !< Return the join of the not blank characters of an array, the blank ones being skipped.
   !<
   !< @note The doctest is not necessary, this being tested by [[string:join]] and [[strjoin]].
   character(kind=CK, len=*), intent(in)  :: array(1:) !< Array to be joined.
   character(kind=CK, len=*), intent(in)  :: sep       !< Separator.
   logical,                   intent(in)  :: is_trim   !< Trim the items.
   character(kind=CK, len=:), allocatable :: join      !< The join of array.
   integer                                :: length    !< Length of the join.
   integer                                :: item_len  !< Length of an item.
   integer                                :: c         !< Character counter into join.
   integer                                :: a         !< Counter.
   logical                                :: is_first  !< The item is the first joined.

   length = -len(sep)
   do a=1, size(array, dim=1)
      if (array(a)=='') cycle
      item_len = len(array(a)) ; if (is_trim) item_len = len_trim(array(a))
      length = length + len(sep) + item_len
   enddo
   allocate(character(kind=CK, len=max(0, length)) :: join)
   c = 0
   is_first = .true.
   do a=1, size(array, dim=1)
      if (array(a)=='') cycle
      if (.not.is_first) then
         join(c+1:c+len(sep)) = sep
         c = c + len(sep)
      endif
      is_first = .false.
      item_len = len(array(a)) ; if (is_trim) item_len = len_trim(array(a))
      join(c+1:c+item_len) = array(a)(1:item_len)
      c = c + item_len
   enddo
   endfunction join_chars

   pure function compare_versions(version_a, version_b, sep) result(order)
   !< Compare two version numbers field by field, see [[string:compare_version_character]].
   character(kind=CK, len=*), intent(in) :: version_a !< First version.
   character(kind=CK, len=*), intent(in) :: version_b !< Second version.
   character(kind=CK, len=*), intent(in) :: sep       !< Fields separator, it must be not null.
   integer                               :: order     !< -1 if a<b, 0 if a==b, 1 if a>b.
   integer                               :: first_a   !< First character of current field of first version.
   integer                               :: first_b   !< First character of current field of second version.
   integer                               :: last_a    !< Last character of current field of first version.
   integer                               :: last_b    !< Last character of current field of second version.

   order = 0
   first_a = 1
   first_b = 1
   do while (first_a<=len(version_a).or.first_b<=len(version_b))
      last_a = field_end(version=version_a, first=first_a)
      last_b = field_end(version=version_b, first=first_b)
      order = compare_fields(field_a=version_a(first_a:last_a), field_b=version_b(first_b:last_b))
      if (order/=0) exit
      first_a = last_a + len(sep) + 1
      first_b = last_b + len(sep) + 1
   enddo

   contains
      pure function field_end(version, first) result(last)
      !< Return the position of the last character of the field starting at `first`, a missing field being null.
      character(kind=CK, len=*), intent(in) :: version !< Version.
      integer,                   intent(in) :: first   !< First character of the field.
      integer                               :: last    !< Last character of the field.
      integer                               :: s       !< Position of the next separator.

      if (first>len(version)) then
         last = first - 1
      else
         s = index(version(first:), sep)
         if (s>0) then
            last = first + s - 2
         else
            last = len(version)
         endif
      endif
      endfunction field_end

      pure function compare_fields(field_a, field_b) result(order)
      !< Compare two fields: as integers if both are made only of digits, lexically otherwise.
      character(kind=CK, len=*), intent(in) :: field_a             !< First field.
      character(kind=CK, len=*), intent(in) :: field_b             !< Second field.
      integer                               :: order               !< -1 if a<b, 0 if a==b, 1 if a>b.
      character(kind=CK, len=10), parameter :: DIGITS='0123456789' !< Decimal digits.
      integer                               :: a                   !< First significant digit of first field.
      integer                               :: b                   !< First significant digit of second field.
      logical                               :: are_integers        !< Both fields are made only of digits.

      a = 1
      b = 1
      are_integers = verify(field_a, DIGITS)==0.and.verify(field_b, DIGITS)==0
      if (are_integers) then
         a = verify(field_a, '0') ; if (a==0) a = len(field_a) + 1
         b = verify(field_b, '0') ; if (b==0) b = len(field_b) + 1
      endif
      if (are_integers.and.len(field_a)-a/=len(field_b)-b) then
         order = merge(1, -1, len(field_a)-a>len(field_b)-b)
      elseif (field_a(a:)<field_b(b:)) then
         order = -1
      elseif (field_a(a:)>field_b(b:)) then
         order = 1
      else
         order = 0
      endif
      endfunction compare_fields
   endfunction compare_versions

   subroutine get_delimiter_mode(unit, delim, iostat, iomsg)
   !< Get the DELIM changeable connection mode for the given unit.
   !<
   !< If the unit is connected to an internal file, then the default value of NONE is always returned.
   use, intrinsic :: iso_fortran_env, only : iostat_inquire_internal_unit
   integer,                   intent(in)    :: unit         !< The unit for the connection.
   character(len=1, kind=CK), intent(out)   :: delim        !< Represents the value of the DELIM mode.
   integer,                   intent(out)   :: iostat       !< IOSTAT error code, non-zero on error.
   character(*),              intent(inout) :: iomsg        !< IOMSG explanatory message - only defined if iostat is non-zero.
   character(10)                            :: delim_buffer !< Buffer for INQUIRE about DELIM, sized for APOSTROHPE.
   character(len(iomsg))                    :: local_iomsg  !< Local variant of iomsg, so it doesn't get inappropriately redefined.

   ! get the string representation of the changeable mode
   inquire(unit, delim=delim_buffer, iostat=iostat, iomsg=local_iomsg)
   if (iostat == iostat_inquire_internal_unit) then
      ! no way of determining the DELIM mode for an internal file
      iostat = 0
      delim = ''
      return
   elseif (iostat /= 0) then
      iomsg = local_iomsg
      return
   endif
   ! interpret the DELIM string
   if (delim_buffer == 'QUOTE') then
      delim = '"'
   elseif (delim_buffer == 'APOSTROPHE') then
      delim = ''''
   else
      delim = '"'
   endif
   endsubroutine get_delimiter_mode

   subroutine get_next_non_blank_character_this_record(unit, ch, iostat, iomsg)
   !< Get the next non-blank character in the current record.
   integer,                   intent(in)    :: unit   !< Logical unit.
   character(kind=CK, len=1), intent(out)   :: ch     !< The non-blank character read. Not valid if IOSTAT is non-zero.
   integer,                   intent(out)   :: iostat !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg  !< IO status message.

   do
      ! we spcify non-advancing, just in case we want this callable outside the context of a child input statement
      ! the PAD specifier simply saves the need for the READ statement to define ch if EOR is hit
      ! read(unit, "(A)", iostat=iostat, iomsg=iomsg, advance='NO') ch
      ! ...but that causes ifort to blow up at runtime
      read(unit, "(A)", iostat=iostat, iomsg=iomsg, pad='NO') ch
      if (iostat /= 0) return
      if (ch /= '') exit
   enddo
   endsubroutine get_next_non_blank_character_this_record

   subroutine get_next_non_blank_character_any_record(unit, ch, iostat, iomsg)
   !< Get the next non-blank character, advancing records if necessary.
   integer,                   intent(in)    :: unit        !< Logical unit.
   character(kind=CK, len=1), intent(out)   :: ch          !< The non-blank character read. Not valid if IOSTAT is non-zero.
   integer,                   intent(out)   :: iostat      !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg       !< IO status message.
   character(len(iomsg))                    :: local_iomsg !< Local variant of iomsg, so it doesn't get inappropriately redefined.

   do
      call get_next_non_blank_character_this_record(unit=unit, ch=ch, iostat=iostat, iomsg=local_iomsg)
      if (is_iostat_eor(iostat)) then
         ! try again on the next record
         read (unit, "(/)", iostat=iostat, iomsg=iomsg)
         if (iostat /= 0) return
      elseif (iostat /= 0) then
         ! some sort of problem
         iomsg = local_iomsg
         return
      else
         ! got it
         exit
      endif
   enddo
   endsubroutine get_next_non_blank_character_any_record

   subroutine get_decimal_mode(unit, decimal_point, iostat, iomsg)
   !< Get the DECIMAL changeable connection mode for the given unit.
   !<
   !< If the unit is connected to an internal file, then the default value of DECIMAL is always returned. This may not be the
   !< actual value in force at the time of the call to this procedure.
   use, intrinsic :: iso_fortran_env, only : iostat_inquire_internal_unit
   integer,                   intent(in)    :: unit           !< Logical unit.
   logical,                   intent(out)   :: decimal_point  !< True if the decimal mode is POINT, false otherwise.
   integer,                   intent(out)   :: iostat         !< IO status code.
   character(kind=CK, len=*), intent(inout) :: iomsg          !< IO status message.
   character(5)                             :: decimal_buffer !< Buffer for INQUIRE about DECIMAL, sized for POINT or COMMA.
   character(len(iomsg))                    :: local_iomsg    !< Local iomsg, so it doesn't get inappropriately redefined.

   inquire(unit, decimal=decimal_buffer, iostat=iostat, iomsg=local_iomsg)
   if (iostat == iostat_inquire_internal_unit) then
      ! no way of determining the decimal mode for an internal file
      iostat = 0
      decimal_point = .true.
      return
   else if (iostat /= 0) then
      iomsg = local_iomsg
      return
   endif
   decimal_point = decimal_buffer == 'POINT'
   endsubroutine get_decimal_mode
endmodule stringifor_string_t
