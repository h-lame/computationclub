! Using reduce, get the sum of 1, 4, 17, 9, 11
{ 1 4 17 9 11 } ! sequence
0 ! initial
[ + ] ! quotation
reduce

! Calculate the sum from 1 to 100, don't type 1 2 3 ... 100
USE: math.ranges
100 ! limit
[1,b] ! sequencer
0 ! initial
[ + ] ! quotation
reduce

! Use map and reduce to get the sum of squares from 1 to 10
10 ! limit
[1,b] ! sequencer
[ 2 ^ ] ! map quotation
map
0 ! initial
[ + ] ! reduce quotation
reduce

