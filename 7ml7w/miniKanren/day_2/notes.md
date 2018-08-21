# miniKanren - Day 2

---

Note: the book uses clojure 1.5.1 and core.logic 0.8.5, but I'm using clojure
1.9 and core.logic 0.8.11.  Hopefully this version discrepancy won't be as
painful as previous chapters.

---

Pattern matching.  Ok:

    (defn insideo [e l]
      (conde
        [(fresh [h t]
          (conso h t l)
          (== h e))]
        [(fresh [h t]
          (conso h t l)
          (insideo e t))]))

Is equivalent, with core.match to:

    (defn insideo [e l]
      (matche [l]
        ([[e . _]])
        ([[_ . t]] (insideo e t))))

This actually does help explain the core.logic implementation of `appendo` that
I saw for Day 1.

    (defne appendo [x y z]
      ([() _ y])
      ([[a . d] _ [a . r]] (appendo d y r)))

I'm not sure it uses `matche`, even via the `defne` macro, but it certainly
looks like the same kind of structure.  Even if it's not using pattern matchin,
it makes more sense now!

Later: Oh! It does seem that `defne` is a shorthand for the `defn .. matche`
construct.  Hurrah!

Except, it seems that the core.logic has an implementation of `defne` that is a
wrapper to `defnm` which is a wrapper for some `conde` boiler plate.  I suspect
I'm reading the source wrong again though.

---

Is it a problem that `defne` always expands all its args to the `matche`?  Our
intro example for `insideo` took `[e l]` but we only passed `[l]` to `matche`.
Would our `matche` version of `insideo` behave differently with `[e l]` passed
to `matche`?

Investigation happens.

It does behave differently.  If we use:

    (defn insideo [e l]
      (matche [e l]
        ([[e . _]])
        ([[_ . t]] (insideo e t))))

or:

    (defne insideo [e l]
      ([[e . _]])
      ([[_ . t]] (insideo e t)))

The definition spits out some warnings:

    WARNING: Differing number of matches. Matching [[e . _]] against [e l]
    WARNING: Differing number of matches. Matching [[_ . t]] against [e l]

And if we run `(run 5 [q] (insideo q [1 2 3 4 5 6]))` the process hangs and
returns nothing.  This compared to our original version, above, that will
promptly return `(1 2 3 4 5)`.

Later: Oh. Literally the next paragraph explains all this.  I really need to
read more before I go off on a tangent.  This is what we want if we're using
`defne`:

    (defne insideo [e l]
      ([_ [e . _]])
      ([_ [_ . t]] (insideo e t)))

