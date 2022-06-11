This is an experiment that attempts to make use of the extremely-limited scripting capability of [ApiMu](https://github.com/bridgekat/apimu). Do NOT expect it to work robustly or efficiently.

### "Highlights"

- The compiler itself is interpreted
- No user-defined types, only supported type is unsigned 32-bit integer
- No register allocation (only uses two registers naively)
- No inlining, dead code elimination, or constant propogation, etc.
- Some corner cases may not be supported
