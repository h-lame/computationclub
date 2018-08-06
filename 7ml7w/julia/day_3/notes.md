# Julia - Day 3

Macros are lispy, and the book explicitly calls them out as operating on the
parsed tree structure of the language.  That's pretty neat.

---

Seems we can't do `names(Expr)` any more as the current Julia only has a `names`
function that takes Modules.  At least `<Expr>.head`, `<Expr>.args`, and
`<Expr>.typ` still work though.

---

It's nice that we can easily create these quoted expressions manually (with or
without the `quote` helper via the `Expr()` constructor).  I wonder what the
semantics of `eval` on these things are.  In other languages we're taught to
shun explicit `eval` because it's slow and a risk, but in LISPy style langs it's
something we're encouraged to do.  I wonder where things sit with Julia.

I also wonder if there's something special about how macros are invoked that
means we need the `@<macroname>` syntax, or if it's something that's introduced
for readability reasons.

---

I feel like this whirlwind introduction to how image codecs work has left me
wanting more.  I'm not sure the description is quite as clear as it could be,
but I'm sure it'll make more sense as we proceed through the implementation.

---

OMG!  This `Pkg.add` thing is installing a local copy of homebrew and installing
a load of homebrew packages.  I really hope this is properly localised and won't
mess up my existing homebrew install.  At the same times, it's neat that it's
so self-contained.

Later: it took forever and failed on two of the homebrew install steps:
fontconfig / cairo and gtk.  I think this is fully isolated from my existing
homebrew, but I'm not sure, and the commands in the output for trying again
on the command line don't seem to work.  I think it's just the `ImageView`
package so hopefully I won't need that and can just view the images with preview
or whatever.

Later still: Seems that `Pkg.add(<somepkg>)` only installs the package, but not
fully.  The first time you run the package it tries to pre-compile it as well.
I get failures on precompiling `ImageView`, perhaps unsurprisingly because the
gtk and cairo stuff failed to install.

When I try to run `img = testimate("cameraman")` from the first example it
also breaks, because it wants to install `QuartzImageIO`, which I allow it to
do, but that also breaks.  Some REPL faffing and github issue browsing later
and I seem to have working `testimage` function, but I've no idea how to look
at the image.

Also, what I get from `testimage` is not a `Gray Image`, but an
`Array{ColorTypes.Gray{FixedPointNumbers.Normed{UInt8,8}},2}` which is almost
certainly what `img.data` is in the next example.  So we can proceed as follows:

    pixels = img[1:8, 1:8]
    pixels = convert(Array{Float32}, pixels)

Interestingly, the rest of the example code works except that when we compare
the dct to idct versions with `pixels == pixels2`, I get `false` even though
eyeballing the results they look the same.  I guess it's a rounding thing?

---

As mentioned above, we need to avoid doing `img.data` and can just work directly
on `img`.

I had to add `.` to the `LOAD_PATH` in order for `using Codec` to work.  I
wonder if I should have tried `using ./Codec`?

    push!(LOAD_PATH, ".")

We need to replace `ifloor(<number>)` with `floor(Integer, <number>)`.  And it
suggests we replace `Array(Float32, (outy*8, outx*8)` with
`Array{Float32}(outy*8, outx*8)` too.

We _also_ need to heavily re-work the `blockidct` function because `grayim` no
longer exists. Seems the Images.jl library was drastically changed between the
time the book was written and now.  We don't have an Image type anymore and
things like `grayim` no longer exist.  Instead we store each pixel not as a
`Float32`, but as a `Gray{Float32}`, this will attach a colour space to the
individual pixels, not the whole image.  Which I guess is good?

We can output the image data with:

    save("filename.tif", img2)

Except I got errors about the data being in the wrong scale.

    WARNING: QuartzImageIO: Mapping to the storage type failed.
    Perhaps your data had out-of-range values?
    Try `map(clamp01nan, img)` to clamp values to a valid range.

And:

    ERROR: ArgumentError: element type FixedPointNumbers.Normed{UInt8,8} is an 8-bit type representing 256 values from 0.0 to 1.0,
      but the values (-0.013210587f0,) do not lie within this range.
      See the READMEs for FixedPointNumbers and ColorTypes for more information.

Happily, the error came with a hint and so I did what it suggested and I got an
image written to disk as follows:

    save("filename.tif", map(clamp01nan, img2))

This `clamp01nan` function makes sure values are clamped to between 0 and 1 and
turns `NaN` into a 0 too.  I don't really understand why I had some data not
between 0 and 1, but this is as good a fix as any.  I wonder if I should have
used `Gray{N0f8}` instead of `Gray{Float32}` because the former is the type I
got when I read in the cameraman test image in the first example REPL session.

---

Using the same save trick with `img` lets me output the original image to see it
and then compare the compressed version too.  It's interesting that on disk they
are both the same size, so I'm not sure what our "compression" algorithm is
really teaching us.  Perhaps it's because I'm writing it out as a tif that means
I don't really save anything?

---

It's surprising to me that we talk about macros, and then don't use them in the
example with the images.  I'm still left feeling that I don't really get what
the book wants me to know about Julia.  It feels a bit all over the place, but
I guess that's maybe what the book is trying to say with its Borg metaphor.

> its unique assimilation of the best features of its competitors is not an
> amalgamation of parts but a coherent and designed assembly.

I think that might be true, but I dunno if the book gets that across
particularly well, because it doesn't tie the features it discusses together.

> The syntax may still change.

Yup, it's a real downside to this book that the languages it talks about have
moved on so far from where they were when the book was written.  4 years is a
long time in a programming languages.  I actually find it frustrating as a book
reader, but exciting as a potential convert to these languages - they're not so
scared of backwards compatibility that innovation is stalled.  Perhaps that's
just because many of these languages are yet to hit their `1.0` so
experimentation is still encouraged, or maybe it's because the communities
around these languages aren't scared of change.  It could be a bit of both.

---

## Find...

> * Julia's documentation on modules and packages.
> * A description of how JPEG works.  What parts were left out of our example?

I actually think this would be an interesting topic to explore with the group in
a one off meeting, or a whole book about image/video/audio compression.

## do(Easy)

> * Write a macro that runs a block of code backward.
> * Experiment with modifying frequencies and observing the effect on an image.
>   What happens when you set some high frequencies to large values, or add lots
>   of noise?  (Hint: Try adding `scale * rand(size(freqs))`)

## do(Medium)

> * Modify the code to allow masking arbitrarily many coefficients, but always
>   the N most important ones.  Instead of calling `blockdct6(img)` you would
>   call `blockdct(img, 6)`.
> * Our codec outputs a frequency array as big as its input, even though most
>   frequencies are zero.  Instead, output only the size nonzero frequencies for
>   each block so that the output is smaller than the input.  Modify the decoder
>   to use this smaller input as well.

Ah!  So this is why our image isn't smaller on disk.  While we've "thrown away"
some of the data, we have still kept around a placeholder for it to be stored.

> * Experiment with different block sizes to see how block size affects the
>   appearance of coding artefacts.  Try a large block size on an image
>   containing lots of text and see what happens.

I guess this is something that JPEG encoders play with when they let you choose
the quality level of the image you generate with them.

## do(Hard)

> * The code currently only works on grayscale images, but the same technique
>   works on colour too. Modify the code to work on colour images like
>   `testimage("mandrill")`.
> * JPEG does prediction of the first coefficient called the DC offset.  The
>   previous block's DC value is subtracted from the current block's DC value.
>   This encodes an offset instead of a number with full range, saving valuable
>   bits.  Try implementing this in the codec.
