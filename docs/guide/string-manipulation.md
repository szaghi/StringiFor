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
