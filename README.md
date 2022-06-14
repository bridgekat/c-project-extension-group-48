WACC is a programming language specification invented by Imperial College London as part of a coursework/project for its second-year Computing undergraduates.

This repository is an experiment that attempts to make use of the extremely-limited scripting capability of [ApiMu](https://github.com/bridgekat/apimu). It only implements a small subset of WACC, and please do not expect it to work robustly or efficiently.

### "Highlights"

- The compiler itself is interpreted.
- No user-defined types, only supported type is unsigned 32-bit integer. It can be used as pointer as well - there is no difference between integers and pointers. Arrays are treated as pointers to the first element.
- Statically typed, but without any type checking! You'll get into trouble if you supplied too few or too many arguments to a function...
- Naive register allocation (relies on the assumption/convention that all registers except `r0` are saved for the caller).
- No inlining, dead code elimination, or constant propagation, etc.
- Every function could only have one exit.

Though we aim for a complete implementation of WACC (or even the full ApiMu scripting language), currently this "compiler" is mainly used to scratch random things that could run on an ARM emulator (another coursework at Imperial we are doing now), and is rather ad-hoc...

-----

The ApiMu scripting language used to implement this "compiler" looks like a subset of Scheme (both are based on S-expressions, code-as-data and macros), but with a reconfigurable NFA lexer and an Earley parser, I could save some parentheses by re-wiring its syntax into anything I want (in principle, this includes any context-free grammar), as long as there is no excessive ambiguity (which does not break the algorithm, but causes massive headaches still). This allows for quick experimentation with new languages -- the construction of AST becomes almost trivial, all the work that remains is the backend.

(TODO: documentation?)
