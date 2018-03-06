# Factor - Day 2

> I'll say it again: don't forget the spaces!

I really think the parser must be super simple, we have to use the spaces as
otherwise everything (if you'll pardon the pun) is concatenated together into
a word, space is the only non-word character. (I guess?)

---

Are `USE:` and `USING:` actual syntax?  Ofc, no.  They're words that live in
the `syntax` vocabulary.  So, hmm, maybe they are?

---

I can define a symbol witg `SYMBOL:`.  Great!

What's a symbol?

Is it a constant?

But they're mutable; like a variable?  But there must be something about them
that means they're _not_ variables?  Otherwise, the text would describe them
as such.  Unless of course, symbol is a hitherto unknown to me, standard synonym
for variable.

---

Interesting that we need to match the file system to the `IN:` statement. Is
this standard where our files and code need to match up for namespaces to work.
I know that it is in Rails, but not Ruby, and I think Python uses the file
system, but the code in the file doesn't need to self declare, it's just picked
up from the filesystem.

(later): Oh, but our test for greeter lives in `/factor/examples/greeter` yet
its `IN: examples.greeter.test`.  I wonder if test is special, or actually we
only need filesystem and `IN:` to match for requires among other files, but
if they're standalone it doesn't matter.

---

I keep getting caught out by the "platonic dialogue" style of this chapter.

Book: do a thing
/me does a thing, it doesn't work, struggles, eventually gives up a reads on
Book: of course this didn't work, do this
/me does that, it still doesn't work, struggles, eventually gives up a reads on
Book: neither did that, you must do another thing too
Me: aaaargh

---

Ooh, a null io object.  Nice.

---

## Interview

> most of the actual parser can be scrapped, and syntax elements such as `[` and
> `]` can become ordinary words in the language

Yesssss!  I actually think this might be one of the interesting things about
this language; literally everything is a word in the language.  The boundary
between what is syntax and what is code is done.  Not even LISP is this simple,
right? `(` and `)` are syntax in LISP.

---

Interesting that it started as a scripting language for a game on the JVM.  I
wonder if that's where the app icon comes from?  Is this another example where
you write a thing in some language, X, then use that thing to write a version of
the thing in itself, then you can throw away the original implementation of the
thing and you are left with something that seemingly could never have existed
because you can't create it without itself.  (Like that GCC bug paper?)

---

I'm interested in what programming with Factor (even to the minor degree we
have done for this book) will make me think about the languages I do use more
regularly.  Will it influence how I program in ruby?  The interview suggests
that it (or maybe concatenative programming languages in general) does
infiltrate your thoughts.  I think that's what I'm hoping to get out of this
book in general.  Ruby is a multi-paradigm language, and you can easily program
in a procedural, oo, or functional style in it.  Can it accept me doing things
concatenatively too?

---

### Your turn

1. > a third way of adding directories to the list of vocabulary roots

   We have `~/.factor_roots` and `FACTOR_ROOTS` env var, what else?
   Call `<path> add-vocab-root` in our `~.factor-rc` (see: https://docs.factorcode.org/content/article-add-vocab-roots.html)
   We can also call this word whenever we like to add to the vocab-roots
   at runtime

2. > The tool that factor provides to deploy a program as a truly standalone
   > application

   We have the application deploy tool (see: http://docs.factorcode.org/content/article-tools.deploy.html)
   which compiles a vocabulary down to native executable calling the `MAIN:`
   function.

---

## do(Easy)

For the palindrome, my first thought, upon spelunking the stdlib for strings
and sequences is that I could use [`reverse!`](http://docs.factorcode.org/content/word-reverse%21%2Csequences.html) because it'd be marginally more
efficient.  What I didn't count on is the following:

    "Foo"      -- [stack: "Foo"]
    dup        -- [stack: "Foo" "Foo"]
    reverse!   -- [stack: "ooF" "ooF"]

The original "Foo" was also reversed by the `reverse!`, I guess because `dup`
doesn't do copy by value, but copy by refernce?  I found that relatively
surprising.  `reverse` does say it returns a new sequence, so that's what we
need to get a stack of `["Foo" "ooF"]`.

---

## do(Medium)

I don't really understand the error about `can't apply function filter to
non-inline word` that I got with my original attempt to write `find-first`.
Even looking in slack and reading the links that `@mudge` provided (see:
http://docs.factorcode.org/content/article-inference-combinators.html and
http://docs.factorcode.org/content/word-unknown-macro-input%2Cstack-checker.errors.html)
don't really explain it to me.  I feel like there's something I've not quite
grokked yet about factor and how things work.

---

I am pretty sure my examples.numberwang is _increadibly_ wrong.  It doesn't
feel like good code, or like I've understood the concatenative way here.  I
wonder if usinga SYMBOL for the guess is wrong headed?  I also reckon that
I've not made use of nice stack shuffling combinators when I should have.

---

## do(Hard)

Manipulating the test runner felt really hard until I re-read the section about
the test suite and poked around with the `with-null-writer`.  I started looking
at the `unit-test` and `test` methods in `test.tools`, but these didn't really
reveal themselves to me very clearly.  Took some "inspiration" from `@mudge`'s
solution which pointed me at `with-string-writer` instead of `with-null-writer`
and that got me cracking on it, but I really don't think I'd have worked it out
on my own.  Thanks `@mudge`!

> Make `test-suite.factor` interactive by turning it into a command-line
> program that asks the user which vocabularies to test via the console, then
> runs the tests and outputs the results.

I didn't do this.
