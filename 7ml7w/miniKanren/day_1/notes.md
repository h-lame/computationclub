# miniKanren - Day 1

---

Note: the book uses clojure 1.5.1 and core.logic 0.8.5, but I'm using clojure
1.9 and core.logic 0.8.11.  Hopefully this version discrepancy won't be as
painful as previous chapters.

---

> Logic programs are like puzzles where only some information is given and the
> solution to the puzzle is to find the rest of the information.

Ok, yes.

> Imagine a Sudoku square where at the start of the puzzle only the rules and a
> few numbers are known.

Isn't this just a description of sudoku puzzles in general?

> Or think of a jigsaw puzzle, where only pieces of the picture and shapes are
> visible.

Wait, what?

---

> This logic program contains a single expression, `(== q 1)`, which is not the
> equality test you are used to. `==` in core.logic is the unification function

Is there a fundamental difference between `==`-as-equality and
`==`-as-unification?  E.g. is it wrong to read `(run* [q] (== q 1))` as "find
me a `q` such that q equals 1"?  What am I missing about "unification" by
reading it that way?

---

It's interesting that using `run` instead of `run*` reveals some of the
implementation details of how `core.logic` works wrt how it traverses the search
space.  For example, with `(run 2 [q] (membero q [1 2 3]))` we get `(1 2)`, but
if we swap `2` and `3` we don't get `(1 2)` anymore, we get `(1 3)`.  So it's
not starting with `1` and counting up to see if 1 then 2 then 3 fits, it's
doing something else with the values, seemingly related to the 2nd arg to
`membero`.  Is the implementation based on unpicking the AST of the unifications
and working from there?

Later: doing the mano/womano/vitalo/turingo examples from the book I get my
results in a different order to the book, even though my fact definitions and
`run*` queries are the same.  Does that negate what I said above? Or reveal that
something has changed about the order the implementation proceeds when building
solutions?

---

