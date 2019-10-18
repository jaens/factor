! :folding=indent:collapseFolds=0:

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

IN: strings
USE: kernel
USE: stack

: sbuf? ( obj -- ? )
    "java.lang.StringBuffer" is ;

: <sbuf> ( capacity -- StringBuffer )
    [ "int" ] "java.lang.StringBuffer" jnew ;

: sbuf-append ( str buf -- )
    [ "java.lang.String" ] "java.lang.StringBuffer" "append"
    jinvoke drop ;

: sbuf-nth ( index sbuf -- char )
    [ "int" ] "java.lang.StringBuffer" "charAt" jinvoke ;

: set-sbuf-nth ( char index sbuf -- )
    swapd
    [ "int" "char" ] "java.lang.StringBuffer" "setCharAt" jinvoke ;

: sbuf-length ( sbuf -- length )
    [ ] "java.lang.StringBuffer" "length" jinvoke ;

: set-sbuf-length ( length sbuf -- )
    [ "int" ] "java.lang.StringBuffer" "setLength" jinvoke ;

: sbuf>str ( sbuf -- str )
    >str ;

: sbuf-reverse ( sbuf -- )
    #! Destructively reverse a string buffer.
    [ ] "java.lang.StringBuffer" "reverse" jinvoke drop ;

DEFER: str>sbuf
: str-reverse ( str -- str )
    str>sbuf dup sbuf-reverse sbuf>str ;