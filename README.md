<a name="top"></a>

# StringiFor [![GitHub tag](https://img.shields.io/github/tag/szaghi/StringiFor.svg)]()

[![License](https://img.shields.io/badge/license-GNU%20GeneraL%20Public%20License%20v3%20,%20GPLv3-blue.svg)]()
[![License](https://img.shields.io/badge/license-BSD2-red.svg)]()
[![License](https://img.shields.io/badge/license-BSD3-red.svg)]()
[![License](https://img.shields.io/badge/license-MIT-red.svg)]()

[![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)]()
[![Build Status](https://travis-ci.org/szaghi/StringiFor.svg?branch=master)](https://travis-ci.org/szaghi/StringiFor)
[![Coverage Status](https://img.shields.io/codecov/c/github/szaghi/StringiFor.svg)](http://codecov.io/github/szaghi/StringiFor?branch=master)

### StringiFor, Strings Fortran Manipulator, yet another strings Fortran module
A KISS pure Fortran library providing  astrings (class) manipulator for modern (2003+) Fortran projects.

+ StringiFor is a pure Fortran (KISS) library providing a strings manipulator for modern Fortran projects;
+ StringiFor is Fortran 2003+ standard compliant;
- StringiFor is OOP designed;
- StringiFor is TDD designed;
+ StringiFor is a Free, Open Source Project.

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/StringiFor.svg)]()
[![Ready in backlog](https://badge.waffle.io/szaghi/StringiFor.png?label=ready&title=Ready)](https://waffle.io/szaghi/StringiFor)
[![In Progress](https://badge.waffle.io/szaghi/StringiFor.png?label=in%20progress&title=In%20Progress)](https://waffle.io/szaghi/StringiFor)
[![Open bugs](https://badge.waffle.io/szaghi/StringiFor.png?label=bug&title=Open%20Bugs)](https://waffle.io/szaghi/StringiFor)

#### Compiler Support

[![Compiler](https://img.shields.io/badge/GNU-v5.3.0+-orange.svg)]()
[![Compiler](https://img.shields.io/badge/Intel-v16.x+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/IBM%20XL-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/g95-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/NAG-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/PGI-not%20tested-yellow.svg)]()

##### GNU partial support
> GNU gfortran does not support user-defined-type-IO, thus some class features are disabled if GNU is used.

---

[What is StringiFor?](#what-is-penf?) | [Main features](#main-features) | [Copyrights](#copyrights) | [Download](#download) | [Compilation](#compilation) | [Documentation](#documentation) | [Comparison to other Approaches](#comparison-to-other-approaches)

---

## What is StringiFor?

Modern Fortran standards (2003+) have introduced a better support for characters variables, but Fortraners still do not have the power on dealing with strings of other more-rich-programmers, e.g. Pythoners. Allocatable deferred length character variables are now quantum-leap with respect the old inflexible Fortran characters, but it is still not enough for many Fortraners. Moreover, Fortran does not provide builtin methods for widely used strings manipulations offered by other languages, e.g. UPPER/lowercase transformation, tokenization, etc... StringiFor attempts to fill this lack.

Go to [Top](#top)

## Main features

StringiFor exposes only one class (OO-designed), the `string` type, that should be used as a more powerful string variable with respect a standard Fortran `character` variable. The main features of this class are:

* [x] seamless interchangeability with standard character variables, e.g. concatenation, IO, etc...;
* [x] handy builtin methods, e.g. split, search, basename, join, etc...;
* [x] low memory consumption: only one deferred length allocatable character member is stored, allowing for efficient memory allocation in array of strings, the elements of which can have different lengths;
+ [x] safe: almost all methods are elemental or pure;
+ [x] robust: the library is Test Driven Developed [TDD](https://en.wikipedia.org/wiki/Test-driven_development), a comprehensive tests suite is provided.

Any feature request is welcome.

Go to [Top](#top)

## Copyrights

StringiFor is an open source project, it is distributed under a multi-licensing system:

+ for FOSS projects:
  - [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html);
+ for closed source/commercial projects:
  - [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause);
  - [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause);
  - [MIT](http://opensource.org/licenses/MIT).

Anyone is interest to use, to develop or to contribute to StringiFor is welcome, feel free to select the license that best matches your soul!

More details can be found on [wiki](https://github.com/szaghi/StringiFor/wiki/Copyrights).

Go to [Top](#top)

## Download

StringiFor home is at [https://github.com/szaghi/StringiFor](https://github.com/szaghi/StringiFor). It uses `git submodule` to handle the third party dependency. To download all the source files you can:

+ clone recursively this repository: `git clone --recursive https://github.com/szaghi/StringiFor`
+ download the latest master-branch archive at [https://github.com/szaghi/StringiFor/archive/master.zip](https://github.com/szaghi/StringiFor/archive/master.zip)
+ download a release archive at [https://github.com/szaghi/StringiFor/releases](https://github.com/szaghi/StringiFor/releases)

Go to [Top](#top)

## Compilation

StringiFor is a modern Fortran project thus a modern Fortran compiler is need to compile the project. In the following table the support for some widely-used Fortran compilers is summarized.

| Compiler Vendor Support                                                  | Notes                       |
|--------------------------------------------------------------------------|-----------------------------|
|[![Compiler](https://img.shields.io/badge/GNU-v5.3.0+-orange.svg)]()      | does not support defined IO |
|[![Compiler](https://img.shields.io/badge/Intel-v16.x+-brightgreen.svg)]()| full support                |
|[![Compiler](https://img.shields.io/badge/IBM%20XL-vx.y-yellow.svg)]()    | not tested                  |
|[![Compiler](https://img.shields.io/badge/g95-vx.y-yellow.svg)]()         | not tested                  |
|[![Compiler](https://img.shields.io/badge/NAG-vx.y-yellow.svg)]()         | not tested                  |
|[![Compiler](https://img.shields.io/badge/PGI-vx.y-yellow.svg)]()         | not tested                  |

The library is modular, namely it exploits Fortran modules. As a consequence, there is compilation-cascade hierarchy to build the library. To correctly build the library the following approaches are supported

+ [Build by means of FoBiS](#build-by-means-of-fobis): full support;
+ [Build by means of GNU Make](#build-by-means-of-fobis): support only Intel Fortran;
+ [Build by means of CMake](#build-by-means-of-fobis): to be implemented.

The FoBiS building support is the most complete, as it is the one used for the developing StringiFor.

### Build by means of FoBiS

A `fobos` file is provided to build the library by means of the Fortran Building System [FoBiS](https://github.com/szaghi/FoBiS).

#### Build all tests

Type

```shell
FoBiS.py build
```

After (a successuful) building a directory `./exe` is created containing all the compiled tests that constitute the StringiFor *regression-tests-suite*, e.g.

```bash
→ FoBiS.py build
Builder options
Directories
  Building directory: "exe"
  Compiled-objects .o   directory: "exe/obj"
  Compiled-objects .mod directory: "exe/mod"
Compiler options
  Vendor: "gnu"
  Compiler command: "gfortran"
  Module directory switch: "-J"
  Compiling flags: "-c -frealloc-lhs -std=f2008 -fall-intrinsics -O2 -Dr16p"
  Linking flags: "-O2"
  Preprocessing flags: "-Dr16p"
  Coverage: False
  Profile: False
PreForM.py used: False
PreForM.py output directory: None
PreForM.py extensions processed: []

Building src/tests/is_real.f90
Compiling src/lib/penf.F90 serially
Compiling src/lib/string_t.F90 serially
Compiling src/lib/stringifor.F90 serially
Compiling src/tests/is_real.f90 serially
Linking exe/is_real
Target src/tests/is_real.f90 has been successfully built
Builder options
  Directories
    Building directory: "exe"
    Compiled-objects .o   directory: "exe/obj"
    Compiled-objects .mod directory: "exe/mod"
  Compiler options
    Vendor: "gnu"
    Compiler command: "gfortran"
    Module directory switch: "-J"
    Compiling flags: "-c -frealloc-lhs -std=f2008 -fall-intrinsics -O2 -Dr16p"
    Linking flags: "-O2"
    Preprocessing flags: "-Dr16p"
    Coverage: False
    Profile: False
  PreForM.py used: False
  PreForM.py output directory: None
  PreForM.py extensions processed: []

Building src/tests/slen.f90
Compiling src/tests/slen.f90 serially
...

→ tree -L 1 exe/
exe/
├── assignments
├── basename_dir
├── camelcase
├── capitalize
├── concatenation
├── equal
├── escape
├── extension
├── fill
...
├── swapcase
├── to_number
├── unique
└── upper_lower
```

#### Build the library

Type

```bash
# static-linked library by means of GNU gfortran
FoBiS.py build -mode stringifor-static-gnu

# shared-linked library by means of GNU gfortran
FoBiS.py build -mode stringifor-shared-gnu

# static-linked library by means of Intel Fortran
FoBiS.py build -mode stringifor-static-intel

# shared-linked library by means of Intel Fortran
FoBiS.py build -mode stringifor-shared-intel
```

The library will be built into the directory `./lib`.

### List other fobos modes

To list all *fobos-provided* modes type

```bash
→ FoBiS.py build -lmodes
The fobos file defines the following modes:
  - "tests-gnu"
  - "tests-gnu-debug"
  - "tests-intel"
  - "tests-intel-debug"
  - "stringifor-static-gnu"
  - "stringifor-shared-gnu"
  - "stringifor-static-intel"
  - "stringifor-shared-intel"
```

It is worth to note that the first mode is the one automatically called by `FoBiS.py build`.

### Build by means of GNU Make

The provided makefile support only Intel Fortran Compiler and it has two main building rules:

+ build the (static linked) library;
+ build the tests suite.

To build the library type

```bash
make
```

The library will be built into the directory `./lib`.

To build the tests suite type

```bash
make TESTS=yes
```

The tests will be built into the directory `./exe`.

### Build by means of CMake

To be done.

Go to [Top](#top)

---

## Documentation

The StringiFor documentation is mainly contained into this file (it has its own [wiki](https://github.com/szaghi/StringiFor/wiki) with some less important documents). Detailed documentation of the API is contained into the [GitHub Pages](http://szaghi.github.io/StringiFor/index.html) that can also be created locally by means of [ford tool](https://github.com/cmacmackin/ford).

+ [A Taste of StringiFor](#a_taste_of_stringifor)
  + [Basic IO](#basic_io)
  + [String manipulation](#string_manipulation)
  + [Numbers handling](#numbers_handling)
  + [Complex scenario](#complex_scenario)
+ [Methods API](#methods-api)

---

### A Taste of StringiFor

StringiFor is very handy...

#### Basic IO

The class `string`  IO is overloaded by defined write/read TBP. Moreover, dedicated methods and operators can be exploited for IO, e.g.

```fortran
use stringifor
type(string) :: astring

astring = 'Hello World'
print "(A)", astring%chars() ! "chars" method returns a standard character variable
print "(DT)", astring        ! defined IO is not enabled with GNU gfortran
print "(A)", astring//''     ! on-the-fly conversion to standard character by means of concatenation
```

#### String manipulation

The class `string` has many methods for a plethora of strings manipulations, e.g.

```fortran
use stringifor
type(string) :: astring
type(string) :: strings(3)

astring = '0123456789'
print "(A)", astring%reverse()//'' ! print "9876543210"

astring = 'Hello World'
print "(A)", astring%replace(old='World', new='People')//'' ! print "Hello People"

astring = 'Hello World'
strings = astring%partition(sep='lo Wo')
print "(A)", 'Before sep: "'//strings(1)//'"' ! print "Hel"
print "(A)", 'Sep itself: "'//strings(2)//'"' ! print "lo Wo"
print "(A)", 'After sep:  "'//strings(3)//'"' ! print "rld"

strings(1) = 'one'
strings(2) = 'two'
strings(3) = 'three'
print "(A)", astring%join(strings)//''          ! print "onetwothree"
print "(A)", astring%join(strings, sep='-')//'' ! print "one-two-three"

astring = ' a StraNgE caSe var'
print "(A)", astring%camelcase()//'' ! print " AStrangeCaseVar"
print "(A)", astring%snakecase()//'' ! print " a_strange_case_var"
print "(A)", astring%startcase()//'' ! print " A Strange Case Var"
```

#### Numbers handling

StringiFor, by means of the [portability environment library, PENF](https://github.com/szaghi/PENF) can handle numbers (reals and integers) effortless. The string/number *casting* (to/from and viceversa) is done by overloaded assignments (for all kinds of integers and reals). For convenience, StringiFor exposes the PENF number *portable* kind parameters.

```fortran
use stringifor
type(string) :: astring

astring = 127 _I1P       ! "I1P" is the PENF kind for 1-byte-like integer.
print "(A)", astring//'' ! print "+127"

astring = 3.021e6_R4P    ! "R4P" is the PENF kind for 4-byte-like real.
print "(A)", astring//'' ! print "+0.302100E+07"

astring = "3.4e9" ! assign to a string without the necessity to define a real kind
if (astring%is_number()) then
  if (astring%is_real()) then
    print "(E13.6)", astring%to_number(kind=1._R4P) ! print " 0.340000E+10" using a 4-byte-like kind
  endif
endif
```

#### Complex scenario

StingiFor is developed to improve the poor Fortran people with *daily* strings-usage, however, also complex scenario is taken into account, e.g. file parsing, OS operations, etc...

```fortran
use stringifor
type(string) :: astring

! OS like manipulation
astring = '/bar/foo.tar.bz2'
print "(A)", astring%basedir()//''                       ! print "/bar"
print "(A)", astring%basename()//''                      ! print "foo.tar.bz2"
print "(A)", astring%basename(extension='.tar')//''      ! print "foo"
print "(A)", astring%basename(last_extension=.true.)//'' ! print "foo.tar"

! XML like tag parsing
astring = '<test> <first> hello </first> <first> not the first </first> </test>'
print "(A)", astring%search(tag_start='<first>', tag_end='</first>')//'' ! print "<first> hello </first>"
```

##### A naive CSV parser

This is just a provocation, but with StringiFor it is easy to develop a naive CSV parser. Let us assume we want to parse a cars-price database as the following one

```csv
Year, Make, Model, Description, Price
1997, Ford, E350   , ac abs moon, 3000.00
1999, Chevy, Venture "Extended Edition"  , , 4900.00
1999, Chevy, Venture "Extended Edition Very Large", , 5000.00
```

Well, parsing it and handling its cells values is very easy by means of StringiFor

```fortran
use stringifor

implicit none
type(string)              :: csv            !< The CSV file as a single stream.
type(string), allocatable :: rows(:)        !< The CSV table rows.
type(string), allocatable :: columns(:)     !< The CSV table columns.
type(string), allocatable :: cells(:,:)     !< The CSV table cells.
type(string)              :: most_expensive !< The most expensive car.
real(R8P)                 :: highest_cost   !< The highest cost.
integer                   :: rows_number    !< The CSV file rows number.
integer                   :: columns_number !< The CSV file columns number.
integer                   :: r              !< Counter.

! parsing the just created CSV file: all done 9 statements!
call csv%read_file(file='cars.csv')              ! read the CSV file as a single stream
call csv%split(tokens=rows, sep=new_line('a'))   ! get the CSV file rows
rows_number = size(rows, dim=1)                  ! get the CSV file rows number
columns_number = rows(1)%count(',') + 1          ! get the CSV file columns number
allocate(cells(1:columns_number, 1:rows_number)) ! allocate the CSV file cells
do r=1, rows_number                              ! parse all cells
  call rows(r)%split(tokens=columns, sep=',')    ! get current columns
  cells(1:columns_number, r) = columns           ! save current columns into cells
enddo

! now you can do whatever with your parsed data
! print the table in markdown syntax
print "(A)", 'A markdown-formatted table'
print "(A)", ''
print "(A)", '|'//csv%join(array=cells(:, 1), sep='|')//'|'
columns = '----' ! re-use columns for printing separators
print "(A)", '|'//csv%join(array=columns, sep='|')//'|'
do r=2, rows_number
  print "(A)", '|'//csv%join(array=cells(:, r), sep='|')//'|'
enddo
print "(A)", ''
! find the most expensive car
print "(A)", 'Searching for the most expensive car'
most_expensive = 'unknown'
highest_cost = -1._R8P
do r=2, rows_number
  if (cells(5, r)%to_number(kind=1._R8P)>=highest_cost) then
    highest_cost = cells(5, r)%to_number(kind=1._R8P)
    most_expensive = csv%join(array=[cells(2, r), cells(3, r)], sep=' ')
  endif
enddo
print "(A)", 'The most expensive car is : '//most_expensive
```

See the test program [csv_naive_parser](https://github.com/szaghi/StringiFor/blob/master/src/tests/csv_naive_parser.f90) for a working example.

Obviously, this is a naive parser without any robustness, but it proves the usefulness of the StringiFor approach.

---

### Methods API

In the following all the methods of `string` are listed with a brief description of their aim. The hyperlinks bring you to the full API explained into the GH pages.

##### builtins replacements

| name                 | meaning             |
|----------------------|---------------------|
|[adjustl ](#adjustl ) | adjustl replacement |
|[adjustr ](#adjustr ) | adjustr replacement |
|[count   ](#count   ) | count replacement   |
|[index   ](#index   ) | index replacement   |
|[len     ](#len     ) | len replacement     |
|[len_trim](#len_trim) | len_trim replacement|
|[repeat  ](#repeat  ) | repeat replacement  |
|[scan    ](#scan    ) | scan replacement    |
|[trim    ](#trim    ) | trim replacement    |
|[verify  ](#verify  ) | verify replacement  |

##### auxiliary methods

| name                                                                 | meaning                                                                          |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------|
|[basedir    ](http://szaghi.github.io/StringiFor/proc/basedir.html  ) | return the base directory name of a string containing a file name                |
|[basename   ](http://szaghi.github.io/StringiFor/proc/basename.html ) | return the base file name of a string containing a file name                     |
|[camelcase  ](http://szaghi.github.io/StringiFor/proc/camelcase.html) | return a string with all words capitalized without spaces                        |
|[capitalize ](#capitalize                                           ) | return a string with its first character capitalized and the rest lowercased     |
|[chars      ](#chars                                                ) | return the raw characters data                                                   |
|[decode     ](#decode                                               ) | decode string                                                                    |
|[encode     ](#encode                                               ) | encode string                                                                    |
|[escape     ](#escape                                               ) | escape backslashes (or custom escape character)                                  |
|[extension  ](#extension                                            ) | return the extension of a string containing a file name                          |
|[fill       ](#fill                                                 ) | pad string on the left (or right) with zeros (or other char) to fill width       |
|[free       ](#free                                                 ) | free dynamic memory                                                              |
|[insert     ](#insert                                               ) | insert substring into string at a specified position                             |
|[join       ](#join                                                 ) | return a string that is a join of an array of strings or characters              |
|[lower      ](#lower                                                ) | return a string with all lowercase characters                                    |
|[partition  ](#partition                                            ) | split string at separator and return the 3 parts (before the separator and after)|
|[read_file  ](#read_file                                            ) | read a file a single string stream                                               |
|[read_line  ](#read_line                                            ) | read line (record) from a connected unit                                         |
|[read_lines ](#read_lines                                           ) | read (all) lines (records) from a connected unit as a single ascii stream        |
|[replace    ](#replace                                              ) | return a string with all occurrences of substring old replaced by new            |
|[reverse    ](#reverse                                              ) | return a reversed string                                                         |
|[search     ](#search                                               ) | search for *tagged* record into string                                           |
|[slice      ](#slice                                                ) | return the raw characters data sliced                                            |
|[snakecase  ](#snakecase                                            ) | return a string with all words lowercase separated by *_*                        |
|[split      ](#split                                                ) | return a list of substring in the string using sep as the delimiter string       |
|[startcase  ](#startcase                                            ) | return a string with all words capitalized, e.g. title case                      |
|[strip      ](#strip                                                ) | return a string with the leading and trailing characters removed                 |
|[swapcase   ](#swapcase                                             ) | return a string with uppercase chars converted to lowercase and vice versa       |
|[to_number  ](#to_number                                            ) | cast string to number                                                            |
|[unescape   ](#unescape                                             ) | unescape double backslashes (or custom escaped character)                        |
|[unique     ](#unique                                               ) | reduce to one (unique) multiple occurrences of a substring into a string         |
|[upper      ](#upper                                                ) | return a string with all uppercase characters                                    |
|[write_file ](#write_file                                           ) | write a single string stream into file                                           |
|[write_line ](#write_line                                           ) | write line (record) to a connected unit                                          |
|[write_lines](#write_lines                                          ) | write lines (records) to a connected unit                                        |

##### inquire methods

| name                         | meaning                                                      |
|------------------------------|--------------------------------------------------------------|
|[end_with    ](#end_with    ) | return true if a string ends with a specified suffix         |
|[is_allocated](#is_allocated) | return true if the string is allocated                       |
|[is_digit    ](#is_digit    ) | return true if all characters in the string are digits       |
|[is_integer  ](#is_integer  ) | return true if the string contains an integer                |
|[is_lower    ](#is_lower    ) | return true if all characters in the string are lowercase    |
|[is_number   ](#is_number   ) | return true if the string contains a number (real or integer)|
|[is_real     ](#is_real     ) | return true if the string contains an real                   |
|[is_upper    ](#is_upper    ) | return true if all characters in the string are uppercase    |
|[start_with  ](#start_with  ) | return true if a string starts with a specified prefix       |

##### operators

| name                     | meaning                                                       |
|--------------------------|---------------------------------------------------------------|
|[assignment](#assignment) | assignment of string from different inputs                    |
|[//        ](#//        ) | concatenation resulting in characters for seamless integration|
|[.cat.     ](#.cat.     ) | concatenation resulting in `string`                           |
|[==        ](#==        ) | equal operator                                                |
|[/=        ](#/=        ) | not equal operator                                            |
|[<         ](#<         ) | lower than operator                                           |
|[<=        ](#<=        ) | lower equal than operator                                     |
|[>=        ](#>=        ) | greater equal than operator                                   |
|[>         ](#>         ) | greater than operator                                         |

##### IO

| name                                    | meaning           |
|-----------------------------------------|-------------------|
|[read(formatted)   ](#read_formatted   ) | formatted input   |
|[write(formatted)  ](#write_formatted  ) | formatted output  |
|[read(unformatted) ](#read_unformatted ) | unformatted input |
|[write(unformatted)](#write_unformatted) | unformatted output|

Go to [Top](#top)

---

## Comparison to other Approaches

The lack of Fortran support for strings manipulation has promoted different solutions in the past years. Following the classification of Clive Page [[1]](#clive-page-talk) we can consider:

+ standard character type;
+ deferred-length allocatable character type (standard 2003+);
+ `VARYING_STRING` type (standard 90/95+) as defined in ISO/IEC 1539-2:2000 (Varying length character strings).

Let us compare StringiFor to the previous three approaches. In particular, let us consider Ian Harvey extension of `VARYING_STRING`, i.e. the `aniso_varying_string` [[2]](#aniso_vstring).

Clive Page had pointed out the following issues, among the others:

+ fixed (at compile time) string length
```fortran
character(len=3) :: astring ! further lengths different from 3 are not allowed
```
+ silent truncation on assignment
```fortran
character(len=3) :: astring
astring = 'abcdefgh' ! silent trunctation at 'abc'
```
+ trim-cluttered code
```fortran
character(len=99) :: astring
character(len=99) :: anotherstring
astring = 'abcdefgh'
anotherstring = trim(astring)//'ilmnopqrst' ! trim-cluttering is a necessity
```
+ handle significant trailing spaces
```fortran
character(len=99) :: astring
character(len=99) :: anotherstring
astring = 'Hello ' ! for some reasons you want to keep these trailing white spaces
anotherstring = trim(astring)//'World' ! you need trim because
                                       ! len(astring)==len(anotherstring), but lost the significant
                                       ! trailing spaces...
```
+ different character definition
```fortran
character         :: astring*10    ! old way
character(len=10) :: anotherstring ! new way
```
+ allocation of array of strings
```fortran
character(len=10), allocatable :: astring(:)
allocate(astring(100)) ! all 100 elements of the array have 10 characters,
                       ! different lengths cannot be declared
```
+ initialization of array of strings
```fortran
! the following is illegal
character(len=9), parameter :: day(7) = ['Monday',    &
                                         'Tuesday',   &
                                         'Wednesday', &
                                         'Thursday',  &
                                         'Friday',    &
                                         'Saturday',  &
                                         'Sunday']
! the following is legal, but cluttered by non significant trailing spaces
character(len=9), parameter :: day(7) = ['Monday   ', &
                                         'Tuesday  ', &
                                         'Wednesday', &
                                         'Thursday ', &
                                         'Friday   ', &
                                         'Saturday ', &
                                         'Sunday']
```
+ IO limitations for non standard character variables
```fortran
character(len=99)             :: astring
character(len=:), allocatable :: anotherstring
type(varying_string)          :: yetanotherstring
! fully-simple support for standard character variables
astring = 'abcdefgh'
print*, astring
print "(A)", astring
read(10, *) astring
! partial-simple support for standard deferred length-length allocatable character variables
! care must be placed in input operation...
print*, anotherstring
print "(A)", anotherstring
read(10, *) anotherstring
! support depends on the implementation of the varying string type
print*, yetanotherstring
print "(DT)", yetanotherstring
read(10, *) yetanotherstring
```
+ substring notation (slice)  for non standard character variables
```fortran
character(len=99)             :: astring
character(len=:), allocatable :: anotherstring
type(varying_string)          :: yetanotherstring
astring = 'abcdefgh'
yetanotherstring = astring
anotherstring = astring(2:6)          ! allowed
anotherstring = yetanotherstring(2:6) ! not allowed
```
+ passing string to procedures expecting standard character argument is *complicated*

Analyzing the above issues we can agree that deferred-length allocatable character and aniso_varyng_string approaches address many of them, at the cost of introducing some oddies.

#### deferred-length allocatable character

This approaches addresses all the issues related to the fixed length limitation, e.g.
```fortran
character(len=:), allocatable :: astring
character(len=:), allocatable :: anotherstring
astring = 'Hello '
anotherstring = astring//'World' ! trailing with spaces of astring correctly handled
                                 ! no need of trim
```

However, it has some limitations too. Aside the input operation, the most important (IMHO) are related to arrays of strings handling, e.g.
```fortran
character(len=:), allocatable :: asetofstring(:)
allocate(character(len=99) :: asetofstring(10)) ! all 10 elements must have len=99
```

#### aniso_varying_string

Aniso_varying_string is an implemention of ISO/IEC 1539-2:2000 (Varying length character strings) developed by Ian Harvey that is internally based on a deferred-lenght allocatable character variable: it is essentially a derived type wrapping a deferred-lenght allocatable character. As a consequence, it has all the advantages of the deferred-length allocatable character approach. The wrapping approach addresses the arrays related issues, e.g.
```fortran
type(varying_string), allocatable :: asetofstring(:)
allocate(asetofstring(10)) ! all 10 elements can have diffent lengths
```
Its major issues are related to IO operations: however, this is addressed by new Fortran support for defined IO for derived type that make more effortless the IO of such an object. The other main issue is the impossibility to use the standard slice notation to access to substring: aniso_varying_string addresses (partially) this issue by public-exposing the wrapped allocatable character of its implementations thus allowing the slicing of it, e.g.
```fortran
type(varying_string) :: astring
astring = 'abcdefg'
print "(A)", astring%chars(2:3) ! print 'bc'
```

#### StringiFor

StringiFor shares the same philosophy of aniso_varying_string, thut it has the same pros and cons. However, StringiFor is an Object Oriented Designed class, thus it has some peculiariaties distinguishing it from aniso_varying_string, see [StringiFor Peculiarities](#stringifor-peculiarities).

#### Comparison results

The following table summarizes the comparison analysis.

| issue                       | standard character | deferred-length allocatable character | aniso_varying_string | StringiFor         |
|-----------------------------|--------------------|---------------------------------------|----------------------|--------------------|
| fixed length                | :cloud:            | :sunny:                               | :sunny:              | :sunny:            |
| silent trunction            | :cloud:            | :sunny:                               | :sunny:              | :sunny:            |
| trim-clutter                | :cloud:            | :sunny:                               | :sunny:              | :sunny:            |
| significant trailing spaces | :cloud:            | :sunny:                               | :sunny:              | :sunny:            |
| different string definition | :cloud:            | :cloud:                               | :sunny:              | :sunny:            |
| array allocatation          | :cloud:            | :cloud:                               | :sunny:              | :sunny:            |
| array initialization        | :cloud:            | :cloud:                               | :sunny:              | :sunny:            |
| IO                          | :sunny:            | :sunny:                               | :partly_sunny:       | :partly_sunny:     |
| substring (slice) notation  | :sunny:            | :sunny:                               | :partly_sunny:       | :partly_sunny:     |
| Fortran builtins            | :sunny:            | :sunny:                               | :partly_sunny:       | :partly_sunny:     |

##### legend
|  symbol        | meaning           |
|----------------|-------------------|
| :cloud:        | bad or no support |
| :partly_sunny: | partial support   |
| :sunny:        | good support      |

### StringiFor Peculiarities

StringiFor publics an OOD class, the `string` object. This class is aimed to address all the issues of the standard character type, as ISO Varying String approaches do, but it is also designed to provide a features-rich string object as you can find on other languages like Python. As a matter of facts, the *auxiliary methods* added to the `string` object consitute a long list of new (for Fortraners) string-facilities, allowing you to handle strings effortless (cases-conversion, files-handling, encode/decode, numbers-casting, etc...), see the complete [API](#methods-api). It is worth to note that StringiFor is a tentative to adopt an fully OOD thus all methods and operators are TBP defined: to use StringiFor you can import only the `string` type, allowing a sane and robust names space handling. Only in the case you want the Fortran builtins to accept a `string` instead of a standard character type, e.g. to use `index(astring, 'c')` seamless with both a `type(string) :: astring` and a `character(99) :: astring`, you must use all the StringiFor public objects, including the overloaded interfaces of the Fortran builtins.

#### References

[1]<a name="clive-page-talk"></a> [*Improved String-handling in Fortran*](http://www.fortran.bcs.org/2015/suggestion_string_handling.pdf), Clive Page, October 2015.

[2]<a name="aniso_vstring"></a> [*aniso_varying_string*](http://www.megms.com.au/aniso_varying_string.htm), Ian Harvey, 2016.

Go to [Top](#top)
