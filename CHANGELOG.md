# Changelog
## [v1.1.9](https://github.com/szaghi/FLAP/tree/v1.1.9) (2026-02-28)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.8...v1.1.9)
### Build system
- Migrate deps from git submodules to FoBiS fetch ([`acd441f`](https://github.com/szaghi/FLAP/commit/acd441f28d196e2b757f63368376bb4cd2bf02d8))

## [v1.1.8](https://github.com/szaghi/FLAP/tree/v1.1.8) (2026-02-22)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.7...v1.1.8)
### Miscellaneous
- Update BeFoR64 submodule ([`ba5a992`](https://github.com/szaghi/FLAP/commit/ba5a992ce82ef6e9f9a6dd59c5a7ac786d70cbad))

## [v1.1.7](https://github.com/szaghi/FLAP/tree/v1.1.7) (2026-02-18)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.6...v1.1.7)
### CI/CD
- Add standalone docs deploy workflow ([`6f07ca3`](https://github.com/szaghi/FLAP/commit/6f07ca3698b695d894e3712a56c7f99d8b84e740))

## [v1.1.6](https://github.com/szaghi/FLAP/tree/v1.1.6) (2026-02-18)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.5...v1.1.6)
### Bug fixes
- Correct project name casing to StringiFor throughout ([`0815b10`](https://github.com/szaghi/FLAP/commit/0815b10dba925771a5f1936cecfd924e43802080))

## [v1.1.5](https://github.com/szaghi/FLAP/tree/v1.1.5) (2026-02-18)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.4...v1.1.5)
### Bug fixes
- Fix GNU gfortran issue with recursive procedure ([`82727d6`](https://github.com/szaghi/FLAP/commit/82727d6c001f2ac5d1f591592958ad9764eec496))

### Documentation
- Add VitePress site, rework CI/CD, and refactor README ([`1678f05`](https://github.com/szaghi/FLAP/commit/1678f0554974158323da267dcaa329e6722fcc88))

### Miscellaneous
- Remove FPM install test ([`d5ad17e`](https://github.com/szaghi/FLAP/commit/d5ad17e0cb8bf3f8a7adb4a71c2761879bf0c8bb))
- Add fpm support ([`cc776cb`](https://github.com/szaghi/FLAP/commit/cc776cb73419ef511addfb8877567b8285418028))
- Add fpm CI ([`3a46e57`](https://github.com/szaghi/FLAP/commit/3a46e578c33723fe8ff44ad766c1806886a843fd))
- Merge pull request [#38](https://github.com/szaghi/FLAP/issues/38) from zoziha/add-fpm-support

Add fpm support ([`25570c3`](https://github.com/szaghi/FLAP/commit/25570c36964ef49942537af942603962c3f26b68))
- Fix fpm.toml pinning correct rev that works with fpm 0.90 ([`5288871`](https://github.com/szaghi/FLAP/commit/5288871cc942aa2203e987af9d98d74ad7205d2c))
- Merge pull request [#39](https://github.com/szaghi/FLAP/issues/39) from epagone/patch-1

Fix fpm.toml pinning correct rev of FACE that works with fpm 0.9.0 ([`726dd77`](https://github.com/szaghi/FLAP/commit/726dd77c4c58e0f2eb89824f18aac8b33db2d590))
- Fix bug in replace method

Fix bug in replace method: the replace method fails if the "old"
substring is a null string, i.e. old=''. Fixed checking if len(old)>0.

A specific doctest has been also added. ([`8c94d4b`](https://github.com/szaghi/FLAP/commit/8c94d4b123ed285f8ed36a8932db4e8543456232))
- Update submodules ([`d209d21`](https://github.com/szaghi/FLAP/commit/d209d214042ac9cb211e5c44241759e4f9ca22a6))
- Update submodules ([`e5df2b9`](https://github.com/szaghi/FLAP/commit/e5df2b9e53cf72e1305f915593ca66c5c269f883))

## [v1.1.4](https://github.com/szaghi/FLAP/tree/v1.1.4) (2022-07-04)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.3...v1.1.4)
### Miscellaneous
- Merge tag 'v1.1.3' into develop

Bugfix issue[#36](https://github.com/szaghi/FLAP/issues/36)

Update makefile ([`afd2d69`](https://github.com/szaghi/FLAP/commit/afd2d691ef5b7d19671e09e023c506c4bf6aa944))
- Fix issue [#36](https://github.com/szaghi/FLAP/issues/36)

Fix issue [#36](https://github.com/szaghi/FLAP/issues/36): update makefile, tests were missing ([`2c0e13c`](https://github.com/szaghi/FLAP/commit/2c0e13cb79bfce9870bf01d501eaec66f0f96a1d))
- Fix issue [#36](https://github.com/szaghi/FLAP/issues/36)

Fix issue [#36](https://github.com/szaghi/FLAP/issues/36): correct typo into makefile ([`c6a78d6`](https://github.com/szaghi/FLAP/commit/c6a78d6721846cbf553a17ea0114ea964568e51e))
- Switch to GH actions ([`7907da9`](https://github.com/szaghi/FLAP/commit/7907da9e88d119c16ad848f5f2ac080aa4a1c34c))

## [v1.1.3](https://github.com/szaghi/FLAP/tree/v1.1.3) (2021-06-18)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.2...v1.1.3)
### Miscellaneous
- Merge branch 'master' into cmake2 ([`98c3e9a`](https://github.com/szaghi/FLAP/commit/98c3e9a95a69b9c4fc9bd0c50332cb2aeeca48db))
- Add FACE dependance to CMakeLists ([`c00068e`](https://github.com/szaghi/FLAP/commit/c00068ec8adf3ca46d67824ebda8167788dfe9cb))
- Merge pull request [#31](https://github.com/szaghi/FLAP/issues/31) from kostyfisik/cmake2

Cmake3 ([`d3b041b`](https://github.com/szaghi/FLAP/commit/d3b041baf7eead73f1a41ea5b08de0d785650020))
- Update examples ([`591ed76`](https://github.com/szaghi/FLAP/commit/591ed76440b51b54cc4d6797a933af629fcf3d12))
- Merge pull request [#32](https://github.com/szaghi/FLAP/issues/32) from band-a-prend/readme

README: update examples ([`9c47122`](https://github.com/szaghi/FLAP/commit/9c471223608cf26b635e32ac6049f8b69260b3f3))
- Strjoin(array,sep) function implementation ([`9bed374`](https://github.com/szaghi/FLAP/commit/9bed3740472450354737dfe6c3fe5be4026a03bd))
- Merge pull request [#33](https://github.com/szaghi/FLAP/issues/33) from band-a-prend/strjoin

stringifor_string_t: strjoin(array,sep) function implementation ([`e3587d1`](https://github.com/szaghi/FLAP/commit/e3587d1f40d6c40e0b82b624088578360f175817))
- Update submodule ([`df60bcd`](https://github.com/szaghi/FLAP/commit/df60bcda5d085f0c66319a30810b4b88e7e3ed82))
- Merge branch 'master' into develop ([`744540d`](https://github.com/szaghi/FLAP/commit/744540da04e13fc78e45c96b6bd709cdb778c612))
- Re-add pre-processing flag for unsupported R16P

Re-add pre-processing flag for unsupported R16P ([`a72c5c6`](https://github.com/szaghi/FLAP/commit/a72c5c61f3aa26ad8a52afc9ed610060ceeb634e))
- Add workaround for NVfortran bugs ([`4ef6ab5`](https://github.com/szaghi/FLAP/commit/4ef6ab5544790f0c623584c055d53adc1bcae78e))
- Strjoin(array,sep, is_col) for 2D-array function impl. ([`6c9640c`](https://github.com/szaghi/FLAP/commit/6c9640cd1c56002a52abf78583841fecad8bff4e))
- Merge pull request [#34](https://github.com/szaghi/FLAP/issues/34) from band-a-prend/strjoin_arr

stringifor_string_t: strjoin(array,sep, is_col) for 2D-array function ([`0056b4f`](https://github.com/szaghi/FLAP/commit/0056b4f82b0caf4db803a539342fa3e2ad8f4ad3))
- Fix issue [#36](https://github.com/szaghi/FLAP/issues/36)

Fix issue [#36](https://github.com/szaghi/FLAP/issues/36): update makefile ([`b3cf8c8`](https://github.com/szaghi/FLAP/commit/b3cf8c8a5a9fd16e2584d7cde272c45b0de5f0ce))
- Merge branch 'release/1.1.3' ([`bad95cb`](https://github.com/szaghi/FLAP/commit/bad95cb8c1ae0f17dd3e15acd6bc2a8cde4bb606))

## [v1.1.2](https://github.com/szaghi/FLAP/tree/v1.1.2) (2020-01-28)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.1...v1.1.2)
### Miscellaneous
- Clean travis setup ([`b3e5fb0`](https://github.com/szaghi/FLAP/commit/b3e5fb0c48f9d0c647d43b9243411cc386e09e43))

## [v1.1.1](https://github.com/szaghi/FLAP/tree/v1.1.1) (2020-01-28)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.0...v1.1.1)
### Miscellaneous
- Merge tag 'v1.1.0' into develop

Add support for ANSI color and style and add glob standanlone procedure

Add support for ANSI color and style and add glob standanlone procedure.

This change addresses the need by:

Adding new method *colorize*.

Side effects:

New third party dependency, FACE is now a requirement (all other codes
using StringiFor must be updated).

Third party dependencies:

https://github.com/szaghi/BeFoR64 (currently v1.1.4)
https://github.com/szaghi/FACE (currently v1.1.2)
https://github.com/szaghi/PENF (currently v1.2.2) ([`99a0bca`](https://github.com/szaghi/FLAP/commit/99a0bca518473447d0576639811e622bcda079d1))
- Try to fix travis issue ([`39a9e08`](https://github.com/szaghi/FLAP/commit/39a9e0826a453180467e3481499c468da579f9e6))
- Merge branch 'master' into develop ([`9a439da`](https://github.com/szaghi/FLAP/commit/9a439da6d5d6e27d00bfe5803083c89302a498b5))
- Merge branch 'release/1.1.1' ([`7f73f26`](https://github.com/szaghi/FLAP/commit/7f73f2682372201721f0fd670cf9c772d11b5268))
- Merge tag 'v1.1.1' into develop

Try to fix deployment issues ([`dba1d2d`](https://github.com/szaghi/FLAP/commit/dba1d2dbfaddff49b4ca693f800a95b169e5d1f9))
- Update CMakeLists ([`9cc7027`](https://github.com/szaghi/FLAP/commit/9cc7027767ec8c42a25ae91d48ad09cb280696cb))
- Try to fix travis issue ([`139c206`](https://github.com/szaghi/FLAP/commit/139c2067c65d7584ec021075923bfe554858a6d7))
- Try to fix travis issue ([`72f40c0`](https://github.com/szaghi/FLAP/commit/72f40c092b20da8fc6039fa65e1bd8c9c3730d23))
- Try to fix travis issue ([`bb31e21`](https://github.com/szaghi/FLAP/commit/bb31e21c9e036dd876631e368764d40eaf66a68d))
- Try to fix travis issue ([`8d588de`](https://github.com/szaghi/FLAP/commit/8d588de00725dbf03e6c820e174657306a1acf86))
- Try to fix travis issue ([`3dc2319`](https://github.com/szaghi/FLAP/commit/3dc23194a05e380b1e20103b638b9ede50ce5366))
- Try to fix travis issue ([`a5a0abf`](https://github.com/szaghi/FLAP/commit/a5a0abf517cb13ea9d7538939d062b222afd3ddf))
- Try to fix travis issue ([`10ce65b`](https://github.com/szaghi/FLAP/commit/10ce65bde5127eadceca52a3e5b6b95d7f076256))
- Try to fix travis issue ([`758ac89`](https://github.com/szaghi/FLAP/commit/758ac89cb8e0f44316099effbfbbf45eaca6c768))
- Try to fix travis issue ([`67044c6`](https://github.com/szaghi/FLAP/commit/67044c6fd293cba23cd95f2811245cf9ded26225))
- Try to fix travis issue ([`084fe5c`](https://github.com/szaghi/FLAP/commit/084fe5c115c277c7beea35f6c049bc28a33274b6))
- Try to fix travis issue ([`2f08433`](https://github.com/szaghi/FLAP/commit/2f0843311b568c663228ed66e6ca3aff45db752d))
- Try to fix travis issue ([`17a8f19`](https://github.com/szaghi/FLAP/commit/17a8f196a4b636d920d18013087ee2f67ccd390c))
- Try to fix travis issue ([`c84224e`](https://github.com/szaghi/FLAP/commit/c84224e7c41c95edca7cc8e4a929a57918b01619))
- Try to fix travis issue ([`f60c79d`](https://github.com/szaghi/FLAP/commit/f60c79ded4d75ea1569df8d72a76826b7715aab8))
- Try to fix travis issue ([`0db86be`](https://github.com/szaghi/FLAP/commit/0db86be8500aa6444dce0a9182d031b495d4b3bf))

## [v1.1.0](https://github.com/szaghi/FLAP/tree/v1.1.0) (2020-01-27)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.1...v1.1.0)
### Miscellaneous
- Merge tag 'v1.0.1' into develop

Fix issue[#28](https://github.com/szaghi/FLAP/issues/28)

Array constructors are inhibited, thus LHS automatic reallocation of
string-arrays does not work. This is a fix.

Why:

Assignment operators were defined *elemental* and there was
a constructor function overloading string name.

This change addresses the need by:

Declare assignments *pure*, remove constructor function and make public
*raw* member.

Side effects:

Unknown...

Fully backward compatible. ([`451fe92`](https://github.com/szaghi/FLAP/commit/451fe92242ebf55a0bc2e10cd8ab5f77b9ae9121))
- Re-add tests deleted for a distraction ([`b6a45a4`](https://github.com/szaghi/FLAP/commit/b6a45a42c5fc85cfb33405f39e873e6114036260))
- Merge branch 'master' into develop ([`0a5f550`](https://github.com/szaghi/FLAP/commit/0a5f5509bad05445b17d2e20e4b434d65044ec1f))
- Update submodules ([`d963be7`](https://github.com/szaghi/FLAP/commit/d963be7326cf3738539be7a6219a233cbfe33143))
- Make glob method also a standalone procedure, fix issue[#13](https://github.com/szaghi/FLAP/issues/13)

Make glob method also a standalone procedure, fix issue[#13](https://github.com/szaghi/FLAP/issues/13)

Side effects:

Nothing ([`e1b3655`](https://github.com/szaghi/FLAP/commit/e1b3655e17ff8bdd0829fd53eb5a2d7d3b9940fa))
- Add support for ANSI color and style-fix issue[#15](https://github.com/szaghi/FLAP/issues/15)

Add support for ANSI color and style-fix issue[#15](https://github.com/szaghi/FLAP/issues/15)

This change addresses the need by:

Adding new method *colorize*.

Side effects:

New third party dependency, FACE is now a requirement (all other codes
using StringiFor must be updated). ([`568c7be`](https://github.com/szaghi/FLAP/commit/568c7be36bbe2189a203ebc57df5e6800f335b9f))
- Partially update README ([`18d0523`](https://github.com/szaghi/FLAP/commit/18d052346f6a57615a9c9d094bfce4c9b1adde24))
- Merge branch 'release/1.1.0' ([`66a1900`](https://github.com/szaghi/FLAP/commit/66a1900aae848a4e780c12480cc19ee144e3106f))

## [v1.0.1](https://github.com/szaghi/FLAP/tree/v1.0.1) (2019-10-23)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.0...v1.0.1)
### Miscellaneous
- Temporary fix for building FiNeR library with intel compilers

Temporary fix for building FiNeR library with intel compilers: Intel
2019 has serious bug and works differently from intel 2018 and from GNU
Fortran... ([`1b50835`](https://github.com/szaghi/FLAP/commit/1b5083514b6c8ad629dfe44bbd011be4f0f9727d))
- Merge conflicts with upstream ([`881d056`](https://github.com/szaghi/FLAP/commit/881d056242c618fecc35701a76562461eced3407))
- Erge tag 'v1.0.0' into develop

Clean old preprocessing flags

Clean old preprocessing flags: now compile with
GNU Fortran (GCC) 9.1.0
ifort (IFORT) 19.1.0.075 20190522 ([`126555f`](https://github.com/szaghi/FLAP/commit/126555f754aa51dedd490347896050bea321821e))
- Update submodules ([`f906e72`](https://github.com/szaghi/FLAP/commit/f906e724e829fcc21a47818fbe5fc443324d112a))
- Fix issue[#28](https://github.com/szaghi/FLAP/issues/28)

Array constructors are inhibited, thus LHS automatic reallocation of
string-arrays does not work. This is a fix.

Why:

Assignment operators were defined *elemental* and there was
a constructor function overloading string name.

This change addresses the need by:

Declare assignments *pure*, remove constructor function and make public
*raw* member.

Side effects:

Unknown... ([`26ba68e`](https://github.com/szaghi/FLAP/commit/26ba68e7db63cdaee88051f265976a9b34d9e372))
- Merge branch 'release/1.0.1' ([`e161ed9`](https://github.com/szaghi/FLAP/commit/e161ed9f241eae6d94ab1c088cecf58c71739e05))

## [v1.0.0](https://github.com/szaghi/FLAP/tree/v1.0.0) (2019-09-13)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.9...v1.0.0)
### Miscellaneous
- Merge tag 'v0.9.9' into develop

Release 0.9.9, add on-the-fly string creator

Stable release, fully backward compatible. ([`a4fd1d2`](https://github.com/szaghi/FLAP/commit/a4fd1d2ca91d703e74aa6fc13708fc116045b72d))
- Split_chunked bug fix

Signed-off-by: YunDanTianChang <2472041823@qq.com> ([`6e27e39`](https://github.com/szaghi/FLAP/commit/6e27e395e77fc2a68c9d80bd0ca07f8c53c45fd7))
- Merge pull request [#21](https://github.com/szaghi/FLAP/issues/21) from yundantianchang/yundantianchang

split_chunked bug fix ([`0bb8f41`](https://github.com/szaghi/FLAP/commit/0bb8f419b091649cf0a8560f3c2de67253187175))
- Add CMake support ([`4f9d4f0`](https://github.com/szaghi/FLAP/commit/4f9d4f0987820806cd344a30b36076875c0ab03a))
- Merge pull request [#23](https://github.com/szaghi/FLAP/issues/23) from victorsndvg/master

Add CMake support ([`de58858`](https://github.com/szaghi/FLAP/commit/de588585f37705c6283dd6f40874e28fa55694a9))
- Update submodules ([`6a346d7`](https://github.com/szaghi/FLAP/commit/6a346d7fe643e14df8c6c554a88c6aa8eefad6da))
- Fix Intel 2018 issue

With Intel 2018 fails to compile some tests: it is required to export
the operators overloading individually.

Note that Intel 2019 still does not compile, it freezes without
providing any error messages... ([`3386b95`](https://github.com/szaghi/FLAP/commit/3386b95a7f88c9bc6d4aeb491db8a7ae0b54c4f9))
- Support Defined I/O for GCC Fortran >= 7.x.y

Solution proposed by:
https://github.com/szaghi/StringiFor/issues/20#issuecomment-447919797 ([`dfa99f6`](https://github.com/szaghi/FLAP/commit/dfa99f6899b40aad6c47c490ffd3ada7031de376))
- Update stringifor_string_t.F90 ([`fa43797`](https://github.com/szaghi/FLAP/commit/fa437973e88864b08b41a9628cb0047a8e13933d))
- Merge pull request [#24](https://github.com/szaghi/FLAP/issues/24) from 14NGiestas/patch-1

Support Defined I/O for GCC Fortran >= 7.x.y ([`8bea525`](https://github.com/szaghi/FLAP/commit/8bea52594a518ce18662435869d0344ed75e1cca))
- Merge branch 'master' into develop ([`65ee6d7`](https://github.com/szaghi/FLAP/commit/65ee6d7e81d5ad4cba142b74451348d021b28e05))
- Clean preprocessing stuff for intel compiler

Clean preprocessing stuff for intel compiler: Intel compiler 19.1.0.075
compiles this version without any preprocessing flags, the compiler
issure about overloaded operators seems to be fixed.

Why:

*

This change addresses the need by:

*

Side effects:

* ([`5d603aa`](https://github.com/szaghi/FLAP/commit/5d603aa2b80bebc5953082d4353601fe821157d7))
- Clean all gfortran preprocessing flags ([`1063b00`](https://github.com/szaghi/FLAP/commit/1063b0088d024a18a9c45bac2138eb1b2c890d32))
- Update travis config ([`dd655a1`](https://github.com/szaghi/FLAP/commit/dd655a1ef278ef4e1d823b84dba454e8a4f34ee7))
- Merge branch 'release/1.0.0' ([`6c4177a`](https://github.com/szaghi/FLAP/commit/6c4177ae0d927897c1a7e4b05c622ada30d04628))

## [v0.9.9](https://github.com/szaghi/FLAP/tree/v0.9.9) (2018-11-29)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.8...v0.9.9)
### Miscellaneous
- Merge tag 'v0.9.8' into develop

Fix bug on basename method with strip last extension option ([`325502b`](https://github.com/szaghi/FLAP/commit/325502b0a5741bb654f8159008c2ca8c379b295b))
- Disable len overloading

Disable len overloading

Why:

Intel Compiler (18.0.0) does not accept the "len" overloading because it
is used into variables initialization into declaration and it does not
understand that the overloading procedures are "pure"... it is probably
necessary to reduce the error in order to fill a bug report. No time to
do it now.

This change addresses the need by:

Disable the len overloading interface.

Side effects:

It is not possible to perform "len(string)".

Must be re-introduced in the near future. ([`b805bab`](https://github.com/szaghi/FLAP/commit/b805babc13f871542956ba766ed875c200c816a1))
- Merge branch 'master' into develop ([`5bf79a6`](https://github.com/szaghi/FLAP/commit/5bf79a69d5e3df016a65672c809f171daf2f4bd7))
- Overload string name for on-the-fly-creator

Overload string name for on-the-fly-creator in order to create string
object on-the-fly (by means of character input) to be passed to other
procedures. ([`2b24063`](https://github.com/szaghi/FLAP/commit/2b24063f84c4b177d08d265cad49922b5e933922))
- Merge branch 'release/0.9.9' ([`517d906`](https://github.com/szaghi/FLAP/commit/517d9064e411e8a35e196c939be497e7fde402b7))

## [v0.9.8](https://github.com/szaghi/FLAP/tree/v0.9.8) (2017-11-23)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.7...v0.9.8)
### Miscellaneous
- Merge tag 'v0.9.7' into develop

Switch to doctests TDD

The tests suite is now based on doctests.

Stable release fully backward compatible. ([`e67ffac`](https://github.com/szaghi/FLAP/commit/e67ffac06161308aef71a9ee1cbbf728bdd225e9))
- Try to use gcc 7 on travis ([`28ab16f`](https://github.com/szaghi/FLAP/commit/28ab16f885624b562948a86314487b254a170548))
- Try to use gcc 7 on travis ([`cd22316`](https://github.com/szaghi/FLAP/commit/cd223164e8e2e7f31987d633770c4cd6b3c4e01b))
- Try to use gcc 7 on travis ([`691e00c`](https://github.com/szaghi/FLAP/commit/691e00c37db544f52adeb24526fb713a47e14423))
- Revert back to gfortran 6.3 compatible version, disable UDTIO for gfortran; GNU 7.x has big regression bugs... ([`fbdc657`](https://github.com/szaghi/FLAP/commit/fbdc6575d9fc1a12d3cfe397ba539c357a6fd605))
- Merge branch 'master' into develop ([`da8692f`](https://github.com/szaghi/FLAP/commit/da8692f62df5cb488c317a2448ae9e06cdc17c49))
- Fix bug in basename method

Fix bug in basename method: if strip last extension is passed with
a dummy argument not having an extension the result is a null string.
Now fixed. ([`d28ade2`](https://github.com/szaghi/FLAP/commit/d28ade28284ade6ee98e7538bf245b1f549aca36))
- Merge branch 'release/0.9.8' ([`d22648c`](https://github.com/szaghi/FLAP/commit/d22648c782479d1ca8248e3c0837a4504d6ca869))

## [v0.9.7](https://github.com/szaghi/FLAP/tree/v0.9.7) (2017-06-30)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.6...v0.9.7)
### Miscellaneous
- Merge tag 'v0.9.6' into develop

Fix issue[#16](https://github.com/szaghi/FLAP/issues/16)

Stable release, fully backward compatible. ([`fe74f54`](https://github.com/szaghi/FLAP/commit/fe74f54f8d4c43848a3cc51c5bfc6ab77bfcbe64))
- Minor general sanitize ([`59376a6`](https://github.com/szaghi/FLAP/commit/59376a6f6ab357b2995a1cb03e83d3c5416edd87))
- Update makefile ([`5f78dcb`](https://github.com/szaghi/FLAP/commit/5f78dcb0fe96e742d9259fe114ce53a619bbaa29))
- Update glob.f90 ([`e2442a7`](https://github.com/szaghi/FLAP/commit/e2442a7226a0cfa2baaa7afc7af3342330c79f08))
- Merge pull request [#17](https://github.com/szaghi/FLAP/issues/17) from ThemosTsikas/patch-1

Update glob.f90 ([`0c5b776`](https://github.com/szaghi/FLAP/commit/0c5b776bae1d79a19038b210ed72d4390768202e))
- Update submodules ([`9f40e01`](https://github.com/szaghi/FLAP/commit/9f40e0157ad3aaeea34044db6ed2eb56ee41edcc))
- Merge branch 'master' into develop ([`50cb0b0`](https://github.com/szaghi/FLAP/commit/50cb0b00d00374b6bb56e9b2cee97576b28830de))
- Start to add doctests and sanitize ([`1b26577`](https://github.com/szaghi/FLAP/commit/1b2657758d7558e21ac6f39b283526e4d05df8e3))
- Complete doctests ([`866959f`](https://github.com/szaghi/FLAP/commit/866959f74dfc0afb117e190f96d0806764639c1c))
- Complete doctest ([`c58ca47`](https://github.com/szaghi/FLAP/commit/c58ca475883a73a435a008f1033217d64c0993a3))
- Merge branch 'release/0.9.7' ([`9eb4f18`](https://github.com/szaghi/FLAP/commit/9eb4f18df85f69e9e59872d217df8b7fac3a1726))

## [v0.9.6](https://github.com/szaghi/FLAP/tree/v0.9.6) (2017-06-16)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.5...v0.9.6)
### Miscellaneous
- Merge tag 'v0.9.5' into develop

Improve read file performance, stable release, fully backward
compatible. ([`9a463e8`](https://github.com/szaghi/FLAP/commit/9a463e8fc2ca02b06a2e58f2cb10d4750e8d39b7))
- Trim out dangerous recursive git clone/update ([`32ce378`](https://github.com/szaghi/FLAP/commit/32ce37803a271cc705e6759edbae5d65eb6d9fc7))
- Update submodule ([`09c0124`](https://github.com/szaghi/FLAP/commit/09c01241a759032da4589c18ed86be69b2603a96))
- Merge branch 'master' into develop ([`ab13188`](https://github.com/szaghi/FLAP/commit/ab13188edc1d0f35c6caa54f7c92563d8bf262ad))
- Update submodules2
2 ([`c524f56`](https://github.com/szaghi/FLAP/commit/c524f5696048056f088f532286d59b1531cbd744))
- Fix issue[#16](https://github.com/szaghi/FLAP/issues/16)

Change intent of an host associated variable in `split_last_token` in
`split_chunked`: intent(out) is not standard conforming with pure
attribute.

The NAG Fortran Compiler notices that:

Error: src/StringiFor/stringifor_string_t.F90, line 1551: TOKENS cannot
be INTENT(OUT) actual arg in PURE procedure SPLIT_LAST_TOKEN

SPLIT_LAST_TOKEN is a PURE internal subroutine of PURE subroutine
SPLIT_CHUNKED which has a TOKENS INTENT(OUT) dummy argument. TOKENS is
accessed in SPLIT_LAST_TOKEN by host association and is used as the TO
actual argument of MOVE_ALLOC which is INTENT(OUT). That means TOKENS is
used in a "variable definition context" which is expressly not allowed
for host-association accessed entities.

The restriction is C1272 in "12.6 Pure procedures" of the 2003 Fortran
Standard. The Final Committee Draft (FCD) of the new Standard (Fortran
2003) is available as PDF from
http://www.dkuug.dk/jtc1/sc22/open/n3661.pdf

C1272
In a pure subprogram any designator with a base object that is [...]
accessed by [...] use association [...], shall not be used in the
following contexts:
(1) In a variable deﬁnition context(16.5.7);

16.5.7 Variable deﬁnition context
Some variables are prohibited from appearing in a syntactic context that
would imply deﬁnition or un- deﬁnition of the variable (5.1.2.7,
5.1.2.12, 12.6). The following are the contexts in which the appearance
of a variable implies such deﬁnition or undeﬁnition of the variable:
[...]
(10) An actual argument in a reference to a procedure with an explicit
interface if the associated dummy argument has the INTENT(OUT) or
INTENT(INOUT) attribute

Side effects:

Nothing ([`9c60ab5`](https://github.com/szaghi/FLAP/commit/9c60ab5356c619ca3b6b5c2a2c83b609037e9b28))
- Merge branch 'release/0.9.6' ([`2351c3c`](https://github.com/szaghi/FLAP/commit/2351c3c7f088449ed17959744e88af30ff5b2943))

## [v0.9.5](https://github.com/szaghi/FLAP/tree/v0.9.5) (2017-03-29)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.4...v0.9.5)
### Bug fixes
- Fix iostat return code when reading missing file ([`117c470`](https://github.com/szaghi/FLAP/commit/117c4708502a1160a2a54b7e40b456e170f76637))
- Fix test coverage and doc before release publication ([`318f2f5`](https://github.com/szaghi/FLAP/commit/318f2f593d3b1a3b1ab41e53d480601347b5ccc6))

### Miscellaneous
- Merge tag 'v0.9.4' into develop

Implement glob method

Implement glob method, stable release, fully backward compatible. ([`2848ccc`](https://github.com/szaghi/FLAP/commit/2848ccc3ebf85ace2e07b03eea5f4f6f531d376f))
- Fix bug in split method

Fix bug in split method: when sep occurs only 1 time at the start or the
end of the string there was a bug, that seems now fixed. ([`4ef642f`](https://github.com/szaghi/FLAP/commit/4ef642f60d9db23c9daef47440ff4187fb929606))
- Trim out impure keyword ([`7bf589b`](https://github.com/szaghi/FLAP/commit/7bf589b0c4b8824593f36872b60a6942ffcfc17b))
- Re-make pure split ([`4245131`](https://github.com/szaghi/FLAP/commit/4245131fa9f571329382bd2b5b1d551bb690fdfd))
- Fix bug in split method

Fix bug in split method: when sep occurs only at the start or the
end (or at both) of the string there was a bug, that seems now fixed. ([`1a1d236`](https://github.com/szaghi/FLAP/commit/1a1d23632b85a9021c6753046dbbf3cebbfb3d67))
- Add efficient file reader, chunked split and bugfix

Add efficient file reader, chunked split and bugfix:

+ the method `string%read_file` has now a new option for a very fast and
efficient reading of streamed file; it can be invoked as `string%read_file(file=file, is_fast=.true.)`

+ add the method `string%split_chunked` to split a string in chunked
trunks; this allows for a more efficient handling of memory than the
standard split;

+ fix a bug on `string%end_with` method;

Side effects:

Nothing. ([`425b119`](https://github.com/szaghi/FLAP/commit/425b119a878d77a5bb44f9ea96882dbe2793323a))
- Merge branch 'release/0.9.5' ([`1381251`](https://github.com/szaghi/FLAP/commit/1381251c2f1783fa4f080f3c449de8c4797ab39e))

## [v0.9.4](https://github.com/szaghi/FLAP/tree/v0.9.4) (2016-12-22)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.3...v0.9.4)
### Miscellaneous
- Merge tag 'v0.9.3' into develop

Implement tempname method, stable release, fully backward compatible. ([`d64b67e`](https://github.com/szaghi/FLAP/commit/d64b67e0ac1f1b831569dacc41981e514f3842d7))
- Implement glob method ([`1f51b40`](https://github.com/szaghi/FLAP/commit/1f51b40f5a770b81452ce99854e08b60de0629d3))
- Merge branch 'release/0.9.4' ([`2a80cfe`](https://github.com/szaghi/FLAP/commit/2a80cfec668cb501b5c7ff982814f18e3e5a155f))

## [v0.9.3](https://github.com/szaghi/FLAP/tree/v0.9.3) (2016-12-22)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.2...v0.9.3)
### Bug fixes
- Fix fobos/install.sh typos ([`95d78fa`](https://github.com/szaghi/FLAP/commit/95d78fac068b711d485522e51c474bbff7f21f34))

### Miscellaneous
- Merge tag 'v0.9.2' into develop

Update makefile, add install script

Stable release, fully backward compatible. ([`7d5dbce`](https://github.com/szaghi/FLAP/commit/7d5dbcecda5246d381159a745fbe3c215da3fac8))
- Implement tempname method ([`dcbbdbf`](https://github.com/szaghi/FLAP/commit/dcbbdbf07147042e6946be1c9c9ba9722aea819c))
- Merge branch 'release/0.9.3' ([`d4bdd78`](https://github.com/szaghi/FLAP/commit/d4bdd7808a0b6f0b4bb07e0f259abfa9f01abe74))

## [v0.9.2](https://github.com/szaghi/FLAP/tree/v0.9.2) (2016-10-06)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.1...v0.9.2)
### Bug fixes
- Fix tabs in .gitmodules ([`6b4d03c`](https://github.com/szaghi/FLAP/commit/6b4d03cc80d7344d8d63f08d0b95dd8cee33e6fd))

### Miscellaneous
- Merge tag 'v0.9.1' into develop

Fix bug on dynamic allocation of split method, stable release, fully backward compatible. ([`2f3646e`](https://github.com/szaghi/FLAP/commit/2f3646e7b8894d28b0361c0ab4d7d6a96876a494))
- Add GNU gfortran support to provided makefile ([`59b7f1e`](https://github.com/szaghi/FLAP/commit/59b7f1e2d58d2f79f188f6b36413258edc7d9540))
- Update PENF submodule ([`c7b8a99`](https://github.com/szaghi/FLAP/commit/c7b8a992dc5c4e9752affc4a3337ae65e875d189))
- Update readme ([`621c8de`](https://github.com/szaghi/FLAP/commit/621c8de04ae9400e7f106ef53b278f7a3cc121f0))
- Update fobos ([`017c66d`](https://github.com/szaghi/FLAP/commit/017c66d3fa39289aa4959b2fbe79935465de6d7b))
- Update PENF ([`47724ae`](https://github.com/szaghi/FLAP/commit/47724ae5f87c940c03c2b3e229fd85d6ef0b4a91))
- Update makefile ([`c3c96f5`](https://github.com/szaghi/FLAP/commit/c3c96f50bf15a6ea65c01b48b8b74ac4144cea21))
- Add install script ([`7440bd6`](https://github.com/szaghi/FLAP/commit/7440bd66d968ece06abb1d197dbc0d845a256ae0))
- Update codecov config ([`4248b41`](https://github.com/szaghi/FLAP/commit/4248b41bd69a94e9dd9dc3797b6d84af3066bf4e))
- Merge branch 'release/0.9.2' ([`c2bc234`](https://github.com/szaghi/FLAP/commit/c2bc234df5059c2ad8b341ffbc58be185805431d))

## [v0.9.1](https://github.com/szaghi/FLAP/tree/v0.9.1) (2016-09-14)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.9.0...v0.9.1)
### Bug fixes
- Fix doc typo ([`92bf01b`](https://github.com/szaghi/FLAP/commit/92bf01b1242b49c4c4654c523ac710515d0c0ba8))

### Miscellaneous
- Try to use gcc 5.3 on trusty beta image ([`06dc14d`](https://github.com/szaghi/FLAP/commit/06dc14d130025deb5869ce3cfbe88ed1db65f141))
- Try to use gcc 6.1 on trusty beta image ([`9be9bc8`](https://github.com/szaghi/FLAP/commit/9be9bc86cbfe39dc4d6fedf37aa86b5a598e8595))
- Amend README typo ([`b872b47`](https://github.com/szaghi/FLAP/commit/b872b47376fa337ec086cd087529d1e09965bb0f))
- Merge branch 'master' of github.com:szaghi/StringiFor ([`b5c8724`](https://github.com/szaghi/FLAP/commit/b5c8724c40409a85b3b5c8b367ff321194d29a0c))
- Update codecov config ([`08dd0ff`](https://github.com/szaghi/FLAP/commit/08dd0ff8af6a49ffe6ee6a5302350804d46d01ab))
- Update submodules ([`e3de30d`](https://github.com/szaghi/FLAP/commit/e3de30d0f0221ad0a87eb25f9478e4e7aa644790))
- Update to BeFoR64 ([`7127b51`](https://github.com/szaghi/FLAP/commit/7127b514725a82317a21801eea41006926cc28ef))
- Select master branch for submodules ([`57d7cc1`](https://github.com/szaghi/FLAP/commit/57d7cc16b4a1cb1672ccebd72802339d42cbbf57))
- Update submodules ([`fa73a1d`](https://github.com/szaghi/FLAP/commit/fa73a1d0443fdf7d3e3c3d090f6e23b102ff0dad))
- Update readme ([`87ab764`](https://github.com/szaghi/FLAP/commit/87ab764d8555568612ce053cc16561051dbf3f9b))
- Sanitze split method allocation logic ([`ae47a9d`](https://github.com/szaghi/FLAP/commit/ae47a9d2ca8fffba158603eeaa6174446ca86f10))
- Restore all checkings for intel debug mode except -check bound that generates a internal compiler error... ([`fc3a233`](https://github.com/szaghi/FLAP/commit/fc3a233b41c5c83aad0384b6cc8aebcb1ae9a247))
- Update fobos and travis ci config ([`4f8e42f`](https://github.com/szaghi/FLAP/commit/4f8e42f897aaff05c90d228f0b987c773866f8cd))
- Merge branch 'release/0.9.1' ([`8bfac08`](https://github.com/szaghi/FLAP/commit/8bfac0834d5701a96a882f5b75c4f42b6914ba9d))

## [v0.9.0](https://github.com/szaghi/FLAP/tree/v0.9.0) (2016-05-24)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.5...v0.9.0)
### Miscellaneous
- Add new version of BeFoR64

Add new version of BeFoR64 ([`9a72e69`](https://github.com/szaghi/FLAP/commit/9a72e6927fb904416146f49441b8a35747b5dc25))
- Re-Introduce support for gfortran 5.3

Re-Introduce support for gfortran 5.3 ([`15bcdbb`](https://github.com/szaghi/FLAP/commit/15bcdbbd6d2bcffe2c099215ef2bd274fd320a21))
- Update README ([`7030de0`](https://github.com/szaghi/FLAP/commit/7030de051f08b653aa542b9a8a14de7f524d0473))

## [v0.8.5](https://github.com/szaghi/FLAP/tree/v0.8.5) (2016-05-23)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.4...v0.8.5)
### Miscellaneous
- Merge tag 'v0.8.4' into develop

Add file-methods, stable release, fully backward compatible. ([`eff55ac`](https://github.com/szaghi/FLAP/commit/eff55ac5ffb34396a22eac42faa88b439be380cc))
- Add unescape method ([`cad1930`](https://github.com/szaghi/FLAP/commit/cad1930c5e9968d2f890600a13af907a9b56ef84))
- Add insert method ([`90f8d6a`](https://github.com/szaghi/FLAP/commit/90f8d6aec72099e7c41040320b64080b6378c006))
- Improve comparison analysis ([`e367e3f`](https://github.com/szaghi/FLAP/commit/e367e3f7ddf3b6a65c1c713529485a19b6f32dad))
- Try to use gfortran-6 ([`8df95a6`](https://github.com/szaghi/FLAP/commit/8df95a6f2e61b10317af5b88dd0b20ae74b7d190))
- Try to use gfortran-6, the hard way ([`94ac06e`](https://github.com/szaghi/FLAP/commit/94ac06ed2dd5853bba4180d77348528356d3cfba))
- Revert back to gfortran 5 to travis ci env, no way to use 6.x trunc ([`3dcc5dd`](https://github.com/szaghi/FLAP/commit/3dcc5ddddf0334e045d91c00bc15d1aa783f5124))
- Improve doc and add csv naive parser example ([`660357c`](https://github.com/szaghi/FLAP/commit/660357c13f26d2ce18a6ef7709e27855b10309da))
- Improve doc and add makefile ([`6f8f6dc`](https://github.com/szaghi/FLAP/commit/6f8f6dc76a56ab944f042b81f842f52033d307f1))
- Sanitize modules names prefixing stringifor_ ([`91ba98f`](https://github.com/szaghi/FLAP/commit/91ba98fd25f69cfa4a80afdd72519414dd9aed12))

## [v0.8.4](https://github.com/szaghi/FLAP/tree/v0.8.4) (2016-05-18)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.3...v0.8.4)
### Miscellaneous
- More verbose tests output ([`a4c034b`](https://github.com/szaghi/FLAP/commit/a4c034be33c16c4ebb539897b3eac5b5b3432315))
- Add gcc 6 to travis ci env ([`32527fd`](https://github.com/szaghi/FLAP/commit/32527fd8dbe0818e29ac3768b48a922d6c9d5b2d))
- Add gcc 6 to travis ci env, again ([`3a0b111`](https://github.com/szaghi/FLAP/commit/3a0b1119313880c9cad881ec6b8b5fa921c41501))
- Revert back to gfortran 5 to travis ci env, gcc 6 not yet allowed ([`8ed0a74`](https://github.com/szaghi/FLAP/commit/8ed0a74944127ef4d95e69d271064ca3ef45c553))
- Merge tag 'v0.8.2' into develop

Fix issue[#8](https://github.com/szaghi/FLAP/issues/8), stable release, fully backward compatible. ([`8090c61`](https://github.com/szaghi/FLAP/commit/8090c619c8180296f2abc0140c9ec7f2cc74eaee))
- Merge tag 'v0.8.3' into develop

Try to add gcc 5 to travis env, stable release, fully backward compatible. ([`dd87da7`](https://github.com/szaghi/FLAP/commit/dd87da7adfa64eb94b74937c9a2e020ee10c3ee9))
- Add read_line(s) methods

Add read_line(s) methods: read single line, and all lines of a formatted
connected unit, both as TBP or standalone procedure. ([`499ed18`](https://github.com/szaghi/FLAP/commit/499ed18e0b12753fa233c86399ca992a593927d7))
- Merge branch 'feature/add-read-record-method' into develop ([`eaf50cb`](https://github.com/szaghi/FLAP/commit/eaf50cbc43480656c45debf7aab86753dc5ab564))
- Add write line(s) method and procedure ([`c611fdd`](https://github.com/szaghi/FLAP/commit/c611fdd74e82ba6278da636aab56470a50a718fa))
- Extend read_line(s) to unformatted unit

Extend read_line(s) to unformatted unit: unformatted unit are supported
for only `access='stream'` and line termination is assumed to be
`new_line()`. ([`6ecc1ce`](https://github.com/szaghi/FLAP/commit/6ecc1ce091ce8efb859b2a63a73ca1f5eb3ef120))
- Extend write_lines format to support unformatted ([`47da164`](https://github.com/szaghi/FLAP/commit/47da164e62d20f0f7ce084d781d8a4415fcc9e04))
- Temporary disabled encode test due to Travis CI misterious bug (maybe gcc<6 fails) ([`e3e01b6`](https://github.com/szaghi/FLAP/commit/e3e01b63bd66882b3aea02d557a02401c2af2dd0))
- Add read_file method and standalone procedure

Add read_file method and standalone procedure ([`61d1631`](https://github.com/szaghi/FLAP/commit/61d1631e86a276c4bff8d5c7c6c901f3a6e4f3dd))
- Add wite_file method and standalone procedure ([`c96d48b`](https://github.com/szaghi/FLAP/commit/c96d48b8f7f6cfe942617fb45302f7cfe3c92ac9))
- Merge branch 'feature/add-file-methods' into develop ([`356f22d`](https://github.com/szaghi/FLAP/commit/356f22d0580a084f542c5212a4a3f02ac073430b))
- Merge branch 'release/0.8.4' ([`e277dd1`](https://github.com/szaghi/FLAP/commit/e277dd1dfca43d15f50ceaf1413b098bb2a6aeee))

## [v0.8.3](https://github.com/szaghi/FLAP/tree/v0.8.3) (2016-05-17)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.2...v0.8.3)
### Miscellaneous
- Try to add gcc 5 to travis env

Try to add gcc 5 to travis env ([`719b0e2`](https://github.com/szaghi/FLAP/commit/719b0e20228b97af1a0eb51ec278cebaf8a065f6))
- Merge branch 'hotfix/0.8.3' ([`f8b97d8`](https://github.com/szaghi/FLAP/commit/f8b97d858007d79f99cf6844929f8271d839d81d))

## [v0.8.2](https://github.com/szaghi/FLAP/tree/v0.8.2) (2016-05-16)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.1...v0.8.2)
### Bug fixes
- Fixed issue[#8](https://github.com/szaghi/FLAP/issues/8) ([`1197f57`](https://github.com/szaghi/FLAP/commit/1197f57ee1a60161d01a90ab04b103664a29c774))

### Miscellaneous
- Merge tag 'v0.8.1' into develop

Minor improve IO, add encode/decode for B64, stable release, fully backward compatible. ([`9abd8da`](https://github.com/szaghi/FLAP/commit/9abd8da9f9cabbe963622374bbc26a58adef59dd))
- Merge branch 'master' into develop ([`71ea567`](https://github.com/szaghi/FLAP/commit/71ea5673674ec6a8be72dab52d6cfd06e2c3d2a0))
- Merge branch 'release/0.8.2' ([`5a1e593`](https://github.com/szaghi/FLAP/commit/5a1e593500965a2bf5b0211656ec59fc3d6fa266))

## [v0.8.1](https://github.com/szaghi/FLAP/tree/v0.8.1) (2016-05-16)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.8.0...v0.8.1)
### Miscellaneous
- Merge tag 'v0.8.0' into develop

Stable release, not fully backward compatible. ([`e5694d2`](https://github.com/szaghi/FLAP/commit/e5694d2e423a663d9c81fe6a0b9fb238d3cafd1b))
- Add partial support for listdirected input

Add partial support for listdirected input.

Bugged: undelimited input with terminators before eor fails,
e.g. 'No quotes' does not return 'No'. ([`28066fc`](https://github.com/szaghi/FLAP/commit/28066fc04ae5c48599f89dd039f36ddd58a5a664))
- Add BeFoR64 dep and first encode test

Add BeFoR64 dep and first encode test ([`7290f86`](https://github.com/szaghi/FLAP/commit/7290f8681d9248e965854d2e2d43f2da1f0e94bd))
- Add decode method with test for b64

Add decode method with test for b64: in the test something strange
happens. The result seems ok (even in bits format), but the
"introspective" test with expected result fails. To be investigated. ([`7ef0efa`](https://github.com/szaghi/FLAP/commit/7ef0efaec4275493b3f969f32bc2955fbe53e7ad))
- Merge branch 'release/0.8.1' ([`094638a`](https://github.com/szaghi/FLAP/commit/094638a79771e5ff6f6ad64010f8e6019d252528))

## [v0.8.0](https://github.com/szaghi/FLAP/tree/v0.8.0) (2016-05-13)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.7.5...v0.8.0)
### Miscellaneous
- Merge tag 'v0.7.5' into develop

Improve operators and builtins overloading, stable release, fully backward compatibile. ([`4d19e19`](https://github.com/szaghi/FLAP/commit/4d19e19c4ab4948c4813a766d9fec3e7d45fbb3b))
- Improve IO

Improve IO: add formatted write of Ian Harvey. ([`5041bf5`](https://github.com/szaghi/FLAP/commit/5041bf51dafb3315974fbc3490742090351e55a9))
- Revert back to my basic defined IO

Revert back to my basic defined IO: the defined IO of Ian seems to be
somehow *overkilling* to my aims. I will refactor in the near future
Ian's work to fit more precisely to my aims. ([`48d0808`](https://github.com/szaghi/FLAP/commit/48d08084c02553f8bc4d91be0266cd03614fbbf4))
- Merge branch 'feature/improve-io' into develop ([`58c6b96`](https://github.com/szaghi/FLAP/commit/58c6b96a3ace28c42efec3c3b5de0a9de6ba541c))
- Migrate names of builtins-replacements methods

Migrate names of builtins-replacements methods. Add also some
overloading interfaces of those builtins procedures.

Side effects:

Refactor the sources structure: to sanitize the overloading interfaces
of builtins procedures these have be placed outside the definition of
the string class, thus a new module is added, namely the string_t.f90
module and the old stringifor.f90 module is used to define the
overlading interfaces and exposes objects to the user. ([`c2a1847`](https://github.com/szaghi/FLAP/commit/c2a1847fc7657b97f9a6c2c2115a117a2ac900a5))
- Improve doc ([`45f96a0`](https://github.com/szaghi/FLAP/commit/45f96a07a8132337597d2b62c066395f14ccad6d))
- Merge branch 'release/0.8.0' ([`870bec9`](https://github.com/szaghi/FLAP/commit/870bec9ebc543d3d415d1fd426baac66abcc8dc6))

## [v0.7.5](https://github.com/szaghi/FLAP/tree/v0.7.5) (2016-05-12)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.7.2...v0.7.5)
### Miscellaneous
- Merge tag 'v0.7.2' into develop

Stable release, fully backward compatible. ([`bc69412`](https://github.com/szaghi/FLAP/commit/bc69412f38efe6d0843fcced86ea09c10db65919))
- Add <,<=,==,>=,> operators

Add <,<=,==,>=,> operators and some builtins overloading interfaces. ([`154625e`](https://github.com/szaghi/FLAP/commit/154625ed3d7d729a0f43635c8b7a61f7f4a04add))
- Merge branch 'release/0.7.5' ([`ecb2d8a`](https://github.com/szaghi/FLAP/commit/ecb2d8ae3319452f62e11a9d1c11ba8b7e38d794))

## [v0.7.2](https://github.com/szaghi/FLAP/tree/v0.7.2) (2016-05-11)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.7.1...v0.7.2)
### Miscellaneous
- Merge tag 'v0.7.1' into develop

Improve documentation, stable release, fully backward compatible. ([`aac5202`](https://github.com/szaghi/FLAP/commit/aac52026b8e2ce56d407d38fcc79ead7d015ee1a))
- Improve doc ([`813b910`](https://github.com/szaghi/FLAP/commit/813b91070a1cb836fa4d5d58e7184e3a3b0d4699))
- Try to fix codecov issue to ignore penf ([`22c3012`](https://github.com/szaghi/FLAP/commit/22c3012331188d14bfd490eb72620c015d23cbea))
- Update .gitignore ([`64bf52d`](https://github.com/szaghi/FLAP/commit/64bf52df48adf068eb61bd039aad84c482f073ff))
- Add slice method ([`9b0459f`](https://github.com/szaghi/FLAP/commit/9b0459ff5fe09885c2aa197336ef4956cde1de44))
- Merge branch 'release/0.7.2' ([`0652f9f`](https://github.com/szaghi/FLAP/commit/0652f9f284727f2c6d60d4a5a870633752d37326))

## [v0.7.1](https://github.com/szaghi/FLAP/tree/v0.7.1) (2016-05-11)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.7.0...v0.7.1)
### Bug fixes
- Fix codecov settings ([`9dfea69`](https://github.com/szaghi/FLAP/commit/9dfea69a236436b43dbbad20ad6ababe417a75de))

### Miscellaneous
- Merge tag 'v0.7.0' into develop

Add many methods in particular the search one, stable release, fully backward compatible. ([`e05e0d7`](https://github.com/szaghi/FLAP/commit/e05e0d795187c04d49812fb213ccb15ac0ef9aef))
- Merge branch 'master' into develop ([`190e9c2`](https://github.com/szaghi/FLAP/commit/190e9c206583a7619987beed137ae3fbba023a6f))
- Add licence files ([`475445c`](https://github.com/szaghi/FLAP/commit/475445c5d039f21105f07843884b61ca273853a5))
- Add contributing guidelineswq ([`d885159`](https://github.com/szaghi/FLAP/commit/d885159317baefee000e918c84a9733b788ba0aa))
- Expand README ([`6d5b523`](https://github.com/szaghi/FLAP/commit/6d5b523d4abdedea73926074cdb1965afdd1ee6c))
- Merge branch 'release/0.7.1' ([`11a045d`](https://github.com/szaghi/FLAP/commit/11a045db2f65329c97919e780d8ab2b8f65e0e8d))

## [v0.7.0](https://github.com/szaghi/FLAP/tree/v0.7.0) (2016-05-11)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.6.0...v0.7.0)
### Miscellaneous
- Test codecov custom settings ([`b742f85`](https://github.com/szaghi/FLAP/commit/b742f855b82913acedabf615baf692aea7bdf9b8))
- Add search method

Add search method: search for *tagged* record defined into string (or
into passed buffers) and return the string record if found. Optionally,
returns also the tag start/end indexes into the original string buffer.

This method can be helpfully used to build XML-like parser, both SAX or
DOM parsers. ([`8e59462`](https://github.com/szaghi/FLAP/commit/8e59462de259679ebeca98a77fd72ac0428f43ac))
- Update codecov settings ([`6616b83`](https://github.com/szaghi/FLAP/commit/6616b83f2e1fc02bb0446525c89227ef5a4d2a3a))
- Merge branch 'release/0.7.0' ([`e71e93b`](https://github.com/szaghi/FLAP/commit/e71e93b668d5f0f483b6b4b0a0b73cfc86cf6669))

## [v0.6.0](https://github.com/szaghi/FLAP/tree/v0.6.0) (2016-05-10)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.5.0...v0.6.0)
### Miscellaneous
- Merge tag 'v0.5.0' into develop

Add assignments to numbers (real and integer), stable release, not backward compatible ([`9694b1e`](https://github.com/szaghi/FLAP/commit/9694b1e3253f30764d7a904fd78446e831e1980b))
- Add extension (get) method ([`6909334`](https://github.com/szaghi/FLAP/commit/6909334ea356d58ddcc91b4cc5f6aede1a6411ae))
- Add escape method ([`62a63c1`](https://github.com/szaghi/FLAP/commit/62a63c192c5a990cee39da392ecd961e9b27bd0e))
- Add reverse method ([`51c796d`](https://github.com/szaghi/FLAP/commit/51c796dfa1194e9a45212318aaa77beaa8307212))
- Add join method, as in python ([`8098d49`](https://github.com/szaghi/FLAP/commit/8098d4982eab631c1bfa6c98eb1835c6e4fa630d))
- Add startcase method ([`92f5bcb`](https://github.com/szaghi/FLAP/commit/92f5bcb6996812ba357a71f690fa5c80b529d9e7))
- Add CamelCase method ([`c63cfa7`](https://github.com/szaghi/FLAP/commit/c63cfa7c75d45c0ebbe2b3a09a34fb22d9b3c3c3))
- Add snake_case method ([`4d122ba`](https://github.com/szaghi/FLAP/commit/4d122bae55c379844556044b279e986a6073eca6))
- Add fill method ([`0503d76`](https://github.com/szaghi/FLAP/commit/0503d768c8c1a2f637454caddb17f6814b8fbb4e))
- Modify join method

Modify join method: by default use self as join-separator, if self is
not allocated set sep to null string ''. It still can be overridden by
user custom value. ([`f52bcf6`](https://github.com/szaghi/FLAP/commit/f52bcf6116d4254916fad6c5c882c0f34cee655c))
- Add number casting from string ([`5abe5e0`](https://github.com/szaghi/FLAP/commit/5abe5e014a4e48772caa9da32b2f79dc60e3b11f))
- Add R16P support for assignments and number casting ([`e8b29af`](https://github.com/szaghi/FLAP/commit/e8b29af2438eea35d2d9ea23306ddf95f4b86cdf))

## [v0.5.0](https://github.com/szaghi/FLAP/tree/v0.5.0) (2016-05-09)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.4.0...v0.5.0)
### Miscellaneous
- Merge tag 'v0.4.0' into develop

Stable release, fully backward compatible. ([`72e0ee1`](https://github.com/szaghi/FLAP/commit/72e0ee1a7dd7623d3a380cd60cb973a6746685bc))
- Add is-number method

Add is-number method ([`7c17e15`](https://github.com/szaghi/FLAP/commit/7c17e159c1b38932a89d1a4d814bd5a6c9f6d7b0))
- Add number assignments

Add number assignments: this is done by means of PENF that is now
a submodule. ([`102d2bb`](https://github.com/szaghi/FLAP/commit/102d2bb7b56739583f9e7af46e632129497493c5))
- Merge branch 'release/0.5.0' ([`1273f81`](https://github.com/szaghi/FLAP/commit/1273f81bfef9b5df246e43f7301546fa97f966ff))

## [v0.4.0](https://github.com/szaghi/FLAP/tree/v0.4.0) (2016-05-09)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.3.0...v0.4.0)
### Miscellaneous
- Merge tag 'v0.3.0' into develop

Add defaults, change API, stable release, NOT backward compatible. ([`4226008`](https://github.com/szaghi/FLAP/commit/42260088c42f0c26762aa1107587da6bb8959714))
- Add basename/dir methods

Add basename/dir methods ([`351e362`](https://github.com/szaghi/FLAP/commit/351e36274e339c65c14ffcc325004953e25d1d1d))
- Add is integer-real inquire methods

Add is integer-real inquire methods ([`7b0822e`](https://github.com/szaghi/FLAP/commit/7b0822e6847a4ed664ee43ffcf2eb92d006c2d95))
- Merge branch 'release/0.4.0' ([`a5f4991`](https://github.com/szaghi/FLAP/commit/a5f4991b950f3bc6fbfe2c8da6b5f6b5519f0beb))

## [v0.3.0](https://github.com/szaghi/FLAP/tree/v0.3.0) (2016-05-09)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.2.0...v0.3.0)
### Miscellaneous
- Merge tag 'v0.2.0' into develop

Stable release, fully backward compatible. ([`02a5cbf`](https://github.com/szaghi/FLAP/commit/02a5cbf118a224a6db603e5efec4d9905b46b834))
- Add common defaults

+ Add common defaults: break backward compatibility, (API change), of
methods using separator-like arguments (that are now optional);
+ add character default kind;
+ refactor tests factory; ([`73efccb`](https://github.com/szaghi/FLAP/commit/73efccb356a378159f1df1f72b9e746a46458b07))
- Merge branch 'release/0.3.0' ([`91f2716`](https://github.com/szaghi/FLAP/commit/91f2716846cafe7e07a775266ad71aed400ce16d))

## [v0.2.0](https://github.com/szaghi/FLAP/tree/v0.2.0) (2016-05-09)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.1.0...v0.2.0)
### Miscellaneous
- Merge tag 'v0.1.0' into develop

Add main python str methods, stable release, fully backward compatible ([`19c485a`](https://github.com/szaghi/FLAP/commit/19c485aee19e21c6521afb099eaa2c4ff7ae0458))
- Add free method and fix tests

Add free method and fix tests ([`4012c05`](https://github.com/szaghi/FLAP/commit/4012c053b1f9f819509d257854dbd0ecee91e666))
- Merge branch 'release/0.2.0' ([`dd6b2d7`](https://github.com/szaghi/FLAP/commit/dd6b2d7907c3bb8a972d29d03a2f5b64986c1b5f))

## [v0.1.0](https://github.com/szaghi/FLAP/tree/v0.1.0) (2016-05-06)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.0.2...v0.1.0)
### Miscellaneous
- Merge tag 'v0.0.2' into develop

Add many builtins, first stable release. ([`7948293`](https://github.com/szaghi/FLAP/commit/794829309434d7b2353ced41296bb125c847ce08))
- Update GNU compiler support ([`9f433bb`](https://github.com/szaghi/FLAP/commit/9f433bb226ec5a878e1192a206f001c82b0a6ff1))
- Update main features ([`384c085`](https://github.com/szaghi/FLAP/commit/384c085890a7dbdf73be6da8e15bb7fe41802c40))
- Merge branch 'master' of github.com:szaghi/StringiFor ([`a93b0c9`](https://github.com/szaghi/FLAP/commit/a93b0c9f5d72c8eecd169bf5f67cfc7ba61f1090))
- Merge branch 'master' into develop ([`98607e8`](https://github.com/szaghi/FLAP/commit/98607e8ee5e512343cda1ffd106e1901e2aa2ebe))
- Add UPPER-lower methods

Add UPPER-lower methods: convert a string to all UPPER or all lower case
characters. ([`213545c`](https://github.com/szaghi/FLAP/commit/213545c0116c3c21e61ede00489d01d136f11c40))
- Add python str methods

Add python str methods. ([`7d39a7d`](https://github.com/szaghi/FLAP/commit/7d39a7d7c386a1a6e1f42a624e9f0cfa389a4b0f))
- Merge branch 'release/0.1.0' ([`22b080b`](https://github.com/szaghi/FLAP/commit/22b080b7ec8a89d5abd83eea72ee9318fbb9bd88))

## [v0.0.2](https://github.com/szaghi/FLAP/tree/v0.0.2) (2016-05-05)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v0.0.1...v0.0.2)
### Miscellaneous
- Merge tag 'v0.0.1' into develop

First manifesto, empty bottle. ([`cdf99fc`](https://github.com/szaghi/FLAP/commit/cdf99fcb7e386f6c648c650a35ba17175a08b2e2))
- Add first tree skeleton

Add first tree skeleton: there is a base class with few minimal tests. ([`77ba688`](https://github.com/szaghi/FLAP/commit/77ba688ee870fa9470b018e86ae24af6fefa2b63))
- Add defined-io-gnu workaround

Add defined-io-gnu workaround: pollute the code with preprocessing flags
to disable defined IO when GNU gfortran is used... so frustrating! ([`053e472`](https://github.com/szaghi/FLAP/commit/053e472062b339614c0c0c41a4f3755e42cceffd))
- Add casting-to-character method

Add casting-to-character method: this allows to IO raw characters data. ([`575049f`](https://github.com/szaghi/FLAP/commit/575049fa200cfc92b41d0068472a5e3f75843dd8))
- Change API of concatenation operator

Change API of concatenation operator: the // operator returns a standard
character instance while the new .cat. operator returns a string. ([`081fc63`](https://github.com/szaghi/FLAP/commit/081fc63d33d01775d311a41fb30bb970ebfa2357))
- Add index builtin replacement

Add index builtin replacement: for namespace safety it is called sindex
and it is implemented as a string method rather as interface overloading
the builtin. ([`885fd26`](https://github.com/szaghi/FLAP/commit/885fd2697b5e53d5fb7b14ad1b53d6aa68e95b43))
- Add left/right adjust builtins replacements

Add left/right adjust builtins replacements: for namespace safety they are called
sadjustl/r they are implemented as a string method rather as interface overloading
the builtins. ([`ade3527`](https://github.com/szaghi/FLAP/commit/ade352798f0d34505ff1f4b588d9d521e1ac0d22))
- Add len/len_trim builtins replacements

Add len/len_trim builtins replacements: for namespace safety they are called
slen/slen_trim they are implemented as a string method rather as interface overloading
the builtins. ([`5476c30`](https://github.com/szaghi/FLAP/commit/5476c30862eca0b4b88e45713fce424375340f55))
- Add repeat builtin replacement

Add repeat builtin replacement

Add repeat builtin replacement: for namespace safety it is called srepeat
and it is implemented as a string method rather as interface overloading
the builtin. ([`7f07ee2`](https://github.com/szaghi/FLAP/commit/7f07ee23965687d44ff5027383296d657b25bdb7))
- Add scan builtin replacement

Add scan builtin replacement

Add scan builtin replacement: for namespace safety it is called sscan
and it is implemented as a string method rather as interface overloading
the builtin. ([`1137f18`](https://github.com/szaghi/FLAP/commit/1137f1889d24900b34ee322fbeb572bb7c8c463d))
- Add trim builtin replacement

Add trim builtin replacement

Add trim builtin replacement: for namespace safety it is called strim
and it is implemented as a string method rather as interface overloading
the builtin. ([`85698c6`](https://github.com/szaghi/FLAP/commit/85698c6c50e87c20f42bdb4bf7069ab492128cde))
- Add verify builtin replacement

Add verify builtin replacement

Add verify builtin replacement: for namespace safety it is called
sverify and it is implemented as a string method rather as interface
overloading the builtin. ([`f693993`](https://github.com/szaghi/FLAP/commit/f69399301ff54138dd5a350700e9c89aa7daf6c0))
- Add many builtins

Add many builtins ([`6a4933b`](https://github.com/szaghi/FLAP/commit/6a4933b7b114fea24557f7d0ad7630250b6788cb))
- Merge branch 'release/0.0.2' ([`8c5abad`](https://github.com/szaghi/FLAP/commit/8c5abad47352cdf437fcaf4496f24a7c1794d7a3))

## [v0.0.1](https://github.com/szaghi/FLAP/tree/v0.0.1) (2016-05-04)
### Miscellaneous
- Initial commit ([`26ec3b9`](https://github.com/szaghi/FLAP/commit/26ec3b95aa367de2574ebb9ffadbf306a66b5a10))
- Add README baseline

Add README baseline: first manifesto of the project aims. ([`04864c7`](https://github.com/szaghi/FLAP/commit/04864c730dbfddbf3bb5ce32c35fbba7e149bb26))
- Merge branch 'release/0.0.1' ([`c889168`](https://github.com/szaghi/FLAP/commit/c889168871a33114c3dfe4ae77fe855ec0c0713a))


