# Numbers

StringiFor integrates with [PENF](https://github.com/szaghi/PENF) (Portable Environment for Fortran) to provide portable numeric kind parameters and seamless string–number conversion.

## PENF Kind Parameters

`use stringifor` re-exports all PENF kind parameters:

| Parameter | Type | Bytes |
|-----------|------|-------|
| `I1P` | integer | 1 |
| `I2P` | integer | 2 |
| `I4P` | integer | 4 |
| `I8P` | integer | 8 |
| `R4P` | real | 4 |
| `R8P` | real | 8 |
| `R16P` | real | 16 (optional, requires `-Dr16p`) |

## Assigning Numbers to Strings

The `assignment(=)` operator is overloaded for all PENF integer and real kinds:

```fortran
use stringifor
type(string) :: s

! Integer assignment
s = 127_I1P
print "(A)", s//''   ! +127

s = -32768_I2P
print "(A)", s//''   ! -32768

s = 1000000_I4P
print "(A)", s//''   ! +1000000

! Real assignment
s = 3.021e6_R4P
print "(A)", s//''   ! +0.302100E+07

s = -1.23456789_R8P
print "(A)", s//''   ! -1.23456789000000E+00
```

## Inquiring String Content

```fortran
use stringifor
type(string) :: s

s = '3.14'
print "(L1)", s%is_number()    ! T
print "(L1)", s%is_real()      ! T
print "(L1)", s%is_integer()   ! F

s = '42'
print "(L1)", s%is_number()    ! T
print "(L1)", s%is_integer()   ! T
print "(L1)", s%is_real()      ! F

s = 'hello'
print "(L1)", s%is_number()    ! F
print "(L1)", s%is_digit()     ! F

s = '0123'
print "(L1)", s%is_digit()     ! T  (all characters are digits)
```

## Casting Strings to Numbers

The `to_number` method casts a string to any PENF numeric kind. The `kind` argument selects the target type:

```fortran
use stringifor
type(string) :: s

s = "3.4e9"

if (s%is_real()) then
  print "(E13.6)", s%to_number(kind=1._R4P)   !  0.340000E+10
  print "(E20.12)", s%to_number(kind=1._R8P)  !  0.340000000000E+10
end if

s = "42"
if (s%is_integer()) then
  print "(I0)", s%to_number(kind=1_I4P)       ! 42
end if
```

::: info
The `kind` argument is only used to select the return type — its value is ignored. Pass any literal of the target kind (e.g., `1._R8P`, `0_I4P`).
:::

## Complete Example

```fortran
use stringifor
implicit none
type(string) :: s
real(R8P)    :: x
integer(I4P) :: n

! String → number → string round-trip
s = "2.718281828"
x = s%to_number(kind=1._R8P)
s = x                           ! re-assign the number back to a string
print "(A)", s//''              ! +2.71828182800000E+00

! Parse and compare
s = "100"
if (s%is_integer()) then
  n = s%to_number(kind=1_I4P)
  if (n > 50) print "(A)", "Greater than 50"
end if
```
