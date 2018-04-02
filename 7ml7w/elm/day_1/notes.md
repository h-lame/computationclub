# Elm - Day 1

`npm install -g elm@0.15.1`

The book is written for elm 0.15 but current is 0.18 and other club members
have investigated enough to work out that 0.18 is different enough that we'd
have to waste a whole lot of energy translating from the book to the current
elm spec.  The elm website doesn't seem to link to old versions of the installer
and whilte the github project is tagged to 0.15 for building from source, you
need haskell and its package manager to do so.  Happily we can install old
versions via `npm`.

Later:

Not 100% convinced I do have the exact same version of elm (or perhaps the elm
repl) as the author even with 0.15.1 installed from npm.  The incidental details
of the repl examples in the book don't match what I get 100%.  Thinks like:

    [1 of 1] Compiling repl          ( repl-temp-000.eml )

don't appear and in the book the type of `a = [1,2,3]` is given as `[number]`,
but I get `List number`.  It's probably exactly the same thing, but it's still
jarring.

---

In the intro the author talks about Javascript being a mess, and needing better
paradigms, better abstractions, types, etc and that being a major selling point
for elm.  I wonder how much of that opening statement is still true in 2018
where we have ES6 and libraries like react.  I've not read enough of this
chapter, nor am I enough of a modern JS developer to be able to answer that
question.  Interesting though.  Do we know if elm influenced any of the thinking
that went into ES6 or react or other parts of the modern JS ecosystem?

---

> "Fire up the elm repl"

But I won't tell you how.

`elm repl`

So actually, you have, but not in so many words.

First impressions running through the simple examples on that first repl
session: it's quite slow.  The first expression took ages, but someone on the
group slack suggested it was doing some lazy compilation or something so that
evaulating the first ever elm expression is slow.  That said, it's not like
the following expressions are fast.

---

These error messages are quite chatty.  It's obviously intentional, I wonder
if it's because of actual research into the UX of error messages in programming
languages.  The verbosity makes it hard to see the actual error I think, but
is that just because I'm used to brief and inscrutable errors that don't really
help, but do have the core problem front-and-center?

---

> single-assignment language

http://wiki.c2.com/?SingleAssignmentLanguage

---

It always feels dangerous to me when a programming language decides to use a
keyword that exists in other languages for a different purpose.  It feels like
something that will seem familiar to a new user, but ultimately trip them up
because it's not the same at all.  The `case` for pattern matching feels like
that to me.  It's _not_ the same as a `case` in ruby or SQL or other languages
that have it, even if it feels like it is so maybe it'd be better to use
something else.

Of course, maybe using a `case` like elm does came first and it's SQL or ruby
that are wrong.

---

> the `.` notation is just sugar. `.color` is actually a function

So `blackQueen.color` is sugar for `.color blackQueen`, which smacks of plenty
of other languages that bolt on object methods after the fact.  I wonder if
`object.method(...)` notation is actually that useful in the long run if many
languages really do it under the hood with `method(object,...)`.

---

The record stuff actually seems quite neat.  I suspect this is very powerful
and we'll see lots of idiomatic elm that builds on this.

---

Pipe composition seems neat.  I am left wondering why we'd do:

    double <| anonymousInc <| 5

when we could express that as:

    double(anonymousInc(5))

Instead?  Perhaps the former turns out to be more idiomatic in elm?

---

I wonder if having to put the pattern matching into our own methods means that
the parser or interpreter is simpler, because it doesn't have to keep track of
stuff for us.  If we want to pattern match, we have to be explicit about it
rather than implicit with multiple definitions.  It would also keep all the code
in one place, rather than allowing it to be splashed all around.  I can imagine
a pathological programmer who would put all their terminating cases in one file
and all the recursive definitions in another, rather than grouping by function.
So maybe it's a design choice not influenced by the underlying impl.

---

Oh, so the currying thing is why we don't have `method arg1, arg2` and only
seem to see commas in data definitions like lists and records.  I wonder if
this makes the backwards pipeline syntax make more sense?

---
