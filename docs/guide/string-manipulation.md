# String Manipulation

All methods are type-bound procedures on the `string` type. Unless stated otherwise they return a new `string` (or standard `character` via `//''`) and do not modify the receiver.

```fortran
use stringifor
type(string) :: s
```

## Case Conversion

```fortran
s = 'Hello World'

print "(A)", s%upper()//''      ! HELLO WORLD
print "(A)", s%lower()//''      ! hello world
print "(A)", s%swapcase()//''   ! hELLO wORLD
print "(A)", s%capitalize()//'' ! Hello world  (first char up, rest down)
```

### Word-level case styles

```fortran
s = ' a StraNgE caSe var'

print "(A)", s%camelcase()//''  !  AStrangeCaseVar
print "(A)", s%snakecase()//''  !  a_strange_case_var
print "(A)", s%startcase()//''  !  A Strange Case Var
```

## Searching and Testing

```fortran
s = 'Hello World'

print "(L1)", s%start_with('Hello')   ! T
print "(L1)", s%end_with('World')     ! T
print "(L1)", s%is_lower()            ! F
print "(L1)", s%is_upper()            ! F
print "(L1)", s%is_digit()            ! F

! count occurrences of a substring
print "(I0)", s%count('l')            ! 3
```

## Replacing and Modifying

```fortran
s = 'Hello World'
print "(A)", s%replace(old='World', new='People')//''  ! Hello People
```

### Reverse

```fortran
s = '0123456789'
print "(A)", s%reverse()//''   ! 9876543210
```

### Reverse words

```fortran
s = '  the sky   is blue '
print "(A)", s%reverse_words()//''   ! blue is sky the
```

### Unique — collapse repeated substrings

```fortran
s = 'aabbcc  hello   world'
print "(A)", s%unique(substring=' ')//''  ! aabbcc hello world
```

### Fill / pad

```fortran
s = '42'
print "(A)", s%fill(width=6)//''             ! 000042  (left-pad with zeros)
print "(A)", s%fill(width=6, right=.true.)//'' ! 420000
print "(A)", s%fill(width=6, fill_char='*')//'' ! ****42
```

### Insert

```fortran
s = 'Helo'
print "(A)", s%insert(substring='l', pos=3)//''  ! Hello
```

### Strip (trim leading/trailing characters)

```fortran
s = '   hello   '
print "(A)", s%strip()//''                   ! hello
print "(A)", s%strip(remove=' h')//''        ! ello
```

### Escape / Unescape

```fortran
s = 'path\to\file'
print "(A)", s%escape()//''    ! path\\to\\file
print "(A)", s%unescape()//''  ! path\to\file
```

### Encode / Decode (Base64)

```fortran
s = 'Hello World'
print "(A)", s%encode()//''   ! SGVsbG8gV29ybGQ=
print "(A)", s%decode()//''   ! (decodes a Base64 string)
```

### Justify — pack words into fully justified lines

```fortran
type(string), allocatable :: lines(:)

s = 'This is an example of text justification.'
lines = s%justify(width=16)
! lines(1) = 'This    is    an'
! lines(2) = 'example  of text'
! lines(3) = 'justification.  '
```

The last line and single-word lines are left-justified and padded with trailing blanks. A word longer than `width` is not
broken: it stays alone on a line longer than `width`.

### Length of the last word

```fortran
s = '   fly me   to   the moon  '
print "(I0)", s%len_last_word()   ! 4
```

## Comparing

### Longest common prefix

```fortran
type(string) :: files(3)

files(1) = 'src/lib/stringifor.F90'
files(2) = 'src/lib/stringifor_string_t.F90'
files(3) = 'src/tests/stringifor/stringifor-doctest-1.f90'
s = files(1)%common_prefix(files(2))        ! src/lib/stringifor
s = files(1)%common_prefix(array=files)     ! src/
```

### Version numbers

`compare_version` returns `-1`, `0` or `1`. Fields made only of digits are compared as integers of any size, the others
lexically; missing fields count as zero.

```fortran
s = '1.2.0'
print "(I0)", s%compare_version('1.10')    ! -1
print "(I0)", s%compare_version('1.2')     ! 0
print "(I0)", s%compare_version('1.1.9')   ! 1
```

::: warning
The comparison is not semantic-versioning aware: `1.0.0-rc1` compares greater than `1.0.0`.
:::

## Splitting and Joining

### Split

```fortran
type(string), allocatable :: tokens(:)

s = 'one two three'
call s%split(tokens=tokens, sep=' ')
! tokens(1)='one', tokens(2)='two', tokens(3)='three'
```

### Partition — split at the first occurrence of a separator

```fortran
type(string) :: parts(3)

s = 'Hello World'
parts = s%partition(sep='lo Wo')
! parts(1) = 'Hel'   (before sep)
! parts(2) = 'lo Wo' (the sep itself)
! parts(3) = 'rld'   (after sep)
```

### Join

```fortran
type(string) :: words(3)

words(1) = 'one'
words(2) = 'two'
words(3) = 'three'

! join using the receiver as separator
s = '-'
print "(A)", s%join(words)//''          ! one-two-three

! join with an explicit sep argument
print "(A)", s%join(words, sep=', ')//'' ! one, two, three
```

## Slicing

```fortran
s = 'Hello World'
print "(A)", s%slice(first=1, last=5)//''  ! Hello
print "(A)", s%slice(first=7)//''          ! World
```

## Searching Tagged Records

Useful for extracting content between markup-style delimiters:

```fortran
s = '<test> <first> hello </first> <first> not first </first> </test>'
print "(A)", s%search(tag_start='<first>', tag_end='</first>')//''
! <first> hello </first>
```

## Temporary Names

```fortran
type(string) :: tmp

tmp = s%tempname(prefix='my_prefix_')
! returns a unique safe name for a temporary file or directory
```

## Operators

| Operator | Result type | Description |
|----------|-------------|-------------|
| `//` | `character` | Concatenation; enables seamless use with Fortran intrinsics |
| `.cat.` | `string` | Concatenation returning a `string` |
| `==`, `/=` | `logical` | Equality / inequality |
| `<`, `<=`, `>=`, `>` | `logical` | Lexicographic comparison |
| `assignment(=)` | — | Assign from `character`, `string`, or any PENF numeric kind |

## Fortran Built-in Replacements

These generic interfaces accept `string` arguments in place of standard `character`:

`adjustl`, `adjustr`, `count`, `index`, `len_trim`, `repeat`, `scan`, `trim`, `verify`

```fortran
type(string) :: s
s = '  hello  '
print "(A)", trim(s)//''         ! hello
print "(I0)", len_trim(s)        ! 5
print "(I0)", index(s, 'ell')    ! 3
```
