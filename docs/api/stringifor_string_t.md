---
title: stringifor_string_t
---

# stringifor_string_t

> StringiFor, definition of `string` type.

**Source**: `src/lib/stringifor_string_t.F90`

## Contents

- [string](#string)
- [glob](#glob)
- [strjoin](#strjoin)
- [adjustl](#adjustl)
- [adjustr](#adjustr)
- [count](#count)
- [index](#index)
- [len_trim](#len-trim)
- [repeat](#repeat)
- [scan](#scan)
- [trim](#trim)
- [verify](#verify)
- [free](#free)
- [glob_character](#glob-character)
- [glob_string](#glob-string)
- [read_file](#read-file)
- [read_line](#read-line)
- [read_lines](#read-lines)
- [split](#split)
- [split_chunked](#split-chunked)
- [write_file](#write-file)
- [write_line](#write-line)
- [write_lines](#write-lines)
- [string_assign_string](#string-assign-string)
- [string_assign_character](#string-assign-character)
- [string_assign_integer_I1P](#string-assign-integer-i1p)
- [string_assign_integer_I2P](#string-assign-integer-i2p)
- [string_assign_integer_I4P](#string-assign-integer-i4p)
- [string_assign_integer_I8P](#string-assign-integer-i8p)
- [string_assign_real_R4P](#string-assign-real-r4p)
- [string_assign_real_R8P](#string-assign-real-r8p)
- [string_assign_real_R16P](#string-assign-real-r16p)
- [read_formatted](#read-formatted)
- [read_delimited](#read-delimited)
- [read_undelimited_listdirected](#read-undelimited-listdirected)
- [read_undelimited](#read-undelimited)
- [write_formatted](#write-formatted)
- [read_unformatted](#read-unformatted)
- [write_unformatted](#write-unformatted)
- [get_delimiter_mode](#get-delimiter-mode)
- [get_next_non_blank_character_this_record](#get-next-non-blank-character-this-record)
- [get_next_non_blank_character_any_record](#get-next-non-blank-character-any-record)
- [get_decimal_mode](#get-decimal-mode)
- [string_](#string)
- [sadjustl_character](#sadjustl-character)
- [sadjustr_character](#sadjustr-character)
- [count_substring](#count-substring)
- [sindex_character_string](#sindex-character-string)
- [sscan_character_string](#sscan-character-string)
- [sverify_character_string](#sverify-character-string)
- [sadjustl](#sadjustl)
- [sadjustr](#sadjustr)
- [scount](#scount)
- [sindex_string_string](#sindex-string-string)
- [sindex_string_character](#sindex-string-character)
- [slen](#slen)
- [slen_trim](#slen-trim)
- [srepeat_string_string](#srepeat-string-string)
- [srepeat_character_string](#srepeat-character-string)
- [sscan_string_string](#sscan-string-string)
- [sscan_string_character](#sscan-string-character)
- [strim](#strim)
- [sverify_string_string](#sverify-string-string)
- [sverify_string_character](#sverify-string-character)
- [basedir](#basedir)
- [basename](#basename)
- [camelcase](#camelcase)
- [capitalize](#capitalize)
- [chars](#chars)
- [colorize_str](#colorize-str)
- [decode](#decode)
- [encode](#encode)
- [escape](#escape)
- [extension](#extension)
- [fill](#fill)
- [insert_character](#insert-character)
- [insert_string](#insert-string)
- [join_strings](#join-strings)
- [join_characters](#join-characters)
- [strjoin_strings](#strjoin-strings)
- [strjoin_characters](#strjoin-characters)
- [strjoin_strings_array](#strjoin-strings-array)
- [strjoin_characters_array](#strjoin-characters-array)
- [lower](#lower)
- [partition](#partition)
- [replace](#replace)
- [reverse](#reverse)
- [search](#search)
- [slice](#slice)
- [snakecase](#snakecase)
- [startcase](#startcase)
- [strip](#strip)
- [swapcase](#swapcase)
- [tempname](#tempname)
- [to_integer_I1P](#to-integer-i1p)
- [to_integer_I2P](#to-integer-i2p)
- [to_integer_I4P](#to-integer-i4p)
- [to_integer_I8P](#to-integer-i8p)
- [to_real_R4P](#to-real-r4p)
- [to_real_R8P](#to-real-r8p)
- [to_real_R16P](#to-real-r16p)
- [unescape](#unescape)
- [unique](#unique)
- [upper](#upper)
- [end_with](#end-with)
- [is_allocated](#is-allocated)
- [is_digit](#is-digit)
- [is_integer](#is-integer)
- [is_lower](#is-lower)
- [is_number](#is-number)
- [is_real](#is-real)
- [is_upper](#is-upper)
- [start_with](#start-with)
- [string_concat_string](#string-concat-string)
- [string_concat_character](#string-concat-character)
- [character_concat_string](#character-concat-string)
- [string_concat_string_string](#string-concat-string-string)
- [string_concat_character_string](#string-concat-character-string)
- [character_concat_string_string](#character-concat-string-string)
- [string_eq_string](#string-eq-string)
- [string_eq_character](#string-eq-character)
- [character_eq_string](#character-eq-string)
- [string_ne_string](#string-ne-string)
- [string_ne_character](#string-ne-character)
- [character_ne_string](#character-ne-string)
- [string_lt_string](#string-lt-string)
- [string_lt_character](#string-lt-character)
- [character_lt_string](#character-lt-string)
- [string_le_string](#string-le-string)
- [string_le_character](#string-le-character)
- [character_le_string](#character-le-string)
- [string_ge_string](#string-ge-string)
- [string_ge_character](#string-ge-character)
- [character_ge_string](#character-ge-string)
- [string_gt_string](#string-gt-string)
- [string_gt_character](#string-gt-character)
- [character_gt_string](#character-gt-string)
- [replace_one_occurrence](#replace-one-occurrence)

## Variables

| Name | Type | Attributes | Description |
|------|------|------------|-------------|
| `CK` | integer | parameter | Default character kind. |
| `UPPER_ALPHABET` | character(kind=[CK](/api/stringifor_string_t), len=26) | parameter | Upper case alphabet. |
| `LOWER_ALPHABET` | character(kind=[CK](/api/stringifor_string_t), len=26) | parameter | Lower case alphabet. |
| `SPACE` | character(kind=[CK](/api/stringifor_string_t), len=1) | parameter | Space character. |
| `TAB` | character(kind=[CK](/api/stringifor_string_t), len=1) | parameter | Tab character. |
| `UIX_DIR_SEP` | character(kind=[CK](/api/stringifor_string_t), len=1) | parameter | Unix/Linux directories separator (/). |
| `BACKSLASH` | character(kind=[CK](/api/stringifor_string_t), len=1) | parameter | Backslash character. |

## Derived Types

### string

OOP designed string class.

#### Components

| Name | Type | Attributes | Description |
|------|------|------------|-------------|
| `raw` | character(kind=[CK](/api/stringifor_string_t), len=:) | allocatable | Raw data. |

#### Type-Bound Procedures

| Name | Attributes | Description |
|------|------------|-------------|
| `adjustl` | pass(self) | Adjustl replacement. |
| `adjustr` | pass(self) | Adjustr replacement. |
| `count` | pass(self) | Count replacement. |
| `index` |  | Index replacement. |
| `len` | pass(self) | Len replacement. |
| `len_trim` | pass(self) | Len_trim replacement. |
| `repeat` |  | Repeat replacement. |
| `scan` |  | Scan replacement. |
| `trim` | pass(self) | Trim replacement. |
| `verify` |  | Verify replacement. |
| `basedir` | pass(self) | Return the base directory name of a string containing a file name. |
| `basename` | pass(self) | Return the base file name of a string containing a file name. |
| `camelcase` | pass(self) | Return a string with all words capitalized without spaces. |
| `capitalize` | pass(self) | Return a string with its first character capitalized and the rest lowercased. |
| `chars` | pass(self) | Return the raw characters data. |
| `colorize` |  | Colorize and stylize strings. |
| `decode` | pass(self) | Decode string. |
| `encode` | pass(self) | Encode string. |
| `escape` | pass(self) | Escape backslashes (or custom escape character). |
| `extension` | pass(self) | Return the extension of a string containing a file name. |
| `fill` | pass(self) | Pad string on the left (or right) with zeros (or other char) to fill width. |
| `free` | pass(self) | Free dynamic memory. |
| `glob` |  | Glob search, finds all the pathnames matching a given pattern. |
| `insert` |  | Insert substring into string at a specified position. |
| `join` |  | Return a string that is a join of an array of strings or characters. |
| `strjoin` |  | Return a string that is a join of an array of strings or characters; |
| `lower` | pass(self) | Return a string with all lowercase characters. |
| `partition` | pass(self) | Split string at separator and return the 3 parts (before, the separator and after). |
| `read_file` | pass(self) | Read a file a single string stream. |
| `read_line` | pass(self) | Read line (record) from a connected unit. |
| `read_lines` | pass(self) | Read (all) lines (records) from a connected unit as a single ascii stream. |
| `replace` | pass(self) | Return a string with all occurrences of substring old replaced by new. |
| `reverse` | pass(self) | Return a reversed string. |
| `search` | pass(self) | Search for *tagged* record into string. |
| `slice` | pass(self) | Return the raw characters data sliced. |
| `snakecase` | pass(self) | Return a string with all words lowercase separated by "_". |
| `split` | pass(self) | Return a list of substring in the string, using sep as the delimiter string. |
| `split_chunked` | pass(self) | Return a list of substring in the string, using sep as the delimiter string. |
| `startcase` | pass(self) | Return a string with all words capitalized, e.g. title case. |
| `strip` | pass(self) | Return a string with the leading and trailing characters removed. |
| `swapcase` | pass(self) | Return a string with uppercase chars converted to lowercase and vice versa. |
| `tempname` | pass(self) | Return a safe temporary name suitable for temporary file or directories. |
| `to_number` |  | Cast string to number. |
| `unescape` | pass(self) | Unescape double backslashes (or custom escaped character). |
| `unique` | pass(self) | Reduce to one (unique) multiple occurrences of a substring into a string. |
| `upper` | pass(self) | Return a string with all uppercase characters. |
| `write_file` | pass(self) | Write a single string stream into file. |
| `write_line` | pass(self) | Write line (record) to a connected unit. |
| `write_lines` | pass(self) | Write lines (records) to a connected unit. |
| `end_with` | pass(self) | Return true if a string ends with a specified suffix. |
| `is_allocated` | pass(self) | Return true if the string is allocated. |
| `is_digit` | pass(self) | Return true if all characters in the string are digits. |
| `is_integer` | pass(self) | Return true if the string contains an integer. |
| `is_lower` | pass(self) | Return true if all characters in the string are lowercase. |
| `is_number` | pass(self) | Return true if the string contains a number (real or integer). |
| `is_real` | pass(self) | Return true if the string contains an real. |
| `is_upper` | pass(self) | Return true if all characters in the string are uppercase. |
| `start_with` | pass(self) | Return true if a string starts with a specified prefix. |
| `assignment(=)` |  | Assignment operator overloading. |
| `operator(//)` |  | Concatenation operator overloading. |
| `operator(.cat.)` |  | Concatenation operator (string output) overloading. |
| `operator(==)` |  | Equal operator overloading. |
| `operator(/=)` |  | Not equal operator overloading. |
| `operator(<)` |  | Lower than operator overloading. |
| `operator(<=)` |  | Lower equal than operator overloading. |
| `operator(>=)` |  | Greater equal than operator overloading. |
| `operator(>)` |  | Greater than operator overloading. |
| `read(formatted)` |  | Formatted input. |
| `write(formatted)` |  | Formatted output. |
| `read(unformatted)` |  | Unformatted input. |
| `write(unformatted)` |  | Unformatted output. |
| `sindex_string_string` | pass(self) | Index replacement. |
| `sindex_string_character` | pass(self) | Index replacement. |
| `srepeat_string_string` | pass(self) | Repeat replacement. |
| `srepeat_character_string` | nopass | Repeat replacement. |
| `sscan_string_string` | pass(self) | Scan replacement. |
| `sscan_string_character` | pass(self) | Scan replacement. |
| `sverify_string_string` | pass(self) | Verify replacement. |
| `sverify_string_character` | pass(self) | Verify replacement. |
| `colorize_str` | pass(self) | Colorize and stylize strings. |
| `glob_character` | pass(self) | Glob search (character output). |
| `glob_string` | pass(self) | Glob search (string output). |
| `insert_string` | pass(self) | Insert substring into string at a specified position. |
| `insert_character` | pass(self) | Insert substring into string at a specified position. |
| `join_strings` | pass(self) | Return join string of an array of strings. |
| `join_characters` | pass(self) | Return join string of an array of characters. |
| `strjoin_strings` | nopass | Return join string of an array of strings. |
| `strjoin_characters` | nopass | Return join string of an array of strings. |
| `strjoin_strings_array` | nopass | Return join 1D string array of an 2D array of strings in columns or rows. |
| `strjoin_characters_array` | nopass | Return join 1D string array of an 2D array of characters in columns or rows. |
| `to_integer_I1P` | pass(self) | Cast string to integer. |
| `to_integer_I2P` | pass(self) | Cast string to integer. |
| `to_integer_I4P` | pass(self) | Cast string to integer. |
| `to_integer_I8P` | pass(self) | Cast string to integer. |
| `to_real_R4P` | pass(self) | Cast string to real. |
| `to_real_R8P` | pass(self) | Cast string to real. |
| `to_real_R16P` | pass(self) | Cast string to real. |
| `string_assign_string` | pass(lhs) | Assignment operator from string input. |
| `string_assign_character` | pass(lhs) | Assignment operator from character input. |
| `string_assign_integer_I1P` | pass(lhs) | Assignment operator from integer input. |
| `string_assign_integer_I2P` | pass(lhs) | Assignment operator from integer input. |
| `string_assign_integer_I4P` | pass(lhs) | Assignment operator from integer input. |
| `string_assign_integer_I8P` | pass(lhs) | Assignment operator from integer input. |
| `string_assign_real_R4P` | pass(lhs) | Assignment operator from real input. |
| `string_assign_real_R8P` | pass(lhs) | Assignment operator from real input. |
| `string_assign_real_R16P` | pass(lhs) | Assignment operator from real input. |
| `string_concat_string` | pass(lhs) | Concatenation with string. |
| `string_concat_character` | pass(lhs) | Concatenation with character. |
| `character_concat_string` | pass(rhs) | Concatenation with character (inverted). |
| `string_concat_string_string` | pass(lhs) | Concatenation with string (string output). |
| `string_concat_character_string` | pass(lhs) | Concatenation with character (string output). |
| `character_concat_string_string` | pass(rhs) | Concatenation with character (inverted, string output). |
| `string_eq_string` | pass(lhs) | Equal to string logical operator. |
| `string_eq_character` | pass(lhs) | Equal to character logical operator. |
| `character_eq_string` | pass(rhs) | Equal to character (inverted) logical operator. |
| `string_ne_string` | pass(lhs) | Not equal to string logical operator. |
| `string_ne_character` | pass(lhs) | Not equal to character logical operator. |
| `character_ne_string` | pass(rhs) | Not equal to character (inverted) logical operator. |
| `string_lt_string` | pass(lhs) | Lower than to string logical operator. |
| `string_lt_character` | pass(lhs) | Lower than to character logical operator. |
| `character_lt_string` | pass(rhs) | Lower than to character (inverted) logical operator. |
| `string_le_string` | pass(lhs) | Lower equal than to string logical operator. |
| `string_le_character` | pass(lhs) | Lower equal than to character logical operator. |
| `character_le_string` | pass(rhs) | Lower equal than to character (inverted) logical operator. |
| `string_ge_string` | pass(lhs) | Greater equal than to string logical operator. |
| `string_ge_character` | pass(lhs) | Greater equal than to character logical operator. |
| `character_ge_string` | pass(rhs) | Greater equal than to character (inverted) logical operator. |
| `string_gt_string` | pass(lhs) | Greater than to string logical operator. |
| `string_gt_character` | pass(lhs) | Greater than to character logical operator. |
| `character_gt_string` | pass(rhs) | Greater than to character (inverted) logical operator. |
| `read_formatted` | pass(dtv) | Formatted input. |
| `read_delimited` | pass(dtv) | Read a delimited input. |
| `read_undelimited` | pass(dtv) | Read an undelimited input. |
| `read_undelimited_listdirected` | pass(dtv) | Read an undelimited list directed input. |
| `write_formatted` | pass(dtv) | Formatted output. |
| `read_unformatted` | pass(dtv) | Unformatted input. |
| `write_unformatted` | pass(dtv) | Unformatted output. |
| `replace_one_occurrence` | pass(self) | Replace the first occurrence of substring old by new. |

## Interfaces

### glob

Overloading glob procedure.
```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: alist_chr(:)
 type(string),     allocatable :: alist_str(:)
 integer, parameter            :: Nf=5
 character(14)                 :: files(1:Nf)
 integer                       :: file_unit
 integer                       :: f
 integer                       :: ff
 logical                       :: test_passed
 do f=1, Nf
    files(f) = astring%tempname(prefix='foo-')
    open(newunit=file_unit, file=files(f))
    write(file_unit, *)f
    close(unit=file_unit)
 enddo
 call glob(self=astring, pattern='foo-*', list=alist_chr)
 call glob(self=astring, pattern='foo-*', list=alist_str)
 do f=1, Nf
    open(newunit=file_unit, file=files(f))
    close(unit=file_unit, status='delete')
 enddo
 test_passed = .false.
 outer_chr: do f=1, size(alist_chr, dim=1)
    do ff=1, Nf
       test_passed = alist_chr(f) == files(ff)
       if (test_passed) cycle outer_chr
    enddo
 enddo outer_chr
 if (test_passed) then
    test_passed = .false.
    outer_str: do f=1, size(alist_str, dim=1)
       do ff=1, Nf
          test_passed = alist_str(f) == files(ff)
          if (test_passed) cycle outer_str
       enddo
    enddo outer_str
 endif
 print '(L1)', test_passed
```

**Module procedures**: [`glob_character`](/api/stringifor_string_t#glob-character), [`glob_string`](/api/stringifor_string_t#glob-string)

### strjoin

**Module procedures**: [`strjoin_strings`](/api/stringifor_string_t#strjoin-strings), [`strjoin_characters`](/api/stringifor_string_t#strjoin-characters), [`strjoin_strings_array`](/api/stringifor_string_t#strjoin-strings-array), [`strjoin_characters_array`](/api/stringifor_string_t#strjoin-characters-array)

### adjustl

Builtin adjustl overloading.

**Module procedures**: [`sadjustl_character`](/api/stringifor_string_t#sadjustl-character)

### adjustr

Builtin adjustr overloading.

**Module procedures**: [`sadjustr_character`](/api/stringifor_string_t#sadjustr-character)

### count

Builtin count overloading.

**Module procedures**: [`count_substring`](/api/stringifor_string_t#count-substring)

### index

Builtin index overloading.

**Module procedures**: [`sindex_string_string`](/api/stringifor_string_t#sindex-string-string), [`sindex_string_character`](/api/stringifor_string_t#sindex-string-character), [`sindex_character_string`](/api/stringifor_string_t#sindex-character-string)

### len_trim

Builtin len_trim overloading.

**Module procedures**: [`slen_trim`](/api/stringifor_string_t#slen-trim)

### repeat

Builtin repeat overloading.

**Module procedures**: [`srepeat_string_string`](/api/stringifor_string_t#srepeat-string-string)

### scan

Builtin scan overloading.

**Module procedures**: [`sscan_string_string`](/api/stringifor_string_t#sscan-string-string), [`sscan_string_character`](/api/stringifor_string_t#sscan-string-character), [`sscan_character_string`](/api/stringifor_string_t#sscan-character-string)

### trim

Builtin trim overloading.

**Module procedures**: [`strim`](/api/stringifor_string_t#strim)

### verify

Builtin verify overloading.

**Module procedures**: [`sverify_string_string`](/api/stringifor_string_t#sverify-string-string), [`sverify_string_character`](/api/stringifor_string_t#sverify-string-character), [`sverify_character_string`](/api/stringifor_string_t#sverify-character-string)

## Subroutines

### free

Free dynamic memory.

```fortran
 type(string) :: astring
 astring = 'this is string example....wow!!!'
 call astring%free
 print '(L1)', astring%is_allocated().eqv..false.
```

**Attributes**: elemental

```fortran
subroutine free(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |

### glob_character

Glob search (character output), finds all the pathnames matching a given pattern according to the rules used by the Unix shell.

 @note Method not portable: works only on Unix/GNU Linux OS.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: alist_chr(:)
 integer, parameter            :: Nf=5
 character(14)                 :: files(1:Nf)
 integer                       :: file_unit
 integer                       :: f
 integer                       :: ff
 logical                       :: test_passed
 do f=1, Nf
    files(f) = astring%tempname(prefix='foo-')
    open(newunit=file_unit, file=files(f))
    write(file_unit, *)f
    close(unit=file_unit)
 enddo
 call astring%glob(pattern='foo-*', list=alist_chr)
 do f=1, Nf
    open(newunit=file_unit, file=files(f))
    close(unit=file_unit, status='delete')
 enddo
 test_passed = .false.
 outer_chr: do f=1, size(alist_chr, dim=1)
    do ff=1, Nf
       test_passed = alist_chr(f) == files(ff)
       if (test_passed) cycle outer_chr
    enddo
 enddo outer_chr
 print '(L1)', test_passed
```

```fortran
subroutine glob_character(self, pattern, list)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `pattern` | character(len=*) | in |  | Given pattern. |
| `list` | character(len=:) | out | allocatable | List of matching pathnames. |

### glob_string

Glob search (string output), finds all the pathnames matching a given pattern according to the rules used by the Unix shell.

 @note Method not portable: works only on Unix/GNU Linux OS.

```fortran
 type(string)                  :: astring
 type(string),     allocatable :: alist_str(:)
 integer, parameter            :: Nf=5
 character(14)                 :: files(1:Nf)
 integer                       :: file_unit
 integer                       :: f
 integer                       :: ff
 logical                       :: test_passed

 do f=1, Nf
    files(f) = astring%tempname(prefix='foo-')
    open(newunit=file_unit, file=files(f))
    write(file_unit, *)f
    close(unit=file_unit)
 enddo
 call astring%glob(pattern='foo-*', list=alist_str)
 do f=1, Nf
    open(newunit=file_unit, file=files(f))
    close(unit=file_unit, status='delete')
 enddo
 test_passed = .false.
 outer_str: do f=1, size(alist_str, dim=1)
    do ff=1, Nf
       test_passed = alist_str(f) == files(ff)
       if (test_passed) cycle outer_str
    enddo
 enddo outer_str
 print '(L1)', test_passed
```

```fortran
subroutine glob_string(self, pattern, list)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `pattern` | character(len=*) | in |  | Given pattern. |
| `list` | type([string](/api/stringifor_string_t#string)) | out | allocatable | List of matching pathnames. |

### read_file

Read a file as a single string stream.

 @note All the lines are stored into the string self as a single ascii stream. Each line (record) is separated by a `new_line`
 character.

 @note For unformatted read only `access='stream'` is supported with new_line as line terminator.

 @note *Fast* file reading allows a very efficient reading of streamed file, but it dumps file as single streamed string.

```fortran
 type(string)              :: astring
 type(string), allocatable :: strings(:)
 type(string)              :: line(3)
 integer                   :: iostat
 character(len=99)         :: iomsg
 integer                   :: scratch
 integer                   :: l
 logical                   :: test_passed(9)
 line(1) = ' Hello World!   '
 line(2) = 'How are you?  '
 line(3) = '   All say: "Fine thanks"'
 open(newunit=scratch, file='read_file_test.tmp')
 write(scratch, "(A)") line(1)%chars()
 write(scratch, "(A)") line(2)%chars()
 write(scratch, "(A)") line(3)%chars()
 close(scratch)
 call astring%read_file(file='read_file_test.tmp', iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+1) = (strings(l)==line(l))
 enddo
 open(newunit=scratch, file='read_file_test.tmp', form='UNFORMATTED', access='STREAM')
 write(scratch) line(1)%chars()//new_line('a')
 write(scratch) line(2)%chars()//new_line('a')
 write(scratch) line(3)%chars()//new_line('a')
 close(scratch)
 call astring%read_file(file='read_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+5) = (strings(l)==line(l))
 enddo
 open(newunit=scratch, file='read_file_test.tmp', form='UNFORMATTED', access='STREAM')
 close(scratch, status='DELETE')
 call astring%read_file(file='read_file_test.tmp', iostat=iostat)
 test_passed(9) = (iostat/=0)
 print '(L1)', all(test_passed)
```

```fortran
subroutine read_file(self, file, is_fast, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `file` | character(len=*) | in |  | File name. |
| `is_fast` | logical | in | optional | Flag to enable (super) fast file reading. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### read_line

Read line (record) from a connected unit.

 The line is read as an ascii stream read until the eor is reached.

 @note For unformatted read only `access='stream'` is supported with new_line as line terminator.

```fortran
 type(string)      :: astring
 type(string)      :: line(3)
 integer           :: iostat
 character(len=99) :: iomsg
 integer           :: scratch
 integer           :: l
 logical           :: test_passed(6)
 line(1) = ' Hello World!   '
 line(2) = 'How are you?  '
 line(3) = '   All say: "Fine thanks"'
 open(newunit=scratch, status='SCRATCH')
 write(scratch, "(A)") line(1)%chars()
 write(scratch, "(A)") line(2)%chars()
 write(scratch, "(A)") line(3)%chars()
 rewind(scratch)
 l = 0
 iostat = 0
 do
   l = l + 1
   call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg)
   if (iostat/=0.and..not.is_iostat_eor(iostat)) then
     exit
   else
     test_passed(l) = (astring==line(l))
   endif
 enddo
 close(scratch)
 open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
 write(scratch) line(1)%chars()//new_line('a')
 write(scratch) line(2)%chars()//new_line('a')
 write(scratch) line(3)%chars()//new_line('a')
 rewind(scratch)
 l = 0
 iostat = 0
 do
   l = l + 1
   call astring%read_line(unit=scratch, iostat=iostat, iomsg=iomsg, form='UnfORMatteD')
   if (iostat/=0.and..not.is_iostat_eor(iostat)) then
     exit
   else
     test_passed(l+3) = (astring==line(l))
   endif
 enddo
 close(scratch)
 print '(L1)', all(test_passed)
```

```fortran
subroutine read_line(self, unit, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### read_lines

Read (all) lines (records) from a connected unit as a single ascii stream.

 @note All the lines are stored into the string self as a single ascii stream. Each line (record) is separated by a `new_line`
 character. The line is read as an ascii stream read until the eor is reached.

 @note The connected unit is rewinded. At a successful exit current record is at eof, at the beginning otherwise.

 @note For unformatted read only `access='stream'` is supported with new_line as line terminator.

```fortran
 type(string)              :: astring
 type(string), allocatable :: strings(:)
 type(string)              :: line(3)
 integer                   :: iostat
 character(len=99)         :: iomsg
 integer                   :: scratch
 integer                   :: l
 logical                   :: test_passed(8)

 line(1) = ' Hello World!   '
 line(2) = 'How are you?  '
 line(3) = '   All say: "Fine thanks"'
 open(newunit=scratch, status='SCRATCH')
 write(scratch, "(A)") line(1)%chars()
 write(scratch, "(A)") line(2)%chars()
 write(scratch, "(A)") line(3)%chars()
 call astring%read_lines(unit=scratch, iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+1) = (strings(l)==line(l))
 enddo
 close(scratch)
 open(newunit=scratch, status='SCRATCH', form='UNFORMATTED', access='STREAM')
 write(scratch) line(1)%chars()//new_line('a')
 write(scratch) line(2)%chars()//new_line('a')
 write(scratch) line(3)%chars()//new_line('a')
 call astring%read_lines(unit=scratch, form='unformatted', iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+5) = (strings(l)==line(l))
 enddo
 close(scratch)
 print '(L1)', all(test_passed)
```

```fortran
subroutine read_lines(self, unit, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### split

Return a list of substring in the string, using sep as the delimiter string.

 @note Multiple subsequent separators are collapsed to one occurrence.

 @note If `max_tokens` is passed the returned number of tokens is either `max_tokens` or `max_tokens + 1`.

```fortran
 type(string)              :: astring
 type(string), allocatable :: strings(:)
 logical                   :: test_passed(11)
 astring = '+ab-++cre-++cre-ab+'
 call astring%split(tokens=strings, sep='+')
 test_passed(1) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'ab-++cre-++cre-ab+'
 call astring%split(tokens=strings, sep='+')
 test_passed(2) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'ab-++cre-++cre-ab'
 call astring%split(tokens=strings, sep='+')
 test_passed(3) = (strings(1)//''=='ab-'.and.strings(2)//''=='cre-'.and.strings(3)//''=='cre-ab')
 astring = 'Hello '//new_line('a')//'World!'
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(4) = (strings(1)//''=='Hello '.and.strings(2)//''=='World!')
 astring = 'Hello World!'
 call astring%split(tokens=strings)
 test_passed(5) = (strings(1)//''=='Hello'.and.strings(2)//''=='World!')
 astring = '+ab-'
 call astring%split(tokens=strings, sep='+')
 test_passed(6) = (strings(1)//''=='ab-')
 astring = '+ab-'
 call astring%split(tokens=strings, sep='-')
 test_passed(7) = (strings(1)//''=='+ab')
 astring = '+ab-+cd-'
 call astring%split(tokens=strings, sep='+')
 test_passed(8) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = 'ab-+cd-+'
 call astring%split(tokens=strings, sep='+')
 test_passed(9) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = '+ab-+cd-+'
 call astring%split(tokens=strings, sep='+')
 test_passed(10) = (strings(1)//''=='ab-'.and.strings(2)//''=='cd-')
 astring = '1-2-3-4-5-6-7-8'
 call astring%split(tokens=strings, sep='-', max_tokens=3)
 test_passed(11) = (strings(1)//''=='1'.and.strings(2)//''=='2'.and.strings(3)//''=='3'.and.strings(4)//''=='4-5-6-7-8')
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine split(self, tokens, sep, max_tokens)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `tokens` | type([string](/api/stringifor_string_t#string)) | out | allocatable | Tokens substring. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |
| `max_tokens` | integer | in | optional | Fix the maximum number of returned tokens. |

### split_chunked

Return a list of substring in the string, using sep as the delimiter string, chunked (memory-efficient) algorithm.

 @note Multiple subsequent separators are collapsed to one occurrence.

 @note The split is performed in chunks of `#chunks` to avoid excessive memory consumption.

```fortran
 type(string)              :: astring
 type(string), allocatable :: strings(:)
 logical                   :: test_passed(1)
 astring = '-1-2-3-4-5-6-7-8-'
 call astring%split_chunked(tokens=strings, sep='-', chunks=3)
 test_passed(1) = (strings(1)//''=='1'.and.strings(2)//''=='2'.and.strings(3)//''=='3'.and.strings(4)//''=='4'.and. &
                   strings(5)//''=='5'.and.strings(6)//''=='6'.and.strings(7)//''=='7'.and.strings(8)//''=='8')
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine split_chunked(self, tokens, chunks, sep)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `tokens` | type([string](/api/stringifor_string_t#string)) | out | allocatable | Tokens substring. |
| `chunks` | integer | in |  | Number of chunks. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### write_file

Write a single string stream into file.

 @note For unformatted read only `access='stream'` is supported with new_line as line terminator.

```fortran
 type(string)              :: astring
 type(string)              :: anotherstring
 type(string), allocatable :: strings(:)
 type(string)              :: line(3)
 integer                   :: iostat
 character(len=99)         :: iomsg
 integer                   :: scratch
 integer                   :: l
 logical                   :: test_passed(8)
 line(1) = ' Hello World!   '
 line(2) = 'How are you?  '
 line(3) = '   All say: "Fine thanks"'
 anotherstring = anotherstring%join(array=line, sep=new_line('a'))
 call anotherstring%write_file(file='write_file_test.tmp', iostat=iostat, iomsg=iomsg)
 call astring%read_file(file='write_file_test.tmp', iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(1) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+1) = (strings(l)==line(l))
 enddo
 call anotherstring%write_file(file='write_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
 call astring%read_file(file='write_file_test.tmp', form='unformatted', iostat=iostat, iomsg=iomsg)
 call astring%split(tokens=strings, sep=new_line('a'))
 test_passed(5) = (size(strings, dim=1)==size(line, dim=1))
 do l=1, size(strings, dim=1)
   test_passed(l+5) = (strings(l)==line(l))
 enddo
 open(newunit=scratch, file='write_file_test.tmp')
 close(unit=scratch, status='delete')
 print '(L1)', all(test_passed)
```

```fortran
subroutine write_file(self, file, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `file` | character(len=*) | in |  | File name. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### write_line

Write line (record) to a connected unit.

 @note If the connected unit is unformatted a `new_line()` character is added at the end (if necessary) to mark the end of line.

 @note There is no doctests, this being tested by means of [write_file](/api/stringifor#write-file) doctests.

```fortran
subroutine write_line(self, unit, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### write_lines

Write lines (records) to a connected unit.

 This method checks if self contains more than one line (records) and writes them as lines (records).

 @note If the connected unit is unformatted a `new_line()` character is added at the end (if necessary) to mark the end of line.

 @note There is no doctests, this being tested by means of [write_file](/api/stringifor#write-file) doctests.

```fortran
subroutine write_lines(self, unit, form, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `form` | character(len=*) | in | optional | Format of unit. |
| `iostat` | integer | out | optional | IO status code. |
| `iomsg` | character(len=*) | inout | optional | IO status message. |

### string_assign_string

Assignment operator from string input.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(1)
 astring = 'hello'
 anotherstring = astring
 test_passed(1) = astring%chars()==anotherstring%chars()
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_string(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_assign_character

Assignment operator from character input.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 'hello'
 test_passed(1) = astring%chars()=='hello'
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_character(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### string_assign_integer_I1P

Assignment operator from integer input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 127_I1P
 test_passed(1) = astring%to_number(kind=1_I1P)==127_I1P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_integer_I1P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | integer(kind=I1P) | in |  | Right hand side. |

### string_assign_integer_I2P

Assignment operator from integer input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 127_I2P
 test_passed(1) = astring%to_number(kind=1_I2P)==127_I2P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_integer_I2P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | integer(kind=I2P) | in |  | Right hand side. |

### string_assign_integer_I4P

Assignment operator from integer input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 127_I4P
 test_passed(1) = astring%to_number(kind=1_I4P)==127_I4P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_integer_I4P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | integer(kind=I4P) | in |  | Right hand side. |

### string_assign_integer_I8P

Assignment operator from integer input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 127_I8P
 test_passed(1) = astring%to_number(kind=1_I8P)==127_I8P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_integer_I8P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | integer(kind=I8P) | in |  | Right hand side. |

### string_assign_real_R4P

Assignment operator from real input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 3.021e6_R4P
 test_passed(1) = astring%to_number(kind=1._R4P)==3.021e6_R4P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_real_R4P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | real(kind=R4P) | in |  | Right hand side. |

### string_assign_real_R8P

Assignment operator from real input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 3.021e6_R8P
 test_passed(1) = astring%to_number(kind=1._R8P)==3.021e6_R8P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_real_R8P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | real(kind=R8P) | in |  | Right hand side. |

### string_assign_real_R16P

Assignment operator from real input.

```fortran
 use penf
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 3.021e6_R8P
 test_passed(1) = astring%to_number(kind=1._R8P)==3.021e6_R8P
 print '(L1)', all(test_passed)
```

**Attributes**: pure

```fortran
subroutine string_assign_real_R16P(lhs, rhs)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | inout |  | Left hand side. |
| `rhs` | real(kind=R16P) | in |  | Right hand side. |

### read_formatted

Formatted input.

 @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!

 @bug Read listdirected with and without delimiters does not work.

```fortran
subroutine read_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `iotype` | character(len=*) | in |  | Edit descriptor. |
| `v_list` | integer | in |  | Edit descriptor list. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(len=*) | inout |  | IO status message. |

### read_delimited

Read a delimited string from a unit connected for formatted input.

 If the closing delimiter is followed by end of record, then we return end of record.

 @note This does not need a doctest, it being tested by [[string::read_formatted]].

```fortran
subroutine read_delimited(dtv, unit, delim, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `delim` | character(kind=[CK](/api/stringifor_string_t), len=1) | in |  | String delimiter. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### read_undelimited_listdirected

Read an undelimited (no leading apostrophe or double quote) character value according to the rules for list directed input.

 A blank, comma/semicolon (depending on the decimal mode), slash or end of record terminates the string.

 If input is terminated by end of record, then this procedure returns an end-of-record condition.

```fortran
subroutine read_undelimited_listdirected(dtv, unit, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(len=*) | inout |  | IO status message. |

### read_undelimited

Read an undelimited string up until end of record or a character from a set of terminators is encountered.

 If a terminator is encountered, the file position will be at that terminating character. If end of record is encountered, the
 file remains at end of record.

```fortran
subroutine read_undelimited(dtv, unit, terminators, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `terminators` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Characters that are considered to terminate the string. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(len=*) | inout |  | IO status message. |

### write_formatted

Formatted output.

```fortran
subroutine write_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `iotype` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Edit descriptor. |
| `v_list` | integer | in |  | Edit descriptor list. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### read_unformatted

Unformatted input.

 @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!

```fortran
subroutine read_unformatted(dtv, unit, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | inout |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### write_unformatted

Unformatted output.

```fortran
subroutine write_unformatted(dtv, unit, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `dtv` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `unit` | integer | in |  | Logical unit. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### get_delimiter_mode

Get the DELIM changeable connection mode for the given unit.

 If the unit is connected to an internal file, then the default value of NONE is always returned.

```fortran
subroutine get_delimiter_mode(unit, delim, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `unit` | integer | in |  | The unit for the connection. |
| `delim` | character(kind=[CK](/api/stringifor_string_t), len=1) | out |  | Represents the value of the DELIM mode. |
| `iostat` | integer | out |  | IOSTAT error code, non-zero on error. |
| `iomsg` | character(len=*) | inout |  | IOMSG explanatory message - only defined if iostat is non-zero. |

### get_next_non_blank_character_this_record

Get the next non-blank character in the current record.

```fortran
subroutine get_next_non_blank_character_this_record(unit, ch, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `unit` | integer | in |  | Logical unit. |
| `ch` | character(kind=[CK](/api/stringifor_string_t), len=1) | out |  | The non-blank character read. Not valid if IOSTAT is non-zero. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### get_next_non_blank_character_any_record

Get the next non-blank character, advancing records if necessary.

```fortran
subroutine get_next_non_blank_character_any_record(unit, ch, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `unit` | integer | in |  | Logical unit. |
| `ch` | character(kind=[CK](/api/stringifor_string_t), len=1) | out |  | The non-blank character read. Not valid if IOSTAT is non-zero. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

### get_decimal_mode

Get the DECIMAL changeable connection mode for the given unit.

 If the unit is connected to an internal file, then the default value of DECIMAL is always returned. This may not be the
 actual value in force at the time of the call to this procedure.

```fortran
subroutine get_decimal_mode(unit, decimal_point, iostat, iomsg)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `unit` | integer | in |  | Logical unit. |
| `decimal_point` | logical | out |  | True if the decimal mode is POINT, false otherwise. |
| `iostat` | integer | out |  | IO status code. |
| `iomsg` | character(kind=[CK](/api/stringifor_string_t), len=*) | inout |  | IO status message. |

## Functions

### string_

Return a string given a character input.

```fortran
 print "(L1)", string('Hello World')//''=='Hello World'
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function string_(c)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `c` | character(len=*) | in |  | Character. |

### sadjustl_character

Left adjust a string by removing leading spaces (character output).

```fortran
 type(string) :: astring
 astring = '   Hello World!'
 print "(L1)", adjustl(astring)=='Hello World!   '
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function sadjustl_character(s) result(adjusted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | class([string](/api/stringifor_string_t#string)) | in |  | String. |

### sadjustr_character

Right adjust a string by removing leading spaces (character output).

```fortran
 type(string) :: astring
 astring = 'Hello World!   '
 print "(L1)", adjustr(astring)=='   Hello World!'
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function sadjustr_character(s) result(adjusted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | class([string](/api/stringifor_string_t#string)) | in |  | String. |

### count_substring

Count the number of occurences of a substring into a string.

```fortran
 print "(L1)", count('hello', substring='ll')==1
```

**Attributes**: elemental

**Returns**: `integer(kind=I4P)`

```fortran
function count_substring(s, substring) result(No)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | character(len=*) | in |  | String. |
| `substring` | character(len=*) | in |  | Substring. |

### sindex_character_string

Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
 If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
 the start of the last occurrence rather than the first.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'llo'
 test_passed(1) = index(s='Hello World Hello!', substring=string1)==index(string='Hello World Hello!', substring='llo')
 test_passed(2) = index(s='Hello World Hello!', substring=string1, back=.true.)==index(string='Hello World Hello!', &
                                                                                       substring='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sindex_character_string(s, substring, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | String. |
| `substring` | type([string](/api/stringifor_string_t#string)) | in |  | Searched substring. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sscan_character_string

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'llo'
 test_passed(1) = scan(s='Hello World Hello!', set=string1)==scan(string='Hello World Hello!', set='llo')
 test_passed(2) = scan(s='Hello World Hello!', set=string1, back=.true.)==scan(string='Hello World Hello!', &
                                                                               set='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sscan_character_string(s, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | String. |
| `set` | type([string](/api/stringifor_string_t#string)) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sverify_character_string

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
 in `set`. If all characters of `string` are found in `set`, the result is zero.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'ell'
 test_passed(1) = verify(s='Hello World Hello!', set=string1)==verify(string='Hello World Hello!', set='llo')
 test_passed(2) = verify(s='Hello World Hello!', set=string1, back=.true.)==verify(string='Hello World Hello!', set='llo', &
                                                                                   back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sverify_character_string(s, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `s` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | String. |
| `set` | type([string](/api/stringifor_string_t#string)) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sadjustl

Left adjust a string by removing leading spaces.

```fortran
 type(string) :: astring
 astring = '   Hello World!'
 print "(L1)", astring%adjustl()//''=='Hello World!   '
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function sadjustl(self) result(adjusted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### sadjustr

Right adjust a string by removing leading spaces.

```fortran
 type(string) :: astring
 astring = 'Hello World!   '
 print "(L1)", astring%adjustr()//''=='   Hello World!'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function sadjustr(self) result(adjusted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### scount

Count the number of occurences of a substring into a string.

 @note If `ignore_isolated` is set to true the eventual "isolated" occurences are ignored: an isolated occurrences are those
 occurrences happening at the start of string (thus not having a left companion) or at the end of the string (thus not having a
 right companion).

```fortran
 type(string) :: astring
 logical      :: test_passed(4)
 astring = '   Hello World  !    '
 test_passed(1) = astring%count(substring=' ')==10
 astring = 'Hello World  !    '
 test_passed(2) = astring%count(substring=' ', ignore_isolated=.true.)==6
 astring = '    Hello World  !'
 test_passed(3) = astring%count(substring=' ', ignore_isolated=.true.)==6
 astring = '   Hello World  !    '
 test_passed(4) = astring%count(substring=' ', ignore_isolated=.true.)==8
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function scount(self, substring, ignore_isolated) result(No)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | character(len=*) | in |  | Substring. |
| `ignore_isolated` | logical | in | optional | Ignore "isolated" occurrences. |

### sindex_string_string

Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
 If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
 the start of the last occurrence rather than the first.

```fortran
 type(string) :: string1
 type(string) :: string2
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 string2 = 'llo'
 test_passed(1) = string1%index(substring=string2)==index(string='Hello World Hello!', substring='llo')
 test_passed(2) = string1%index(substring=string2, back=.true.)==index(string='Hello World Hello!', substring='llo', &
                                                                       back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sindex_string_string(self, substring, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | type([string](/api/stringifor_string_t#string)) | in |  | Searched substring. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sindex_string_character

Return the position of the start of the first occurrence of string `substring` as a substring in `string`, counting from one.
 If `substring` is not present in `string`, zero is returned. If the back argument is present and true, the return value is
 the start of the last occurrence rather than the first.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 test_passed(1) = string1%index(substring='llo')==index(string='Hello World Hello!', substring='llo')
 test_passed(2) = string1%index(substring='llo', back=.true.)==index(string='Hello World Hello!', substring='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sindex_string_character(self, substring, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Searched substring. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### slen

Return the length of a string.

```fortran
 type(string) :: astring
 astring = 'Hello World!   '
 print "(L1)", astring%len()==len('Hello World!   ')
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function slen(self) result(l)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### slen_trim

Return the length of a string, ignoring any trailing blanks.

```fortran
 type(string) :: astring
 astring = 'Hello World!   '
 print "(L1)", astring%len_trim()==len_trim('Hello World!   ')
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function slen_trim(self) result(l)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### srepeat_string_string

Concatenates several copies of an input string.

```fortran
 type(string) :: astring
 astring = 'x'
 print "(L1)", astring%repeat(5)//''=='xxxxx'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function srepeat_string_string(self, ncopies) result(repeated)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | String to be repeated. |
| `ncopies` | integer | in |  | Number of string copies. |

### srepeat_character_string

Concatenates several copies of an input string.

```fortran
 type(string) :: astring
 astring = 'y'
 print "(L1)", astring%repeat('x', 5)//''=='xxxxx'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function srepeat_character_string(rstring, ncopies) result(repeated)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `rstring` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | String to be repeated. |
| `ncopies` | integer | in |  | Number of string copies. |

### sscan_string_string

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.

```fortran
 type(string) :: string1
 type(string) :: string2
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 string2 = 'llo'
 test_passed(1) = string1%scan(set=string2)==scan(string='Hello World Hello!', set='llo')
 test_passed(2) = string1%scan(set=string2, back=.true.)==scan(string='Hello World Hello!', set='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sscan_string_string(self, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `set` | type([string](/api/stringifor_string_t#string)) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sscan_string_character

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is in `set`.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 test_passed(1) = string1%scan(set='llo')==scan(string='Hello World Hello!', set='llo')
 test_passed(2) = string1%scan(set='llo', back=.true.)==scan(string='Hello World Hello!', set='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sscan_string_character(self, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `set` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### strim

Remove trailing spaces.

```fortran
 type(string) :: astring
 astring = 'Hello World!   '
 print "(L1)", astring%trim()==trim('Hello World!   ')
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strim(self) result(trimmed)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### sverify_string_string

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
 in `set`. If all characters of `string` are found in `set`, the result is zero.

```fortran
 type(string) :: string1
 type(string) :: string2
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 string2 = 'llo'
 test_passed(1) = string1%verify(set=string2)==verify(string='Hello World Hello!', set='llo')
 test_passed(2) = string1%verify(set=string2, back=.true.)==verify(string='Hello World Hello!', set='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sverify_string_string(self, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `set` | type([string](/api/stringifor_string_t#string)) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### sverify_string_character

Return the leftmost (if `back` is either absent or equals false, otherwise the rightmost) character of string that is not
 in `set`. If all characters of `string` are found in `set`, the result is zero.

```fortran
 type(string) :: string1
 logical      :: test_passed(2)
 string1 = 'Hello World Hello!'
 test_passed(1) = string1%verify(set='llo')==verify(string='Hello World Hello!', set='llo')
 test_passed(2) = string1%verify(set='llo', back=.true.)==verify(string='Hello World Hello!', set='llo', back=.true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer`

```fortran
function sverify_string_character(self, set, back) result(i)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `set` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Searched set. |
| `back` | logical | in | optional | Start of the last occurrence rather than the first. |

### basedir

Return the base directory name of a string containing a file name.

```fortran
 type(string) :: string1
 logical      :: test_passed(4)
 string1 = '/bar/foo.tar.bz2'
 test_passed(1) = string1%basedir()//''=='/bar'
 string1 = './bar/foo.tar.bz2'
 test_passed(2) = string1%basedir()//''=='./bar'
 string1 = 'bar/foo.tar.bz2'
 test_passed(3) = string1%basedir()//''=='bar'
 string1 = '\bar\foo.tar.bz2'
 test_passed(4) = string1%basedir(sep='\')//''=='\bar'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function basedir(self, sep)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Directory separator. |

### basename

Return the base file name of a string containing a file name.

 Optionally, the extension is also stripped if provided or the last one if required, e.g.

```fortran
 type(string) :: astring
 logical      :: test_passed(5)
 astring = 'bar/foo.tar.bz2'
 test_passed(1) = astring%basename()//''=='foo.tar.bz2'
 test_passed(2) = astring%basename(extension='.tar.bz2')//''=='foo'
 test_passed(3) = astring%basename(strip_last_extension=.true.)//''=='foo.tar'
 astring = '\bar\foo.tar.bz2'
 test_passed(4) = astring%basename(sep='\')//''=='foo.tar.bz2'
 astring = 'bar'
 test_passed(5) = astring%basename(strip_last_extension=.true.)//''=='bar'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function basename(self, sep, extension, strip_last_extension)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Directory separator. |
| `extension` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | File extension. |
| `strip_last_extension` | logical | in | optional | Flag to enable the stripping of last extension. |

### camelcase

Return a string with all words capitalized without spaces.

 @note Multiple subsequent separators are collapsed to one occurence.

```fortran
 type(string) :: astring
 astring = 'caMeL caSe var'
 print '(L1)', astring%camelcase()//''=='CamelCaseVar'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function camelcase(self, sep)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### capitalize

Return a string with its first character capitalized and the rest lowercased.

```fortran
 type(string) :: astring
 astring = 'say all Hello WorLD!'
 print '(L1)', astring%capitalize()//''=='Say all hello world!'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function capitalize(self) result(capitalized)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### chars

Return the raw characters data.

```fortran
 type(string) :: astring
 astring = 'say all Hello WorLD!'
 print '(L1)', astring%chars()=='say all Hello WorLD!'
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function chars(self) result(raw)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### colorize_str

Colorize and stylize strings, DEFAULT kind.

```fortran
 type(string) :: astring
 astring = 'say all Hello WorLD!'
 print '(L1)', astring%colorize(color_fg='red')=='[31msay all Hello WorLD![0m'
```

**Attributes**: pure

**Returns**: `character(len=:)`

```fortran
function colorize_str(self, color_fg, color_bg, style) result(colorized)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `color_fg` | character(len=*) | in | optional | Foreground color definition. |
| `color_bg` | character(len=*) | in | optional | Background color definition. |
| `style` | character(len=*) | in | optional | Style definition. |

### decode

Return a string decoded accordingly the codec.

 @note Only BASE64 codec is currently available.

```fortran
 type(string) :: astring
 astring = 'SG93IGFyZSB5b3U/'
 print '(L1)', astring%decode(codec='base64')//''=='How are you?'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function decode(self, codec) result(decoded)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `codec` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Encoding codec. |

### encode

Return a string encoded accordingly the codec.

 @note Only BASE64 codec is currently available.

```fortran
 type(string) :: astring
 astring = 'How are you?'
 print '(L1)', astring%encode(codec='base64')//''=='SG93IGFyZSB5b3U/'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function encode(self, codec) result(encoded)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `codec` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Encoding codec. |

### escape

Escape backslashes (or custom escape character).

```fortran
 type(string) :: astring
 logical      :: test_passed(2)
 astring = '^\s \d+\s*'
 test_passed(1) = astring%escape(to_escape='\')//''=='^\\s \\d+\\s*'
 test_passed(2) = astring%escape(to_escape='\', esc='|')//''=='^|\s |\d+|\s*'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function escape(self, to_escape, esc) result(escaped)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `to_escape` | character(kind=[CK](/api/stringifor_string_t), len=1) | in |  | Character to be escaped. |
| `esc` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Character used to escape. |

### extension

Return the extension of a string containing a file name.

```fortran
 type(string) :: astring
 astring = '/bar/foo.tar.bz2'
 print '(L1)', astring%extension()//''=='.bz2'
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function extension(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### fill

Pad string on the left (or right) with zeros (or other char) to fill width.

```fortran
 type(string) :: astring
 logical      :: test_passed(4)
 astring = 'this is string example....wow!!!'
 test_passed(1) = astring%fill(width=40)//''=='00000000this is string example....wow!!!'
 test_passed(2) = astring%fill(width=50)//''=='000000000000000000this is string example....wow!!!'
 test_passed(3) = astring%fill(width=50, right=.true.)//''=='this is string example....wow!!!000000000000000000'
 test_passed(4) = astring%fill(width=40, filling_char='*')//''=='********this is string example....wow!!!'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function fill(self, width, right, filling_char) result(filled)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `width` | integer | in |  | Final width of filled string. |
| `right` | logical | in | optional | Fill on the right instead of left. |
| `filling_char` | character(kind=[CK](/api/stringifor_string_t), len=1) | in | optional | Filling character (default "0"). |

### insert_character

Insert substring into string at a specified position.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(5)
 astring = 'this is string example wow!!!'
 acharacter = '... '
 test_passed(1) = astring%insert(substring=acharacter, pos=1)//''=='... this is string example wow!!!'
 test_passed(2) = astring%insert(substring=acharacter, pos=23)//''=='this is string example...  wow!!!'
 test_passed(3) = astring%insert(substring=acharacter, pos=29)//''=='this is string example wow!!!... '
 test_passed(4) = astring%insert(substring=acharacter, pos=-1)//''=='... this is string example wow!!!'
 test_passed(5) = astring%insert(substring=acharacter, pos=100)//''=='this is string example wow!!!... '
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function insert_character(self, substring, pos) result(inserted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | character(len=*) | in |  | Substring. |
| `pos` | integer | in |  | Position from which insert substring. |

### insert_string

Insert substring into string at a specified position.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(5)
 astring = 'this is string example wow!!!'
 anotherstring = '... '
 test_passed(1) = astring%insert(substring=anotherstring, pos=1)//''=='... this is string example wow!!!'
 test_passed(2) = astring%insert(substring=anotherstring, pos=23)//''=='this is string example...  wow!!!'
 test_passed(3) = astring%insert(substring=anotherstring, pos=29)//''=='this is string example wow!!!... '
 test_passed(4) = astring%insert(substring=anotherstring, pos=-1)//''=='... this is string example wow!!!'
 test_passed(5) = astring%insert(substring=anotherstring, pos=100)//''=='this is string example wow!!!... '
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function insert_string(self, substring, pos) result(inserted)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | type([string](/api/stringifor_string_t#string)) | in |  | Substring. |
| `pos` | integer | in |  | Position from which insert substring. |

### join_strings

Return a string that is a join of an array of strings.

 The join-separator is set equals to self if self has a value or it is set to a null string ''. This value can be overridden
 passing a custom separator.

```fortran
 type(string) :: astring
 type(string) :: strings(3)
 logical      :: test_passed(5)
 strings(1) = 'one'
 strings(2) = 'two'
 strings(3) = 'three'
 test_passed(1) = (astring%join(array=strings)//''==strings(1)//strings(2)//strings(3))
 test_passed(2) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2)//'-'//strings(3))
 call strings(1)%free
 strings(2) = 'two'
 strings(3) = 'three'
 test_passed(3) = (astring%join(array=strings, sep='-')//''==strings(2)//'-'//strings(3))
 strings(1) = 'one'
 strings(2) = 'two'
 call strings(3)%free
 test_passed(4) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(2))
 strings(1) = 'one'
 call strings(2)%free
 strings(3) = 'three'
 test_passed(5) = (astring%join(array=strings, sep='-')//''==strings(1)//'-'//strings(3))
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function join_strings(self, array, sep) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `array` | type([string](/api/stringifor_string_t#string)) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### join_characters

Return a string that is a join of an array of characters.

 The join-separator is set equals to self if self has a value or it is set to a null string ''. This value can be overridden
 passing a custom separator.

```fortran
 type(string) :: astring
 character(5) :: characters(3)
 logical      :: test_passed(6)
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(1) = (astring%join(array=characters)//''==characters(1)//characters(2)//characters(3))
 test_passed(2) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2)//'-'//characters(3))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(3) = (astring%join(array=characters, sep='-')//''==characters(2)//'-'//characters(3))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(4) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(2))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(5) = (astring%join(array=characters, sep='-')//''==characters(1)//'-'//characters(3))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = 'three'
 astring = '_'
 test_passed(6) = (astring%join(array=characters)//''==characters(1)//'_'//characters(2)//'_'//characters(3))
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function join_characters(self, array, sep) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `array` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### strjoin_strings

Return a string that is a join of an array of strings.

 The join-separator is set equals to a null string '' if custom separator isn't specified.

```fortran
 type(string)     :: strings(3)
 logical          :: test_passed(5)
 strings(1) = 'one'
 strings(2) = 'two'
 strings(3) = 'three'
 test_passed(1) = (strjoin(array=strings)//''==strings(1)//strings(2)//strings(3))
 test_passed(2) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(2)//'-'//strings(3))
 call strings(1)%free
 strings(2) = 'two'
 strings(3) = 'three'
 test_passed(3) = (strjoin(array=strings, sep='-')//''==strings(2)//'-'//strings(3))
 strings(1) = 'one'
 strings(2) = 'two'
 call strings(3)%free
 test_passed(4) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(2))
 strings(1) = 'one'
 call strings(2)%free
 strings(3) = 'three'
 test_passed(5) = (strjoin(array=strings, sep='-')//''==strings(1)//'-'//strings(3))
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strjoin_strings(array, sep) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `array` | class([string](/api/stringifor_string_t#string)) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### strjoin_characters

Return a string that is a join of an array of characters.

 The join-separator is set equals to a null string '' if custom separator isn't specified.
 The trim function is applied to array items if optional logical is_trim variable isn't set to .false.

```fortran
 character(5) :: characters(3)
 logical      :: test_passed(13)
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(1) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2))//trim(characters(3)))
 test_passed(2) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2))//'-'//trim(characters(3)))
 test_passed(3) = ( strjoin(array=characters, is_trim=.false.)//''==characters(1)//characters(2)//characters(3))
 test_passed(4) = ( strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2)//'-'//characters(3))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(5) = (strjoin(array=characters)//''==trim(characters(2))//trim(characters(3)))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(6) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(2)))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(7) = (strjoin(array=characters)//''==trim(characters(1))//trim(characters(3)))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(8) = (strjoin(array=characters, sep='-')//''==trim(characters(2))//'-'//trim(characters(3)))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(9) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(2)))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(10) = (strjoin(array=characters, sep='-')//''==trim(characters(1))//'-'//trim(characters(3)))
 characters(1) = ''
 characters(2) = 'two'
 characters(3) = 'three'
 test_passed(11) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(2)//'-'//characters(3))
 characters(1) = 'one'
 characters(2) = 'two'
 characters(3) = ''
 test_passed(12) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(2))
 characters(1) = 'one'
 characters(2) = ''
 characters(3) = 'three'
 test_passed(13) = (strjoin(array=characters, sep='-', is_trim=.false.)//''==characters(1)//'-'//characters(3))
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strjoin_characters(array, sep, is_trim) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `array` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |
| `is_trim` | logical | in | optional | Flag to setup trim character or not |

### strjoin_strings_array

Return a string that is a join of columns or rows of an array of strings.

 The join-separator is set equals to a null string '' if custom separator isn't specified.
 The is_col is setup the direction of join: within default columns (.true.) or rows(.false.).

```fortran
 type(string), allocatable :: strings_arr(:, :)
 logical                   :: test_passed(5)

 strings_arr = reshape( source = &
                        [string('one'), string('two'), string('three'),  &
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
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strjoin_strings_array(array, sep, is_col) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `array` | class([string](/api/stringifor_string_t#string)) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |
| `is_col` | logical | in | optional | Direction: 'columns' if .true. or 'rows' if .false. |

### strjoin_characters_array

Return a string that is a join of columns or rows of an array of characters.

 The join-separator is set equals to a null string '' if custom separator isn't specified.
 The trim function is applied to array items if optional logical is_trim variable isn't set to .false.
 The is_col is setup the direction of join: within default columns (.true.) or rows(.false.).

```fortran
 character(len=10)         :: chars_arr(3, 2)
 logical                   :: test_passed(9)
 chars_arr(:, 1) = ['one       ', 'two       ', 'three     ']
 chars_arr(:, 2) = ['ONE       ', 'TWO       ', 'THREE     ']

 test_passed(1) = all( strjoin(array=chars_arr) == &
                       reshape([string('onetwothree'), string('ONETWOTHREE')], &
                       shape = [2]) )

 test_passed(2) = all( strjoin(array=chars_arr, is_trim=.false.) ==  &
                       reshape([string('one       two       three     '),  &
                                string('ONE       TWO       THREE     ')], &
                       shape = [2]) )

 test_passed(3) = all( strjoin(array=chars_arr, sep='_') == &
                       reshape([string('one_two_three'), string('ONE_TWO_THREE')], &
                       shape = [2]) )

 test_passed(4) = all( strjoin(array=chars_arr, sep='_', is_trim=.false.) ==  &
                       reshape([string('one       _two       _three     '),  &
                                string('ONE       _TWO       _THREE     ')], &
                       shape = [2]) )

 test_passed(5) = all( strjoin(array=chars_arr, is_col=.false.) == &
                       reshape([string('oneONE'), string('twoTWO'), string('threeTHREE')], &
                       shape = [3]) )

 test_passed(6) = all( strjoin(array=chars_arr, is_trim=.false., is_col=.false.) ==  &
                       reshape([string('one       ONE       '),  &
                                string('two       TWO       '),  &
                                string('three     THREE     ')], &
                       shape = [3]) )

 test_passed(7) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) == &
                       reshape([string('one_ONE'), string('two_TWO'), string('three_THREE')], &
                       shape = [3]) )

 test_passed(8) = all( strjoin(array=chars_arr, sep='_', is_trim=.false., is_col=.false.) ==  &
                       reshape([string('one       _ONE       '),  &
                                string('two       _TWO       '),  &
                                string('three     _THREE     ')], &
                       shape = [3]) )

 chars_arr(2,1) = ''
 test_passed(9) = all( strjoin(array=chars_arr, sep='_', is_col=.false.) ==  &
                       reshape([string('one_ONE'),  &
                                string('TWO'),  &
                                string('three_THREE')], &
                       shape = [3]) )

 print '(L1)', all(test_passed)
```

 all items of character array have equal lengths

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strjoin_characters_array(array, sep, is_trim, is_col) result(join)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `array` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Array to be joined. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |
| `is_trim` | logical | in | optional | Flag to setup trim character or not |
| `is_col` | logical | in | optional | Direction: 'columns' if .true. or 'rows' if .false. |

### lower

Return a string with all lowercase characters.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 'Hello WorLD!'
 test_passed(1) = astring%lower()//''=='hello world!'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function lower(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### partition

Split string at separator and return the 3 parts (before, the separator and after).

```fortran
 type(string) :: astring
 type(string) :: strings(3)
 logical      :: test_passed(3)
 astring = 'Hello WorLD!'
 strings = astring%partition(sep='lo Wo')
 test_passed(1) = (strings(1)//''=='Hel'.and.strings(2)//''=='lo Wo'.and.strings(3)//''=='rLD!')
 strings = astring%partition(sep='Hello')
 test_passed(2) = (strings(1)//''==''.and.strings(2)//''=='Hello'.and.strings(3)//''==' WorLD!')
 astring = 'Hello WorLD!'
 strings = astring%partition()
 test_passed(3) = (strings(1)//''=='Hello'.and.strings(2)//''==' '.and.strings(3)//''=='WorLD!')
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function partition(self, sep) result(partitions)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### replace

Return a string with all occurrences of substring old replaced by new.

```fortran
 type(string) :: astring
 logical      :: test_passed(4)
 astring = 'When YOU are sad YOU should think to me :-)'
 test_passed(1) = (astring%replace(old='YOU', new='THEY')//''=='When THEY are sad THEY should think to me :-)')
 test_passed(2) = (astring%replace(old='YOU', new='THEY', count=1)//''=='When THEY are sad YOU should think to me :-)')
 astring = repeat(new_line('a')//'abcd', 20)
 astring = astring%replace(old=new_line('a'), new='|cr|')
 astring = astring%replace(old='|cr|', new=new_line('a')//'    ')
 test_passed(3) = (astring//''==repeat(new_line('a')//'    '//'abcd', 20))
 astring = 'abcd  efg    hlmn'
 astring = astring%replace(old='', new='-')
 test_passed(4) = (astring//''=='abcd  efg    hlmn')
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function replace(self, old, new, count) result(replaced)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `old` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Old substring. |
| `new` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | New substring. |
| `count` | integer | in | optional | Number of old occurences to be replaced. |

### reverse

Return a reversed string.

```fortran
 type(string) :: astring
 logical      :: test_passed(2)
 astring = 'abcdefghilmnopqrstuvz'
 test_passed(1) = (astring%reverse()//''=='zvutsrqponmlihgfedcba')
 astring = '0123456789'
 test_passed(2) = (astring%reverse()//''=='9876543210')
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function reverse(self) result(reversed)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### search

Search for *tagged* record into string, return the first record found (if any) matching the tags.

 Optionally, returns the indexes of tag start/end, thus this is not an `elemental` function.

 @note The tagged record is searched into self if allocated otherwise into `in_string` if passed or, eventually, into
 `in_character` is passed. If tag is not found the return string is not allocated and the start/end indexes (if requested) are
 zero.

```fortran
 type(string)                  :: astring
 type(string)                  :: anotherstring
 character(len=:), allocatable :: acharacter
 integer                       :: istart
 integer                       :: iend
 logical                       :: test_passed(5)
 astring = '<test> <first> hello </first> <first> not the first </first> </test>'
 anotherstring = astring%search(tag_start='<first>', tag_end='</first>')
 test_passed(1) = anotherstring//''=='<first> hello </first>'
 astring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
 anotherstring = astring%search(tag_start='<a>', tag_end='</a>')
 test_passed(2) = anotherstring//''=='<a> <a> <a> the nested a </a> </a> </a>'
 call astring%free
 anotherstring = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
 astring = astring%search(in_string=anotherstring, tag_start='<a>', tag_end='</a>')
 test_passed(3) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
 call astring%free
 acharacter = '<test> <a> <a> <a> the nested a </a> </a> </a> </test>'
 astring = astring%search(in_character=acharacter, tag_start='<a>', tag_end='</a>')
 test_passed(4) = astring//''=='<a> <a> <a> the nested a </a> </a> </a>'
 acharacter = '<test> <first> hello </first> <sec> <sec>not the first</sec> </sec> </test>'
 astring = astring%search(in_character=acharacter, tag_start='<sec>', tag_end='</sec>', istart=istart, iend=iend)
 test_passed(5) = astring//''==acharacter(31:67)
 print '(L1)', all(test_passed)
```

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function search(self, tag_start, tag_end, in_string, in_character, istart, iend) result(tag)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `tag_start` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Start tag. |
| `tag_end` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | End tag. |
| `in_string` | type([string](/api/stringifor_string_t#string)) | in | optional | Search into this string. |
| `in_character` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Search into this character string. |
| `istart` | integer | out | optional | Starting index of tag inside the string. |
| `iend` | integer | out | optional | Ending index of tag inside the string. |

### slice

Return the raw characters data sliced.

```fortran
 type(string) :: astring
 astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
 print "(A)", astring%slice(11,25)
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function slice(self, istart, iend) result(raw)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `istart` | integer | in |  | Slice start index. |
| `iend` | integer | in |  | Slice end   index. |

### snakecase

Return a string with all words lowercase separated by "_".

 @note Multiple subsequent separators are collapsed to one occurence.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
 test_passed(1) = astring%snakecase()//''=='the_quick_brown_fox_jumps_over_the_lazy_dog.'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function snakecase(self, sep)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### startcase

Return a string with all words capitalized, e.g. title case.

 @note Multiple subsequent separators are collapsed to one occurence.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 'the Quick Brown fox Jumps over the Lazy Dog.'
 test_passed(1) = astring%startcase()//''=='The Quick Brown Fox Jumps Over The Lazy Dog.'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function startcase(self, sep)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `sep` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Separator. |

### strip

Return a copy of the string with the leading and trailing characters removed.

 @note Multiple subsequent separators are collapsed to one occurence.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = '  Hello World!   '
 test_passed(1) = astring%strip()//''=='Hello World!'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function strip(self, remove_nulls)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `remove_nulls` | logical | in | optional | Remove null characters at the end. |

### swapcase

Return a copy of the string with uppercase characters converted to lowercase and vice versa.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = '  Hello World!   '
 test_passed(1) = astring%swapcase()//''=='  hELLO wORLD!   '
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function swapcase(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### tempname

Return a safe temporary name suitable for temporary file or directories.

```fortran
 type(string) :: astring
 character(len=:), allocatable :: tmpname
 logical                       :: test_passed(5)
 tmpname = astring%tempname()
 inquire(file=tmpname, exist=test_passed(1))
 test_passed(1) = .not.test_passed(1)
 tmpname = astring%tempname(is_file=.false.)
 inquire(file=tmpname, exist=test_passed(2))
 test_passed(2) = .not.test_passed(2)
 tmpname = astring%tempname(path='./')
 inquire(file=tmpname, exist=test_passed(3))
 test_passed(3) = .not.test_passed(3)
 astring = 'me-'
 tmpname = astring%tempname()
 inquire(file=tmpname, exist=test_passed(4))
 test_passed(4) = .not.test_passed(4)
 tmpname = astring%tempname(prefix='you-')
 inquire(file=tmpname, exist=test_passed(5))
 test_passed(5) = .not.test_passed(5)
 print '(L1)', all(test_passed)
```

**Returns**: `character(len=:)`

```fortran
function tempname(self, is_file, prefix, path)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `is_file` | logical | in | optional | True if tempname should be used for file (the default). |
| `prefix` | character(len=*) | in | optional | Name prefix, otherwise self is used (if allocated). |
| `path` | character(len=*) | in | optional | Path where file/directory should be used, default `./`. |

### to_integer_I1P

Cast string to integer (I1P).

```fortran
 use penf
 type(string) :: astring
 integer(I1P) :: integer_
 logical      :: test_passed(1)
 astring = '127'
 integer_ = astring%to_number(kind=1_I1P)
 test_passed(1) = integer_==127_I1P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer(kind=I1P)`

```fortran
function to_integer_I1P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | integer(kind=I1P) | in |  | Mold parameter for kind detection. |

### to_integer_I2P

Cast string to integer (I2P).

```fortran
 use penf
 type(string) :: astring
 integer(I2P) :: integer_
 logical      :: test_passed(1)
 astring = '127'
 integer_ = astring%to_number(kind=1_I2P)
 test_passed(1) = integer_==127_I2P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer(kind=I2P)`

```fortran
function to_integer_I2P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | integer(kind=I2P) | in |  | Mold parameter for kind detection. |

### to_integer_I4P

Cast string to integer (I4P).

```fortran
 use penf
 type(string) :: astring
 integer(I4P) :: integer_
 logical      :: test_passed(1)
 astring = '127'
 integer_ = astring%to_number(kind=1_I4P)
 test_passed(1) = integer_==127_I4P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer(kind=I4P)`

```fortran
function to_integer_I4P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | integer(kind=I4P) | in |  | Mold parameter for kind detection. |

### to_integer_I8P

Cast string to integer (I8P).

```fortran
 use penf
 type(string) :: astring
 integer(I8P) :: integer_
 logical      :: test_passed(1)
 astring = '127'
 integer_ = astring%to_number(kind=1_I8P)
 test_passed(1) = integer_==127_I8P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `integer(kind=I8P)`

```fortran
function to_integer_I8P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | integer(kind=I8P) | in |  | Mold parameter for kind detection. |

### to_real_R4P

Cast string to real (R4P).

```fortran
 use penf
 type(string) :: astring
 real(R4P)    :: real_
 logical      :: test_passed(1)
 astring = '3.4e9'
 real_ = astring%to_number(kind=1._R4P)
 test_passed(1) = real_==3.4e9_R4P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `real(kind=R4P)`

```fortran
function to_real_R4P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | real(kind=R4P) | in |  | Mold parameter for kind detection. |

### to_real_R8P

Cast string to real (R8P).

```fortran
 use penf
 type(string) :: astring
 real(R8P)    :: real_
 logical      :: test_passed(1)
 astring = '3.4e9'
 real_ = astring%to_number(kind=1._R8P)
 test_passed(1) = real_==3.4e9_R8P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `real(kind=R8P)`

```fortran
function to_real_R8P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | real(kind=R8P) | in |  | Mold parameter for kind detection. |

### to_real_R16P

Cast string to real (R16P).

```fortran
 use penf
 type(string) :: astring
 real(R16P)   :: real_
 logical      :: test_passed(1)
 astring = '3.4e9'
 real_ = astring%to_number(kind=1._R16P)
 test_passed(1) = real_==3.4e9_R16P
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `real(kind=R16P)`

```fortran
function to_real_R16P(self, kind) result(to_number)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `kind` | real(kind=R16P) | in |  | Mold parameter for kind detection. |

### unescape

Unescape double backslashes (or custom escaped character).

```fortran
 type(string) :: astring
 logical      :: test_passed(2)
 astring = '^\\s \\d+\\s*'
 test_passed(1) = (astring%unescape(to_unescape='\')//''=='^\s \d+\s*')
 test_passed(2) = (astring%unescape(to_unescape='s')//''=='^\s \\d+\s*')
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function unescape(self, to_unescape, unesc) result(unescaped)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `to_unescape` | character(kind=[CK](/api/stringifor_string_t), len=1) | in |  | Character to be unescaped. |
| `unesc` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Character used to unescape. |

### unique

Reduce to one (unique) multiple (sequential) occurrences of a substring into a string.

 For example the string ' ab-cre-cre-ab' is reduce to 'ab-cre-ab' if the substring is '-cre'.
 @note Eventual multiple trailing white space are not reduced to one occurrence.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = '+++ab-++cre-++cre-ab+++++'
 test_passed(1) = astring%unique(substring='+')//''=='+ab-+cre-+cre-ab+'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function unique(self, substring) result(uniq)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `substring` | character(kind=[CK](/api/stringifor_string_t), len=*) | in | optional | Substring which multiple occurences must be reduced to one. |

### upper

Return a string with all uppercase characters.

```fortran
 type(string) :: astring
 logical      :: test_passed(1)
 astring = 'Hello WorLD!'
 test_passed(1) = astring%upper()//''=='HELLO WORLD!'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function upper(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### end_with

Return true if a string ends with a specified suffix.

```fortran
 type(string) :: astring
 logical      :: test_passed(5)
 astring = 'Hello WorLD!'
 test_passed(1) = astring%end_with(suffix='LD!').eqv..true.
 test_passed(2) = astring%end_with(suffix='lD!').eqv..false.
 test_passed(3) = astring%end_with(suffix='orLD!', start=5).eqv..true.
 test_passed(4) = astring%end_with(suffix='orLD!', start=8, end=12).eqv..true.
 test_passed(5) = astring%end_with(suffix='!').eqv..true.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function end_with(self, suffix, start, end, ignore_null_eof)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `suffix` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Searched suffix. |
| `start` | integer | in | optional | Start position into the string. |
| `end` | integer | in | optional | End position into the string. |
| `ignore_null_eof` | logical | in | optional | Ignore null character at the end of file. |

### is_allocated

Return true if the string is allocated.

```fortran
 type(string) :: astring
 logical      :: test_passed(2)
 test_passed(1) = astring%is_allocated().eqv..false.
 astring = 'hello'
 test_passed(2) = astring%is_allocated().eqv..true.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_allocated(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### is_digit

Return true if all characters in the string are digits.

```fortran
 type(string) :: astring
 logical      :: test_passed(2)
 astring = '   -1212112.3 '
 test_passed(1) = astring%is_digit().eqv..false.
 astring = '12121123'
 test_passed(2) = astring%is_digit().eqv..true.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_digit(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### is_integer

Return true if the string contains an integer.

 The regular expression is `\s*[\+\-]?\d+([eE]\+?\d+)?\s*`. The parse algorithm is done in stages:

 | S0  | S1      | S2  | S3   | S4  | S5  | S6  |
 |-----|---------|-----|------|-----|-----|-----|
 |`\s*`|`[\+\-]?`|`\d+`|`[eE]`|`\+?`|`\d+`|`\s*`|

 Exit on stages-parsing results in:

 | S0 | S1 | S2 | S3 | S4 | S5 | S6 |
 |----|----|----|----|----|----|----|
 |  F |  F |  T |  F |  F |  T |  T |

 @note This implementation is courtesy of
 [tomedunn](https://github.com/tomedunn/fortran-string-utility-module/blob/master/src/string_utility_module.f90#L294)

```fortran
 type(string) :: astring
 logical      :: test_passed(6)
 astring = '   -1212112 '
 test_passed(1) = astring%is_integer().eqv..true.
 astring = '   -1212112'
 test_passed(2) = astring%is_integer(allow_spaces=.false.).eqv..false.
 astring = '-1212112   '
 test_passed(3) = astring%is_integer(allow_spaces=.false.).eqv..false.
 astring = '+2e20'
 test_passed(4) = astring%is_integer().eqv..true.
 astring = ' -2E13 '
 test_passed(5) = astring%is_integer().eqv..true.
 astring = ' -2 E13 '
 test_passed(6) = astring%is_integer().eqv..false.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_integer(self, allow_spaces)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `allow_spaces` | logical | in | optional | Allow leading-trailing spaces. |

### is_lower

Return true if all characters in the string are lowercase.

```fortran
 type(string) :: astring
 logical      :: test_passed(3)
 astring = ' Hello World'
 test_passed(1) = astring%is_lower().eqv..false.
 astring = ' HELLO WORLD'
 test_passed(2) = astring%is_lower().eqv..false.
 astring = ' hello world'
 test_passed(3) = astring%is_lower().eqv..true.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_lower(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### is_number

Return true if the string contains a number (real or integer).

```fortran
 type(string) :: astring
 logical      :: test_passed(7)
 astring = '   -1212112 '
 test_passed(1) = astring%is_number().eqv..true.
 astring = '   -121.2112 '
 test_passed(2) = astring%is_number().eqv..true.
 astring = '   -1212112'
 test_passed(3) = astring%is_number(allow_spaces=.false.).eqv..false.
 astring = '-12121.12   '
 test_passed(4) = astring%is_number(allow_spaces=.false.).eqv..false.
 astring = '+2e20'
 test_passed(5) = astring%is_number().eqv..true.
 astring = ' -2.4E13 '
 test_passed(6) = astring%is_number().eqv..true.
 astring = ' -2 E13 '
 test_passed(7) = astring%is_number().eqv..false.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_number(self, allow_spaces)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `allow_spaces` | logical | in | optional | Allow leading-trailing spaces. |

### is_real

Return true if the string contains a real.

 The regular expression is `\s*[\+\-]?\d*(|\.?\d*([deDE][\+\-]?\d+)?)\s*`. The parse algorithm is done in stages:

 | S0  | S1      | S2  | S3  | S4  | S5     | S6      | S7  | S8  |
 |-----|---------|-----|-----|-----|--------|---------|-----|-----|
 |`\s*`|`[\+\-]?`|`\d*`|`\.?`|`\d*`|`[deDE]`|`[\+\-]?`|`\d*`|`\s*`|

 Exit on stages-parsing results in:

 | S0 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 |
 |----|----|----|----|----|----|----|----|----|


 @note This implementation is courtesy of
 [tomedunn](https://github.com/tomedunn/fortran-string-utility-module/blob/master/src/string_utility_module.f90#L614)

```fortran
 type(string) :: astring
 logical      :: test_passed(6)
 astring = '   -1212112.d0 '
 test_passed(1) = astring%is_real().eqv..true.
 astring = '   -1212112.d0'
 test_passed(2) = astring%is_real(allow_spaces=.false.).eqv..false.
 astring = '-1212112.d0   '
 test_passed(3) = astring%is_real(allow_spaces=.false.).eqv..false.
 astring = '+2.e20'
 test_passed(4) = astring%is_real().eqv..true.
 astring = ' -2.01E13 '
 test_passed(5) = astring%is_real().eqv..true.
 astring = ' -2.01 E13 '
 test_passed(6) = astring%is_real().eqv..false.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_real(self, allow_spaces)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `allow_spaces` | logical | in | optional | Allow leading-trailing spaces. |

### is_upper

Return true if all characters in the string are uppercase.

```fortran
 type(string) :: astring
 logical      :: test_passed(3)
 astring = ' Hello World'
 test_passed(1) = astring%is_upper().eqv..false.
 astring = ' HELLO WORLD'
 test_passed(2) = astring%is_upper().eqv..true.
 astring = ' hello world'
 test_passed(3) = astring%is_upper().eqv..false.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function is_upper(self)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |

### start_with

Return true if a string starts with a specified prefix.

```fortran
 type(string) :: astring
 logical      :: test_passed(4)
 astring = 'Hello WorLD!'
 test_passed(1) = astring%start_with(prefix='Hello').eqv..true.
 test_passed(2) = astring%start_with(prefix='hell').eqv..false.
 test_passed(3) = astring%start_with(prefix='llo Wor', start=3).eqv..true.
 test_passed(4) = astring%start_with(prefix='lo W', start=4, end=7).eqv..true.
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function start_with(self, prefix, start, end)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `prefix` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Searched prefix. |
| `start` | integer | in | optional | Start position into the string. |
| `end` | integer | in | optional | End position into the string. |

### string_concat_string

Concatenation with string.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(1)
 astring = 'Hello '
 anotherstring = 'Bye bye'
 test_passed(1) = astring//anotherstring=='Hello Bye bye'
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function string_concat_string(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_concat_character

Concatenation with character.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(1)
 astring = 'Hello '
 acharacter = 'World!'
 test_passed(1) = astring//acharacter=='Hello World!'
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function string_concat_character(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_concat_string

Concatenation with character (inverted).

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(1)
 astring = 'Hello '
 acharacter = 'World!'
 test_passed(1) = acharacter//astring=='World!Hello '
 print '(L1)', all(test_passed)
```

**Attributes**: pure

**Returns**: character(kind=[CK](/api/stringifor_string_t), len=:)

```fortran
function character_concat_string(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_concat_string_string

Concatenation with string.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 type(string) :: yetanotherstring
 logical      :: test_passed(1)
 astring = 'Hello '
 anotherstring = 'Bye bye'
 yetanotherstring = astring.cat.anotherstring
 test_passed(1) = yetanotherstring%chars()=='Hello Bye bye'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function string_concat_string_string(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_concat_character_string

Concatenation with character.

```fortran
 type(string)                  :: astring
 type(string)                  :: yetanotherstring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(1)
 astring = 'Hello '
 acharacter = 'World!'
 yetanotherstring = astring.cat.acharacter
 test_passed(1) = yetanotherstring%chars()=='Hello World!'
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function string_concat_character_string(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_concat_string_string

Concatenation with character (inverted).

```fortran
 type(string)                  :: astring
 type(string)                  :: yetanotherstring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(1)
 astring = 'Hello '
 acharacter = 'World!'
 yetanotherstring = acharacter.cat.astring
 test_passed(1) = yetanotherstring%chars()=='World!Hello '
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function character_concat_string_string(lhs, rhs) result(concat)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_eq_string

Equal to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(2)
 astring = '  one '
 anotherstring = 'two'
 test_passed(1) = ((astring==anotherstring).eqv..false.)
 astring = 'the same '
 anotherstring = 'the same '
 test_passed(2) = ((astring==anotherstring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_eq_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_eq_character

Equal to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = '  one '
 acharacter = 'three'
 test_passed(1) = ((astring==acharacter).eqv..false.)
 astring = 'the same '
 acharacter = 'the same '
 test_passed(2) = ((astring==acharacter).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_eq_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_eq_string

Equal to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = '  one '
 acharacter = 'three'
 test_passed(1) = ((acharacter==astring).eqv..false.)
 astring = 'the same '
 acharacter = 'the same '
 test_passed(2) = ((acharacter==astring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_eq_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_ne_string

Not equal to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(2)
 astring = '  one '
 anotherstring = 'two'
 test_passed(1) = ((astring/=anotherstring).eqv..true.)
 astring = 'the same '
 anotherstring = 'the same '
 test_passed(2) = ((astring/=anotherstring).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_ne_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_ne_character

Not equal to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = '  one '
 acharacter = 'three'
 test_passed(1) = ((astring/=acharacter).eqv..true.)
 astring = 'the same '
 acharacter = 'the same '
 test_passed(2) = ((astring/=acharacter).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_ne_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_ne_string

Not equal to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = '  one '
 acharacter = 'three'
 test_passed(1) = ((acharacter/=astring).eqv..true.)
 astring = 'the same '
 acharacter = 'the same '
 test_passed(2) = ((acharacter/=astring).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_ne_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_lt_string

Lower than to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(2)
 astring = 'one'
 anotherstring = 'ONE'
 test_passed(1) = ((astring<anotherstring).eqv..false.)
 astring = 'ONE'
 anotherstring = 'one'
 test_passed(2) = ((astring<anotherstring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_lt_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_lt_character

Lower than to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((astring<acharacter).eqv..false.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((astring<acharacter).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_lt_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_lt_string

Lower than to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((acharacter<astring).eqv..true.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((acharacter<astring).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_lt_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_le_string

Lower equal than to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(3)
 astring = 'one'
 anotherstring = 'ONE'
 test_passed(1) = ((astring<=anotherstring).eqv..false.)
 astring = 'ONE'
 anotherstring = 'one'
 test_passed(2) = ((astring<=anotherstring).eqv..true.)
 astring = 'ONE'
 anotherstring = 'ONE'
 test_passed(3) = ((astring<=anotherstring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_le_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_le_character

Lower equal than to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(3)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((astring<=acharacter).eqv..false.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((astring<=acharacter).eqv..true.)
 astring = 'ONE'
 acharacter = 'ONE'
 test_passed(3) = ((astring<=acharacter).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_le_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_le_string

Lower equal than to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(3)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((acharacter<=astring).eqv..true.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((acharacter<=astring).eqv..false.)
 astring = 'ONE'
 acharacter = 'ONE'
 test_passed(3) = ((acharacter<=astring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_le_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_ge_string

Greater equal than to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(3)
 astring = 'one'
 anotherstring = 'ONE'
 test_passed(1) = ((astring>=anotherstring).eqv..true.)
 astring = 'ONE'
 anotherstring = 'one'
 test_passed(2) = ((astring>=anotherstring).eqv..false.)
 astring = 'ONE'
 anotherstring = 'ONE'
 test_passed(3) = ((astring>=anotherstring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_ge_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_ge_character

Greater equal than to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(3)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((astring>=acharacter).eqv..true.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((astring>=acharacter).eqv..false.)
 astring = 'ONE'
 acharacter = 'ONE'
 test_passed(3) = ((astring>=acharacter).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_ge_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_ge_string

Greater equal than to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(3)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((acharacter>=astring).eqv..false.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((acharacter>=astring).eqv..true.)
 astring = 'ONE'
 acharacter = 'ONE'
 test_passed(3) = ((acharacter>=astring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_ge_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_gt_string

Greater than to string logical operator.

```fortran
 type(string) :: astring
 type(string) :: anotherstring
 logical      :: test_passed(2)
 astring = 'one'
 anotherstring = 'ONE'
 test_passed(1) = ((astring>anotherstring).eqv..true.)
 astring = 'ONE'
 anotherstring = 'one'
 test_passed(2) = ((astring>anotherstring).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_gt_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | type([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### string_gt_character

Greater than to character logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((astring>acharacter).eqv..true.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((astring>acharacter).eqv..false.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function string_gt_character(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | class([string](/api/stringifor_string_t#string)) | in |  | Left hand side. |
| `rhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Right hand side. |

### character_gt_string

Greater than to character (inverted) logical operator.

```fortran
 type(string)                  :: astring
 character(len=:), allocatable :: acharacter
 logical                       :: test_passed(2)
 astring = 'one'
 acharacter = 'ONE'
 test_passed(1) = ((acharacter>astring).eqv..false.)
 astring = 'ONE'
 acharacter = 'one'
 test_passed(2) = ((acharacter>astring).eqv..true.)
 print '(L1)', all(test_passed)
```

**Attributes**: elemental

**Returns**: `logical`

```fortran
function character_gt_string(lhs, rhs) result(is_it)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `lhs` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Left hand side. |
| `rhs` | class([string](/api/stringifor_string_t#string)) | in |  | Right hand side. |

### replace_one_occurrence

Return a string with the first occurrence of substring old replaced by new.

 @note The doctest is not necessary, this being tested by [replace](/api/stringifor_string_t#replace).

**Attributes**: elemental

**Returns**: type([string](/api/stringifor_string_t#string))

```fortran
function replace_one_occurrence(self, old, new) result(replaced)
```

**Arguments**

| Name | Type | Intent | Attributes | Description |
|------|------|--------|------------|-------------|
| `self` | class([string](/api/stringifor_string_t#string)) | in |  | The string. |
| `old` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | Old substring. |
| `new` | character(kind=[CK](/api/stringifor_string_t), len=*) | in |  | New substring. |
