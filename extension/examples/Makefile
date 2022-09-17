TESTEVAL = ../testeval
ASM      = ../../src/assemble

.PHONY: all clean

all: examples.out

examples.s: ../prelude.mu ../compiler.mu examples.mu
	echo ":quit" | $(TESTEVAL) $^
examples.out: examples.s
	$(ASM) $< $@

clean:
	rm -f examples.s
	rm -f examples.out
