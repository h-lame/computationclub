# miniKanren - Day 3

---

Note: the book uses clojure 1.5.1 and core.logic 0.8.5, but I'm using clojure
1.9 and core.logic 0.8.11.  Hopefully this version discrepancy won't be as
painful as previous chapters.

---

Interestingly (or not), if I _do_ try to run `(run* [q] (<= q 1))` instead of
an infinite stream of results what I get is:

    ClassCastException clojure.core.logic.LVar cannot be cast to java.lang.Number  clojure.lang.Numbers.lte (Numbers.java:230)

I wonder if that's core.logic's way of protecting itself from these kinds of
things?  You can use comparison operators that could result in infinite sets
unless you use the finite domains stuff?  Or maybe I've forgotten how to run a
simple query.

---

When I read the first version of the "triples that add up to 100" I wondered
about the temp var `a` and wondered if we could just write a nested function.
The book goes on to explain that we have a special construct, `fd/eq` that will
pick things apart for us, but I was expecting to be able to just nest some
`fd/+`s.  I then tried to write that and realised I couldn't work it out because
`fd/+` takes 3 args, the left hand side, the right hand side of the + and the
result.  You can't really write a nested version of that.

---

Ah. `story-db` simply takes our vector of stuff and turns them into
`(db-fact ploto :cook :dead-cook)` constructs that core.logic.pldb can use. I
originally misunderstood what `ploto` did - I thought it was a function we'd see
later that would infer something, not the basic relation we'd start with.  I
should have read more closely.

---

`everyg` seems useful in the context of some of the exercises from Day 2.  Might
revisit this if I get some time.

---

Annoyingly, the code from the book doesn't seem to work.  First stumbling block
is we need to `(declare storyo*)`, not `(declare story*)`.  We also need the
full `story-db` definition which is only in the downlaoded source and not shown
in the book.  But even with that the code pasted into the repl and run gives:
`()` for the `:dead-wadsworth` example.

Later: the problem is that `story-db` is a `def` so it calculates once at the
time it's defined.  As it's based on the `story-elements` def it only picked up
the initial (truncated) version when I first defined it.  Even though I then
re-defined `story-elements` in the REPL that didn't redefine `story-db`.  I had
to do that again.  Now the example works and I know who to get a dead wadsworth!

---

I guess the previous 2 days were useful for this day, and I think what we're
saying about core.logic is that it's a super powerful minikanren because it
lives inside another programming lagnuage that you might reasonably use for
production systems.  [PlePuProPro][plepupropro] aside, that's not really true
of languages like Prolog which have miniKanren style abilities built in.

[plepupropro]: https://urbanautomaton.com/blog/2015/08/10/the-pledge-to-put-prolog-in-production/

> To give you an idea of the leverage core.logic is giving you, imagine
> implementing the narrative generator in Java or Ruby. Would it still be as
> concise and easy to extend?

Yeah, but it's not a fair example.  If we were trying to implement it in raw
clojure it'd be a painful too.  If we used a minikanren implementation in Java
or Ruby that might be a fairer comparison.  Of course, they exist only as
separate parts that you need to download, whereas core.logic comes with clojure.

> More than a library, miniKanren is a new language with a new programming
> paradigm.

I really feel like there's some incredibly muddying of miniKanren vs. core.logic
going on.  I very much want to get it clear what miniKanren is on it's own if
that even makes sense.  The book, by using a specific implementation, and
showing us how easy it is to plug into the existing ecosystem for that language
makes it harder to understand I think.  On the flipside, it does make it easy
to pick up and use, and see how useful this particular implementation is.

> Running programs backward will always put a smile on my face.

This is true.  It is super exciting!

---

## Find...

> * Examples of other people using core.logic’s finite domains.
> * Commercial products that are powered by logic engines. Hint: Include Prolog
>   in your search.

## do(Easy)

> * Code some other mathematical equations and have core.logic fill in the
>   answers.
> * Generate stories where the motorist never appears and there are at least two
>   murderers.

## do(Medium)

> * It’s more suspenseful if we learn who the killers are at the end of the
>   story. Use Clojure’s data manipulation tools to push those story events to
>   the end.
> * If the policeman arrives, the motorist can no longer be killed. This is a
>   limitation of our linear logic because inputs are always consumed. Extend
>   the generator such that story elements can have multiple outputs and use
>   this to enable stories where the policeman and the motorist are both
>   murdered.

## do(Hard)

> * Try to write a Sudoku solver using finite domains. Hint: You’ll need to
>   create unnamed logic variables with (lvar) at empty places in the grid.
>   Build multiple views on the same grid by row, column, and square.
> * Create a new set of story elements and initial state using your own
>   imagination or inspiration from a favorite book. Use the narrative generator
>   to find the most interesting version.
