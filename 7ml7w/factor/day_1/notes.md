# Factor - Day 1

It feels pretty unusual to me to be installing a new programming language and
the default for running it is a GUI app (even if it's basically a REPL with
some extra bells and whistles).

Later: it's incredibly annoying that this gui doesn't have readline support
in built. Althought it can be provided with [an extra
vocabulary](http://docs.factorcode.org/content/vocab-readline-listener.html)
for the listener.  It does have a click to repeat thing though, so that's
nice.

Later later: oh, that readline vocabulary is only for the terminal factor
listener, which we've not been introduced to yet.

---

I guess that a concatenative language like this has a very simple parser, and
I also guess that we're going to need our old friend the y combinator for doing
conditionals with short-circuiting.  Maybe?

Later: oh right, no, that's what quotations (anonymous functions are).

I think I like the idea that we have to think more like the computer, our
program (and thus thought process) has to be: "do this" "then this" "then
that".

---

I wonder how much maps/dicts/hashes being a list of two-element lists is a
concious design choice made for simplicity's sake (it's what you'd do in a
lisp, right?) and how much it was something that grew out of a lack of a first
class version, and a desire not to add more punctuation.  Why do we have:

    { 4 3 2 1 }

Which introduces something that comes *before* the elements we want to act on,
instead of something like:

    4 3 2 1 4 list

e.g. 4, 3, 2, 1 are the 4 elements we want to put in a list.  Obviously that'd
be a pain to write all the time for something we likely use all the time, but
wouldn't it be purer?  However, with that sugar added, why do maps have to be
so cumbersone?  Why can't they have sugar too?

All that said, it is interesting that we have `of` and `at` for accessing
things in a map depending on the order of the things in the stack.  I wonder if
this will be a theme for factor's stdlib where we get pairs (or triples or
quads or...) of functions to deal with parameter ordering.  Or again, just for
a few select operations that are used regularly.

Later: Oh, right, quotations also get special sugar with `[ 42 + ]`.  So it's
not like lists are the only ones (TBH this is good, be weird if it was the only
special syntax case).

---

I like that it seems like most characters are valid word characters.  It
appeals to the rubyist in me that we can have predicate `?` and bang `!`
methods.  I reckon it'll take a while to get the mnemonics for `bi` vs `bi@` vs
`bi*` though.

---

## do(Medium)

I made the Factor.app crash by entering:

    ! Use map and reduce to get the sum of squares from 1 to 10
    10 ! limit
    [1,b] ! sequencer
    [ ^ 2 ] ! map quotation
    map
    0 ! initial
    [ + ] ! reduce quotation
    reduce

E.g. I had `[ ^ 2 ]` instead of `[ 2 ^ ]` as my quotation for map.  It just
hung forever, I wonder why it didn't break with a missing number of arguments
for `^`, or a type error.  I wonder if it depended on what was on my stack
from the previous questions.  Perhaps there was enough on my stack for it
to actually try to do this function too many times.

---

## do(Hard)

Curious about how `each` works I tried `"abcde" [ ] each` and found that it
iterates over the characters in the string.  I then tried `"ë" [ ] each` and
saw that it gave me `235`, I then tried `"✔️" [ ] each` and got `10004 65039`
on my stack so it seems it isn't iterating over characters, but bytes perhaps?
I debugged this with `1string` (e.g. `"✔️" [ 1string ] each`) and got back:

    --- Data stack:
    "✔"
    "️"`

Which is less good.  I then tried `"💀" [ ] each`, or I would have, if typing
the skull hadn't messed up the interpreter entirely.  It gave me a pop-up
dialog with `"Cannot create slice" from 0 to 3 seq "\"💀" reason "end > sequence""`
in it.  The UI was then borked and I had to quit and restart.

Tangent: for a "hard" question it seems unusual that it gives us the algorithm
and also the list of words we've to use, which essentially convert directly
from English into the factor code.  Perhaps this is feature not a bug though,
expressing how simple it is to think about a problem and then just write it down
as we would think it.
