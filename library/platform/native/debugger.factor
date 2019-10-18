! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2004 Slava Pestov.
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

IN: errors
USE: combinators
USE: continuations
USE: kernel
USE: lists
USE: logic
USE: math
USE: namespaces
USE: prettyprint
USE: stack
USE: stdio
USE: strings
USE: unparser
USE: vectors
USE: words

: expired-error ( obj -- )
    "Object did not survive image save/load: " write . ;

: io-task-twice-error ( obj -- )
    "Attempting to perform two simultaneous I/O operations on "
    write . ;

: no-io-tasks-error ( obj -- )
    "No I/O tasks" print ;

: undefined-word-error ( obj -- )
    "Undefined word: " write . ;

: incompatible-port-error ( obj -- )
    "Unsuitable port for operation: " write . ;

: io-error ( list -- )
    "I/O error in kernel function " write
    unswons write ": " write car print ;

: type-check-error ( list -- )
    "Type check error" print
    uncons car dup "Object: " write .
    "Object type: " write type type-name print
    "Expected type: " write type-name print ;

: array-range-error ( list -- )
    "Array range check error" print
    unswons "Object: " write .
    uncons car "Maximum index: " write .
    "Requested index: " write . ;

: float-format-error ( list -- )
    "Invalid floating point literal format: " write . ;

: signal-error ( obj -- )
    "Operating system signal " write . ;

: negative-array-size-error ( obj -- )
    "Cannot allocate array with negative size " write . ;

: bad-primitive-error ( obj -- )
    "Bad primitive number: " write . ;

: c-string-error ( obj -- )
    "Cannot convert to C string: " write . ;

: ffi-disabled-error ( obj -- )
    drop "Recompile Factor with #define FFI." print ;

: ffi-error ( obj -- )
    "FFI: " write print ;

: port-closed-error ( obj -- )
    "Port closed: " write . ;

: kernel-error. ( obj n -- str )
    {
        expired-error
        io-task-twice-error
        no-io-tasks-error
        incompatible-port-error
        io-error
        undefined-word-error
        type-check-error
        array-range-error
        float-format-error
        signal-error
        negative-array-size-error
        bad-primitive-error
        c-string-error
        ffi-disabled-error
        ffi-error
        port-closed-error
    } vector-nth execute ;

: kernel-error? ( obj -- ? )
    dup cons? [ uncons cons? swap fixnum? and ] [ drop f ] ifte ;

: error. ( error -- str )
    dup kernel-error? [
        uncons car swap kernel-error.
    ] [
        dup string? [ print ] [ . ] ifte
    ] ifte ;