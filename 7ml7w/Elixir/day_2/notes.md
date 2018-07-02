# Elixir - Day 2

I wonder if maps are structs, or structs are maps with some sugar (like ruby's
openstructs perhaps)?

---

Tracing things through from rent -> state_machine -> fire -> fire -> activate
seems quite confusing (this could be my dip-in-and-dip-out approach to reading
this chapter though).  Is the problem here a confused model, or that I'm missing
something about idiomatic elixir?

Later: oh, the book addresses this as somewhat intentional to drive us towards
using macros to tidy things up. Well played, Book, well played!

---

Access to the AST via `quote` is neat.  This is where some of the LISP influence
is coming in I think.

---

Introducing `__using__` to avoid doing `StateMachine.state` seems like an
esoteric concept to introduce at this stage.  Like starting a ruby thing with
descriptions of `module#included`.

---

> Notice there’s no = sign. Module attribute assignment is not a
> matchexpression, as the runtime = would be.

I am 100% sure I would mess this up almost every time.  I'd like to explore what
this really means.

---

I'm slightly confused by `unquote` and how we've written our own function with
the same name that seems to take two sets of arguments.  I think I'm just not
familiar enough with elixir to parse this.  I assumed `unquote` was a built-in
like `quote`, but maybe it's not and all the instances get passed through this
version we've written.  But maybe not?

---

## Find...

> * The elixir-pipes GitHub project. Look at how the macros improve the usage of
>   pipes. Look at how `pipe_with` is implemented.
> * The supported Elixir module attributes.
> * A tutorial on Elixir-style metaprogramming.
> * Elixir protocols. What do they do?
> * `function_exported?` What does that function do? (You will need it for one
>   of the next problems.)

## do(Easy)

> * Add a find state to the state machine that transitions from lost to found.
>   Add this code in both the concrete and abstract versions of your state
>   machine. Which is easier, and why?

## do(Medium)

> * Write tests for VidStore.
> * What was different, and what was the same?

Isn't this what they made us do in the last section of the code before the "what
we learned in day 2" bit?  What did I miss?

## do(Hard)

> * Add `before_(event_name)` and `after_(event_name)` hooks. If those
>   functions exist, make sure fire executes them.
> * Add a protocol to our state machine that forces a state machine struct to
>   implement the state field.
