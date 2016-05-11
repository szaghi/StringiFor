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

#### Table of Contents

- [What is StringiFor?](#what-is-penf?)
- [Main features](#main-features)
- [Copyrights](#copyrights)
- [Documentation](#documentation)
	- [A Taste of StringiFor](#a-taste-of-penf)

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/StringiFor.svg)]()
[![Ready in backlog](https://badge.waffle.io/szaghi/StringiFor.png?label=ready&title=Ready)](https://waffle.io/szaghi/StringiFor)
[![In Progress](https://badge.waffle.io/szaghi/StringiFor.png?label=in%20progress&title=In%20Progress)](https://waffle.io/szaghi/StringiFor)
[![Open bugs](https://badge.waffle.io/szaghi/StringiFor.png?label=bug&title=Open%20Bugs)](https://waffle.io/szaghi/StringiFor)

#### Compiler Support

[![Compiler](https://img.shields.io/badge/GNU-v5.2.0+-orange.svg)]()
[![Compiler](https://img.shields.io/badge/Intel-v15.x+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/IBM%20XL-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/g95-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/NAG-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/PGI-not%20tested-yellow.svg)]()

##### GNU partial support
> GNU gfortran does not support user-defined-type-IO, thus some class features are disabled if GNU is used.

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

## Documentation

The StringiFor documentation is mainly contained into this file (it has its own [wiki](https://github.com/szaghi/StringiFor/wiki) with some less important documents). Detailed documentation of the API is contained into the [GitHub Pages](http://szaghi.github.io/StringiFor/index.html) that can also be created locally by means of [ford tool](https://github.com/cmacmackin/ford).

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

---

### Methods API

In the following all the methods of `string` are listed with a brief description of their aim. The hyperlinks bring you to the full API explained into the GH pages.

+ String manipulations & Co.:
  + [`basedir   `](http://szaghi.github.io/StringiFor/proc/basedir.html) return the base directory name of a string containing a file name.
  + [`basename  `](#basename  ) return the base file name of a string containing a file name.
  + [`camelcase `](#camelcase ) return a string with all words capitalized without spaces.
  + [`capitalize`](#capitalize) return a string with its first character capitalized and the rest lowercased.
  + [`chars     `](#chars     ) return the raw characters data.
  + [`escape    `](#escape    ) escape backslashes (or custom escape character).
  + [`extension `](#extension ) return the extension of a string containing a file name.
  + [`fill      `](#fill      ) pad string on the left (or right) with zeros (or other char) to fill width.
  + [`free      `](#free      ) free dynamic memory.
  + [`join      `](#join      ) return a string that is a join of an array of strings or characters.
  + [`lower     `](#lower     ) return a string with all lowercase characters.
  + [`partition `](#partition ) split string at separator and return the 3 parts (before, the separator and after).
  + [`replace   `](#replace   ) return a string with all occurrences of substring old replaced by new.
  + [`reverse   `](#reverse   ) return a reversed string.
  + [`search    `](#search    ) search for *tagged* record into string.
  + [`snakecase `](#snakecase ) return a string with all words lowercase separated by "\_".
  + [`split     `](#split     ) return a list of substring in the string, using sep as the delimiter string.
  + [`startcase `](#startcase ) return a string with all words capitalized, e.g. title case.
  + [`strip     `](#strip     ) return a string with the leading and trailing characters removed.
  + [`swapcase  `](#swapcase  ) return a string with uppercase chars converted to lowercase and vice versa.
  + [`to_number `](#to_number ) cast string to number.
  + [`unique    `](#unique    ) reduce to one (unique) multiple occurrences of a substring into a string.
  + [`upper     `](#upper     ) return a string with all uppercase characters.
+ inquires:
  + [`end_with    `](#end_with    ) return true if a string ends with a specified suffix.
  + [`is_allocated`](#is_allocated) return true if the string is allocated.
  + [`is_digit    `](#is_digit    ) return true if all characters in the string are digits.
  + [`is_integer  `](#is_integer  ) return true if the string contains an integer.
  + [`is_lower    `](#is_lower    ) return true if all characters in the string are lowercase.
  + [`is_number   `](#is_number   ) return true if the string contains a number (real or integer).
  + [`is_real     `](#is_real     ) return true if the string contains an real.
  + [`is_upper    `](#is_upper    ) return true if all characters in the string are uppercase.
  + [`start_with  `](#start_with  ) return true if a string starts with a specified prefix.
+ builtins replacements:
  + [`sadjustl `](#sadjustl ) adjustl replacement.
  + [`sadjustr `](#sadjustr ) adjustr replacement.
  + [`scount   `](#scount   ) count replacement.
  + [`sindex   `](#sindex   ) index replacement.
  + [`slen     `](#slen     ) len replacement.
  + [`slen_trim`](#slen_trim) len_trim replacement.
  + [`srepeat  `](#srepeat  ) repeat replacement.
  + [`sscan    `](#sscan    ) scan replacement.
  + [`strim    `](#strim    ) trim replacement.
  + [`sverify  `](#sverify  ) verify replacement.
+ IO:
  + [`read(formatted)   `](#read_formatted   ) formatted input.
  + [`write(formatted)  `](#write_formatted  ) formatted output.
  + [`read(unformatted) `](#read_unformatted ) unformatted input.
  + [`write(unformatted)`](#write_unformatted) unformatted output.
+ operators:
  + [`assignment`](#assignment) assignment of string from different inputs.
  + [`//`        ](#//        ) concatenation resulting in characters for seamless integration.
  <!-- + [`.cat.`     ](#.cat.     ) concatenation resulting in `string`. -->

Go to [Top](#top)
