USING: arrays kernel math opengl opengl.gl opengl.glu
opengl.demo-support ui ui.gadgets ui.render ui.pixel-formats
threads accessors calendar literals ;
in: nehe.4

TUPLE: nehe4-gadget < gadget rtri rquad thread quit? ;

CONSTANT: width 256
CONSTANT: height 256
: redraw-interval ( -- dt ) 10 milliseconds ;

: <nehe4-gadget> (  -- gadget )
    nehe4-gadget new
    0.0 >>rtri
    0.0 >>rquad ;

M: nehe4-gadget draw-gadget* ( gadget -- )
    GL_PROJECTION glMatrixMode
    glLoadIdentity
    45.0 width height / >float 0.1 100.0 gluPerspective
    GL_MODELVIEW glMatrixMode
    glLoadIdentity
    GL_SMOOTH glShadeModel
    0.0 0.0 0.0 0.0 glClearColor
    1.0 glClearDepth
    GL_DEPTH_TEST glEnable
    GL_LEQUAL glDepthFunc
    GL_PERSPECTIVE_CORRECTION_HINT GL_NICEST glHint
    GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT bitor glClear
    glLoadIdentity
    -1.5 0.0 -6.0 glTranslatef
    dup rtri>> 0.0 1.0 0.0 glRotatef

    GL_TRIANGLES [
        1.0 0.0 0.0 glColor3f
        0.0 1.0 0.0 glVertex3f
        0.0 1.0 0.0 glColor3f
        -1.0 -1.0 0.0 glVertex3f
        0.0 0.0 1.0 glColor3f
        1.0 -1.0 0.0 glVertex3f
    ] do-state

    glLoadIdentity

    1.5 0.0 -6.0 glTranslatef
    dup rquad>> 1.0 0.0 0.0 glRotatef
    0.5 0.5 1.0 glColor3f
    GL_QUADS [
        -1.0 1.0 0.0 glVertex3f
        1.0 1.0 0.0 glVertex3f
        1.0 -1.0 0.0 glVertex3f
        -1.0 -1.0 0.0 glVertex3f
    ] do-state
    [ 0.2 + ] change-rtri
    [ 0.15 - ] change-rquad drop ;

: nehe4-update-thread ( gadget -- )
    dup quit?>> [ drop ] [
        redraw-interval sleep
        dup relayout-1
        nehe4-update-thread
    ] if ;

M: nehe4-gadget graft* ( gadget -- )
    f >>quit?
    [ nehe4-update-thread ] curry in-thread ;

M: nehe4-gadget ungraft* ( gadget -- )
    t >>quit? drop ;

MAIN-WINDOW: run4
    {
        { title "NeHe Tutorial 4" }
        { pref-dim { $ width $ height } }
        { pixel-format-attributes {
            windowed
            double-buffered
            T{ depth-bits { value 16 } }
        } }
    }
    <nehe4-gadget> >>gadgets ;
