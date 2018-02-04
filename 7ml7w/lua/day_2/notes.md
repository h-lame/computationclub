# Lua - Day 2

Table constructor for non string values, or for strings that don't conform to
method name rules is to use `[]`.

    thing = { [123] = "hats", ["foo bar"] = "baz"}

You still have to use the `[]` syntax to get these values though because
they're not valid method names.

    thing[123] -- not thing.123
    thing["foo bar"] -- not thing.foo bar or thing."foo bar"

It's actually because the `{foo = 1}` syntax is sugar for setting the keys as
strings.

---

Chapter 7.1 about iterators answers some of the questions we had on Day 1 about
closures.  Yes lua has them, and they seem to do as we would expect.

---

We can mix arrays and dictionaries in one table:

    thing = {"hats", "cats", "bats", mats = "rats"}
    print_table(thing)
    -- 1: "hats"
    -- 2: "cats"
    -- 3: "bats"
    -- mats: "rats"

And we can even mix array and dictionary stynax to define an array:

    thing = {"hats", "cats", "bats", [4] = "rats"}
    print_table(thing)
    -- 1: "hats"
    -- 2: "cats"
    -- 3: "bats"
    -- 4: "rats"

But only at the end:

    thing = {"hats", "cats", "bats", [4] = "rats", "mats"}
    print_table(thing)
    -- 1: "hats"
    -- 2: "cats"
    -- 3: "bats"
    -- 4: "mats"

And we can't overwrite values already defined:

    thing = {"hats", "cats", "bats", [2] = "rats"}
    print_table(thing)
    -- 1: "hats"
    -- 2: "cats"
    -- 3: "bats"

Once we've defined it though, then we can do whatever we want, so it seems this
special handling of arrays is just in the constructor syntax

---

The length operator we saw for strings, `#`, works on tables, but only if they
are "array" style tables, it doesn't count dictionary style entries.

    #{1,2,3}
    -- 3

    #{foo = 1, bar = 2, baz = 3}
    -- 0

---

When definining `Villain` we set the metatable of the object we build to be
the "superclass" `self` - which is `Villain`.  We also set the `__index` special
function of the "superclass" to be itself.  This means prior to calling new
`Villain.__index` is `nil`, and after calling `new` to construct an object it is
itself.  This seems weird, why isn't it `obj.__index = self`?  (aside from the
fact that it doesn't work when we do that, obvs...).

---

The book suggests that we re-write Villain and SuperVillain, to declare the
`new` and `take_hit` methods with the `:` syntax.  However, the existing version
works just fine if we call them with `:` instead of `.`.  I wonder if this is
a conventiony thing.

---

> This is all stock Lua table manipulation

Sure, but `array[1] = array[#array]; array[#array] = nil` seems like an unusual
construct for shifting everything down by one.  To me it reads like:

> set the first element of the array to the element at the end and then
> set the element at the end to nil.  What happens to all the rest?

_time passes_

Of course, because we use `sort_by_time` before `remove_first` it doesn't
actually matter.  What we're doing *is* as I described; capture the 1st item
and then put the last item in its place and blank out the last item.  The
array will no longer be in order, but it will be shorter, which is all we
care about.

---

I was surprised that the behaviour of `punch.lua` was that we output stuff
and then wait.  Of course, this is because we `print` first and `schedule`
after, so we do a thing, and then tell the scheduler to wait before it talks
to us again.  This surprised me as I thought it was a problem in `scheduler`
but it's actually a function of what our `punch` and `block` methods do. If
we flip the `print` and `schedule` calls around it does what I expect, although
it does delay the first bit of output.

---

Interesting that the interview with Roberto suggests that the "CSV as
configuration" example in Day 1, which seemed baffling to us, might actually
be a canonical reason for the language existing (it's not clear if CSV was
what they were converting away from).

Tangent: the interview mentions Roberto was surprised when Grim Fandango came
out, presumably because it used Lua.  Was GF the first game to use Lua as a
scripting engine?

---

## do(medium)

Part 1: I struggled with this for ages because it doesn't seem like it's easy
(or indeed possible) to run code when all tables are created, and manipulating
`_G` doesn't seem like it would help.  The answer isn't that we want to augment
*every* table, just those in the global scope, which is what `_G` stores.  We
can do this with `__nexindex` because ultimately what we do when we declare a
new variable as `foo = { bar = 'baz' }` is `_G['foo'] = { bar = 'baz' }`.  It's
tables all the way down!

Tangent: the exercise for this and `concatenate` say "array", but we don't
really have arrays, just tables.  Do we expect `concatenate` to work for all
tables (I can't see how my impl. wouldn't), and do we expect `+` via
`concatenate` to work for all tables?  Should we be checking that the table
only has numeric keys?  Adding an array to a table ends up dropping the keys of
the table - is that expected?

It's sad that with this hack `{1,2,3} + {4,5,6}` doesn't work (which is what
tripped me up initially), but it's neat that Lua checks the metatable of the 2nd
arg if the 1st doesn't have one so that all this works:

    a = {1,2,3}
    a + {4,5,6} -- we'd expect this because a has the hack
    {4,5,6} + a -- wouldn't expect this, but Lua does a thing!


Part 2: I thought Lua had negative indexing, but it seems not.  Or, not in the
way I expected.  You can ask for `a[-1]`, but it doesn't give you the last entry
it gives you the value with key `-1`.  I guess this makes sense, because arrays
are just tables.

Then I read up on the table std library (https://www.lua.org/pil/19.html) and
realised that table has push/pop already via `insert`/`remove` (as made explicit in
https://www.lua.org/pil/19.2.html).  It does say that the `insert(table, 1,
value)` or `remove(table, 1)` aren't particularly performant because it moves
everything around, so I wonder if my naive lua impl is faster?  (Probably not
because `insert`/`remove` is in C).

---

## do(hard)

Surprised we have to seed the PRNG manually, otherwise we get the same seed
each time and every run generates the same 5 random numbers.

Found it also surprising that the book suggests we need more than one coroutine
when I think I'm only using one.  Of course, what I realise the book means now
is that you have to call `coroutine.create` more than once, which is what I'm
doing, but as it's effectively the same line of code, called in a loop I
mentally ascribed it to be the _same_ coroutine.  I thought the book was
suggesting we'd need more than one coroutine that _did different things_.
Which we don't need.
