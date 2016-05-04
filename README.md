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

[![Compiler](https://img.shields.io/badge/GNU-v5.2.0+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/Intel-v15.x+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/IBM%20XL-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/g95-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/NAG-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/PGI-not%20tested-yellow.svg)]()

## What is StringiFor?

Modern Fortran standards (2003+) have introduced a better support for characters variables, but Fortraners still do not have the power on dealing with strings of other more-rich-programmers, e.g. Pythoners. Allocatable deferred length character variables are now quantum-leap with respect the old inflexible Fortran characters, but it is still not enough for many Fortraners. Moreover, Fortran does not provide builtin methods for widely used strings manipulations offered by other languages, e.g. UPPER/lowercase transformation, tokenization, etc... StringiFor attempts to fill this lack.

Go to [Top](#top)

## Main features

StringiFor exposes only one class (OO-designed), the `string` type, that should be used as a more powerful string variable with respect a standard Fortran `character` variable. The main features of this class are:

* [ ] seamless interchangeability with standard character variables, i.e.:
  + [ ] I/O operation;
  + [ ] string/character concatenation;
  + [ ] string/character assignment;
* [ ] handy builtin methods:
  + [ ] UPPER/lower case transformartion;
  + [ ] tokenization;
  + [ ] number-to-string (and viceversa) casting;

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

Besides this README file the StringiFor documentation is contained into its own [wiki](https://github.com/szaghi/StringiFor/wiki). Detailed documentation of the API is contained into the [GitHub Pages](http://szaghi.github.io/StringiFor/index.html) that can also be created locally by means of [ford tool](https://github.com/cmacmackin/ford).

### A Taste of StringiFor

To be written.

Go to [Top](#top)
