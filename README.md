# C Project Extension - Group 48

> ... We extended the emulator and assembler to support more instructions (those used in function calls, including `PUSH`, `POP`, `BL` and `BX`), and enabled the emulator to dump a part of its memory as a bitmap file (so that we could have graphical output from the emulator). We then used Zhanrong’s side project, an interpreter for a Scheme-like language, to implement a compiler that could turn a tiny subset of C into the subset of ARM assembly supported by our emulator. With its help, we were able to build a simple ray tracer that runs on our emulator. Finally, Haoran (the only Computing student in our group) implemented a post-processing filter that adds to the bitmap output some artistic quality. This was done in standard C.

This repository contains the source code of our **compiler** and **ray tracer**, in case anyone wish to try them out on their own implementation of the assembler and emulator.

## The compiler

The compiler can be seen as an experiment that attempts to make use of the extremely-limited scripting capability of [ApiMu](https://github.com/bridgekat/apimu). It only supports a small subset of C (has just enough features for our ray tracer), and please do not expect it to work robustly or efficiently.

### "Highlights"

- The compiler itself is interpreted.
- There are no user-defined types, the only supported type is 32-bit integer. It can be used as pointer as well - there is no difference between integers and pointers. Arrays are treated as pointers to the first element. (To access the second element, you need to add 4 from it: `*(p + 4)`, since the pointer is unaware of the type it points to... The array access notation `p[i]` automatically multiplies the index `i` by 4, so `p[1]` is equivalent to `*(p + 4)`.)
- Statically typed, but without any type checking! You'll get into trouble if you supplied too few arguments to a function...
- **No readable error message in case of failure.**
- Naive register allocation (relies on the assumption / calling convention that all registers except `r0` are saved for the caller).
- No inlining, dead code elimination, or constant propagation, etc.
- Every function could only have one exit.

### Running the compiler

First, [download the `testeval` executable (script interpreter) for your platform](https://github.com/bridgekat/apimu/releases/tag/v0.1-alpha) and put it inside the [`extension`](extension) folder. Optionally, you can put your `assemble` executable inside the [`src`](src) folder. Then running `make` from the [`extension/examples`](extension/examples) directory will compile several functions in [`extensions/examples/examples.mu`](extensions/examples/examples.mu) into assembly, and will invoke your assembler to generate binary code for them.

Note that the compiler also generates instructions beyond the coursework specification (2022 version):

1. Special names, `sp`, `lr` and `pc`, will be used for registers 13, 14 and 15, respectively;
2. You will need to implement "Branch with link" (`bl`) and "branch and exchange" (`bx`);
3. Also there are "stack operations" (`push { ... }` and `pop { ... }`). Note that the stack is assumed to be descending, with `sp` pointing to the last element itself ("full" mode). Support for `ldm` and `stm` is not necessary (the compiler is too dumb to make use of them).
4. If you have used signed (`/`) or unsigned (`./`) integer division in your program, you will need to handle `sdiv` and `udiv` instructions (the format is `sdiv/udiv Rd, Rn, Rm`, just like the multiply instruction).

The calling convention is not found in any standard -- it was invented to simplify things:

1. [Arguments are pushed onto stack from right to left. First argument is on `sp + 0`, the second one `sp + 4`. The last one has the highest address. The caller need to pop arguments from the stack after the function call.](https://en.wikipedia.org/wiki/X86_calling_conventions#cdecl)
2. Functions put their return values in register `r0`. All other registers should be unmodified by a function call (this is achieved by saving all used registers on the stack at the beginning of each function, and restoring them at exit). Functions without a return value may leave the value of `r0` undefined.

## The ray tracer

To run the ray tracer, you need to additionally support the following features in your assembler:

1. The `include` directive copy-pastes another file into the current file, just like the `#include` macro in C. (See the last few lines of [extension/entry.s](extension/entry.s))

And in your emulator:

1. Make sure that all write operations to the program counter (`pc` register) will **cause the pipeline to flush** (like a branching instruction). We have an explicit write operation to the `pc` in our optimised long division procedure, found in [`extension/fixed_precise.s`](extension/fixed_precise.s#L74).

Invoke `make` from the [`extension`](extension) directory to compile and assemble the ray tracer program. The generated ARM code will be at `extension/raytracer.out`.

When executed by your emulator, **it will put pixel data into a designated part of the emulator's memory**. This part is called the "framebuffer". As mentioned in [extension/entry.s](extension/entry.s), some arguments will need to be specified by the emulator before the program starts:

1. The **stack pointer `sp`**. Since the stack is assumed to be descending, you should give `sp` an initial value large enough to prevent stack overflow. (We used 524288)
2. The initial value of `*sp` should be a 32-bit integer indicating the **starting address of the framebuffer (in bytes)**. You can set it to be the same as `sp` (i.e. place the framebuffer immediately after the stack) but anywhere convenient will be OK.
3. The initial value of `*(sp + 4)` should be a 32-bit integer indicating the **width of the framebuffer (in pixels)**. Similarly, `*(sp + 8)` shoule be a 32-bit integer indicating the **height of the framebuffer (in pixels)**.

The framebuffer will be used by the program as a 2D array of 32-bit integers stored in row-major order. It should contain the final image after the program halts. Each array element contains 4 bytes, but only the least significant 3 bytes will be used: lowest byte is the red component, then green, then blue (refer to the `setPixel` function in [`extension/raytracer.mu`](extension/raytracer.mu#L119)). Be sure to reserve at least `4 * width * height` bytes of memory for the framebuffer. You may have to increase the total memory of your emulator if you want high-resolution images.

To show the resulting image visually, you could add `printf` in your emulator to generate a [PPM image file](https://en.wikipedia.org/wiki/Netpbm#PPM_example) and use [GIMP](https://www.gimp.org/) to view it. Good luck!

## Final note

If you want to modify some of the constants in the ray tracer, please note that we have avoided writing numbers not representable as 8-bit immediate values; where we cannot avoid, we put that procedure nearer to the end of the program. The spec did not give a suggestion for **loading constants from more than 4095 bytes away**, which can be a problem only for very long programs like our ray tracer.
