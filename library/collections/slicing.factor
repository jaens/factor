! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: sequences
USING: generic kernel kernel-internals lists math namespaces
strings vectors ;

: head-slice ( n seq -- slice ) 0 -rot <slice> ; flushable

: tail-slice ( n seq -- slice ) [ length ] keep <slice> ; flushable

: (slice*) [ length swap - ] keep ;

: head-slice* ( n seq -- slice ) (slice*) head-slice ; flushable

: tail-slice* ( n seq -- slice ) (slice*) tail-slice ; flushable

: subseq ( from to seq -- seq ) [ <slice> ] keep like ; flushable

M: object head ( index seq -- seq ) [ head-slice ] keep like ;

: head* ( n seq -- seq ) [ head-slice* ] keep like ; flushable

M: object tail ( index seq -- seq ) [ tail-slice ] keep like ;

: tail* ( n seq -- seq ) [ tail-slice* ] keep like ; flushable

: head? ( seq begin -- ? )
    2dup [ length ] 2apply < [
        2drop f
    ] [
        dup length rot head-slice sequence=
    ] if ; flushable

: ?head ( seq begin -- str ? )
    2dup head? [ length swap tail t ] [ drop f ] if ; flushable

: tail? ( seq end -- ? )
    2dup [ length ] 2apply < [
        2drop f
    ] [
        dup length rot tail-slice* sequence=
    ] if ; flushable

: ?tail ( seq end -- seq ? )
    2dup tail? [ length swap head* t ] [ drop f ] if ; flushable

: replace-slice ( new from to seq -- seq )
    #! Replace the range between 'from' and 'to' in 'seq' with
    #! 'new'. The new sequence has the same type as 'seq'.
    tuck >r >r head-slice r> r> tail-slice swapd append3 ;
    flushable

: (group) ( n seq -- )
    2dup length >= [
        dup empty? [ 2drop ] [ dup like , drop ] if
    ] [
        2dup head , dupd tail-slice (group)
    ] if ;

: group ( n seq -- seq ) [ (group) ] { } make ; flushable

: start-step ( subseq seq n -- subseq slice )
    pick length dupd + rot <slice> ;

: start* ( subseq seq n -- n )
    pick length pick length pick - > [
        3drop -1
    ] [
        2dup >r >r start-step dupd sequence= [
            r> 2drop r>
        ] [
            r> r> 1+ start*
        ] if
    ] if ; flushable

: start ( subseq seq -- n )
    #! The index of a subsequence in a sequence.
    0 start* ; flushable

: subseq? ( subseq seq -- ? ) start -1 > ; flushable

: (split1) ( seq subseq -- before after )
    #! After is a slice.
    dup pick start dup -1 = [
        2drop dup like f
    ] [
        [ swap length + over tail-slice ] keep rot head swap
    ] if ; flushable

: split1 ( seq subseq -- before after )
    #! After is of the same type as seq.
    (split1) dup like ; flushable

: (split) ( seq subseq -- )
    tuck (split1) >r , r> dup [ swap (split) ] [ 2drop ] if ;

: split ( seq subseq -- seq ) [ (split) ] [ ] make ; flushable

: (cut) ( n seq -- before after )
    [ head ] 2keep tail-slice ; flushable

: cut ( n seq -- before after )
    [ (cut) ] keep like ; flushable

: drop-prefix ( seq1 seq2 -- seq1 seq2 )
    2dup mismatch dup -1 = [ drop 2dup min-length ] when
    tuck swap tail-slice >r swap tail-slice r> ;

: unpair ( seq -- firsts seconds )
    flip dup empty? [ drop { } { } ] [ first2 ] if ;

IN: strings

: completion? ( partial completion quot -- ? )
    #! Test if 'partial' is a completion of 'completion', by
    #! comparing each "-"-delimited chunk using 'quot'. The
    #! quotation is usually either [ subseq? ] or [ swap head? ].
    >r [ "-" split ] 2apply 2dup [ length ] 2apply <=
    [ r> 2map [ ] all? ] [ r> 3drop f ] if ; inline
