// ===================================
// Syntax definitions for new language
// ===================================

// Operators and keywords
(add_pattern [_ <op_period_slash>           ::= (word "./")])
(add_pattern [_ <op_left_brace>             ::= (word "{")])
(add_pattern [_ <op_right_brace>            ::= (word "}")])
(add_pattern [_ <op_amp>                    ::= (word "&")])
(add_pattern [_ <op_bar>                    ::= (word "|")])
(add_pattern [_ <op_caret>                  ::= (word "^")])
(add_pattern [_ <op_double_less>            ::= (word "<<")])
(add_pattern [_ <op_double_greater>         ::= (word ">>")])
(add_pattern [_ <op_period_double_greater>  ::= (word ".>>")])
(add_pattern [_ <kw_var>                    ::= (word "var")])

// Integer expressions
(add_rule_auto [Nat      <_expr 100> ::= <nat64>])
(add_rule_auto [Var      <_expr 100> ::= <symbol>])
(add_rule_auto [Ref      <_expr 100> ::= <op_amp>* <_expr 100>])
(add_rule_auto [Deref    <_expr 100> ::= <op_asterisk>* <_expr 100>])
(add_rule_auto [Minus    <_expr 90>  ::= <op_minus>* <_expr 90>])
(add_rule_auto [Mul      <_expr 80>  ::= <_expr 80> <op_asterisk>* <_expr 81>])
(add_rule_auto [SDiv     <_expr 80>  ::= <_expr 80> <op_slash>* <_expr 81>])
(add_rule_auto [UDiv     <_expr 80>  ::= <_expr 80> <op_period_slash>* <_expr 81>])
(add_rule_auto [Add      <_expr 70>  ::= <_expr 70> <op_plus>* <_expr 71>])
(add_rule_auto [Sub      <_expr 70>  ::= <_expr 70> <op_minus>* <_expr 71>])
(add_rule_auto [BitAnd   <_expr 65>  ::= <_expr 66> <op_amp>* <_expr 66>])
(add_rule_auto [BitOr    <_expr 65>  ::= <_expr 66> <op_bar>* <_expr 66>])
(add_rule_auto [BitXor   <_expr 65>  ::= <_expr 66> <op_caret>* <_expr 66>])
(add_rule_auto [Lsl      <_expr 65>  ::= <_expr 66> <op_double_less>* <_expr 66>])
(add_rule_auto [Asr      <_expr 65>  ::= <_expr 66> <op_double_greater>* <_expr 66>])
(add_rule_auto [Lsr      <_expr 65>  ::= <_expr 66> <op_period_double_greater>* <_expr 66>])
(add_rule_auto [Assign   <_expr 60>  ::= <_expr 61> <op_equals>* <_expr 60>])

// Conditional expressions
(add_rule_auto [Le       <_expr 40>  ::= <_expr 41> <op_less_equals>* <_expr 41>])
(add_rule_auto [Lt       <_expr 40>  ::= <_expr 41> <op_less>* <_expr 41>])
(add_rule_auto [Ge       <_expr 40>  ::= <_expr 41> <op_greater_equals>* <_expr 41>])
(add_rule_auto [Gt       <_expr 40>  ::= <_expr 41> <op_greater>* <_expr 41>])
(add_rule_auto [Eq       <_expr 40>  ::= <_expr 41> <op_double_equals>* <_expr 41>])
(add_rule_auto [Neq      <_expr 40>  ::= <_expr 41> <op_bang_equals>* <_expr 41>])
(add_rule_auto [Not      <_expr 40>  ::= <op_bang>* <_expr 40>])
(add_rule_auto [And      <_expr 33>  ::= <_expr 33> <op_amp_amp>* <_expr 34>])
(add_rule_auto [Or       <_expr 32>  ::= <_expr 32> <op_bar_bar>* <_expr 33>])
(add_rule_auto [Implies  <_expr 31>  ::= <_expr 31> <op_right_arrow>* <_expr 32>])
(add_rule_auto [Iff      <_expr 30>  ::= <_expr 30> <op_left_right_arrow>* <_expr 31>])

