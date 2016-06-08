USING: help.markup help.syntax io kernel math quotations
opengl.gl multiline assocs strings ;
in: opengl.shaders

HELP: gl-shader
{ $class-description { $snippet "gl-shader" } " is a predicate class comprising values returned by OpenGL to represent shader objects. The following words are provided for creating and manipulating these objects:"
    { $list
        { { $link <gl-shader> } " - Compile GLSL code into a shader object" }
        { { $link gl-shader-ok? } " - Check whether a shader object compiled successfully" }
        { { $link check-gl-shader } " - Throw an error unless a shader object compiled successfully" }
        { { $link gl-shader-info-log } " - Retrieve the info log of messages generated by the GLSL compiler" }
        { { $link delete-gl-shader } " - Invalidate a shader object" }
    }
  "The derived predicate classes " { $link vertex-shader } " and " { $link fragment-shader } " are also defined for the two standard kinds of shader defined by the OpenGL specification." } ;

HELP: vertex-shader
{ $class-description { $snippet "vertex-shader" } " is the predicate class of " { $link gl-shader } " objects that refer to shaders of type " { $snippet "GL_VERTEX_SHADER" } ". In addition to the " { $snippet "gl-shader" } " words, the following vertex shader-specific functions are defined:"
    { $list
        { { $link <vertex-shader> } " - Compile GLSL code into a vertex shader object " }
    }
} ;

HELP: fragment-shader
{ $class-description { $snippet "fragment-shader" } " is the predicate class of " { $link gl-shader } " objects that refer to shaders of type " { $snippet "GL_FRAGMENT_SHADER" } ". In addition to the " { $snippet "gl-shader" } " words, the following fragment shader-specific functions are defined:"
    { $list
        { { $link <fragment-shader> } " - Compile GLSL code into a fragment shader object " }
    }
} ;

HELP: <gl-shader>
{ $values { "source" "The GLSL source code to compile" } { "kind" "The kind of shader to compile, such as " { $snippet "GL_VERTEX_SHADER" } " or " { $snippet "GL_FRAGMENT_SHADER" } } { "shader" "a new " { $link gl-shader } } }
{ $description "Tries to compile the given GLSL source into a shader object. The returned object can be checked for validity by " { $link check-gl-shader } " or " { $link gl-shader-ok? } ". Errors and warnings generated by the GLSL compiler will be collected in the info log, available from " { $link gl-shader-info-log } ".\n\nWhen the shader object is no longer needed, it should be deleted using " { $link delete-gl-shader } " or else be attached to a " { $link gl-program } " object deleted using " { $link delete-gl-program } "." } ;

HELP: <vertex-shader>
{ $values { "source" "The GLSL source code to compile" } { "vertex-shader" "a new " { $link vertex-shader } } }
{ $description "Tries to compile the given GLSL source into a vertex shader object. Equivalent to " { $snippet "GL_VERTEX_SHADER <gl-shader>" } "." } ;

HELP: <fragment-shader>
{ $values { "source" "The GLSL source code to compile" } { "fragment-shader" "a new " { $link fragment-shader } } }
{ $description "Tries to compile the given GLSL source into a fragment shader object. Equivalent to " { $snippet "GL_FRAGMENT_SHADER <gl-shader>" } "." } ;

HELP: gl-shader-ok?
{ $values { "shader" "A " { $link gl-shader } " object" } { "?" boolean } }
{ $description "Returns a boolean value indicating whether the given shader object compiled successfully. Compilation errors and warnings are available in the shader's info log, which can be gotten using " { $link gl-shader-info-log } "." } ;

HELP: check-gl-shader
{ $values { "shader" "A " { $link gl-shader } " object" } }
{ $description "Throws an error containing the " { $link gl-shader-info-log } " for the shader object if it failed to compile. Otherwise, the shader object is left on the stack." } ;

HELP: delete-gl-shader
{ $values { "shader" "A " { $link gl-shader } " object" } }
{ $description "Deletes the shader object, invalidating it and releasing any resources allocated for it by the OpenGL implementation." } ;

