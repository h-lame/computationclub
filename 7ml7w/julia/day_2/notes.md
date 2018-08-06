# Julia - Day 2

Using `=` in loops to destructure the array seems like an interesting choice. Is
it inspired by maths notation, or just a quirk of the designers.  I wonder how
idiomatic it is to use `=` vs. `in` (vs. some other construct?).

---

The intro to user-defined types reveals that the `Dict(...)` syntax we have to
use now instead of `{}` or `[]` to build dictionaries is a constructor, not a
special function.  Still intrigued about the `Dict{...}(...)` form, can we
create types that take the same dual params?

---

Aside: if this chapters theme is Star Trek, and specifically the Borg, why are
the `MovieCharacter` examples based on the wizard of oz?

---

More language deprecations:

    abstract Story

is now:

    abstract type Story end

and:

    super(Story)

is now:

    supertype(Story)

---

While we can't do multiple nesting of concrete types, we can do multiple
nesting of abstract types.

    abstract type Foo end
    abstract type Bar <: Foo end
    abstract type Baz <: Bar end

This is ok, but:

    abstract type Foo end
    type Bar <: Foo end
    type Baz <: Bar end

Doesn't work.  It actually seems a little more interesting than "no nested
subtypes" in that:

    type Foo end
    type Bar <: Foo end

doesn't work either.  This is only one level of nesting, so maybe it's that you
can't use concrete types as supertypes.  Interesting.  While looking up the new
function for `super` I came across loads of stuff about the type system and it
suggests we can create composite and union and parametric types, so I think it's
a powerful system and "no nesting" won't really be a problem.

---

`generic function with 1 method` is an intriguing output to get after defining a
method.  The book mentioned "multiple dispatch" will be covered later, so I'm
hoping this will explain it.

---

> All of Julia's operators are also functions and can be used in prefix notation
> too.

This makes me think that there must be something we can do to create our own
operators and infix functions.  Neat!

---

I'm not sure I understand the distinction made between "overloading" and
"multiple dispatch".  Nor that the definition of "multiple dispatch" is
necessarily "more powerful".  I think they might be thinking of a specific
other language's implementation of "overloading" and comparing it to Julia's
"multiple dispatch", but they haven't named it.  To me, it seems exactly the
same as, for example, what Elixir was doing, but the book didn't go ga-ga over
that.

> In object-oriented languages, it ends up being whichever type is written on
> the left, which doesn't make a lot of sense, but people have gotten used to
> it.

Fair play, this is a good call.  Although often we end up with things like that
living as methods that take multiple args and live on some kind of grab bag
utility object.

> Multiple dispatch is a rarely seen language feature assimilated directly from
> Lisps.

Is it though?  As a very rusty Java programmer I feel like Java does this too.
Maybe Java was inspired by Lisp, or maybe I'm getting multiple dispatch confused
with overloading, but I don't quite get it.

> There's no need to subclass `Int64` to add a new type of `concat`, nor do you
> need to modify the `Int64` object with monkey-patching.

Right, ok.  Now I think we're getting down to it, although I feel like this is a
feature of a functional language where data and behaviour aren't tied together,
not really a feature of multiple dispatch.  I also feel that "powerful" and
"beautiful" as descriptors here might be an "eye of the beholder" kind of thing.

> try running `methods(+)` at the REPL

Gosh, yes, that's a lot of `+`es.  Of course, with powerful enough introspection
tools I suspect any OO language could generate a similarly verbose list of `+`
implementations that act on a similarly bewildering array of arguments and base
types.

---

More deprecations.  The `flip_coins` implementation should be, I think:

    function flip_coins(times)
      count = 0
      for i = 1:times
        count += convert(Int64, rand(Bool))
      end
      count
    end

Later: and `pflip_coins` should be:

    function pflip_coins(times)
      @parallel (+) for i = 1:times
        convert(Int64, rand(Bool))
      end
    end

Later still: and `flip_coins_histogram`:

    function flip_coins_histogram(trials, times)
      bars = zeros(times + 1)
      for i = 1:trials
        bars[pflip_coins(times) + 1] += 1
      end
      hist = pmap((len -> repeat("*", convert(Int64, len))), bars)
      for line in hist
        println("|$(line)")
      end
    end

---

A built-in macro for timing functions is nice.  Similar to what we'd do in our
shell too.  Intrigued by what `@parallel` actually does, it's nice to have it
though.  I'm not sure I agree that:

> the parallel version is even a bit easier to read

though.  I expect this would change as I got more familiar with the language and
parallelisation in general.

---

I really like the interviews with the language creators.  I think I'd like to
read a "Seven interviews with language creators in seven chapters" book more
than I'd like to read another "Seven languages in seven weeks" book.

> Of course, it's not too late to change some of these choices.

I think this is particularly refreshing.  As we've seen from some of the
examples in the book that no longer work with the current version of Julia it
doesn't seem like they shy away from making changes if it simplifies the
language.  I wonder what drives those changes though, simplifying the language
for users, or simplifying the language for the creators.  Of course, that might
be a false dichotomy.

---

## Find...

> * The parallel computing part of the Julia manual.  Specifically, read up on
>   `@spawn` and `@everywhere`.
> * The Wikipedia page on multiple dispatch

## do(Easy)

> * Write a `for` loop that counts backward using Julia's range notation
> * Write an iteration over a multidimensional array like
>   `[1 2 3; 4 5 6; 7 8 9]`.  In what order does it get printed out?
> * Use `pmap` to take an array of trial counts and produce the number of heads
>   found for each element.

## do(Medium)

> * Write a factorial function as a parallel `for` loop.
> * Add a method for `concat` that can concatenate and integer with a matrix.
>   `concat(5, [1 2; 3 4])` should produce `[5 5 1 2; 5 5 3 4]`.
> * You can extend built-in functions with new methods too.  Add a new method
>   for `+` to make `"Jul" + "ia"` work.

## do(Hard)

> * Parallel `for` loops dispatch loop bodies to other processes.  Depending on
>   the size of the loop body, this can have noticeable overhead.  See if you
>   can beat Julia's parallel `for` loop version of `pflip_coins` by writing
>   something using the lower-level primitives like `@spawn` or `remotecall`.
