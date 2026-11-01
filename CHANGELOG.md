# Changelog

All notable changes to this project are documented here.
Versions follow [Semantic Versioning](https://semver.org/).
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [1.11.1] — 2026-11-01
### Added
- **numbers**: Read the exponent without its letter, nan and inf

- **numbers**: Convert any number of up to 18 digits without read

- **numbers**: Shortest text of a real, and edit_distance

- **numbers**: Settle reals of more than 18 digits on the first 18


### Documentation
- **examples**: Animated sessions of regex, UTF-8 and numbers

- **tutorial**: Chapter 8, Unicode text

- **cookbook**: Recipes for sorting, escapes, chunked split and regex calls

- **readme**: Show the regex, UTF-8 and numbers sessions

- **site**: Project logo, colour palette, GitHub link and animated sessions

- **site**: A new logo, an S cut on the diagonal

- **regex**: Warn that nvfortran reads backslashes in patterns

- **numbers**: Forms of a real, Eisel-Lemire, shortest and edit_distance


### Fixed
- **numbers**: Settle long reals exactly, without read

- **numbers**: Report an integer past the range of its kind

- **numbers**: Reject malformed numbers and read integer exponents exactly


## [1.11.0] — 2026-10-31
### Added
- **regex**: Regular expressions, a Pike VM linear in the subject

- **regex**: Finditer, findall, split, sub and the re_* procedures


### Documentation
- **regex**: Regular expressions guide, tutorial chapter and recipes

- **readme**: Regular expressions and UTF-8 in the features


## [1.10.0] — 2026-10-30
### Added
- **utf8**: Positions and lengths in characters with by=SF_CHARS

- **utf8**: Slice, insert and len_last_word in characters with by=SF_CHARS

- **utf8**: Widths in characters with by=SF_CHARS

- **utf8**: Display width in terminal columns

- **xml**: Escape_xml, unescape_xml and xml_error

- **utf8**: Unicode whitespace with unicode=.true.

- **sort**: Strsort and the orders strless, strless_nocase, strless_natural


### Documentation
- **utf8**: Positions and widths in characters

- **utf8**: Display width, and its differences from wcwidth

- **xml**: XML escaping

- **utf8**: Unicode whitespace

- **sort**: Sorting arrays of strings


### Fixed
- **string_t**: Assigning a part of a string to itself

- **string_t**: Partition as Python str.partition ⚠ BREAKING CHANGE


## [1.9.1] — 2026-10-30
### Fixed
- **io**: Use-after-free in the module read_lines with skip_bom


## [1.9.0] — 2026-10-30
### Added
- **unicode**: Generate the Unicode property tables from the UCD

- **utf8**: Add the UTF-8 core: validation, codepoints and repair

- **escape**: Add the C escape codecs escape_c, unescape_c and escapes_error

- **utf8**: Scan, verify and strip work on units

- **utf8**: Reverse, squeeze and transliterate work on units

- **utf8**: Match wildcard patterns by units

- **io**: Read and write the UTF-8 byte order mark


### Documentation
- Add searching to the tutorial, unit, binary and stdin recipes

- **utf8**: Document the methods that work on units, add the 1.9.0 upgrade notes ⚠ BREAKING CHANGE


### Fixed
- **ci**: Run install smoke test from the release workflow

- **string_t**: Split_chunked without tokens, end_with on a null string


### Performance
- **utf8**: ASCII fast paths for the methods that work on units


## [1.8.0] — 2026-10-04
### Added
- **string_t**: Fast exact number casting, count/index/strip options


### Documentation
- Cover the new methods in tutorial, cookbook and home pages


## [1.7.0] — 2026-10-04
### Added
- **string_t**: Add character classes, tr-like and padding methods


## [1.6.0] — 2026-10-03
### Added
- **string_t**: Add read_number with an error status, keep empty fields in split


## [1.5.0] — 2026-10-03
### Added
- **string_t**: Add match of wildcard patterns, make glob safe


## [1.4.0] — 2026-10-03
### Documentation
- Add the 1.4.0 upgrade notes, sync run_tests.sh and release.sh


### Performance
- **string_t**: Make split, replace, unique, escape, join and read_* linear


## [1.3.1] — 2026-10-03
### Changed
- **cmake**: Find PENF and FACE by their standard config names


### Fixed
- **makefile**: Repair the make build and keep the doctests in sync

- **cmake**: Make the installed package usable by find_package

- **string_t**: Return a not allocated string for an unknown codec

- **release**: Sync fpm.toml version on release, unblock docs build


## [1.3.0] — 2026-10-02
### Added
- **string_t**: Add six string methods from the issue #3 wishlist


### Documentation
- Rebuild README and site on compiled examples, fix I/O bugs


### Fixed
- **string_t**: Prevent out-of-bounds on blank and null strings

- **fobos**: Repair makecoverage rule and adopt double-dash fobis CLI

- **string_t**: Correct is_real and base64 decode, extend slice/strip


## [1.2.0] — 2026-10-02
### Fixed
- **docs**: Untrack package-lock and pin esbuild for lock-free vite build

- **string_t**: Guard R16P generic bindings with PENF_R16P macro


## [1.1.6] — 2026-02-18
### Fixed
- **docs**: Correct project name casing to StringiFor throughout


## [1.1.5] — 2026-02-18
### Documentation
- Add VitePress site, rework CI/CD, and refactor README


## [1.1.4] — 2026-02-18
### Fixed
- Fix GNU gfortran issue with recursive procedure



