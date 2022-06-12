// ===================================
// Syntax definitions for new language
// ===================================

// Additional operators and keywords
// Others are defined in `prelude.mu` as part of the base language and can be reused
(add_pattern [_ <op_period_slash>           ::= (word "./")])
(add_pattern [_ <op_left_brace>             ::= (word "{")])
(add_pattern [_ <op_right_brace>            ::= (word "}")])
(add_pattern [_ <op_amp>                    ::= (word "&")])
(add_pattern [_ <op_bar>                    ::= (word "|")])
(add_pattern [_ <op_caret>                  ::= (word "^")])
(add_pattern [_ <op_double_less>            ::= (word "<<")])
(add_pattern [_ <op_double_greater>         ::= (word ">>")])
(add_pattern [_ <op_period_double_greater>  ::= (word ".>>")])
(add_pattern [_ <kw_int>                    ::= (word "int")])
(add_pattern [_ <kw_while>                  ::= (word "while")])

// Integer expressions
(add_rule_auto [Parens   <_expr 100> ::= <op_left_paren>* <_expr 0> <op_right_paren>*])
(add_rule_auto [Block    <_expr 100> ::= <op_left_brace>* <_block> <op_right_brace>*])
(add_rule_auto [Nat      <_expr 100> ::= <nat64>])
(add_rule_auto [Var      <_expr 100> ::= <symbol>])
(add_rule_auto [App      <_expr 100> ::= <symbol> <op_left_paren>* <_arglist> <op_right_paren>*])
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

// Boolean expressions
(add_rule_auto [Le       <_expr 40>  ::= <_expr 41> <op_less_equals>* <_expr 41>])
(add_rule_auto [Lt       <_expr 40>  ::= <_expr 41> <op_less>* <_expr 41>])
(add_rule_auto [Ge       <_expr 40>  ::= <_expr 41> <op_greater_equals>* <_expr 41>])
(add_rule_auto [Gt       <_expr 40>  ::= <_expr 41> <op_greater>* <_expr 41>])
(add_rule_auto [Eq       <_expr 40>  ::= <_expr 41> <op_double_equals>* <_expr 41>])
(add_rule_auto [Neq      <_expr 40>  ::= <_expr 41> <op_bang_equals>* <_expr 41>])
/*
(add_rule_auto [Not      <_expr 40>  ::= <op_bang>* <_expr 40>])
(add_rule_auto [And      <_expr 33>  ::= <_expr 33> <op_amp_amp>* <_expr 34>])
(add_rule_auto [Or       <_expr 32>  ::= <_expr 32> <op_bar_bar>* <_expr 33>])
(add_rule_auto [Implies  <_expr 31>  ::= <_expr 31> <op_right_arrow>* <_expr 32>])
(add_rule_auto [Iff      <_expr 30>  ::= <_expr 30> <op_left_right_arrow>* <_expr 31>])
*/

// Compound expressions
(add_rule_auto [ArgNil        <_arglist> ::= ])
(add_rule_auto [ArgOne        <_arglist> ::= <_expr 0>])
(add_rule_auto [ArgSnoc       <_arglist> ::= <_arglist> <op_comma>* <_expr 0>])
(add_rule_auto [VarDecl       <_var>     ::= <kw_int>* <symbol>])
(add_rule_auto [VarArray      <_var>     ::= <kw_int>* <op_left_bracket>* <nat64> <op_right_bracket>* <symbol>])
(add_rule_auto [VarInit       <_var>     ::= <kw_int>* <symbol> <op_equals>* <_expr 60>])
(add_rule_auto [BlockExpr     <_block>   ::= <_expr 0> <op_semicolon>*])
(add_rule_auto [BlockVarCons  <_block>   ::= <_var> <op_semicolon>* <_block>])
(add_rule_auto [BlockExprCons <_block>   ::= <_expr 0> <op_semicolon>* <_block>])
(add_rule_auto [If            <_expr 10> ::= <kw_if>* <_expr 11> <kw_then>* <_expr 11> <kw_else>* <_expr 10>])
(add_rule_auto [While         <_expr 10> ::= <kw_while>* <_expr 11> <_expr 10>])

