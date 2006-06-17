! Copyright (C) 2006 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: help
USING: arrays graphs hashtables help io kernel math namespaces
porter-stemmer prettyprint sequences strings ;

! Right now this code is specific to the help. It will be
! generalized to an abstract full text search engine later.

: ignored-word? ( str -- ? )
    { "the" "of" "is" "to" "an" "and" "if" "in" "with" "this" "not" "are" "for" "by" "can" "be" "or" "from" "it" "does" "as" } member? ;

: tokenize ( string -- seq )
    [ dup letter? swap LETTER? or not ] split*
    [ >lower stem ] map
    [
        dup ignored-word? over length 1 = or swap empty? or not
    ] subset ;

: index-text ( score article string -- )
    tokenize [ >r 2dup r> nest hash+ ] each 2drop ;

: index-article-title ( article -- )
    3 swap dup article-title index-text ;

: index-article-content ( article -- )
    1 swap dup [ help ] string-out index-text ;

: index-article ( article -- )
    dup index-article-title index-article-content ;

SYMBOL: term-index

: discard-irrelevant ( results -- results )
    #! Discard results in the low 33%
    dup 0 [ second max ] reduce
    swap [ first2 rot / 2array ] map-with
    [ second 1/3 > ] subset ;

: count-occurrences ( seq -- hash )
    [
        dup [ hash-keys [ off ] each ] each
        [ [ swap +@ ] hash-each ] each
    ] make-hash ;

: search-help ( phrase -- assoc )
    tokenize [ term-index get hash ] map [ ] subset
    count-occurrences hash>alist
    [ first2 2array ] map
    [ [ second ] 2apply swap - ] sort discard-irrelevant ;

: index-help ( -- )
    [ all-articles [ index-article ] each ] make-hash
    term-index set-global ;

: search-help. ( phrase -- )
    "Search results for ``" write dup write "'':" print
    search-help [
        first <link> [ article-title ] keep write-object terpri
    ] each ;