This tells it to ignore the first arg `e`, and do our matching based solely on
the second arg `l`.  In this case it's slightly confusing, because we do use `e`
in the match, but only in the context of `l` (e.g. if the first element of `l`
is the same as `e`, then match.

---

It's frustrating that the map example before and after we use `featurec`
have different return values.  Before it's just the "found-a", but after it's
"found-a" and the value of a.  It makes it harder to compare them.

---

`conde` is just one of a suite of conditionals.  I should probably try to work
out what the `e` means, and what the `a` and `u` mean in `conda` and `condu` so
that I can try to make sense of them.  This all smells a bit like factor and
it's terse names for things.  The longer I program in a language that prefers
good names for things, the less patience I have for this sort of thing.

Later: Perhaps it's `cond each`, `cond all` or `cond any`, and `cond unique`?
I'm not entirely sure this makes sense, so I'm a bit none the wiser why they
have those suffixes.

It's annoying that the `conda` version of `whicho` introduces an `all` wrapper
to the conditions in each branch / universe.  We didn't have that before.

---

I think this day's sidestep into `featurec` feels a bit under-developed.  We
don't yet really know what miniKanren is in isolation and yet we're shown this
`featurec` stuff as if we should really appreciate it as being amazing and a
thing that other kanren can't do.  The interview portion suggests that
integration with clojure data-structures isn't complete either.  It is obviously
a useful feature, but without understanding the limitations in the existing
integration, or why other kanren don't have this, it definitely feels strange
as one of the things to introduce to us in Day 2.  I think I'd have liked to
hear more about the `cond<x>`s and their family of support functions.

---

## Find...

> * Examples of code using `featurec`
> * The source code for core.logic’s membero

## do(Easy)

> * Rewrite `extendo` from Day 1’s problems using `matche` or `defne`.

    (defne extend⁰ [h t l]
      ([() _ t])
      ([[h-head . h-tail] _ [h-head . l-without-h-head]]
       (extend⁰ h-tail t l-without-h-head)))

> * Create a goal `not-rooto` which takes a map with a :username key and
>   succeeds only if the value is not “root”.

    (defn not-root⁰ [m]
      (fresh [u]
        (featurec m {:username u})
        (!= u :root)))

Is this right? I've no idea how I even test this.  The following repl session
suggests it's doing the right thing.  E.g. with no `q` to bind it fails if
the map is `{:username :root}`, binds to anything if the map isn't that, and
creates one of those unreadable `featurec` things if the value we pass in is
`q`.  It seemt to be saying that it'll allow anything that's not :root.

    user=> (run 1 [q] (not-root⁰ {:username :root}))
    ()
    user=> (run 1 [q] (not-root⁰ {:username :butts}))
    (_0)
    user=> (run 1 [q] (not-root⁰ {:username q}))
    ((_0 :- (!= (_1 :root)) (clojure.core.logic/featurec _0 _1)))


> * Run `whicho` in reverse, asking for elements in one or both of the sets.

Using the `conda` version from the book:

    (defn whicho [x s1 s2 r]
      (conda
        [(all
          (membero x s1)
          (membero x s2)
          (== r :both))]
        [(all
          (membero x s1)
          (== r :one))]
        [(all
          (membero x s2)
          (== r :two))]))

If I run `(run* [q] (whicho :a [:a :b :c] [:d :e :c] q))` I get `(:one)`, as
expected.  If I try `(run* [q] (whicho :a [:a :b :c] q :one))` it hangs,
figuring this might be because there are infinite possiblities I try a
`(run 1 [q] (whicho :a [:a :b :c] q :one))` version, but it also hangs.
Changing tack I got for `(run 1 [q] (whicho q [:a :b :c] [:d :e :c] :one))`
which gives me `(:a)`, and the `run*` version gives me `(:a :b :c)`.  However if
I try `(run 1 [q] (whicho :a q [:d :e :c] :one))` it hangs again.  I think this
is to be expected, but I'm not sure.

> * Add a `:none` branch to `whicho`. What happens when you use the `:none`
>   branch in the `whicho` version built on `conde`?

    (defn whicho [x s1 s2 r]
      (conda
        [(all
          (nafc membero x s1)
          (nafc membero x s2)
          (== r :none))]
        [(all
          (membero x s1)
          (membero x s2)
          (== r :both))]
        [(all
          (membero x s1)
          (== r :one))]
        [(all
          (membero x s2)
          (== r :two))]))

Struggled for a while with this until I found the experimental `nafc` for
negation, and found some examples of using it.  The `conde` version is:

    (defn whicho [x s1 s2 r]
      (conde
        [(membero x s1)
         (== r :one)]
        [(membero x s2)
         (== r :two)]
        [(membero x s1)
         (membero x s2)
         (== r :both)]
        [(nafc membero x s1)
         (nafc membero x s2)
         (== r :none)]))

As far as I can tell, it doesn't change the results though.  I'm not sure what
the book wants me to find out here?

## do(Medium)

> * Using the database from yesterday, create `unsungo`, which takes a list of
>   computer scientists and succeeds if none of them have won Turing Awards.
>   `conda` may prove useful.

    (defn unsung⁰ [peeps]
      (conda
        [(== peeps ())]
        [(fresh [peep peeps-rest y]
          (all
            (scientist⁰ peep)
            (nafc turing⁰ peep y)
            (unsung⁰ peeps-rest)))]))

I don't think this is right, but also, I don't really understand how I'd check
this.  Running it with `(run* [q] (unsung⁰ q))` just gives `(())` which doesn't
seem right.  Curiously though, a much simpler example using these facts and
`nafc` doesn't work either:

    (with-db facts
      (run* [q]
        (fresh [y]
          (man⁰ q)
          (nafc turing⁰ q y))))

E.g. as I understand it, find men that haven't won a turing prize.  This returns
`(:leslie-lamport :john-mccarthy :alonzo-church :alan-turing)` which is just all
the men, it should return `(:alonzo-church :alan-turing)`.  However, `nafc` does
work if I try:

    (with-db facts
      (run* [q]
        (fresh [y]
          (nafc man⁰ q)
          (turing⁰ q y))))

E.g find me all the not-men who have a turing prize.  Rightly it returns
`(:barbara-liskov :frances-allen)`.  If I try negating both then I get something
truly weird:

    user=> (with-db facts (run* [q] (fresh [y] (nafc man⁰ q) (nafc turing⁰ q y))))
    ((_0 :- (clojure.core.logic/nafc #object[clojure.lang.AFunction$1 0x3499670b "clojure.lang.AFunction$1@3499670b"] _0 _1) (clojure.core.logic/nafc #object[clojure.lang.AFunction$1 0x8d4b860 "clojure.lang.AFunction$1@8d4b860"] _0)))

So I suspect I've just not understood `nafc` correctly.  I'm not sure this is
what the book wants to point me at.  Negation seems hard (infinite) in the
context or logic programming, so I'm sure I've missed something.

## do(Hard)

> * Play with `(insideo :a [:a :b :a])`. How many times does it succeed? Make it
>   succeed only once but have `(insideo q [:a :b :a])` return all distinct
>   elements. Hint: Try using the `!=` constraint.

`(inside⁰ :a [:a :b :a])` completes 2 times, and the `:b` version completes
once.  Using the `conde` version of `inside⁰` anyway, if we use the `condu`
version that we last saw in the book, then both complete only one time, but
trying the `(insideo q [:a :b :a])` example only gives us `(:a)`, not `(:a :b)`
so we have to do something to try and unify the two versions.

    (defn inside⁰ [e l]
      (conde
        [(fresh [h t]
           (conso h t l)
           (== h e))]
        [(fresh [h t]
           (conso h t l)
           (inside⁰ e t)
           (!= h e))]))

Seems that adding a constraint to cut the 2nd branch so it doesn't recurse if
we've already matched is the thing to do.  I'm not sure how I'd express the
above using `matche` or `defne` as my first passes don't work:

    (defn inside⁰ [e l]
      (matche [l]
        ([[e . _]])
        ([[x . t]] ((inside⁰ t l) (!= x e)))))

    (defne inside⁰ [e l]
      ([_ [e . _]])
      ([_ [x . t]] (inside⁰ t l) (!= x e)))

Both of these jsut hang forever when we try the bound or unbound versions given
in the exercise.
