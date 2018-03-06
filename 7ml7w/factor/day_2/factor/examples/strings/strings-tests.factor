USING: examples.strings tools.test ;
IN: examples.strings.tests

{ t } [ "racecar" palindrome? ] unit-test
{ f } [ "A man, a plan, a canal? Panama!" palindrome? ] unit-test
