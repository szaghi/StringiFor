!< StringiFor, Strings Fortran, yet another stringify Fortran module
module stringifor
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor, Strings Fortran, yet another stringify Fortran module
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
save
public :: string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: string
  private
  character(len=:), allocatable :: raw !< Raw data.
  contains
    ! public methods
    generic :: assignment(=) => string_assign_string, &
                                string_assign_character   !< Assignment operator overloading.
    generic :: operator(//) => string_concat_string,    &
                               string_concat_character, &
                               character_concat_string    !< Concatenation operator overloading.
#ifndef __GFORTRAN__
    generic :: read(formatted) => read_formatted          !< Formatted input.
    generic :: write(formatted) => write_formatted        !< Formatted output.
    generic :: read(unformatted) => read_unformatted      !< Unformatted input.
    generic :: write(unformatted) => write_unformatted    !< Unformatted output.
#endif
    ! private methods
    procedure, private, pass(lhs) :: string_assign_string    !< Assignment operator from string input.
    procedure, private, pass(lhs) :: string_assign_character !< Assignment operator from character input.
    procedure, private, pass(lhs) :: string_concat_string    !< Concatenation with string.
    procedure, private, pass(lhs) :: string_concat_character !< Concatenation with character.
    procedure, private, pass(rhs) :: character_concat_string !< Concatenation with character (inverted).
    procedure, private, pass(dtv) :: read_formatted          !< Formatted input.
    procedure, private, pass(dtv) :: write_formatted         !< Formatted output.
    procedure, private, pass(dtv) :: read_unformatted        !< Unformatted input.
    procedure, private, pass(dtv) :: write_unformatted       !< Unformatted output.
endtype string
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  elemental subroutine string_assign_string(lhs, rhs)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Assignment operator from string input.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(inout) :: lhs !< Left hand side.
  type(string),  intent(in)    :: rhs !< Right hand side.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(rhs%raw)) lhs%raw = rhs%raw
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine string_assign_string

  elemental subroutine string_assign_character(lhs, rhs)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Assignment operator from character input.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: lhs !< Left hand side.
  character(len=*), intent(in)    :: rhs !< Right hand side.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  lhs%raw = rhs
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine string_assign_character

  pure function string_concat_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with string.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string), intent(in)     :: lhs       !< Left hand side.
  type(string),  intent(in)     :: rhs       !< Right hand side.
  type(string)                  :: concat    !< Concatenated string.
  character(len=:), allocatable :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  temporary = ''
  if (allocated(lhs%raw)) temporary = lhs%raw
  if (allocated(rhs%raw)) temporary = temporary//rhs%raw
  if (temporary/='') concat%raw = temporary
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_string

  pure function string_concat_character(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in) :: lhs    !< Left hand side.
  character(len=*), intent(in) :: rhs    !< Right hand side.
  type(string)                 :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(lhs%raw)) then
    concat%raw = lhs%raw//rhs
  else
    concat%raw = rhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction string_concat_character

  pure function character_concat_string(lhs, rhs) result(concat)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Concatenation with character (inverted).
  !---------------------------------------------------------------------------------------------------------------------------------
  character(len=*), intent(in) :: lhs    !< Left hand side.
  class(string),    intent(in) :: rhs    !< Right hand side.
  type(string)                 :: concat !< Concatenated string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(rhs%raw)) then
    concat%raw = lhs//rhs%raw
  else
    concat%raw = lhs
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction character_concat_string

  subroutine read_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted input.
  !<
  !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  character(len=100)              :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  read(unit, "(A)", iostat=iostat, iomsg=iomsg)temporary
  dtv%raw = trim(temporary)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_formatted

  subroutine write_formatted(dtv, unit, iotype, v_list, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Formatted output.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)    :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  character(len=*), intent(in)    :: iotype    !< Edit descriptor.
  integer,          intent(in)    :: v_list(:) !< Edit descriptor list.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(dtv%raw)) then
    write(unit, "(A)", iostat=iostat, iomsg=iomsg)dtv%raw
  else
    write(unit, "(A)", iostat=iostat, iomsg=iomsg)''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_formatted

  subroutine read_unformatted(dtv, unit, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Unformatted input.
  !<
  !< @bug Change temporary acks: find a more precise length of the input string and avoid the trimming!
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(inout) :: dtv       !< The string.
  integer,          intent(in)    :: unit      !< Logical unit.
  integer,          intent(out)   :: iostat    !< IO status code.
  character(len=*), intent(inout) :: iomsg     !< IO status message.
  character(len=100)              :: temporary !< Temporary storage string.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  read(unit, iostat=iostat, iomsg=iomsg)temporary
  dtv%raw = trim(temporary)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine read_unformatted

  subroutine write_unformatted(dtv, unit, iostat, iomsg)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Unformatted output.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(string),    intent(in)    :: dtv    !< The string.
  integer,          intent(in)    :: unit   !< Logical unit.
  integer,          intent(out)   :: iostat !< IO status code.
  character(len=*), intent(inout) :: iomsg  !< IO status message.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(dtv%raw)) then
    write(unit, iostat=iostat, iomsg=iomsg)dtv%raw
  else
    write(unit, iostat=iostat, iomsg=iomsg)''
  endif
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine write_unformatted
endmodule stringifor
