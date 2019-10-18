IN: scratchpad
USE: namespaces
USE: parser
USE: stack
USE: streams
USE: test
USE: stdio
USE: math

[ 4 ] [ "/library/test/io/no-trailing-eol.factor" run-resource ] unit-test

: lines-test ( stream -- line1 line2 )
    [ read read ] with-stream ;

[
    "This is a line."
    "This is another line."
] [
    "/library/test/io/windows-eol.txt" <resource-stream> lines-test
] unit-test

[
    "This is a line."
    "This is another line."
] [
    "/library/test/io/mac-os-eol.txt" <resource-stream> lines-test
] unit-test

[
    "This is a line.\rThis is another line.\r"
] [
    "/library/test/io/mac-os-eol.txt" <resource-stream>
    [ 500 read# ] with-stream
] unit-test

[
    255
] [
    "/library/test/io/binary.txt" <resource-stream>
    [ read1 ] with-stream >fixnum
] unit-test