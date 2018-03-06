USING: examples.numberwang tools.test kernel namespaces words.symbol compiler.units ;

IN: examples.numberwang.tests

: setup-numberwang ( number -- )
  numberwang define-symbol
  numberwang set
  ;


{ t } [ [ 10 setup-numberwang 10 is-it-numberwang? ] with-compilation-unit ] unit-test
{ f } [ [ 10 setup-numberwang 9 is-it-numberwang? ] with-compilation-unit ] unit-test
