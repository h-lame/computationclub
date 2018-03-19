# Factor - Day 3

I find the extremely liberal use of punctuation in order to name words and
make their intent clear to be very charming.  `>>price` and `price>>` are
pretty cool.

> boa constructor

Come on!

Seems like these `TUPLE`s are similar to ruby structs, on the face of it
anyway.

The `<factory>` stuff is interesting, I'm not sure why we wrap the word in
angle brackets, but it's clearly some idiom ratehr than anything
syntactical.

The `T{...}` stuff is nice too.  I assume that things like `[]` and `T{}`
are later additions to the language, added to make things easier as people
developed programming idioms in the language.  It is strange to flip from
postfix to prefix notation though.  It feels a little strange.

---

We had to use `inline` in Day 2 in order to get something to work (a word
that took a quotation) and it was sprung on us without any explanation.
Googling for a solution to the error message was pretty hard, as it seems
that factor is quite the ungoogleable language.  It's a shame we don't
get much more discussion of what `inline` really means here, we just have
to take it on faith that we need it, because words that take quotations
are "combinators", and move on.  I think it might be a core feature of
factor that helps explain more about the stack and how we program in
factor.  Calling them "combinators" in suggests something of the lambda
calculus to me, but it may be a red-herring.  Either way I guess we're
not going to get that discussion in this chapter.

---

> Notice how easy it is to assemble words into pipelines. The implied
> function composition and automatic use of the stack means that our
> code reads beautifully. There is very little noise because we don’t
> need any punctuationto assemble words or variable names to transport
> values from one word tothe next.

I think this is partially true.  There are echoes of some of the pipeline
operator I've seen people talk about with elixir (spoilers for language
4 I guess), but while we don't need syntax or variables, having to use
obscure (to me, an unfamiliar factor programmer) wors like `dup` and `tri`
at the start and end of the `total` word don't seem 100% better than any
other syntax for pipelines.

I wonder if the implicit stack and lack of temporary variable names:

a) are powerful for sure, we can avoid a lot of boilerplate we'd need
   in other languages, but...
b) mean the programmer has to keep more in their head while writing
   and reading the code, and I think that might make the language
   look simpler, but _be_ harder.

---

I find the pattern in this chapter where we are shown some code that we
should run but the very next paragraph explains that it was expected to
fail to be very frustrating.  Particularly when the code as presented
in the chapter is broken for other reasons.  How am I supposed to know
when the code is broken because of a typo, or because some of the code
has been elided by mistake vs. it's broken for pedagogical reasons?

---

Actually, the aside "in defence of fizzbuzz" is actually pretty good.
I'm a big fan of using small, known, problems as a playground for
learning about new architectures, programming paradigms, or whatever.

And I think it's fair to say that the `fizzbuzz-with-pipeline` does
actually show that pretty well.  This is a "factor"-native version
of fizzbuzz that shows things about factor, that the transliterated
`fizzbuzz-traditional` doesn't.  This isn't just a version that uses
factor-idioms, like how we name words or whatever, it's a process of
breaking things down and composing functions that would be hard to
iterate forwards towards from the imperative version.

For all I may have complained about other examples in the book, I
do really like this one section.  It peels back the covers of factor
and explores what is unique about it pretty well I think.  I just
wish there was more like this.

---


> It’s also worthnoting that the name Factor does not make it any easier
> to search the Webfor answers.

100 times this. If nothing else, it proves the old saying about the
hardest things in computer science.  Arguably googleability would not
have been so much of an issue when factor was created, but it can't
have helped grow the community in recent years.