Boring aside: I don't understand why in the results of `(run 5 [q] (membero
[1 2 3] q))`, for the results where `[1 2 3]` isn't the head of the list we
don't have multiple `.`.  E.g. `(_0 [1 2 3] . _1)` is what we get, not
`(_0 . [1 2 3] . _1)`, or `(_0 [1 2 3] _1)`.  Why do we need the `.` between the
preceeding args and the last one, but not betwee all the others, or why isn't it
a prefix operator like `==`?  I suspect this is my clojure that is lacking and
it's not a miniKanren thing.

---

Oh, `membero` isn't silly shorthand to be read as `member o[f]`, but the `o`
means that it's something special relating to core.logic and _relations_.

It's not clear to me yet exactly what _relations_ are though.

Boring aside: because it's supposed to be a superscript o I've decided, at great
cost to my ability to type, to use unicode superscript 0 (`⁰`) instead of an `o`
at the end of my functions.

---

In:

    (with-db facts
      (run* [q]
        (fresh [p y]
          (vital⁰ p :dead)
          (turing⁰ p y)
          (== q [p y]))))

The final `(== q [p y])` isn't really a "condition" that's required to solve the
query, it's used to bind our other variables back to `q` to satisfy the thing we
asked for.

The same result can be achieved with:

    (with-db facts
      (run* [p y]
        (vital⁰ p :dead)
        (turing⁰ p y)))

So other than introducing us to `fresh` to give us "local" variables in our
queries, I'm not sure why we've expressed it the previous way.  I do wonder if
there's something that we get / don't miss out on with the `fresh` approach that
we miss out on without it.  Perhaps the fact db is too small for this to be a
problem here.  It doesn't seem to impact the "shuffled" version either.

---

What's mostly interesting to me about this intro to miniKanren is that it all
seems so familiar.  I don't have a great feeling so far for what "miniKanren" is
(as opposed to microKanren, or other declarative programming languages like
Prolog, or the club's very own Sentient).  Have we just been bathed in this
stuff for a while so that it doesn't seem so magical?  What would it be like to
be exposed to this stuff for the first time via Day 1 in this book?

---

## Find...

> * The core.logic home page
> * One of the many wonderful talks on core.logic or miniKanren by David Nolen
>   or Dan Friedman and William Byrd
> * A core.logic tutorial
> * What other projects are doing with core.logic

## do(Easy)

> * Try running a logic program that has two `membero` goals, both with `q` as
>   the first argument. What happens when the same element exists in both
>   collections?

Given:

    (run* [q] (membero q [1 2 3]) (membero q [3 4 5]))

We get `(3)`, unsurprisingly.  If we tried

    (run* [q] (membero q [1 2 3]) (membero q [4 5 6]))

We'd get `()`, again unsurprisingly.  And if we tried:

    (run* [q] (membero q [1 2 3]) (membero q [3 2 1 4 5]))

We'd get `(1 2 3)`.  I'm probably overthinking this, but I don't understand what
the question is trying to get me to figure out that isn't already obvious.

> * `appendo` is a core.logic built-in that will append two lists. Write some
>   logic programs similar to the `membero` examples to get a feel for how it
>   works. Be sure to use `q` in each of the three argument positions to see
>   what happens.

    (run* [q] (appendo q [2] [1 2]))
    #=> ((1))
    (run* [q] (appendo [1] q [1 2]))
    #=> ((2))
    (run* [q] (appendo [1] [2] q))
    #=> ((1 2))

Again, I feel like I'm missing something in how I should play with this to get
more interesting results.  `membero` could easily be used to generate infinite
lists, but I don't know how to use `appendo` to do that given that all 3 args
seem like they'd constrain things quite hard (with one unbound var anyway).

    (run* [q w] (appendo [w] [2] q))
    #=> ([(_0 2) _0])

Is at least more interesting, but still not an infinite stream (because that
`_0` for `w` hides the inifinite).

> * Create `languageo` and `systemo` database relations and add the relevant
>   facts based on which category best classifies the person’s work.

No.

## do(Medium)

> * Use `conde` to create `scientisto`, which succeeds for any of the men or
>   women.

    (defn scientist⁰ [p]
      (conde
        [(man⁰ p)]
        [(woman⁰ p)]))

> * Construct a logic program that finds all scientists who’ve won Turing
>   Awards.

    (with-db facts
      (run* [q]
        (fresh [y]
          (scientist⁰ q) (turing⁰ q y))))

This feels slightly weird given we can just use:

    (with-db facts
      (run* [q]
        (fresh [y] (turing⁰ q y))))

e.g. `scientist⁰` doesn't add anything.  I guess it's showing us how to write
functions that use facts.  Or, again, I'm overthinking this.

## do(Hard)

> * Create a genealogy system using a family tree database and relations like
>   `childo` and `spouseo`. Then write relations that can traverse the tree
>   like `ancestoro`, `descendanto`, and `cousino`.

No.

> * Write a relation called `extendo`, which works like the built-in `appendo`,
>   mentioned in the easy problems.

    (defn extend⁰ [h t l]
      (conde
        [(== h ()) (== t l)]
        [(fresh [h-head h-tail l-without-h-head]
           (conso h-head h-tail h)
           (conso h-head l-without-h-head l)
           (extend⁰ h-tail t l-without-h-head))]))

I cheated here and looked up the answer, because my first version only worked
for `(extend⁰ [1] q [1 2])` and `(extend⁰ [1] [2] q)`, but not
`(extend⁰ q [2] [1 2])`.  My first version was:

    (defn extend⁰ [h t l]
      (fresh [hh ht]
        (conso hh ht h)
        (conso hh t l)))

I knew it needed to be recursive, but I couldn't really work out how to split
the head and tail of the first element into something that would be recurseable.
What I needed to do was split the first element and combine it with splitting
the second element.  The solution I found was in the readme of [a core logic
tutorial][core-logic-tutorial] and [their implementation][their-implementation],
with less clear (to me anyway) variable names is also available as src, not just
readme contents.  My first attempt at finding it was to go direct to the [`appendo` implementation
in the core.logic src][appendo-core-logic-src] but that seems to be built using
macros and I couldn't understand it at all.  Perhaps Day 2 or 3 will enlighten
me.

[their-implementation]: https://github.com/swannodette/logic-tutorial/blob/master/src/logic_tutorial/tut2.clj#L5-L11.
[core-logic-tutorial]: https://github.com/swannodette/logic-tutorial
[appendo-core-logic-src]: https://github.com/clojure/core.logic/blob/master/src/main/clojure/clojure/core/logic.clj#L1772-L1777


