! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.

! Some code for defining slot accessors and mutators. Used to
! implement tuples, as well as builtin types.
IN: generic
USING: kernel kernel-internals lists math namespaces parser
sequences strings vectors words ;

: define-typecheck ( class generic def -- )
    #! Just like:
    #! GENERIC: generic
    #! M: class generic def ;
    over define-generic define-method ;

: define-slot-word ( class slot word quot -- )
    over [
        >r swap >fixnum r> cons define-typecheck
    ] [
        2drop 2drop
    ] ifte ;

: define-reader ( class slot reader -- )
    [ slot ] define-slot-word ;

: define-writer ( class slot writer -- )
    [ set-slot ] define-slot-word ;

: define-slot ( class slot reader writer -- )
    >r >r 2dup r> define-reader r> define-writer ;

: ?create ( { name vocab }/f -- word )
    dup [ first2 create ] when ;

: intern-slots ( spec -- spec )
    [ first3 swap ?create swap ?create 3vector ] map ;

: define-slots ( class spec -- )
    #! Define a collection of slot readers and writers for the
    #! given class. The spec is a list of lists of length 3 of
    #! the form [ slot reader writer ]. slot is an integer,
    #! reader and writer are either words, strings or f.
    [ first3 define-slot ] each-with ;

: reader-word ( class name -- word )
    >r word-name "-" r> append3 "in" get 2vector ;

: writer-word ( class name -- word )
    [ swap "set-" % word-name % "-" % % ] "" make
    "in" get 2vector ;

: simple-slot ( class name -- reader writer )
    [ reader-word ] 2keep writer-word ;

: simple-slots ( class slots base -- spec )
    #! Takes a list of slot names, and for each slot name
    #! defines a pair of words <class>-<slot> and 
    #! set-<class>-<slot>. Slot numbering is consecutive and
    #! begins at base.
    over length [ + ] map-with
    [ >r dupd simple-slot r> -rot 3vector ] 2map nip
    intern-slots ;
