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
(add_pattern [_ <kw_void>                   ::= (word "void")])
(add_pattern [_ <kw_while>                  ::= (word "while")])
(add_pattern [_ <kw_return>                 ::= (word "return")])

// Integer expressions
(add_rule_auto [Parens   <_expr 101> ::= <op_left_paren>* <_expr 0> <op_right_paren>*])
(add_rule_auto [Nat      <_expr 100> ::= <nat64>])
(add_rule_auto [Var      <_expr 100> ::= <symbol>])
(add_rule_auto [App      <_expr 100> ::= <symbol> <op_left_paren>* <_arglist> <op_right_paren>*])
(add_rule_auto [Access   <_expr 100> ::= <_expr 100> <op_left_bracket>* <_expr 0> <op_right_bracket>*])
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
(add_rule_auto [Lsr      <_expr 65>  ::= <_expr 66> <op_period_double_greater>* <_expr 66>])
(add_rule_auto [Asr      <_expr 65>  ::= <_expr 66> <op_double_greater>* <_expr 66>])
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

// Argument lists
(add_rule_auto [ArgNil       <_arglist> ::= ])
(add_rule_auto [ArgOne       <_arglist> ::= <_expr 0>])
(add_rule_auto [ArgSnoc      <_arglist> ::= <_arglist> <op_comma>* <_expr 0>])

// Block expressions
(add_rule_auto [ItemExpr     <_item>    ::= <_expr 0> <op_semicolon>*])
(add_rule_auto [ItemBlock    <_item>    ::= <op_left_brace>* <_block> <op_right_brace>*])
(add_rule_auto [ItemVarDecl  <_item>    ::= <kw_int>* <symbol> <op_semicolon>*])
(add_rule_auto [ItemVarArray <_item>    ::= <kw_int>* <op_left_bracket>* <nat64> <op_right_bracket>* <symbol> <op_semicolon>*])
(add_rule_auto [ItemVarInit  <_item>    ::= <kw_int>* <symbol> <op_equals>* <_expr 0> <op_semicolon>*])
(add_rule_auto [ItemIf       <_item>    ::= <kw_if>* <_expr 101> <_item>])
(add_rule_auto [ItemIfElse   <_item>    ::= <kw_if>* <_expr 101> <_item> <kw_else>* <_item>])
(add_rule_auto [ItemWhile    <_item>    ::= <kw_while>* <_expr 101> <_item>])
(add_rule_auto [BlockNil     <_block>   ::= ])
(add_rule_auto [BlockOne     <_block>   ::= <kw_return>* <_item>])
(add_rule_auto [BlockCons    <_block>   ::= <_item> <_block>])