// Block expressions
(add_rule_auto [VarDecl  <_vardecl>  ::= <kw_var>* <symbol>])
(add_rule_auto [Nil      <_inner>    ::= ])
(add_rule_auto [VarCons  <_inner>    ::= <_vardecl> <op_semicolon>* <_inner>])
(add_rule_auto [ExprCons <_inner>    ::= <_expr 0> <op_semicolon>* <_inner>])
// (add_rule_auto [Block    <_expr 100> ::= <op_left_brace>* <_inner> <op_right_brace>*])

// Top level declarations
// (add_rule      [_        <_decl>     ::= ])
(add_rule      [Top'     <tree 0>    ::= <op_left_brace> <_inner> <op_right_brace>])

// (define_macro Var' [fun (x) => (print x)])
// (define_macro Top' [fun (_ x _) => `(quote ,x)])
(define_macro Top' [fun (_ x _) => x])

// ===============================
// Main procedures for compilation
// ===============================

let

  // StackInfo: list of strings
  lookup = fun (v stackInfo) =>
    let lookup' = fun (v stackInfo n) => [
      match stackInfo with (name . xs) =>
        if (string_eq (print v) (print name)) then n else (lookup' v xs [n + 1])
    ] in (lookup' v stackInfo 0)

  // TODO: branch!
  //   if [cond-expr] then [true-block] else [false-block]
  //   ... [cond-expr] tst r0; beq false-label; [true-block] b end-label; false-label: [false-block] end-label: ...
  // TODO: loop!
  //   while [cond-expr] do [loop-body]
  //   ... loop-begin: [cond-expr] tst r0; beq end-label; [loop-body] j loop-begin; end-label: ...

  re = 0
  sp = 13
  lr = 14
  pc = 15

  /*
  * IR:
  * (Lvalue <code>): final value of register 0 is considered as memory address
  * (Rvalue <code>): final value of register 0 is considered as value
  *
  * Code:
  * (Const <regid> <value>):          constant into register
  * (Local <regid> <index>):          translates to (Add <regid> <sp> <index * 4>)
  * (Push <regid>?):                  push content of register onto stack
  * (Pop <regid>?):                   pop top of the stack into a register
  * (Load <regid> <regid addr>):      load data at memory location specified by a register
  * (Store <regid> <regid addr>):     store data to memory location specified by a register
  * (Minus <regid> <regid>)...:       unary arithmetic instructions
  * (Add <regid> <regid> <regid>)...: binary arithmetic instructions
  */

  // Converts IR code to ARM assembly
  toString = fun (x) => [
    match x with
    ()       => "\n"
    (x . xs) => [
      match x with
      (`Const regid value) => "ldr r" .++ (print regid) .++ ", =" .++ (print value)
      (`Local regid index) => "add r" .++ (print regid) .++ ", sp, #" .++ (print [index * 4])
      (`Push)              => "sub sp, sp, #4"
      (`Push regid)        => "push { r" .++ (print regid) .++ " }"
      (`Pop)               => "add sp, sp, #4"
      (`Pop regid)         => "pop { r" .++ (print regid) .++ " }"
      (`Load regid addr)   => "ldr r" .++ (print regid) .++ ", [" .++ (print addr) .++ "]"
      (`Store regid addr)  => "str r" .++ (print regid) .++ ", [" .++ (print addr) .++ "]"
      (`Minus rd rn)       => "rsb r" .++ (print rd) .++ ", r" .++ (print rd) .++ ", #0"
      (`Add rd rn rm)      => "add r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Sub rd rn rm)      => "sub r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Mul rd rn rm)      => "mul r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`SDiv rd rn rm)     => "sdiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`UDiv rd rn rm)     => "udiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
    ] .++ "\n" .++ (toString xs)
  ]

  // Increases all indices greater or equal than n by k
  // Use it before surrounding code with Push/Pop pairs
  makeGap = fun (code n k) => [
    match code with
    ()        => ()
    (x . xs)  => [
      match x with
      (`Local regid index) => (cons (list `Local regid [if index >= n then [index + k] else index]) (makeGap xs n k))
      (`Push . _)          => (cons x (makeGap xs [n + 1] k))
      (`Pop . _)           => (cons x (makeGap xs [n - 1] k))
      other                => (cons x (makeGap xs n k))
    ]
  ]

  // Merges two pieces of code, with register 1 holding the result of a and register 0 holding the result of b
  merge = fun (a b) => a ++ `((Push 0)) ++ (makeGap b 0 1) ++ `((Pop 1))

  // If IR is already an rvalue, does nothing; otherwise converts it to an rvalue by inserting a Load instruction
  makeRvalue = fun (x) => [
    match x with
    (`Lvalue code) => `(Rvalue ,[code ++ `((Load 0 0))])
    (`Rvalue code) => `(Rvalue ,code)
  ]

  // Converts an expression to IR
  exprIR = fun (x stackInfo) => [
    match x with
    (`Nat n)          => `(Rvalue ((Const 0 ,n)))
    (`Var v)          => [match (lookup v stackInfo) with index => `(Lvalue ((Local 0 ,index)))]
    (`Ref e)          => [match (exprIR e stackInfo) with (`Lvalue code) => `(Rvalue ,code)]
    (`Deref e)        => [match (makeRvalue (exprIR e stackInfo)) with (`Rvalue code) => `(Lvalue ,code)]
    (unop e)          => [match (makeRvalue (exprIR e stackInfo)) with (`Rvalue code) => `(Rvalue ,[code ++ `((,unop 0 0))])]
    (`Assign lhs rhs) => [
      match (exprIR lhs stackInfo) with (`Lvalue lhsCode) => [
        match (makeRvalue (exprIR rhs stackInfo)) with (`Rvalue rhsCode) =>
          `(Lvalue ,[(merge rhsCode lhsCode) ++ `((Store 1 0))])
      ]
    ]
    (binop lhs rhs)   => [
      match (makeRvalue (exprIR lhs stackInfo)) with (`Rvalue lhsCode) => [
        match (makeRvalue (exprIR rhs stackInfo)) with (`Rvalue rhsCode) =>
          `(Rvalue ,[(merge lhsCode rhsCode) ++ `((,binop 0 1 0))])
      ]
    ]
  ]

  // Converts a block to IR
  blockInnerIR = fun (x stackInfo) => [
    match x with
    (`VarCons e es)  => [
      match e with (VarDecl name) => [
        match (blockInnerIR es (cons name stackInfo)) with (type code) =>
          `(,type ,[`((Push)) ++ (makeGap code 0 1) ++ `((Pop))])
      ]
    ]
    (`ExprCons e (Nil)) => (exprIR e stackInfo)
    (`ExprCons e es) => [
      match (exprIR e stackInfo) with (_ lhsCode) => [
        match (blockInnerIR es stackInfo) with (type rhsCode) =>
          `(,type ,(merge lhsCode rhsCode))
      ]
    ]
  ]

  // Converts a function to IR
  functionIR = fun ((params block)) => (makeRvalue (blockInnerIR block params))

in [begin
  (define toString toString)
  (define lookup lookup)
  (define makeGap makeGap)
  (define merge merge)
  (define makeRvalue makeRvalue)
  (define exprIR exprIR)
  (define blockInnerIR blockInnerIR)
  (define functionIR functionIR)
]

// =============
// Test programs
// =============

(define func1 `(
  (x y) {
    var z;
    z = x * 2;
    y = -z;
    x + y + z;
  }))

(display [match (functionIR func1) with (`Rvalue code) => (toString code)])