HELP: gl-shader-info-log
{ $values { "shader" "A " { $link gl-shader } " object" } { "log" string } }
{ $description "Retrieves the info log for " { $snippet "shader" } ", including any errors or warnings generated in compiling the shader object." } ;

HELP: gl-program
{ $class-description { $snippet "gl-program" } " is a predicate class comprising values returned by OpenGL to represent proram objects. The following words are provided for creating and manipulating these objects:"
    { $list
        { { $link <gl-program> } ", " { $link <simple-gl-program> } " - Link a set of shaders into a GLSL program" }
        { { $link gl-program-ok? } " - Check whether a program object linked successfully" }
        { { $link check-gl-program } " - Throw an error unless a program object linked successfully" }
        { { $link gl-program-info-log } " - Retrieve the info log of messages generated by the GLSL linker" }
        { { $link gl-program-shaders } " - Retrieve the set of shader objects composing the GLSL program" }
        { { $link delete-gl-program } " - Invalidate a program object and all its attached shaders" }
        { { $link with-gl-program } " - Use a program object" }
    }
} ;

HELP: <gl-program>
{ $values { "shaders" "A sequence of " { $link gl-shader } " objects." } { "program" "a new " { $link gl-program } } }
{ $description "Creates a new GLSL program object, attaches all the shader objects in the " { $snippet "shaders" } " sequence, and attempts to link them. The returned object can be checked for validity by " { $link check-gl-program } " or " { $link gl-program-ok? } ". Errors and warnings generated by the GLSL linker will be collected in the info log, available from " { $link gl-program-info-log } ".\n\nWhen the program object and its attached shaders are no longer needed, it should be deleted using " { $link delete-gl-program } "." } ;

HELP: <simple-gl-program>
{ $values { "vertex-shader-source" "A string containing GLSL vertex shader source" } { "fragment-shader-source" "A string containing GLSL fragment shader source" } { "program" "a new " { $link gl-program } } }
{ $description "Wrapper for " { $link <gl-program> } " for the simple case of compiling a single vertex shader and fragment shader and linking them into a GLSL program. Throws an exception if compiling or linking fails." } ;

{ <gl-program> <simple-gl-program> } related-words

HELP: gl-program-ok?
{ $values { "program" "A " { $link gl-program } " object" } { "?" boolean } }
{ $description "Returns a boolean value indicating whether the given program object linked successfully. Link errors and warnings are available in the program's info log, which can be gotten using " { $link gl-program-info-log } "." } ;

HELP: check-gl-program
{ $values { "program" "A " { $link gl-program } " object" } }
{ $description "Throws an error containing the " { $link gl-program-info-log } " for the program object if it failed to link. Otherwise, the program object is left on the stack." } ;

HELP: gl-program-info-log
{ $values { "program" "A " { $link gl-program } " object" } { "log" string } }
{ $description "Retrieves the info log for " { $snippet "program" } ", including any errors or warnings generated in linking the program object." } ;

HELP: delete-gl-program
{ $values { "program" "A " { $link gl-program } " object" } }
{ $description "Deletes the program object, invalidating it and releasing any resources allocated for it by the OpenGL implementation. Any attached " { $link gl-shader } "s are also deleted.\n\nIf the shader objects should be preserved, they should each be detached using " { $link detach-gl-program-shader } ". The program object can then be destroyed alone using " { $link delete-gl-program-only } "." } ;

HELP: with-gl-program
{ $values { "program" "A " { $link gl-program } " object" } { "quot" "A quotation with stack effect " { $snippet "( program -- )" } } }
{ $description "Enables " { $snippet "program" } " for all OpenGL calls made in the dynamic extent of " { $snippet "quot" } ". " { $snippet "program" } " is left on the top of the stack when " { $snippet "quot" } " is called. The fixed-function pipeline is restored at the end of " { $snippet "quot" } "." } ;

ABOUT: "gl-utilities"
