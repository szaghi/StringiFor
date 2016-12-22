!< StringiFor `glob` test.
program glob
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `glob` test.
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)                  :: astring        !< A string.
type(string),     allocatable :: alist_str(:)   !< A list (string).
character(len=:), allocatable :: alist_chr(:)   !< A list (character).
integer, parameter            :: Nf=5           !< Maximum number of files.
character(14)                 :: files(1:Nf)    !< Files list.
integer                       :: file_unit      !< File unit.
integer                       :: f              !< Counter.
integer                       :: ff             !< Counter.
logical                       :: test_passed(2) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

do f=1, Nf
  files(f) = astring%tempname(prefix='foo-')
  print*, 'Create file '//files(f)
  open(newunit=file_unit, file=files(f))
  write(file_unit, *)f
  close(unit=file_unit)
enddo

call astring%glob(pattern='foo-*', list=alist_str)
call astring%glob(pattern='foo-*', list=alist_chr)

do f=1, Nf
  open(newunit=file_unit, file=files(f))
  close(unit=file_unit, status='delete')
enddo

if (size(alist_str, dim=1) /= Nf) error stop 'error: glob search failed'
if (size(alist_chr, dim=1) /= Nf) error stop 'error: glob search failed'

print*, ' Files found by glob (string output)'
outer_str: do f=1, size(alist_str, dim=1)
  print*, alist_str(f)%chars()
  do ff=1, Nf
    test_passed(1) = alist_str(f) == files(f)
    if (test_passed(1)) cycle outer_str
  enddo
enddo outer_str

print*, ' Files found by glob (character output)'
outer_chr: do f=1, size(alist_chr, dim=1)
  print*, alist_chr(f)
  do ff=1, Nf
    test_passed(2) = alist_chr(f) == files(f)
    if (test_passed(2)) cycle outer_chr
  enddo
enddo outer_chr

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram glob
