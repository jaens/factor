USING: alien.c-types alien.syntax classes.struct
windows.directx.dxgiformat windows.types ;
in: windows.directx.dxgitype

CONSTANT: DXGI_STATUS_OCCLUDED 0x087a0001
CONSTANT: DXGI_STATUS_CLIPPED 0x087a0002
CONSTANT: DXGI_STATUS_NO_REDIRECTION 0x087a0004
CONSTANT: DXGI_STATUS_NO_DESKTOP_ACCESS 0x087a0005
CONSTANT: DXGI_STATUS_GRAPHICS_VIDPN_SOURCE_IN_USE 0x087a0006
CONSTANT: DXGI_STATUS_MODE_CHANGED 0x087a0007
CONSTANT: DXGI_STATUS_MODE_CHANGE_IN_PROGRESS 0x087a0008

CONSTANT: DXGI_ERROR_INVALID_CALL 0x887a0001
CONSTANT: DXGI_ERROR_NOT_FOUND 0x887a0002
CONSTANT: DXGI_ERROR_MORE_DATA 0x887a0003
CONSTANT: DXGI_ERROR_UNSUPPORTED 0x887a0004
CONSTANT: DXGI_ERROR_DEVICE_REMOVED 0x887a0005
CONSTANT: DXGI_ERROR_DEVICE_HUNG 0x887a0006
CONSTANT: DXGI_ERROR_DEVICE_RESET 0x887a0007
CONSTANT: DXGI_ERROR_WAS_STILL_DRAWING 0x887a000a
CONSTANT: DXGI_ERROR_FRAME_STATISTICS_DISJOINT 0x887a000b
CONSTANT: DXGI_ERROR_GRAPHICS_VIDPN_SOURCE_IN_USE 0x887a000c
CONSTANT: DXGI_ERROR_DRIVER_INTERNAL_ERROR 0x887a0020
CONSTANT: DXGI_ERROR_NONEXCLUSIVE 0x887a0021
CONSTANT: DXGI_ERROR_NOT_CURRENTLY_AVAILABLE 0x887a0022
CONSTANT: DXGI_ERROR_REMOTE_CLIENT_DISCONNECTED 0x887a0023
CONSTANT: DXGI_ERROR_REMOTE_OUTOFMEMORY 0x887a0024

STRUCT: DXGI_RGB
{ Red FLOAT }
{ Green FLOAT }
{ Blue FLOAT } ;

STRUCT: DXGI_GAMMA_CONTROL
{ Scale DXGI_RGB }
{ Offset DXGI_RGB }
{ GammaCurve DXGI_RGB[1025] } ;

STRUCT: DXGI_GAMMA_CONTROL_CAPABILITIES
{ ScaleAndOffsetSupported BOOL }
{ MaxConvertedValue FLOAT }
{ MinConvertedValue FLOAT }
{ NumGammaControlPoints UINT }
{ ControlPointPositions FLOAT[1025] } ;

STRUCT: DXGI_RATIONAL
{ Numerator UINT }
{ Denominator UINT } ;

ENUM: DXGI_MODE_SCANLINE_ORDER
    DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED
    DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE
    DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST
    DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST ;

ENUM: DXGI_MODE_SCALING
    DXGI_MODE_SCALING_UNSPECIFIED
    DXGI_MODE_SCALING_CENTERED
    DXGI_MODE_SCALING_STRETCHED ;

ENUM: DXGI_MODE_ROTATION
    DXGI_MODE_ROTATION_UNSPECIFIED
    DXGI_MODE_ROTATION_IDENTITY
    DXGI_MODE_ROTATION_ROTATE90
    DXGI_MODE_ROTATION_ROTATE180
    DXGI_MODE_ROTATION_ROTATE270 ;

STRUCT: DXGI_MODE_DESC
{ Width UINT }
{ Height UINT }
{ RefreshRate DXGI_RATIONAL }
{ Format DXGI_FORMAT }
{ ScanlineOrdering DXGI_MODE_SCANLINE_ORDER }
{ Scaling DXGI_MODE_SCALING } ;

STRUCT: DXGI_SAMPLE_DESC
{ Count UINT }
{ Quality UINT } ;
