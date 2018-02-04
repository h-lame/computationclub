# Lua - Day 3

Is the `/a/` in the path of the examples in the book super relevant?

later: probably not, looks like `/a/` is replaced by `/b/` in the 2nd set of
examples (for playing midi, not just saying "hello world") - so I expect it's
just there to indicate this is version "b" of the code.  Feels like an artefact
of the book compilation (printing the actual path to the code that was inlined)
rather than an important detail.  Shame they didn't elide it then.

---
dofile (code) vs doFile (text)

---
The regex notation in `parse_note` is unfamiliar.

Later: it's not really regex.  For example, we can't do `OR`s.  Lua does have
bindings to other regex libraries if you need them.  I guess this makes sense
when we think about lua's "small + fast" mindset.

---
Where's E# and B# in the `notes` table in `note`? Are these not notes one can
play?  Or are they matematically the same as other notes or something so we
don't have to specify them?

Later: seems they exist, but like, not really?

* https://en.wikipedia.org/wiki/F_(musical_note)#E_sharp
* https://en.wikipedia.org/wiki/C_(musical_note)#B_sharp

---
What's the weird typographical thing where the first char of a single-quoted
string is italicised?  Maybe it's because I'm typing code in this time rather
than skimming it, but it's putting me off because I feel like it should mean
something that I don't understand (it almost certainly doesn't mean anything
though).

---
We need to use scheduler from day 2 and I tried briefly to require it from
the `day_2` folder.  By default you can't, but you can add paths to the load
file with:

    package.path .. ';<some path>'

So we could add it, but as I had to require scheduler in two places it became
annoying so I stopped.  Interestingly I found that lua has `.` and `/` notation
for requiring in subfolders.  I guess this is like Java and Python.

---
It's a real shame that play.cpp is so bare-bones as to not include any error
output.  my first few attempts to run `good_morning_to_all.lua` were hampered
by stupid typos I'd made in the lua code (the hazards of transcribing code
from a book while slumped on a sofa on a lazy sunday afternoon I guess).

From a quick google we find the following message on the lua users mailinglist:
http://lua-users.org/lists/lua-l/2007-01/msg00566.html.  It suggests adding
the following conditional around the `lua_dofile(...)` call to capture the
error that is left on the stack and print it out.

    if (luaL_dofile(L, argv[1]))
    {
      printf("%s\n", lua_tostring(L, -1));
    }

Now I don't need to worry about typos!  Yay!

Later: oh, this is one of the things that the chapter asks you to find out once
you've read it all.  Hmmmm.

Later, still: oh, this is the part 2 (of 2) for the `do(Medium)` exercises. I
could not have completed `do(Easy)` or part 1 (of 2) of `do(Medium)` without
this.  Seems a weird thing to leave off as an exercise for the reader.

---
Something feels weird to me about this `_G` metatable stuff.  Maybe it's me
coming from Ruby where we can do this sort of thing but as a community we
mostly shy away from it.  I wonder if this is lua-idiomatic because mostly lua
is embedded in other systems and this kind of thing lets us more easily write
DSLs? Particularly if the intended audience for these DSLs isn't other
programmers but other folk who don't have our deep-seated reverence for syntax
and punctuation nuance.  Perhaps this is a strength of lua?

---

## do(Easy)

part 1 - you said this wasn't 7 musical notations in 7 weeks, but
it seems like you want me to learn at least 1. (I'm skipping this)

---

## do(Medium)

part 2 - we did this already, I like feeling prescient!

---

## do(Hard)

I don't think I know enough about midi, nor do I care enough about
midi to attempt this.  I guess I'd want to augment the song.part with a port
or something to say which midi port to send the notes to. In the C code I'd
want to open midi ports on demand based on the parts and send all the messages
for those parts to the correct midi object.  I don't think I know how to test
this.  Hopefully someone else from the club will have done it.

---

## Final thoughts

I'm not really sure what I'm expected to get out of this
introduction to Lua.  The tables stuff is interesting, and the metatables in
particular feel like a rich vein to be mined.  It's a language that's embedded
in loads of systems (redis, unity, nginx, etc..) so knowing it seems like it'd
be useful.  At the same time, I can't really imagine picking it up to do
something new.  The book suggests "code is data, because you can create
functions on the fly" as the lightbulb moment for this language, but I feel like
many developers coming to this book now (or even in 2014 when published) would
have had ample opportunity to work in languages with first class functions.

I feel a bit like the interesting things about this language are not what the
book has shown me.  It's pulled back the curtain a bit - I'd love to explore
metatables a bit more in depth, I'm interested in the C API and the stack
stuff - hints of some of our NAND2Tetris work coming through, I'm keen on
knowing more lua because of where lua is used in systems I use daily - but not
enough.  It's very much a small tasting plates menu, except I didn't realise and
haven't ordered enough food.
