TESTEVAL = ./testeval
ASM      = ../src/assemble

.PHONY: all clean

all: raytracer.out

raytracer.s: prelude.mu compiler.mu raytracer.mu
	echo ":quit" | $(TESTEVAL) $^
raytracer.out: entry.s fixed_fast.s fixed_precise.s raytracer.s
	$(ASM) $< $@

clean:
	rm -f raytracer.s
	rm -f raytracer.out
