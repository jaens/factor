! (c)2009 Joe Groff bsd license
USING: alien alien.c-types alien.data alien.libraries
alien.syntax classes.struct kernel math system-info.windows
windows.types ;
in: windows.dwmapi

STRUCT: MARGINS
    { cxLeftWidth    int }
    { cxRightWidth   int }
    { cyTopHeight    int }
    { cyBottomHeight int } ;

STRUCT: DWM_BLURBEHIND
    { dwFlags                DWORD   }
    { fEnable                BOOL    }
    { hRgnBlur               HANDLE  }
    { fTransitionOnMaximized BOOL    } ;

: <MARGINS> ( l r t b -- MARGINS )
    MARGINS <struct-boa> ; inline

: full-window-margins ( -- MARGINS )
    -1 -1 -1 -1 <MARGINS> ; inline

<< "dwmapi" "dwmapi.dll" stdcall add-library >>

LIBRARY: dwmapi

FUNCTION: HRESULT DwmExtendFrameIntoClientArea ( HWND hWnd, MARGINS* pMarInset ) ;
FUNCTION: HRESULT DwmEnableBlurBehindWindow ( HWND hWnd, DWM_BLURBEHIND* pBlurBehind ) ;
FUNCTION: HRESULT DwmIsCompositionEnabled ( BOOL* pfEnabled ) ;

CONSTANT: WM_DWMCOMPOSITIONCHANGED 0x31E

: composition-enabled? ( -- ? )
    windows-major 6 >=
    [ { bool } [ DwmIsCompositionEnabled drop ] with-out-parameters ]
    [ f ] if ;
