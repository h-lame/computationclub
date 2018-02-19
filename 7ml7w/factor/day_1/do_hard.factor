! given a number from 1 .. 99 put the digits of the number on the stack
! use /i and mod to do this
64
[ 10 /i ]
[ 10 mod ]
bi

! do the above for any length of string, use string stuff
USE: math.parser
100925346
number>string ! convert number into a string
[ 1string string>number ] ! each quotation (iterates over string for each char,
!                                           turns each char into a string,
!                                           turns that string into a number)
each
