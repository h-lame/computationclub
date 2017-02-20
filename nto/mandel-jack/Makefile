all: run

run: Mandel.hack
	$(HACK_JS) Mandel.hack

clean:
	rm -f *.vm *.asm *.hack

%.vm: %.jack
	$(JACK_COMPILER) $< > $@

Mandel.asm: Main.vm
	$(VM_TRANSLATOR) --init Main.vm lib/*.vm > Mandel.asm

%.hack: %.asm
	$(HACK_ASSEMBLER) $< > $@

.PHONY: all run
