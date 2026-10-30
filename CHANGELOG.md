# Changelog

All notable changes to this project are documented here.
Versions follow [Semantic Versioning](https://semver.org/).
Format follows [Keep a Changelog](https://keepachangelog.com/).

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



