! Copyright (c) 2008 Aaron Schaefer.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math math.functions math.ranges math.order
project-euler.common sequences layouts ;
in: project-euler.044

! http://projecteuler.net/index.php?section=problems&id=44

! DESCRIPTION
! -----------

! Pentagonal numbers are generated by the formula, Pn=n(3n−1)/2. The first ten
! pentagonal numbers are:

!     1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...

! It can be seen that P4 + P7 = 22 + 70 = 92 = P8. However, their difference,
! 70 − 22 = 48, is not pentagonal.

! Find the pair of pentagonal numbers, Pj and Pk, for which their sum and
! difference is pentagonal and D = |Pk − Pj| is minimised; what is the value of D?


! SOLUTION
! --------

! Brute force using a cartesian product and an arbitrarily chosen limit.

<PRIVATE

: nth-pentagonal ( n -- seq )
    dup 3 * 1 - * 2 /i ; inline

: sum-and-diff? ( m n -- ? )
    [ + ] [ - ] 2bi [ pentagonal? ] both? ; inline

: euler044-step ( min m n -- min' )
    [ nth-pentagonal ] bi@
    2dup sum-and-diff? [ - abs min ] [ 2drop ] if ; inline

PRIVATE>

: euler044 ( -- answer )
    most-positive-fixnum
    2500 [1,b] [
        dup [1,b] [
            euler044-step
        ] with each
    ] each ;

! [ euler044 ] 10 ave-time
! 289 ms ave run time - 0.27 SD (10 trials)

SOLUTION: euler044
