!< StringiFor, Strings Fortran, yet another stringify Fortran module
module stringifor
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor, Strings Fortran, yet another stringify Fortran module
!-----------------------------------------------------------------------------------------------------------------------------------
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P
use string_t, only : CK,                                                                     &
                     sadjustl_character, sadjustr_character,                                 &
                     sindex_string_string, sindex_string_character, sindex_character_string, &
                     slen, slen_trim,                                                        &
                     srepeat_string_string,                                                  &
                     sscan_string_string, sscan_string_character, sscan_character_string,    &
                     strim,                                                                  &
                     string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
save
! expose StingiFor objects
public :: CK
public :: string
! expose StingiFor overloaded builtins
public :: adjustl, adjustr, index, len, len_trim, repeat, scan, trim
! expose PENF kinds
public :: I1P, I2P, I4P, I8P, R4P, R8P, R16P
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
! builtins overloading interfaces
interface adjustl
  !< Builtin adjustl overloading.
  module procedure sadjustl_character
endinterface adjustl
interface adjustr
  !< Builtin adjustr overloading.
  module procedure sadjustr_character
endinterface adjustr
interface index
  !< Builtin index overloading.
  module procedure sindex_string_string, sindex_string_character, sindex_character_string
endinterface index
interface len
  !< Builtin len overloading.
  module procedure slen
endinterface len
interface len_trim
  !< Builtin len_trim overloading.
  module procedure slen_trim
endinterface len_trim
interface repeat
  !< Builtin repeat overloading.
  module procedure srepeat_string_string
endinterface repeat
interface scan
  !< Builtin scan overloading.
  module procedure sscan_string_string, sscan_string_character, sscan_character_string
endinterface scan
interface trim
  !< Builtin trim overloading.
  module procedure strim
endinterface trim
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule stringifor
