USING: kernel math random ;
in: benchmark.random

: random-benchmark ( -- )
    1,000,000 [
        200 random random-unit random-32 3drop
    ] times ;

MAIN: random-benchmark
