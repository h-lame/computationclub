USING: random math math.ranges kernel io namespaces math.parser sequences ;
IN: examples.numberwang

SYMBOL: numberwang

: set-numberwang ( upper-bound -- ) [1,b] random numberwang set ;

: request-number ( -- string )
    "Guess: " print flush
    readln
    ;

: get-number ( -- number )
    request-number
    [ dup string>number ] [ drop request-number ] until
    string>number
    ;

: higher-hint ( number -- )
    ! the number is higher than numberwang, so guess lower
    numberwang get > [ "Lower!" print flush ] when ;

: lower-hint ( number -- )
    ! the number is lower than numberwang, so guess higher
    numberwang get < [ "Higher!" print flush ] when ;

: hints ( number -- )
    [ higher-hint ] [ lower-hint ] bi ;

: is-it-numberwang? ( number -- ? )
    dup numberwang get = [ drop t ] [ hints f ] if ;

: thats-numberwang! ( -- )
    numberwang get number>string "! That's numberwang!" append print ;

: play-numberwang ( -- )
    100 set-numberwang
    [ get-number is-it-numberwang? ] [ ] until
    thats-numberwang! ;

MAIN: play-numberwang
