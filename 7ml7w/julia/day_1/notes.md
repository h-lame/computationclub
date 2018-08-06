# Julia - Day 1

> What about a multidimensional array?  No problem.  Plus is still plus, and
> will add to each element.  You can even distribute the plus across the whole.

What?  On first reading I can't tell the difference between "add to each
element" and "distribute the plus across the whole".  I hope this will become
apparent soon.

It seems interesting that on day 1 we're seeing data structures, and on day 2
we're seeing control flow.  For other langs I seem to recall that we'd cover
both of these as part of day 1.  This suggests either that control flow is weird
or the data structures are super powerful.

Later: arrays do seem very powerful, but dicts don't.  This seems like an oddly
truncated day 1 compared to other languages.

---

    typeof({:foo => 5})
    ERROR: syntax: { } vector syntax is discontinued

Boo!  Seems the `{}` syntax is removed.  I can't find an exact reference to it,
but it seems it's replaced with a more functional approach:

    Dict(:foo => 5)
    Dict{Symbol,Int64} with 1 entry:
      :foo => 5

Interestingly, if we try using `[]` to define the dict, we get something else:

    [:foo => 1]
    1-element Array{Pair{Symbol,Int64},1}:
     :foo=>1

Seems that `=>` is some kind of constructor of a pair object, and maybe the `{}`
syntax was confusing things.  It's unclear why we've dropped the first class
nature of dicts though, and relegated them to a function when arrays and pairs
have syntax.

Later:  The book suggests that we have `{}` for "implicitly typed" dicts with
the `Dict{Any,Any}` type, and `[]` for "explicitly typed" dicts.  We don't have
either of those syntaxes any more, and TBH they seem ripe for confusion so it
does feel like a good thing.  We can get an "Any" dict via the function, if we
supply multiple pairs at definition time:

    Dict(:foo => 6, 7 => "hat")
    Dict{Any,Any} with 2 entries:
      7    => "hat"
      :foo => 6

I wonder how we go about creating an "Any" dict using the function, if at
definition time we don't have all the pairs that would make us get an "Any".

Later still: Seems we can construct typed arrays with a type prefix to `[]` so
that we can make sure we get an array of floats, even if we have to start with
integers.  I tried doing `Dict(Any, Any)` but this created a dict with a key
of `Any` whose value was `Any`.  Then I tried `Dict{Any, Any}` which seemed to
work, except it hadn't created an actual "any dict".  What I'd created was
instead the type signature for an "any dict".  Finally I realised that I needed
to invoke that type signature with `()`.  Functions are first-class in Julia, so
`Dict{Any, Any}` is a reference to a function, not the result of one.  Chances
are it is actually the result of calling the `Dict` function with `{Any, Any}`
which is some other form of invoking it than `Dict(:foo => 1)`.  Either way we
need to do `Dict{Any, Any}(:foo => 1)` to get a properly created "any dict".

---

`\` inverse division!  That seems interesting.

---

> The `in` function is exactly the same as the [`in`] operator.  It has special
> syntax support so you can use it either way.

This kind of thing intrigues me, why do we give certain functions special status
so that they can be "sugared".  More prosaically, I'm also intrigued to find out
if the "special syntax" is something that julia programmers can create for their
own functions, or if it's only available to the programmers of julia to grant to
functions they deem special.  If the latter, why?  If the former, how idiomatic
is it?

---

Arrays starting from `1` and using `end` to get the last element are nice
touches.

> This is similar to Python's -1, but a bit more readable

Of course it is, but `-1` can be replaced with `-2` or `-3` or `-<whatever>` to
read from the list in reverse.  It doesn't seem like `end` is some sugar for
`-1` and we can still use `-1` for reverse indexing though.  :(

---

> Since you can use them just like regular arrays, you can pass them to
> functions so that those functions operate only on a subset of the data.

This seems super powerful.  Particularly if this means we can have an array of
10 elements, pass a slice of the middle 4 to a function and have it change those
elements in the array.

---

Using semicolons to define multi dimensional arrays seems super neat.  And using
commas in the indice to refer to an n-dimensional value also seems neat.

---

## Find...

> 1. The Julia manual
> 2. Information about IJulia
> 3. The Julia language Reddit, which has blog posts and articles related to
> Julia

## do(Easy)

> * Use `typeof` to find the types of types.  Try `Symbol` or `Int64`.  Can you
>   find the types of operators?
> * Create a typed dictionary with keys that are symbols and values that are
>   floats.  What happens when you add `:thisis => :notanumber` to the
>   dictionary?
> * Create a 5x5x5 array where each 5x5 block in the first two dimensions is a
>   single number but that number increases for each block.  For example,
>   `magic[:,:,1]` would have all elements equal to 1 and `magic[:,:,2]` would
>   have all elements equal to 2.
> * Run some arrays of various types through functions like `sin` and `round`.
>   What happens?

## do(Medium)

> * Create a matrix and multiple it by its inverse.  Hint: `inv` computes the
>   inverse of a matrix, but not all matrices are invertable.
> * Create two dictionaries and merge them.  Hint: Look up `merge` in the
>   manual.
> * `sort` and `sort!` both operate on arrays.  What is the difference between
>   them?

## do(Hard)

> * Brush off your linear algebra knowledge and construct a 90-degree rotation
>   matrix.  Try rotating the unit vector `[1; 0; 0]` by multiplying it by your
>   matrix.
