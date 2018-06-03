# Elm - Day 3

As noted in [my day 2 notes](../day_2/notes.md) the group decided to go off book
for Elm as the book content was out of date with modern Elm.  We read [The
Elm Architecture](https://guide.elm-lang.org/architecture/) instead.  As it
turns out we took 2 meetings to cover that and explore all the things we wanted
to properly so my notes for [day 2](../day_2/notes.md) cover everything that the
group read for day 2 and day 3.

Below are my notes from reading Day 3 of the book anyway though.  Just in case.

---

Game structure does seem quite neat.  Having everything set up with a few lines
of code is very powerful, and the point that the event loop and timing are often
the hardest part of the game code is well made.

---

> We use type aliases because we'll need to reuse these definitions througout
> our game.

It's not clear to me what a type alias is, instead of just a type.  Is it
because we want to have multiple things called `Player` and `Game`?  Or is it
some boilerplate that lets you repeat a definition in mutiple modules?

---

`secsPerFrame` is a function?  does elm not have costants?  Everytime we want to
refer to `secsPerFrame` we ultimately have to find that function, call it and
perform the code inside it?  Which admittedly in this case is just a simple
division, but still.  Or is it not a function at all?

---

Interested in the design choice that went into `<~` as a short hand for `map`.
It's only 1 char shorter than `map` but it's also an `infix` operator rather
than a more traditional method call.  E.g. `foo <~ bar baz` instead of `map foo
(bar baz)`.  Maybe the saving is 1 char on `p` and 2 chars on `(` and `)` around
the final arg to `map`.  Seems odd though.

Or maybe it's just to look like `~`, which we meet next and seems to provide
unification across `map` and `map2`.  Wonder if it is "infinite" so we don't
need `map10` as a function?

---

It's a shame that Day 2, which lays the foundation for what we do in Day 3 uses
concepts that have been replaced in modern Elm, as what we actually get in Day 3
is pretty interesting.  It is nice that we can write a complete game with only
a small amount of code because Elm's runtime does a whole bunch of heavy lifting
for us.  We don't really learn much new about Elm on this day, but it is nice to
see a whole game application and talk through it in detail.

---

We're directed to find and read: http://elm-lang.org/blog/making-pong - it's
good, but doesn't add much that we haven't covered here.  It's also not updated
with modern Elm so it's not like we can use it to examine the diffferences
between a Signals-based game and a Subscriptions-based game.

---

I'm not doing the exercises.

---

> When something is right, you can feel it.  To me, a while lot of Elm feels
> right.  It may not be the final winner, but these concepts are helping the
> industry head in the right direction.

I think this is a key insight; Elm doesn't feel like it'll be what we use to
write web applications in down the line. I think it's too different and too
esoteric for most devs, but the ideas it introduces are powerful and I think
we'll see them more, but in something more like "standard" JS, not, for better
or worse, with Elm.
