! Copyright (C) 2009 Philipp Brüschweiler
! See http://factorcode.org/license.txt for BSD license.
in: infix.ast

TUPLE: ast-number value ;
TUPLE: ast-local name ;
TUPLE: ast-array name index ;
TUPLE: ast-slice name from to step ;
TUPLE: ast-function name arguments ;
TUPLE: ast-op left right op ;
TUPLE: ast-negation term ;
