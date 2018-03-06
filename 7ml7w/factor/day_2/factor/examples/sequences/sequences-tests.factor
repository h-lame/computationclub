USING: examples.sequences tools.test kernel ;
IN: examples.sequences.tests

{ "foo" } [ { "bar" "baz" "foo" "qux" } [ "foo" = ] find-first ] unit-test
{ null } [ { "bar" "baz" "foo" "qux" } [ "quux" = ] find-first ] unit-test
