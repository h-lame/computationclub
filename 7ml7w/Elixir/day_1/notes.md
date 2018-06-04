# Elixir - Day 1

I wonder if not knowing Erlang, but actually knowing Ruby makes this chapter
harder or easier to follow?

For example, I am pretty sure that the section about reassignment (but not
really) would have more impact, if reassignment wasn't exactly how I expect
things to work.  I think I'd like to explore where it does and doesn't work
and why that's good or bad some more.

[This article][variables-in-elxir] explains it a bit more, as well as
introducing the concept of "pinning" with `^` when assigning / destructuring /
pattern matching.  Also, it makes it clear that `x = 5; x = 10` is really
`x = 5; y = 10` because the first and second `x` are really _different_
variables.  Under the hood it's doing alpha conversion which we've seen
previously at the club the several times we've tackled lambda calculus.

It seems quite bold to say "It's really like Ruby" and "Day 1 is all about how
similar Elixir and Ruby are", only for 4 pages in to say "that's where the ruby
ends". I wonder how true that is, or if it is true, why we've been pointed at
ruby in the first place.   The point about "intelligent sugar" is interesting
though.

---

I don't think I'll ever get used to `.()` syntax.  I wonder if that's some kind
of purity thing, or a parser simplification thing, or...

We can't seem to get partial functions by calling them with only some of the
arguments.  `add.(1)` doesn't give us a new function that will always add
1 to the 2nd arg.  It just gives us an error.  I wonder if we can do this sort
of thing with some other invocation syntax.

The description of `inc` and `dec` as partially applied functions seems to hint
that we can do this, but we've had to code it manually rather than getting it
direct from the language.  This hints to me that if we want this sort of thing,
we always have to do it manually, which seems lacking in a functional language.

---

Much like `.()` syntax, I remain on the fence about `|>`.  It is obviously more
clear what is going on, but at the same time, is it idiomatic elixir to always
use `|>` or only when we're doing multiple method calls?  If not, then don't we
end up mixing things and creating more confusion?  Even if we're expert
developers who use Elixir loads and have internalised reading `.()` vs `|>`
there's still a cognitive load in translating from left-to-right and
right-to-left.  Maybe it'd be better if Elixir was opinionated enough to pick
one and stick with it.

---

Pattern matching via method definitions will never not be neat to me.  I guess
it's my Java upbringing.  I particularly like the _conditional_ pattern matching
we're getting here.  It seems very powerful.

> If an inbound argument does not satisfy the condition specified in the guard,
> it falls through to the next definition.

I guess this means that the order of our definitions is important.  Not that
it's not in Ruby or other languages, but it's worth noting.

----

Tangent: you can't seem to quit `iex` with CTRL+D?  That's ... weird.

---

`is_list "string" #=> false` vs. `is_list 'char' #=> true` makes me sad.  I
wonder if this comes from Erlang (strings vs char lists) as otherwise I'm not
sure why you'd create a new language with an actual difference between a string
and a list of characters.  Particularly if the book is right, and char lists are
better in terms of performance and encoding support.

---

Keyword lists seem weird after we've seen maps.  They feel a little like the
weird map/hash thing that Factor (or was it Lua?) used.  I guess that it's the
simplest construct to use before you build in an actual hashtable
implementation.  It's good that we have real maps, but I wonder how much code
there is out there that (still) uses keyword lists - are they more efficient
perhaps?  For certain usecases only?

---

Oh, default values for arg functions effectively declaring two functions for you
is nice.  But `\\` is gross.

Is the bit about dropping the parenthesis for the last argument to a function
if it's a list suggesting that `def` itself is a function? e.g. `def foo(),
do: blah` is really `def.(foo(), [{:do, [blah]}])` ?  E.g. we're calling `def`
with two arguments, `foo()` - not that I know what that _is_ - and a keyword
list: `[{:do, [blah]}]` ?  This seems ... neat?

---

## do(Easy)

> * Express some geometry objects using tuples: a two-dimensional point, a line,
>   a circle, a polygon, and a triangle.
> * Write a function to compute the hypotenuse of a right triangle given the
>   length of two sides.
> * Convert a string to an atom.
> * Test to see if an expresssion is an atom.

---

## do(Medium)

> * Given a list of numbers use recursion to find:
>   * the size of the list
>   * the maximum value
>   * the minimum value
> * Given a list of atoms, build a function called `word_count` that returns a
>   keyword list, where the keys are atoms from the list and the values are the
>   number of occurrences of that word in the list.  For example,
>   `word_count([:one, :two, :two])` returns `[one: 1, two: 2]`

---

## do(Hard)

> * Represent a tree of sentences as tuples.  Traverse the tree, presenting an
>   indented list.  For example, `traverse({"See Spot.", {"See Spot sit", "See
>   Spot run."}})` would return:
>
>       See Spot.
>         See Spot sit.
>         See Spot run.
>
> * Given an incomplete tic-tac-toe board, compute the next player's best move.

[variables-in-elixir]: http://www.programming-during-recess.net/2016/05/08/rebinding-variables-in-elixir/
