# Advanced Usage

## OS-Style Path Manipulation

The `string` type has methods for common file-path operations:

```fortran
use stringifor
type(string) :: s

s = '/bar/foo.tar.bz2'

print "(A)", s%basedir()//''                          ! /bar
print "(A)", s%basename()//''                         ! foo.tar.bz2
print "(A)", s%extension()//''                        ! .bz2
print "(A)", s%basename(extension='.tar')//''         ! foo
print "(A)", s%basename(strip_last_extension=.true.)//'' ! foo.tar
```

| Method | Description |
|--------|-------------|
| `basedir()` | Directory part of a path |
| `basename()` | File name part of a path |
| `extension()` | File extension (including the dot) |
| `basename(extension='.ext')` | Base name stripped of the given extension |
| `basename(strip_last_extension=.true.)` | Base name with the last extension removed |

## XML-Style Tag Search

`search` finds the first occurrence of content delimited by start/end tags:

```fortran
use stringifor
type(string) :: s

s = '<test> <first> hello </first> <first> not the first </first> </test>'

print "(A)", s%search(tag_start='<first>', tag_end='</first>')//''
! <first> hello </first>
```

Only the **first** matching region is returned. This is useful for simple markup extraction without a full XML parser.

## Glob Pattern Matching

```fortran
use stringifor
type(string)              :: pattern
type(string), allocatable :: matches(:)

pattern = '*.f90'
call pattern%glob(matches)

! or use the module-level procedure
call glob(pattern='src/**/*.F90', list=matches)
```

## Naive CSV Parser

A practical demonstration of combining `read_file`, `split`, `count`, and `to_number`:

```fortran
use stringifor
implicit none

type(string)              :: csv
type(string), allocatable :: rows(:)
type(string), allocatable :: columns(:)
type(string), allocatable :: cells(:,:)
type(string)              :: most_expensive
real(R8P)                 :: highest_cost
integer                   :: rows_number, columns_number, r

! Read the entire file into a single string stream, then split into rows
call csv%read_file(file='cars.csv')
call csv%split(tokens=rows, sep=new_line('a'))

rows_number    = size(rows, dim=1)
columns_number = rows(1)%count(',') + 1

allocate(cells(1:columns_number, 1:rows_number))
do r = 1, rows_number
  call rows(r)%split(tokens=columns, sep=',')
  cells(1:columns_number, r) = columns
end do

! Print as a Markdown table
print "(A)", '| ' // csv%join(array=cells(:, 1), sep=' | ') // ' |'
print "(A)", '|' // repeat('----|', columns_number)
do r = 2, rows_number
  print "(A)", '| ' // csv%join(array=cells(:, r), sep=' | ') // ' |'
end do

! Find the most expensive car (column 5 = Price)
most_expensive = 'unknown'
highest_cost   = -1._R8P
do r = 2, rows_number
  if (cells(5, r)%to_number(kind=1._R8P) >= highest_cost) then
    highest_cost   = cells(5, r)%to_number(kind=1._R8P)
    most_expensive = csv%join(array=[cells(2, r), cells(3, r)], sep=' ')
  end if
end do
print "(A)", 'Most expensive: ' // most_expensive
```

The `csv.csv` file used above looks like:

```
Year, Make, Model, Description, Price
1997, Ford, E350, ac abs moon, 3000.00
1999, Chevy, Venture "Extended Edition", , 4900.00
1999, Chevy, Venture "Extended Edition Very Large", , 5000.00
```

::: warning
This is an intentionally naive parser — it does not handle quoted fields containing the delimiter, or escaped quotes. It demonstrates the API rather than production-quality CSV parsing.
:::

## Colorized Terminal Output

Using the built-in FACE integration:

```fortran
use stringifor
type(string) :: s

s = 'Warning!'
print "(A)", s%colorize(color='yellow', style='bold')//''
```

## Joining 2D Arrays (strjoin)

`strjoin` extends `join` to work on 2D arrays, collapsing either rows or columns:

```fortran
use stringifor
type(string) :: grid(3,2)
type(string) :: row_joined(2)

grid(1,1) = 'a' ; grid(2,1) = 'b' ; grid(3,1) = 'c'
grid(1,2) = 'd' ; grid(2,2) = 'e' ; grid(3,2) = 'f'

row_joined = strjoin(grid, sep=',')
! row_joined(1) = 'a,b,c'
! row_joined(2) = 'd,e,f'
```