// Top level declarations
(add_rule [Top' <tree 0> ::= <op_left_brace> <_block> <op_right_brace>])
(define_macro Top' [fun (_ x _) => x])

// ===============================
// Main procedures for compilation
// ===============================

let

  /*
  * StackInfo: list of
  *   (Int <name>)
  *   (IntArray <name> <size>)
  *
  * Linear IR: list of
  *   (Lvalue <code>): final value of register 0 is considered as memory address
  *   (Rvalue <code>): final value of register 0 is considered as value
  *
  * Code: list of
  *   (Const <regid> <value>):          constant into register
  *   (Local <regid> <index>):          translates to (Add <regid> <sp> <index * 4>)
  *   (Push <regid>):                   push content of register onto stack
  *   (Pop <regid>):                    pop top of the stack into a register
  *   (PushN <num>):                    translates to (Sub <sp> <sp> <num * 4>)
  *   (PopN <num>):                     translates to (Add <sp> <sp> <num * 4>)
  *   (Load <regid> <regid addr>):      load data at memory location specified by a register
  *   (Store <regid> <regid addr>):     store data to memory location specified by a register
  *   (Minus <regid> <regid>)...:       unary arithmetic instructions
  *   (Add <regid> <regid> <regid>)...: binary arithmetic instructions
  *   (Label <id>):                     label
  *   (Jump <id>):                      jump to label
  *   (JumpZero <id>):                  if register 0 is zero then jump to label
  *   (Call <id>):                      jump with link (call function)
  *   (Return):                         jump back to linked position (return)
  */

  symbol_eq = fun (a b) => (string_eq (print a) (print b))
  lr = 14
  labelCount = 0

  // Returns the offset of a local variable
  lookup = fun (v stackInfo) =>
    let lookup' = fun (v stackInfo acc) => [
      match stackInfo with (x . xs) => [
        match x with
        (`Int name)           => if (symbol_eq v name) then `(Lvalue ,acc) else (lookup' v xs [acc + 1])
        (`IntArray name size) => if (symbol_eq v name) then `(Rvalue ,acc) else (lookup' v xs [acc + size])
      ]
    ] in (lookup' v stackInfo 0)

  // Increases all indices greater or equal than n by k
  // Use it before surrounding code with Push/Pop pairs
  makeGap = fun (code n k) => [
    match code with
    ()        => ()
    (x . xs)  => [
      match x with
      (`Local regid index) => (cons (list `Local regid [if index >= n then [index + k] else index]) (makeGap xs n k))
      (`Push regid)        => (cons x (makeGap xs [n + 1] k))
      (`Pop regid)         => (cons x (makeGap xs [n - 1] k))
      (`PushN m)           => (cons x (makeGap xs [n + m] k))
      (`PopN m)            => (cons x (makeGap xs [n - m] k))
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

  // More permissive version (for functions with undefined return values)
  makeRvalue_ = fun (x) => [
    match x with
    (`Lvalue code) => `(Rvalue ,[code ++ `((Load 0 0))])
    (`Rvalue code) => `(Rvalue ,code)
    (`Nvalue code) => `(Rvalue ,code) // Undefined!
  ]

  // Converts an expression to IR
  exprIR = fun (x stackInfo) => [
    match x with
    (`Parens e)       => (exprIR e stackInfo)
    (`Block b)        => (blockIR b stackInfo)
    (`Nat n)          => `(Rvalue ((Const 0 ,n)))
    (`Var v)          => [match (lookup v stackInfo) with (type index) => `(,type ((Local 0 ,index)))]
    (`Ref e)          => [match (exprIR e stackInfo) with (`Lvalue code) => `(Rvalue ,code)]
    (`Deref e)        => [match (makeRvalue (exprIR e stackInfo)) with (`Rvalue code) => `(Lvalue ,code)]
    (`Assign lhs rhs) => [
      match (exprIR lhs stackInfo) with (`Lvalue lhsCode) => [
        match (makeRvalue (exprIR rhs stackInfo)) with (`Rvalue rhsCode) =>
          `(Lvalue ,[(merge rhsCode lhsCode) ++ `((Store 1 0))])
    ]]
    (`If e lhs rhs)   => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue condCode) => [
        match (makeRvalue (exprIR lhs stackInfo)) with (`Rvalue lhsCode) => [
          match (makeRvalue (exprIR rhs stackInfo)) with (`Rvalue rhsCode) => [
            begin
              labelCount = labelCount + 2;
              let falseLabel = labelCount - 2; endLabel = labelCount - 1 in
                `(Rvalue ,[
                  condCode ++ `((JumpZero ,falseLabel)) ++
                  lhsCode ++ `((Jump ,endLabel)) ++
                  `((Label ,falseLabel)) ++ rhsCode ++ `((Label ,endLabel))
                ])
    ]]]]
    (`While e body)   => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue condCode) => [
        match (exprIR body stackInfo) with (type code) => [
          begin
            labelCount = labelCount + 2;
            let beginLabel = labelCount - 2; endLabel = labelCount - 1 in
              `(Nvalue ,[
                `((Label ,beginLabel)) ++ condCode ++ `((JumpZero ,endLabel)) ++
                code ++ `((Jump ,beginLabel)) ++ `((Label ,endLabel))
              ])
    ]]]
    // Assuming CDECL convention: caller clean-up (this allows Push/Pops in the IR to pair up)
    // We don't care about other registers, as long as register 0 contains the return value
    (`App name args)  => [
      match (arglistIR args stackInfo) with (n code) =>
        `(Rvalue ,[code ++ `((Call ,(print name)) (PopN ,n))])
    ]
    // The rest are all unary or binary arithmetic operations
    (unop e)          => [match (makeRvalue (exprIR e stackInfo)) with (`Rvalue code) => `(Rvalue ,[code ++ `((,unop 0 0))])]
    (binop lhs rhs)   => [
      match (makeRvalue (exprIR lhs stackInfo)) with (`Rvalue lhsCode) => [
        match (makeRvalue (exprIR rhs stackInfo)) with (`Rvalue rhsCode) =>
          `(Rvalue ,[(merge lhsCode rhsCode) ++ `((,binop 0 1 0))])
    ]]
  ]

  // Converts an arglist to (<num args> <code>)
  // <code> is responsible for pushing arguments onto stack, from right to left
  arglistIR = fun (x stackInfo) => [
    match x with
    (`ArgNil)       => (list 0 (nil))
    (`ArgOne e)     => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue code) =>
        (list 1 [code ++ `((Push 0))])
    ]
    (`ArgSnoc es e) => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue rhsCode) => [
        match (arglistIR es stackInfo) with (n lhsCode) =>
          (list [n + 1] [rhsCode ++ `((Push 0)) ++ (makeGap lhsCode 0 1)])
    ]]
  ]

  // Converts a block to IR
  blockIR = fun (x stackInfo) => [
    match x with
    (`BlockExpr e)                        => (exprIR e stackInfo)
    (`BlockVarCons (`VarDecl name) es)    => [
      match (blockIR es (cons `(Int ,name) stackInfo)) with (type code) =>
        `(,type ,[`((PushN 1)) ++ code ++ `((PopN 1))])
    ]
    (`BlockVarCons (`VarArray size name) es) => [
      match (blockIR es (cons `(IntArray ,name ,size) stackInfo)) with (type code) =>
        `(,type ,[`((PushN ,size)) ++ code ++ `((PopN ,size))])
    ]
    (`BlockVarCons (`VarInit name e) es)  => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue initCode) => [
        match (blockIR es (cons `(Int ,name) stackInfo)) with (type code) =>
          `(,type ,[initCode ++ `((Push 0)) ++ code ++ `((PopN 1))])
      ]
    ]
    (`BlockExprCons e es)                 => [
      match (exprIR e stackInfo) with (_ lhsCode) => [
        match (blockIR es stackInfo) with (type rhsCode) =>
          `(,type ,[lhsCode ++ rhsCode])
      ]
    ]
  ]

  // Checks if the given code contains a function call (so that we need to save LR on the stack)
  // (Registers 4+ are never used so we don't need to save them.)
  hasCall = fun (x) => [
    match x with
    ()              => false
    ((`Call _) . _) => true
    (_ . xs)        => (hasCall xs)
  ]

  // Converts a function to IR
  functionIR = fun ((params block)) => [
    match (makeRvalue_ (blockIR block params)) with (`Rvalue code) =>
      if (hasCall code)
      then `((Push ,lr)) ++ (makeGap code 0 1) ++ `((Pop ,lr) (Return))
      else code ++ `((Return))
  ]

  // Converts IR code to ARM assembly
  toString = fun (x) => [
    match x with
    // Shortcuts (better than nothing...)
    ((`Le 0 rn rm) (`JumpZero id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bgt label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Lt 0 rn rm) (`JumpZero id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bge label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Ge 0 rn rm) (`JumpZero id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "blt label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Gt 0 rn rm) (`JumpZero id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "ble label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Eq 0 rn rm) (`JumpZero id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bne label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Neq 0 rn rm) (`JumpZero id) . xs) => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "beq label_" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Local 0 index) (`Load 0 0) . xs)                     => "ldr r0, [sp, #" .++ (print [index * 4]) .++ "]\n" .++ (toString xs)
    ((`Push 0) (`Local 0 index) (`Pop 1) (`Store 1 0) . xs) => "str r0, [sp, #" .++ (print [[index - 1] * 4]) .++ "]\n" .++ (toString xs)
    ((`PopN 0) . xs)           => (toString xs)
    ((`PopN a) (`PopN b) . xs) => (toString `((PopN ,[a + b]) . ,xs))
    // Single instructions
    ()       => "\n"
    (x . xs) => [
      match x with
      (`Const regid value)  => "ldr r" .++ (print regid) .++ ", =" .++ (print value)
      (`Local regid index)  => "add r" .++ (print regid) .++ ", sp, #" .++ (print [index * 4])
      (`Push regid)         => "push { r" .++ (print regid) .++ " }"
      (`Pop regid)          => "pop { r" .++ (print regid) .++ " }"
      (`PushN num)          => "sub sp, sp, #" .++ (print [num * 4])
      (`PopN num)           => "add sp, sp, #" .++ (print [num * 4])
      (`Load regid addr)    => "ldr r" .++ (print regid) .++ ", [r" .++ (print addr) .++ "]"
      (`Store regid addr)   => "str r" .++ (print regid) .++ ", [r" .++ (print addr) .++ "]"
      (`Label id)           => "label_" .++ (print id) .++ ":"
      (`Jump id)            => "b label_" .++ (print id)
      (`JumpZero id)        => "tst r0, r0\n" .++ "beq label_" .++ (print id)
      (`Call name)          => "bl " .++ name
      (`Return)             => "bx lr"
      (`Minus rd rn)        => "rsb r" .++ (print rd) .++ ", r" .++ (print rd) .++ ", #0"
      (`Add rd rn rm)       => "add r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Sub rd rn rm)       => "sub r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Mul rd rn rm)       => "mul r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`SDiv rd rn rm)      => "sdiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`UDiv rd rn rm)      => "udiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitAnd rd rn rm)    => "and r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitOr rd rn rm)     => "orr r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitXor rd rn rm)    => "eor r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Lsl rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", lsl r" .++ (print rm)
      (`Asr rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", asr r" .++ (print rm)
      (`Lsr rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", lsr r" .++ (print rm)
      (`Le rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "movle r0, #1"
      (`Lt rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "movlt r0, #1"
      (`Ge rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "movge r0, #1"
      (`Gt rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "movgt r0, #1"
      (`Eq rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "moveq r0, #1"
      (`Neq rd rn rm)       => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r0, #0\n" .++ "movne r0, #1"
    ] .++ "\n" .++ (toString xs)
  ]

in [begin
  (define exprIR exprIR)
  (define blockIR blockIR)
  (define functionIR functionIR)
  (define toString toString)
]

// =============
// Test programs
// =============

(define
  func1 `(((Int x) (Int y)) {
    int z;
    z = y;
    z * 0x10000 + x * 0x10;
  }))

(define
  func2 `(((Int x) (Int y)) {
    if (x > y) then x else y;
  }))

(define
  func3 `(((Int n)) {
    int a = 1;
    int b = 1;
    while (b <= n) {
      int c = a + b;
      a = b;
      b = c;
    };
    b;
  }))

(define
  func4 `(((Int n) (Int m)) {
    int p = 233;
    int i = 0;
    while (i < n) {
      int j = 0;
      while (j < m) {
        *(p + i * m + j) = 0;
        j = j + 1;
      };
      i = i + 1;
    };
  }))

(define
  func5 `(((Int k) (Int pvec)) {
    int[3] arr;
    *arr       = fixed_mul(k, *pvec);
    *(arr + 1) = fixed_mul(k, *(pvec + 1));
    *(arr + 2) = fixed_mul(k, *(pvec + 2));
  }))

(display (toString (functionIR func1)))
(display (toString (functionIR func2)))
(display (toString (functionIR func3)))
(display (toString (functionIR func4)))
(display (toString (functionIR func5)))
