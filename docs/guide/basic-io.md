# Basic I/O

The `string` type integrates with Fortran's I/O system through defined write/read type-bound procedures and operator overloading.

## Importing

```fortran
use stringifor
```

This brings in the `string` type and all overloaded operators and built-in replacements.

## Assigning and Printing

The simplest way to create a `string` is by assigning a character literal:

```fortran
type(string) :: s

s = 'Hello World'
```

There are three equivalent ways to print it:

```fortran
! 1. chars() returns a standard character variable
print "(A)", s%chars()

! 2. Defined I/O (requires GFortran >= 7.1 for DT descriptor)
print "(DT)", s

! 3. Concatenation with '' triggers automatic conversion to character
print "(A)", s//''
```

::: tip
The `//''` idiom is the most portable and concise way to pass a `string` wherever a `character` is expected. The concatenation operator `//` is overloaded to return a standard `character`, enabling seamless integration with any Fortran procedure expecting a `character` argument.
:::

## Reading from Standard Input

```fortran
type(string) :: s

read *, s
```

## Reading from a File

### Line by line

```fortran
type(string) :: line
integer      :: unit, iostat

open(newunit=unit, file='data.txt', status='OLD')
do
  call line%read_line(unit=unit, iostat=iostat)
  if (iostat /= 0) exit
  ! process line...
end do
close(unit)
```

### All lines at once

```fortran
type(string), allocatable :: lines(:)

call read_file(file='data.txt', lines=lines)
! lines(1), lines(2), ... contain each line
```

### Entire file as a single stream

```fortran
type(string) :: content

call content%read_file(file='data.txt')
```

## Writing to a File

```fortran
type(string) :: lines(3)

lines(1) = 'First line'
lines(2) = 'Second line'
lines(3) = 'Third line'

call write_file(file='output.txt', lines=lines)
```

## Unformatted (Binary) I/O

Both `read_file` / `write_file` accept an optional `form='unformatted'` argument. Only `access='stream'` with `new_line` as line terminator is supported:

```fortran
type(string), allocatable :: lines(:)

call read_file(file='data.bin', lines=lines, form='unformatted')
call write_file(file='data.bin', lines=lines, form='unformatted')
```

## Checking Allocation

```fortran
type(string) :: s

if (s%is_allocated()) then
  print "(A)", s%chars()
end if
```

## Freeing Memory

```fortran
call s%free()
```