// Top level declarations
// (Yes, there is no difference between "void" and "int" as return types... at least for now)
(add_rule      [_            <_void_int>  ::= <kw_void>])
(add_rule      [_            <_void_int>  ::= <kw_int>])
(add_rule      [ParamNil'    <_paramlist> ::= ])
(add_rule      [ParamOne'    <_paramlist> ::= <kw_int> <symbol>])
(add_rule      [ParamCons'   <_paramlist> ::= <kw_int> <symbol> <op_comma> <_paramlist>])
(add_rule_auto [Func         <_func>      ::= <_void_int>* <symbol> <op_left_paren>* <_paramlist> <op_right_paren>*
                                              <op_left_brace>* <_block> <op_right_brace>*])
(add_rule      [DeclNil'     <_decls>     ::= ])
(add_rule      [DeclCons'    <_decls>     ::= <_func> <_decls>])
(add_rule      [Top'         <tree 0>     ::= <op_left_brace> <_decls> <op_right_brace>])
(define_macro ParamNil'  [fun ()        => `()])
(define_macro ParamOne'  [fun (_ x)     => `((Int ,x))])
(define_macro ParamCons' [fun (_ l _ r) => `((Int ,l) . ,r)])
(define_macro DeclNil'   [fun ()        => `()])
(define_macro DeclCons'  [fun (l r)     => `(,l . ,r)])
(define_macro Top'       [fun (_ x _)   => `(quote ,x)])

// ===============================
// Main procedures for compilation
// ===============================

(add_pattern   [_ <op_period_double_plus_period> ::= (word ".++.")])
(add_rule_auto [concatIR <expr 70> ::= <expr 71> <op_period_double_plus_period>* <expr 70>])

letrec

  /*
  * StackInfo: list of
  *   (Int <name>)
  *   (IntArray <name> <size>)
  *
  * LinearIR:
  *   (Lvalue <regnum> <code>): final value of register 1 is considered as memory address
  *   (Rvalue <regnum> <code>): final value of register 1 is considered as value
  *   (Nvalue <regnum> <code>): final value of register 1 is undefined
  *   where <regnum>: number of registers modified by <code>, always >= 1
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
  *   (JumpZero <regid> <id>):          if given register is zero then jump to label
  *   (Func <name>):                    function label
  *   (Call <regid> <name>):            call function, copying return value on register 0 to some register
  *   (Save <regid>):                   save return value to register 0
  *   (Return):                         jump back to linked position
  */

  numRegs = 12
  lr = 14
  labelCount = 0

  // Returns the offset of a local variable
  lookup = fun (v stackInfo) =>
    letrec lookup' = fun (v stackInfo acc) => [
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
    ()       => ()
    (x . xs) => [
      match x with
      (`Local regid index) => (cons (list `Local regid [if index >= n then [index + k] else index]) (makeGap xs n k))
      (`Push regid)        => (cons x (makeGap xs [n + 1] k))
      (`Pop regid)         => (cons x (makeGap xs [n - 1] k))
      (`PushN m)           => (cons x (makeGap xs [n + m] k))
      (`PopN m)            => (cons x (makeGap xs [n - m] k))
      other                => (cons x (makeGap xs n k))
    ]
  ]

  // Applies function f to all register names that appear in the code
  updateRegs = fun (f code) => [
    match code with
    ()       => `()
    (x . xs) => (cons [
      match x with
      (`Const regid value) => `(Const ,(f regid) ,value)
      (`Local regid index) => `(Local ,(f regid) ,index)
      (`Push regid)        => `(Push ,(f regid))
      (`Pop  regid)        => `(Pop  ,(f regid))
      (`PushN num)         => x
      (`PopN num)          => x
      (`Label id)          => x
      (`Jump id)           => x
      (`JumpZero regid id) => `(JumpZero ,(f regid) ,id)
      (`Func name)         => x
      (`Call regid name)   => `(Call ,(f regid) ,name)
      (`Save regid)        => `(Save ,(f regid))
      (`Return)            => x
      (unop  rd rn)        => `(,unop  ,(f rd) ,(f rn))
      (binop rd rn rm)     => `(,binop ,(f rd) ,(f rn) ,(f rm))
    ] (updateRegs f xs))
  ]

  // Increases all nonzero register indices by 1, vacating register 1 from code
  // (We assume in the calling convention that functions save all registers except 0 for the caller)
  vacate1 = fun (code) =>
    (updateRegs [fun (n) => if n == 0 then 0 else n + 1] code)

  // Swaps registers 1 and 2
  swap12 = fun (code) =>
    (updateRegs [fun (n) => if n == 1 then 2 else if n == 2 then 1 else n] code)

  // Concatenates two pieces of IR, only preserving the result of the last one
  concatIR = fun ((_ lhsRn lhsCode) (type rhsRn rhsCode)) =>
    `(,type ,(max lhsRn rhsRn) ,[lhsCode ++ rhsCode])

  // Merges two pieces of IR, with register 1 holding the result of LHS and register 2 holding the result of RHS
  // Pre: lhsRn <= numRegs && rhsRn <= numRegs
  mergeIR = fun ((type lhsRn lhsCode) (_ rhsRn rhsCode)) =>
    if rhsRn < numRegs then `(,type ,(max lhsRn [rhsRn + 1]) ,[lhsCode ++ (vacate1 rhsCode)])
    else `(,type ,numRegs ,[lhsCode ++ `((Push 1)) ++ (swap12 (makeGap rhsCode 0 1)) ++ `((Pop 1))])

  // Expects an IR to return an lvalue
  expectLvalue = fun (x) => [
    match x with
    (`Lvalue rn code) => `(Lvalue ,rn ,code)
  ]

  // If IR is already an rvalue, does nothing; otherwise converts it to an rvalue by inserting a Load instruction
  makeRvalue = fun (x) => [
    match x with
    (`Lvalue rn code) => `(Rvalue ,rn ,[code ++ `((Load 1 1))])
    (`Rvalue rn code) => `(Rvalue ,rn ,code)
  ]

  // More permissive version (for functions with undefined return values)
  makeRvalue_ = fun (x) => [
    match x with
    (`Lvalue rn code) => `(Rvalue ,rn ,[code ++ `((Load 1 1))])
    (`Rvalue rn code) => `(Rvalue ,rn ,code)
    (`Nvalue rn code) => `(Rvalue ,rn ,code) // Undefined!
  ]

  // Converts an expression to IR
  exprIR = fun (x stackInfo) => [
    match x with
    (`Parens e)         => (exprIR e stackInfo)
    (`Block b)          => (blockIR b stackInfo)
    (`Nat n)            => `(Rvalue 2 ((Const 1 ,n)))
    (`Var v)            => [match (lookup v stackInfo) with (type index) => `(,type 2 ((Local 1 ,index)))]
    (`Ref e)            => [match (exprIR e stackInfo) with (`Lvalue rn code) => `(Rvalue ,rn ,code)]
    (`Deref e)          => [match (makeRvalue (exprIR e stackInfo)) with (`Rvalue rn code) => `(Lvalue ,rn ,code)]
    (`Access lhs rhs)   =>
      let lhs = (makeRvalue (exprIR lhs stackInfo))
          rhs = (makeRvalue (exprIR rhs stackInfo))
      in (mergeIR lhs rhs) .++. `(Lvalue 3 ((Add4 1 1 2)))
    (`Assign lhs rhs)   =>
      let lhs = (expectLvalue (exprIR lhs stackInfo))
          rhs = (makeRvalue (exprIR rhs stackInfo))
      in (mergeIR lhs rhs) .++. `(Lvalue 3 ((Store 2 1)))
    // Assuming CDECL convention: caller clean-up (this allows Push/Pops in the IR to pair up).
    // Return value is copied from register 0 to 1. All other registers are unmodified by assumption
    (`App name args)  => [
      match (arglistIR args stackInfo 0 `(Nvalue 0 ())) with (n code) =>
        code .++. `(Rvalue 2 ((Call 1 ,(print name)) (PopN ,n)))
    ]
    // The rest are all unary or binary arithmetic operations
    (unop e)          => [
      let code = (makeRvalue (exprIR e stackInfo))
      in code .++. `(Rvalue 2 ((,unop 1 1)))
    ]
    (binop lhs rhs)   => [
      let lhs = (makeRvalue (exprIR lhs stackInfo))
          rhs = (makeRvalue (exprIR rhs stackInfo))
      in (mergeIR lhs rhs) .++. `(Rvalue 3 ((,binop 1 1 2)))
    ]
  ]

  // Converts an arglist to (<num args> <code>)
  // <code> is responsible for pushing arguments onto stack, from right to left
  arglistIR = fun (x stackInfo n acc) => [
    match x with
    (`ArgNil)       => `(,n ,acc)
    (`ArgOne e)     => [
      let curr = (makeRvalue (exprIR e stackInfo))
      in `(,[n + 1] ,[acc .++. curr .++. `(Nvalue 2 ((Push 1)))])
    ]
    (`ArgSnoc es e) => [
      let curr = (makeRvalue (exprIR e stackInfo))
      in (arglistIR es (cons `(Int "") stackInfo) [n + 1] [acc .++. curr .++. `(Nvalue 2 ((Push 1)))])
    ]
  ]

  // Converts a block to IR
  blockIR = fun (x stackInfo) => [
    match x with
    (`ItemExpr e)                             => (exprIR e stackInfo)
    (`ItemBlock b)                            => (blockIR b stackInfo)
    (`BlockCons (`ItemVarDecl name) xs)       => [
      match (blockIR xs (cons `(Int ,name) stackInfo)) with (type rn code) =>
        `(,type ,rn ,[`((PushN 1)) ++ code ++ `((PopN 1))])
    ]
    (`BlockCons (`ItemVarArray size name) xs) => [
      match (blockIR xs (cons `(IntArray ,name ,size) stackInfo)) with (type rn code) =>
        `(,type ,rn ,[`((PushN ,size)) ++ code ++ `((PopN ,size))])
    ]
    (`BlockCons (`ItemVarInit name e) xs)     => [
      match (makeRvalue (exprIR e stackInfo)) with (`Rvalue lhsRn lhsCode) => [
        match (blockIR xs (cons `(Int ,name) stackInfo)) with (type rhsRn rhsCode) =>
          `(,type ,(max lhsRn rhsRn) ,[lhsCode ++ `((Push 1)) ++ rhsCode ++ `((PopN 1))])
      ]
    ]
    (`ItemIf e body) => [
      let cond = (makeRvalue (exprIR e stackInfo))
          body = (blockIR body stackInfo)
          falseLabel = labelCount
      in begin
        labelCount = labelCount + 1;
             cond
        .++. `(Nvalue 2 ((JumpZero 1 ,falseLabel)))
        .++. body
        .++. `(Nvalue 0 ((Label ,falseLabel)))
    ]
    (`ItemIfElse e lhs rhs) => [
      let cond = (makeRvalue (exprIR e stackInfo))
          lhs = (blockIR lhs stackInfo)
          rhs = (blockIR rhs stackInfo)
          falseLabel = labelCount
          endLabel = labelCount + 1
      in begin
        labelCount = labelCount + 2;
             cond
        .++. `(Nvalue 2 ((JumpZero 1 ,falseLabel)))
        .++. lhs
        .++. `(Nvalue 0 ((Jump ,endLabel)))
        .++. `(Nvalue 0 ((Label ,falseLabel)))
        .++. rhs
        .++. `(Nvalue 0 ((Label ,endLabel)))
    ]
    (`ItemWhile e body) => [
      let cond = (makeRvalue (exprIR e stackInfo))
          body = (blockIR body stackInfo)
          beginLabel = labelCount
          endLabel = labelCount + 1
      in begin
        labelCount = labelCount + 2;
             `(Nvalue 0 ((Label ,beginLabel)))
        .++. cond
        .++. `(Nvalue 2 ((JumpZero 1 ,endLabel)))
        .++. body
        .++. `(Nvalue 0 ((Jump ,beginLabel)))
        .++. `(Nvalue 0 ((Label ,endLabel)))
    ]
    (`BlockNil)       => `(Nvalue 0 ())
    (`BlockOne x)     => (blockIR x stackInfo)
    (`BlockCons x xs) => (blockIR x stackInfo) .++. (blockIR xs stackInfo)
  ]

  // Checks if the given code contains a function call (so that we need to save LR on the stack)
  hasCall = fun (x) => [
    match x with
    ()                => false
    ((`Call _ _) . _) => true
    (_ . xs)          => (hasCall xs)
  ]

  // Preservation of (general purpose) registers
  wrap = fun (n code) =>
    if n <= 1 then code
    else `((Push ,[n - 1])) ++ (makeGap (wrap [n - 1] code) 0 1) ++ `((Pop ,[n - 1]))

  // Converts a function to IR code
  functionIR = fun ((`Func name params block)) => [
    match (makeRvalue_ (blockIR block params)) with (`Rvalue rn code) =>
      let code = (wrap rn [code ++ `((Save 1))]) in
      let code = if (hasCall code) then `((Push ,lr)) ++ (makeGap code 0 1) ++ `((Pop ,lr)) else code in
        `((Func ,(print name))) ++ code ++ `((Return))
  ]

  // Converts a program (a list of function definitions) to IR code
  programIR = fun (x) => [
    match x with
    ()       => (nil)
    (d . ds) => (functionIR d) ++ (programIR ds)
  ]

  // Converts IR code to ARM assembly
  toString = fun (x) => [
    match x with
    // Shortcuts (better than nothing...)
    // WARNING: some of these are unsound, more checks required
    ((`Le _ rn rm) (`JumpZero _ id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bgt l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Lt _ rn rm) (`JumpZero _ id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bge l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Ge _ rn rm) (`JumpZero _ id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "blt l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Gt _ rn rm) (`JumpZero _ id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "ble l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Eq _ rn rm) (`JumpZero _ id) . xs)  => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "bne l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Neq _ rn rm) (`JumpZero _ id) . xs) => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "beq l" .++ (print id) .++ "\n" .++ (toString xs)
    ((`Local r index) (`Load _ _) . xs)  => "ldr r" .++ (print r) .++ ", [sp, #" .++ (print [index * 4]) .++ "]\n" .++ (toString xs)
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
      (`Label id)           => "l" .++ (print id) .++ ":"
      (`Jump id)            => "b l" .++ (print id)
      (`JumpZero regid id)  => "tst r" .++ (print regid) .++ ", r" .++ (print regid) .++ "\n" .++ "beq l" .++ (print id)
      (`Func name)          => "\n" .++ name .++ ":"
      (`Call regid name)    => "bl " .++ name .++ "\n" .++ "mov r" .++ (print regid) .++ ", r0"
      (`Save regid)         => "mov r0, r" .++ (print regid)
      (`Return)             => "bx lr"
      (`Minus rd rn)        => "rsb r" .++ (print rd) .++ ", r" .++ (print rd) .++ ", #0"
      (`Add rd rn rm)       => "add r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Add4 rd rn rm)      => "add r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm) .++ ", lsl #2" // Temporary fix
      (`Sub rd rn rm)       => "sub r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Mul rd rn rm)       => "mul r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`SDiv rd rn rm)      => "sdiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`UDiv rd rn rm)      => "udiv r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitAnd rd rn rm)    => "and r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitOr rd rn rm)     => "orr r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`BitXor rd rn rm)    => "eor r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", r" .++ (print rm)
      (`Lsl rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", lsl r" .++ (print rm)
      (`Lsr rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", lsr r" .++ (print rm)
      (`Asr rd rn rm)       => "mov r" .++ (print rd) .++ ", r" .++ (print rn) .++ ", asr r" .++ (print rm)
      (`Le rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "movle r" .++ (print rd) .++ ", #1"
      (`Lt rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "movlt r" .++ (print rd) .++ ", #1"
      (`Ge rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "movge r" .++ (print rd) .++ ", #1"
      (`Gt rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "movgt r" .++ (print rd) .++ ", #1"
      (`Eq rd rn rm)        => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "moveq r" .++ (print rd) .++ ", #1"
      (`Neq rd rn rm)       => "cmp r" .++ (print rn) .++ ", r" .++ (print rm) .++ "\n" .++ "mov r" .++ (print rd) .++ ", #0\n" .++ "movne r" .++ (print rd) .++ ", #1"
    ] .++ "\n" .++ (toString xs)
  ]

in [begin
  (define exprIR exprIR)
  (define blockIR blockIR)
  (define functionIR functionIR)
  (define programIR programIR)
  (define toString toString)
]
