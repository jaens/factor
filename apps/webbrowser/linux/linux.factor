! Copyright (C) 2011 John Benediktsson
! See http://factorcode.org/license.txt for BSD license

USING: arrays io.launcher kernel present system webbrowser ;

in: webbrowser.linux

M: linux open-file ( path -- )
    present "xdg-open" swap 2array run-detached drop ;
