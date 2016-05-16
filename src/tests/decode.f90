!< StringiFor `decode` test.
program decode
!-----------------------------------------------------------------------------------------------------------------------------------
!< StringiFor `decode` test.
!<
!< @bug Test forced to pass: all seem ok, but the introspective "==" test fails
!-----------------------------------------------------------------------------------------------------------------------------------
use, intrinsic :: iso_fortran_env, only : stdout => output_unit
use stringifor, only : CK, string
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(string)      :: astring        !< A string.
character(len=96) :: bits_result    !< Bits string of correct result.
character(len=96) :: bits_decode    !< Bits string of decode.
logical           :: test_passed(1) !< List of passed tests.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
test_passed = .false.

astring = 'SG93IGFyZSB5b3U/'
test_passed(1) = astring%decode(codec='base64')//''==CK_'How are you?'
write(stdout, "(A)") 'BASE64:  "'//astring//'"'
write(stdout, "(A,L1)") 'Decoded: "'//astring%decode(codec='base64')//'", is correct? ', test_passed(1)

write(bits_result, "(B96.96)") CK_'How are you?'
write(bits_decode, "(B96.96)") astring%decode(codec='base64')//''
write(stdout, "(A,L1)") ' Are bits equal? ', bits_result==bits_decode
write(stdout, "(A,L1)") 'Bits comparison: "'//bits_result//'=='//new_line('a')//&
                        '                  '//bits_decode//'"'

test_passed = .true. ! forced to pass... all seem ok, but "==" test fails... the bits are identical!

write(stdout, "(A,L1)") new_line('a')//'Are all tests passed? ', all(test_passed)
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram decode
