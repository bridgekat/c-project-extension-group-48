This is an experiment that attempts to make use of the extremely-limited scripting capability of [ApiMu](https://github.com/bridgekat/apimu). Do NOT expect it to work robustly or efficiently.

### "Highlights"

- The compiler itself is interpreted
- No user-defined types, only supported type is unsigned 32-bit integer
- No register allocation (only uses two registers naively)
- No inlining, dead code elimination, or constant propogation, etc.
- Some corner cases may not be supported

The ApiMu scripting language looks like a subset of Scheme (both are based on S-expressions, code-as-data and macros), but with a reconfigurable NFA lexer and an Earley parser, I could save some parentheses by re-wiring its syntax into anything I want (in principle, this includes any context-free grammar), as long as there is no excessive ambiguity (which does not break the algorithm, but causes massive headaches instead). This allows for quick experimentation with new languages -- the construction of AST becomes almost trivial, all the work that remains is the backend.

(TODO: documentation?)

However, the above description only holds in theory. The current implementation is very broken (e.g. it does not give a proper error message when there is ambiguity). Fortunately, it is still enough for a simple compiler of a simple language...
