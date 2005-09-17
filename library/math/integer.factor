! Copyright (C) 2004, 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: math
USING: errors generic kernel math sequences sequences-internals ;

UNION: integer fixnum bignum ;

: (gcd) ( b a y x -- a d )
    dup 0 number= [
        drop nip
    ] [
        tuck /mod >r pick * swap >r swapd - r> r> (gcd)
    ] ifte ; inline

: gcd ( x y -- a d )
    #! Compute the greatest common divisor d and multiplier a
    #! such that a*x=d mod y.
    swap 0 1 2swap (gcd) abs ; foldable

: lcm ( a b -- c )
    #! Smallest integer such that c/a and c/b are both integers.
    2dup gcd nip >r * r> /i ; foldable

: mod-inv ( x n -- y )
    #! Compute the multiplicative inverse of x mod n.
    gcd 1 = [ "Non-trivial divisor found" throw ] unless ;
    foldable

IN: math-internals

: fraction> ( a b -- a/b )
    dup 1 number= [ drop ] [ (fraction>) ] ifte ; inline

: division-by-zero ( x y -- )
    "Division by zero" throw drop ; inline

M: integer / ( x y -- x/y )
    dup 0 number= [
        division-by-zero
    ] [
        dup 0 < [ [ neg ] 2apply ] when
        2dup gcd nip tuck /i >r /i r> fraction>
    ] ifte ;

M: fixnum number=
    #! Fixnums are immediate values, so equality testing is
    #! trivial.
    eq? ;

M: fixnum < fixnum< ;
M: fixnum <= fixnum<= ;
M: fixnum > fixnum> ;
M: fixnum >= fixnum>= ;

M: fixnum + fixnum+ ;
M: fixnum - fixnum- ;
M: fixnum * fixnum* ;
M: fixnum /i fixnum/i ;
M: fixnum /f fixnum/f ;
M: fixnum mod fixnum-mod ;

M: fixnum /mod fixnum/mod ;

M: fixnum 1+ 1 fixnum+ ;
M: fixnum 1- 1 fixnum- ;

M: fixnum bitand fixnum-bitand ;
M: fixnum bitor fixnum-bitor ;
M: fixnum bitxor fixnum-bitxor ;
M: fixnum shift fixnum-shift ;

M: fixnum bitnot fixnum-bitnot ;

M: bignum number= bignum= ;
M: bignum < bignum< ;
M: bignum <= bignum<= ;
M: bignum > bignum> ;
M: bignum >= bignum>= ;

M: bignum + bignum+ ;
M: bignum - bignum- ;
M: bignum * bignum* ;
M: bignum /i bignum/i ;
M: bignum /f bignum/f ;
M: bignum mod bignum-mod ;

M: bignum /mod bignum/mod ;

M: bignum 1+ 1 >bignum bignum+ ;
M: bignum 1- 1 >bignum bignum- ;

M: bignum bitand bignum-bitand ;
M: bignum bitor bignum-bitor ;
M: bignum bitxor bignum-bitxor ;
M: bignum shift bignum-shift ;

M: bignum bitnot bignum-bitnot ;

M: integer truncate ;
M: integer floor ;
M: integer ceiling ;

! Integers support the sequence protocol
M: integer length ;
M: integer nth drop ;
M: integer nth-unsafe drop ;
