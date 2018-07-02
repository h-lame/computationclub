# Elixir - Day 3

> you effectively redefined the Elixir language

Woah there.  We wrote an API, let's not get ahead of ourselves.  Given the
number of devs I've worked with that don't know where rails ends and where ruby
starts I reckon this is a dangerous precedent to set: macros and class level code
isn't "redefining the language".  But then, maybe it also doesn't matter.

---

I really like the interview with José Valim.  I hope the book continues with
this sort of insert.  It's really nice hearing from the language creator about
some of the reasons behind the language, and their favourite parts.  I'm
interested to read more about Protocols as interfaces in Java always seemed
useful, but restrictive and it sounds like they'll be different.

Later: we don't get to hear about protocols in the rest of this chapter :(

---

I was initially confused by the 2nd `receive`, but then I realised it's a
function that listens to messages coming into the current process.  In `iex` the
main repl is, of course, a process so we can call it without adorning it with a
function or `spawn`ing it.  The example is tossing a ball to another process and
asking it to the repl know when it caught it.

---

José's point about having decent abstractions (and named things) to discuss
various concurrency patterns seems really sensible.  The short description of
`Task` is very clear, and I wish we'd get to see more about the others, but I
guess the book isn't infinite.

---

From the example notes, I'm not sure I really understand what `handle_cast` is
for.  `handle_call` I can intuit from the contents of the function itself, but
`handle_cast` seems opaque to me, and the note on it doesn't really help.  I
guess it'll become apparent when we see how we interact with and send messages
to the `GenServer`, and what those messages look like.

Later: oh! ok.  We literally invoke `call` or `cast` (and presumably others for
the callbacks we haven't seen) and this are dealt with by `handle_call` and
`handle_cast` respectively.  They'll do some pattern matching against the
message sent, so I guess we can provide multiple implementations.  Our
`handle_call` definition accepts any action, but if we try to invoke `cast` with
a first arg other than `:add` it breaks.

---

Annoyingly, the book tells us to edit `states/lib/states.ex` but our more recent
version of Elixir gives us all the boilerplate in
`states/lib/states/application.ex`.  Worse is that editing `states.ex` seemed to
leave the app in a running, but not quite state, so trying the repl examples in
the book failed in strange ways.  Still, not the books fault really.

---

## Find...

> * The Erlang `gen_Server` behaviours
> * The way to code a timeout with an Elixir `receive`
> * Information on ERlangs OTP

## do(Easy)

> * How can you crash your server? What happens if you crash it with and without
>   a supervisor?
> * Add a timeout to the pitcher or catcher.  What happens when you time out?

## do(Medium)

> * Write tests for the OTP database.  Hint: There are two types of setup in
>   TestUnit.

## do(Hard)

> * Build some redundancy into the video store by adding a second process.
>   Writes go to both processes.  When one process crashes, make it get the
>   video database from the the OTP server when it starts back up.

Right, yes, this seems important.  I thought that Elixir / Erlang / GenServer
was just going to Do This For Me based on the description in the book, but it
obviously doesn't.  I wonder if there's a pattern for this.

> * Wrap the state machine in an agent rather than a full OTP application.
> * How would you persist the videos into Erlang's DETS database?

What now?  This seems like a big thing to drop on us as a parting shot.  I'm
certainly intrigued though.

---

> Our insatiable desire for more mobile applications and more power on the cloud
> will eventually require programmers to be concurrency experts.

Will it thought?  Seems like it if we have powerful abstractions then people
will be able to get by and create applications without knowing about the models
underneath.  Rails lets people write db-backed webapps without really knowing
too much about SQL (for good or ill, TBH), and I don't see why a decent set of
concurrency abstractions should be any different to a decent set of persistence
abstractions.

> a general-purpose functional language will need to be able to insulate its
> users from tedious boilerplate.

No disagreement from me, although I don't think it's something that only applies
to a functional language.  All languages should aim this high, regardless of
paradigm.  I wonder if functional languages have traditionally been bad in this
regard though?

---


Day 3 seems very light compared to Days 1 & 2.  The ideas we explore seem very
powerful, but we touch on them very lightly.  Perhaps that's the power of Elixir
(or Erlang TBH) though: powerful abstractions that you don't have to think very
hard about to use.

Of course, I'm not doing the exercises and maybe they would bulk out the day.
Nor am I doing any onwards reading (what are protocols that we were so enticed
by in the interview section?) so perhaps the fault here is my own, not the book.
