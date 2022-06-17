*WACC is a programming language specification invented by Imperial College London as part of a coursework/project for its second-year Computing undergraduates. It is similar to a subset of the C programming language (modulo some differences in the syntax), and here we consider a subset of both.*

This repository is an experiment that attempts to make use of the extremely-limited scripting capability of [ApiMu](https://github.com/bridgekat/apimu). It only implements a small subset of C and WACC, and please do not expect it to work robustly or efficiently.

## "Highlights"

- The compiler itself is interpreted
- No user-defined types, only supported type is 32-bit integer. It can be used as pointer as well - there is no difference between integers and pointers. Arrays are treated as pointers to the first element.
- Statically typed, but without any type checking! You'll get into trouble if you supplied too few arguments to a function...
- **No readable error message in case of failure!**
- Naive register allocation (relies on the assumption / calling convention that all registers except `r0` are saved for the caller).
- No inlining, dead code elimination, or constant propagation, etc.
- Every function could only have one exit.

Though we aim for a complete implementation of WACC (or even the full ApiMu scripting language), currently this "compiler" is mainly used to scratch random things that could run on an ARM emulator (another coursework at Imperial we are doing now), and is rather ad-hoc...

## Running the program

You will need to get the `testeval` executable (script interpreter) either from [here](https://github.com/bridgekat/apimu/releases/tag/v0.1-alpha) (Linux x64 only, requires GLIBCXX 3.4.29) or by [building from source](https://github.com/bridgekat/apimu#building-experimental). Then running [`compile.sh`](compile.sh) will compile several functions in [`examples.mu`](examples.mu) into assembly, which can be used by the ARM assembler and emulator (if you are also doing one).

Note that the compiler also generates instructions beyond the coursework specification (2022 version):

1. Special names for registers 13, 14 and 15 (`sp`, `lr` and `pc`) will be used;
2. "Branch with link" (`bl`) and "branch and exchange" (`bx`);
3. "Stack operations" (`push { ... }` and `pop { ... }`). Note that the stack is assumed to be descending, with `sp` pointing to the last element itself ("full" mode). Support for `ldm` and `stm` is not necessary (the compiler is too dumb to make use of them).
4. If you have used signed (`/`) or unsigned (`./`) integer division in your program, you will need to handle `sdiv` and `udiv` instructions (the format is `sdiv/udiv Rd, Rn, Rm`, just like the multiply instruction).

The calling convention is not found in any standard -- it was invented to simplify things:

1. [Arguments are pushed onto stack from right to left. First argument is on `sp + 0`, the second one `sp + 4`. The last one has the highest address. The caller need to pop arguments from the stack after the function call.](https://en.wikipedia.org/wiki/X86_calling_conventions#cdecl)
2. Functions put their return values in register `r0`. All other registers should be unmodified by a function call (this is achieved by saving all used registers on the stack at the beginning of each function, and restoring them at exit). Functions without a return value may leave the value of `r0` undefined.
