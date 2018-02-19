! 3^2 + 4^2
3 dup * 4 dup * + ! simple way

3 4 [ dup * ] bi@ + ! using a "cleave combinator"

! square root of 3^2 + 4^2
USE: math.functions
3 2 ^ 4 2 ^ + sqrt

3 4 [ 2 ^ ] bi@ + sqrt

! given 1 2 on the stack, how do we get 1 1 2 on the stack

1
2
swap dup rot

! given my name, make it a greeting, and shout it
USE: ascii
"Murray Steele"

"Hello, " swap append >upper
! do I need to stack shuffle, yes? I think so otherwise we can't append
! "Hello, " to the start
