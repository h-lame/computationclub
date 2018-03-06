USING: tools.test io io.streams.string kernel namespaces sequences splitting math.parser prettyprint ;

USE: examples.greeter
USE: examples.strings
USE: examples.sequences
USE: examples.numberwang

IN: examples.test-suite

: run-tests ( -- total-count failed-count )
    [ "examples" test ] with-string-writer
    string-lines
    [ "Unit Test:" head? ] filter
    length
    test-failures get length
    ;

: print-failures ( -- )
    test-failures get empty? [ ] [ :test-failures ] if
    ;

: print-run-status ( total-count fail-count -- )
    [ number>string ] bi@
    "/"
    rot
    3append
    "Test run status: "
    " (failed/passed)"
    swapd
    3append
    print
    ;

: test-all-examples ( -- )
    run-tests
    print-failures
    print-run-status
    ;

MAIN: test-all-examples
