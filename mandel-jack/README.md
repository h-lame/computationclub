# computationclub-mandelbrot

A quick mandelbrot implementation in Jack for the [Mandelbrot meeting][1] of the
[London Computation Club][2].

Jack is the language defined in the book we read previously, ["NAND2Tetris"][3],
and I thought it might be fun to try and run a mandelbrot program using all the
tooling we developed while reading that book.  Our [compiler][4], our
[vm-translator][5], our [assmbler][6], and our [computer][7].  You'll need all
those to run this.

There's also a ruby implementation that outputs ascii used as a check that the
algorithm actually works and produces a mandelbrot.
# Spoilers

It doesn't work.  It halts on the 13th pixel of the 2nd row.  Don't know why.
Possibly because I can't write Jack, possibly because there are flaws in our
tooling.  More likeky, a combination of all.

It's also possible that even if it didn't halt while running it wouldn't render
anything identifiable as a mandelbrot because Jack doesn't handle floating point
and you really  need floating point mathematics in order to see a reasonably
detailed mandelbrot.

That said, you can modify the provided ruby implementation Although, one can
modify the ruby implementation to do integer only mathematics and a very
low-resolution mandel brot does appear.

[1]: https://github.com/computationclub/computationclub.github.io/wiki/The-New-Turing-Omnibus-Chapter-9-Mathematical-Research
[2]: https://london.computation.club
[3]: http://www.nand2tetris.org/
[4]: https://github.com/computationclub/jack-compiler
[5]: https://github.com/computationclub/vm-translator
[6]: https://github.com/computationclub/hack-assembler
[7]: https://github.com/computationclub/hack-js
