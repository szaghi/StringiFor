!< Checker of the Unicode property tables (issue #51, step 0.4), run by scripts/utf8/gen_unicode_tables.py --check-driver.
!<
!< Looks every codepoint 0..10FFFF up in each table with `in_ranges` and prints the ranges found, one per line:
!< "TABLE FIRST LAST" (decimal). The generator compares them with its own per-codepoint reading of the UCD files, so
!< both the tables and the lookup are checked on the whole codespace. Then prints the full case folding of every codepoint
!< that `case_fold` changes: "CASE_FOLD CODEPOINT TO..." (decimal).
program check_tables
use penf, only : I4P
use stringifor_unicode_tables, only : case_fold, in_ranges, PUNCT_SYMBOL_RANGES, WHITE_SPACE_RANGES, WIDE_RANGES, ZERO_WIDTH_RANGES
implicit none

call scan_table('WIDE_RANGES', WIDE_RANGES)
call scan_table('ZERO_WIDTH_RANGES', ZERO_WIDTH_RANGES)
call scan_table('WHITE_SPACE_RANGES', WHITE_SPACE_RANGES)
call scan_table('PUNCT_SYMBOL_RANGES', PUNCT_SYMBOL_RANGES)
call scan_folding


contains
  subroutine scan_table(name, ranges)
  !< Print the ranges of codepoints the lookup finds in a table.
  character(len=*), intent(in) :: name        !< Table name.
  integer(I4P),     intent(in) :: ranges(:,:) !< Table.
  integer(I4P)                 :: codepoint   !< Codepoint.
  integer(I4P)                 :: first       !< First codepoint of the current range, -1 if none.

  first = -1
  do codepoint = 0, int(z'10FFFF', I4P)
    if (in_ranges(codepoint, ranges)) then
      if (first < 0) first = codepoint
    elseif (first >= 0) then
      write(*, '(a,1x,i0,1x,i0)') name, first, codepoint - 1
      first = -1
    endif
  enddo
  if (first >= 0) write(*, '(a,1x,i0,1x,i0)') name, first, int(z'10FFFF', I4P)
  endsubroutine scan_table

  subroutine scan_folding
  !< Print the case folding of every codepoint that has one.
  integer(I4P) :: codepoint !< Codepoint.
  integer(I4P) :: folded(3) !< Its folding.
  integer      :: n         !< Codepoints of the folding.

  do codepoint = 0, int(z'10FFFF', I4P)
    call case_fold(codepoint, folded, n)
    if (n > 1 .or. folded(1) /= codepoint) write(*, '(a,*(1x,i0))') 'CASE_FOLD', codepoint, folded(1:n)
  enddo
  endsubroutine scan_folding
endprogram check_tables
