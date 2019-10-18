! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2003, 2004 Slava Pestov.
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 
! 1. Redistributions of source code must retain the above copyright notice,
!    this list of conditions and the following disclaimer.
! 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
! 
! THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
! INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
! FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
! DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
! SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
! PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
! OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
! WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
! OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
! ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

IN: namespaces
USE: combinators
USE: kernel
USE: lists
USE: logic
USE: stack
USE: strings
USE: vectors

! Other languages have classes, objects, variables, etc.
! Factor has similar concepts.
!
!   5 "x" set
!   "x" get 2 + .
! 7
!   7 "x" set
!   "x" get 2 + .
! 9
!
! get ( name -- value ) and set ( value name -- ) search in
! the namespaces on the namespace stack, in top-down order.
!
! At the bottom of the namespace stack, is the global
! namespace; it is always present.
!
! bind ( namespace quot -- ) executes a quotation with a
! namespace pushed on the namespace stack.

: namespace ( -- namespace )
    #! Push the current namespace.
    namestack* vector-peek ; inline

: with-scope ( quot -- )
    #! Execute a quotation with a new namespace on the
    #! namestack.
    <namespace> >n call n> drop ;

: extend ( object code -- object )
    #! Used in code like this:
    #! : <subclass>
    #!      <superclass> [
    #!          ....
    #!      ] extend ;
    over >r bind r> ; inline

: lazy ( var [ a ] -- value )
    #! If the value of the variable is f, set the value to the
    #! result of evaluating [ a ].
    over get [ drop get ] [ swap >r call dup r> set ] ifte ;

: traverse-path ( name object -- object )
    dup has-namespace? [ get* ] [ 2drop f ] ifte ;

: (object-path) ( object list -- object )
    [ uncons >r swap traverse-path r> (object-path) ] when* ;

: object-path ( list -- object )
    #! An object path is a list of strings. Each string is a
    #! variable name in the object namespace at that level.
    #! Returns f if any of the objects are not set.
    namespace swap (object-path) ;

: (set-object-path) ( name -- namespace )
    dup namespace get* dup [
        nip
    ] [
        drop <namespace> tuck put
    ] ifte ;

: set-object-path ( value list -- )
    unswons over [
        (set-object-path) [ set-object-path ] bind
    ] [
        nip set
    ] ifte ;

: on ( var -- ) t put ;
: off ( var -- ) f put ;
: toggle ( var -- ) dup get not put ;