! Copyright (C) 2009, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors math.rectangles kernel prettyprint.custom prettyprint.backend ;
in: math.rectangles.prettyprint

M: rect pprint*
    [
        \ RECT: [
            [ loc>> ] [ dim>> ] bi [ pprint* ] bi@
        ] pprint-prefix
    ] check-recursion ;
