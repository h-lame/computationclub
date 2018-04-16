# Elm - Day 2

Note: The book covers Elm 0.15 and this chapter focuses on a feature called
Signals and creating web-apps in the online Elm editor.  Unfortunately, for us
[Elm 0.17 removed them completely](http://elm-lang.org/blog/farewell-to-frp) and
replaced them with Subscriptions, a completely different concept and API.  This
makes it hard to follow along with the book.  Instead we decided to read [The
Elm Architecture](https://guide.elm-lang.org/architecture/) and deal with User
Input and Effects which covers similar ground to the book and uses the
Subscriptions feature.

I'm a masochist though, so what follows are my notes from reading Day 2 of the
book, and then reading The Elm Architecture afterwards.

---

## The Book

I really like the excerpts of interviews with the language creators that the
book occasionally drops in.  A different (better?) version of the book would go
deeper on these to explore each concept explored and give us a better idea of
why the feature is there.

---

The "farewell to FRP" post suggests that Signals were complicated and removing
them made what you had to understand about developing with Elm much more simple.
On the basis of the first few pages of Day 2, I can only agree.  I don't really
get what `Signal.map show Mouse.position` does.  Well, I do, because as I move
the mouse, it updates some text to show me the result.  But I don't really
understand what `Signal.map` does, what is is mapping to and from or over?  The
book doesn't go into a huge amount of detail here.

It's a shame the `Signal.foldp` example is missing from the (print version of)
the book as we jump straight from "what is foldl" to "here's a foldp with the
`Keyboard.arrows` signal" without showing us the code.  It's not hard to imagine
what it looks like:

    Signal.foldp (presses arrow -> presses + arrow.x) 0 Keyboard.arrows

Or something like that anyway based on the next example with `Mouse.position`
but it's missing and that's annoying.

---

> `foldp` works just like `foldl` did, but instead of folding across a list
> from the left, `foldp` folds across time, from the past

What?  I am pretty sure there's a clearer way to explain this.  I think that
where `foldl` returns an accumulated result, `foldp` returns a function that,
given a `Signal` instance, will execute whenever the signal updates and yield
the value to anything that is listening for it.  Like a `Signal.map` call for
example.  It's like map reduce for events?

---

Knowing that an entire code snippet from the previous page is missing I can't
help but wonder if there's something missing from:

    import Graphics.element exposing (show)
    import Keyboard

    main = Signal.map show Keyboard.arrows

to mean that it outputs `{ x = 1, y = -1 }` after we press up and right.  Does
Elm really map keyboard arrow presses directly to co-ordinate manipulations
without some other intervention?

---

Like with Factor before Elm I'm genuinely intrigued by the need for shortcuts
like `map2` for mapping two things.  Would something like:

    Signal.map div (Mouse.x Window.height)

(or whatever syntax we'd need to create a tuple) not suffice?  How do we, as
a programming community, decide that `map2` is ok, but `map3` or `map4` is
beyond the pale?  FWIW it looked like factor was happy with 3 arg variants, but
I didn't see any 4-arg variants I don't think.  Shouldn't there be some generic
construct for doing this?  Maybe there is but it's painful, which might mean we
should focus on making it less painful, instead of introducing `map2`.

Later: while reading the page on [`Random`](http://package.elm-lang.org/packages/elm-lang/core/latest/Random)
it seems that Elm goes up to `map5` on here.  I wonder if that's the Elm limit,
5.

---

Unfamiliarity with Elm aside, the shout+whisper example does point at writing
web apps in Elm being particularly concise.  It's nice not having all the
boilerplate for hooking things up.  It is a bit jarring to see direct references
to `onInput` in the example html though, after years of JS where we don't inline
event handlers.  I wonder what the generated HTML + JS actually looks like?

---

It's a shame that Elm changed so drastically between 0.15, the version available
when the book was written, and 0.18, the version available at the time I'm
reading it.  It's an even bigger shame that the book suggests using an online
editor to explore the features it talks about for this day as it makes it very
hard to follow along.  I think the examples shown do point at how simple Elm
has made writing web apps, and how powerful the functional abstractions it has
provided over the standard DOM manipulation are.

Onwards to:

---

## The Elm Architecture

### https://guide.elm-lang.org/architecture/

Are they saying that they invented MVC? Even if they call it Model, View,
Update?  Is that what the elm architecture is MVC, but not as you know it from
writing server-side web apps, but the version you'd recognise from writing GUI
apps?

---

Ok, it's quite neat that the model can be just an int.

Are `main`, `model`, `update`, `view` actually keywords, or syntax perhaps in
Elm?  They have a different colour in the rendered code examples, although it's
not the same as other things I am fairly sure are keywords (import, type) so
maybe they're not?

Later: `viewValidation` is also in the grey font so I think maybe that this is
reserved for the names of functions in their definitions, not to highlight
keywords.  Probably under the hood model, view, update are special, but only
because they're the attributes in the record you provide to `Html.beginnerApp`
(and presumably to other methods on Html for apps that aren't for beginners).

Later still: `getRandomGif` also has this.  There's no way that is a keyword.
Hurrah me, I've intuited the meaning of something using typography and
repetition.  Just like The Witness trained me to.

---

### https://guide.elm-lang.org/architecture/user_input/

How we map from the view being declared as something that produces `Html Msg`
values, when it's written to just produce some Html seems like something deep
to be investigated.  The Html is constructed to have event handlers that will
produce `Msg`s, but how does Elm know to connect those to the `Msg` in the
"return value" of the view function?

(Is that even right, is `view` a function?  Is `Html Msg` it's return value?
Am I completely misreading this?)

If we wrote some Html that didn't have any event handlers to generate `Msg`s
would Elm refuse to compile?

---

### https://guide.elm-lang.org/architecture/user_input/forms.html

It's weird (to me) that the page about Forms doesn't include an actual Form,
just a bunch of inputs.  I suspect this is just a "get off may lawn" moment
though.  It doesn't feel like this section on Forms is significantly different
to the previous section on text fields.  I guess that a client-side app
framework has less interest in actual forms though, as they suggest a backend
that isn't really present (by default) with an Elm app.

---

I think I do buy the "the html is just Elm so no fancy templating language
required" argument here.  All the refactoring and reuse stuff we learn for
writing "normal" code can be applied to our view code, and has the benefit of
not passing around Strings.

---

### https://guide.elm-lang.org/architecture/effects/
> Have a general purpose time-travel debugger.

Is Elm doing Event Sourcing out of the box?  Is that what this means?  Does
the runtime collect all this stuff for you somewhere (or make it easy to do
so if it isn't).

---

### https://guide.elm-lang.org/architecture/effects/random.html

> dieFace

💀

---

I'm a bit lost with the "phase one" section here.  What is `Cmd.none` for?

When we get to "phase two" it definitely feels unusual to me that we separate
`NewFace` and `Roll`.  I thought we'd update `Roll` to do the random stuff, but
it seems we're going to do something else and have that generate a `NewFace`
message to update the `dieFace`. This separation feels overkilly here, but maybe
in a larger example it's absolutely the right thing to do.

Ok, so when we get `NewFace` we don't mutate the existing model, we construct
a new Model instance and replace the existing model.  I was looking for a line
like:

    { model | dieFace = newFace }

I guess being functionally pure is a good thing though.  New instances instead
of mutating existing ones.  Particularly when we don't need state here (we
needed it in the Form example because we get different messages for each form
element and we need to persist the values to allow for validation).

I am definitely having trouble reading the method / type signatures and
translating them back and forth to my understanding.  It took me a while to
understand that:

    Random.generate NewFace (Random.int 1 6)

does in fact map onto

    Random.generate : (a -> msg) -> Random.Generator a -> Cmd msg

because `NewFace` isn't just a word or a type name, it's actually a function
that needs to be passed a value (an Int in this case), and will produce a `Msg`
instance.  Effectively we're saying, run `Random.int 1 6` to get an integer
between 1 and 6, then throw that value into the `NewFace` function to get a msg
which will be returned wrapped in a `Cmd`.  That the argument for `Cmd` is
named `msg` and our type is called `Msg` is (probably) just an unrelated
coincidence.  Or an idiom or something.

---

> In fact, any time our program needs to get unreliable values (randomness,
> HTTP, file I/O, database reads, etc.) you have to go through Elm.

This seems like an odd statement.  Would "the Elm runtime", or "the elm standard
library" be more correct than just "elm" here?  Isn't all the code we write
"elm"?  What makes my code not elm, but Random.generate be elm?

---

### https://guide.elm-lang.org/architecture/effects/http.html

    Result Http.Error String

Seems weird that the type signature (or method signature, whatever, I doubt I'll
ever get that straight) has the error first.  I'm used to callback things having
the error function as an optional last param.  I wonder if this is a way of
forcing you to think about the error functions or conditions and not ignore
them?

> I also changed the MorePlease branch a bit. We need an HTTP command, so I
> called the getRandomGif function. The trick is that I made that function up. It does not exist yet. That is the next step!

Mate.  You may think this is funny, but this is all new to people, so building
up your changes slowly is probably a better call.

---

Are `Results` promises?  Does that matter? What about `Cmd`s which is what
`Http.send` apparently returns.

---

Oh! It's decoding JSON.  It didn't occur to me that `Decoder` worked on JSON,
I thought maybe it was CGI decoding, or URI decoding and trying to parse a
data attribute from some HTML.  I'd probably have expected a JSON decoder to
have the word JSON in the name.  Perhaps if we had the full example code we'd
see the import statements that would make this more obvious.

---

### https://guide.elm-lang.org/architecture/effects/time.html

Subscriptions, yay!  This is, I think, what Elm replaced Signals with.

Ok, so `subscriptions` are the fourth part of the Elm architecture then?  If we
assume that `model`, `update`, and `view` are the first 3.  So it's not just
MVC then.

---

It's really nice that we get animation "for free".  Every time the clock ticks,
we generate a new model.  Every time the model changes, Elm runs our view
function and we draw a clock for the current time.  Elm then does the work to
re-render the DOM for us.  We haven't had to write any explicit animation code;
just subscribe to some events and change the model.  We've seen it before with
typing or moving the mouse (in the book), but here we get it for animation too.
Even though its' the same underlying Elm feature, it feels way more powerful
because it's animation (or because I am easily impressed by visual tricks).

---

### https://guide.elm-lang.org/architecture/effects/web_sockets.html

> We are going to make a simple chat app.

This page is pretty short and most of is the code for this chat app.  It speaks
to how powerful Elm is that this is the case.  Kudos to you Elm, kudos to you!

Later: oh, ok, it's a _very_ simple chat app, it just echos back to you because
obviously, this Elm example isn't going to tell us how to write a web chat
back-end server.

---

### https://guide.elm-lang.org/architecture/more.html

I'm still a little unclear as to what "The Elm Architecture" really is and the
strange "you have to use Elm" comment about getting unreliable values.  But this
is a much better grounding in Elm than the Day 2 chapter.  It is longer though
so perhaps that's not surprising.  FWIW: the subscriptions stuff does seem to
be clearer than the signals stuff, but perhaps it's because we've only seen it
in the context of "The Elm Architecture" and not tried to do anything with them
directly.
