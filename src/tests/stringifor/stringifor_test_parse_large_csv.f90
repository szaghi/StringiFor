!< StringiFor `csv_naive_parser` test.
program stringifor_test_parse_large_csv
!< StringiFor `csv_naive_parser` test.
use stringifor

implicit none
type(string)                  :: csv            !< The CSV file as a single stream.
type(string), allocatable     :: rows(:)        !< The CSV table rows.
type(string), allocatable     :: columns(:)     !< The CSV table columns.
type(string), allocatable     :: cells(:,:)     !< The CSV table cells.
integer                       :: rows_number    !< The CSV file rows number.
integer                       :: columns_number !< The CSV file columns number.
integer                       :: c, r           !< Counter.
logical                       :: test_passed(5) !< List of passed tests.

test_passed = .false.

call csv%read_file(file='src/tests/stringifor/stringifor_test_parse_large_csv.csv', is_fast=.true.)
call csv%split_chunked(tokens=rows, sep=new_line('a'), chunks=10) ! get the CSV file rows
rows_number = size(rows, dim=1)                                   ! get the CSV file rows number
columns_number = rows(1)%count(',') + 1                           ! get the CSV file columns number
allocate(cells(1:columns_number, 1:rows_number))                  ! allocate the CSV file cells
do r=1, rows_number                                               ! parse all cells
  call rows(r)%split(tokens=columns, sep=',')                     ! get current columns
  cells(1:columns_number, r) = columns                            ! save current columns into cells
enddo

! now you can do whatever with your parsed data
! print the table in markdown syntax
print "(A)", 'A markdown-formatted table'
print "(A)", ''
print "(A)", '|'//csv%join(array=cells(:, 1), sep='|')//'|'
do c=1, columns_number
   columns(c) = '----' ! re-use columns for printing separators
enddo
print "(A)", '|'//csv%join(array=columns, sep='|')//'|'
do r=2, rows_number
  print "(A)", '|'//csv%join(array=cells(:, r), sep='|')//'|'
enddo
print "(A)", ''

test_passed(1) = rows_number==1000
test_passed(2) = columns_number==23
test_passed(3) = cells(1, 1)=='488.750000000000000'
test_passed(4) = cells(6, 1)=='935.544846279384000'
test_passed(5) = cells(23, 1000)=='0.000000000000000'
print "(A,L1)", new_line('a')//'Are all tests passed? ', all(test_passed)
if (.not.all(test_passed)) error stop 1
endprogram stringifor_test_parse_large_csv
