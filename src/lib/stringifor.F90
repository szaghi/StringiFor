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
! expose StingiFor new procedures
public :: read_lines, write_lines
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
contains
  subroutine read_lines(unit, lines, form, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Read lines (records) from a connected-formatted unit.
  !<
  !< @note The connected unit is rewinded. At a successful exit current record is at eof, at the beginning otherwise.
  !<
  !< The lines are returned as an array of strings that are read until the eof is reached.
  !< The line is read as an ascii stream read until the eor is reached.
  !<
  !< @note For unformatted read only `access='stream'` is supported with new_line as line terminator.
  !---------------------------------------------------------------------------------------------------------------------------------
  integer,          intent(in)               :: unit     !< Logical unit.
  type(string),     intent(out), allocatable :: lines(:) !< The lines.
  character(len=*), intent(in),    optional  :: form     !< Format of unit.
  integer,          intent(out),   optional  :: iostat   !< IO status code.
  character(len=*), intent(inout), optional  :: iomsg    !< IO status message.
  type(string)                               :: form_    !< Format of unit, local variable.
  integer                                    :: iostat_  !< IO status code, local variable.
  character(len=:), allocatable              :: iomsg_   !< IO status message, local variable.
  character(kind=CK, len=1)                  :: ch       !< Character storage.
  integer                                    :: l        !< Counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  form_ = 'FORMATTED' ; if (present(form)) form_ = form ; form_ = form_%upper()
  iomsg_ = repeat(' ', 99) ; if (present(iomsg)) iomsg_ = iomsg
  rewind(unit)
  select case(form_%chars())
  case('FORMATTED')
    l = 0
    do
      read(unit, *, err=10, end=10)
      l = l + 1
    enddo
  case('UNFORMATTED')
    l = 0
    do
      read(unit, err=10, end=10) ch
      if (ch==new_line('a')) l = l + 1
    enddo
  endselect
  10 rewind(unit)
  if (l>0) then
    allocate(lines(1:l))
    l = 0
    iostat_ = 0
    do
      l = l + 1
      call lines(l)%read_line(unit=unit, form=form, iostat=iostat_, iomsg=iomsg_)
      if (iostat_/=0.and..not.is_iostat_eor(iostat_)) then
        exit
      endif
    enddo
  endif
  if (present(iostat)) iostat = iostat_
  if (present(iomsg)) iomsg = iomsg_
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_lines

  subroutine write_lines(unit, lines, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Write lines (records) to a connected-formatted unit.
  !---------------------------------------------------------------------------------------------------------------------------------
  integer,          intent(in)              :: unit      !< Logical unit.
  type(string),     intent(in)              :: lines(1:) !< The lines.
  integer,          intent(out),   optional :: iostat    !< IO status code.
  character(len=*), intent(inout), optional :: iomsg     !< IO status message.
  integer                                   :: l         !< Counter.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  do l=1, size(lines, dim=1)
    call lines(l)%write_line(unit=unit, iostat=iostat, iomsg=iomsg)
  enddo
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_lines
endmodule stringifor
