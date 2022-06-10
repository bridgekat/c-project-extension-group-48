// ===================================
// Syntax definitions for new language
// ===================================

// Operators and keywords
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
(add_rule_auto [Div      <_expr 80>  ::= <_expr 80> <op_slash>* <_expr 81>])
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

(define func1 `(
  (x z) {
    x = 1;
    var y; y = x * 2;
    z = y * 3;
    x + y + z;
  }
))

let

  /*
  exprIR = fun (x stackInfo) => [
    match x with
    (`)
  ]
  */

  offsetLocals = fun (n stackInfo) => [
    match stackInfo with
    ()                          => ()
    ((`Local name offset) . xs) => (cons (list `Local name [offset + n]) (offsetLocals n xs))
    (x . xs)                    => (cons x (offsetLocals n xs))
  ]

  pushLocal = fun (varDecl stackInfo) => [
    match varDecl with
    (`VarDecl name) => (cons (list `Local name 0) (offsetLocals 4 stackInfo))
  ]

  blockInnerIR = fun (x stackInfo) => [
    match x with
    (`Nil)            => ()
    (`VarCons e es)   => (cons (list "TODO: SP +4") (blockInnerIR es (pushLocal e stackInfo)))
    (`ExprCons e es)  => (cons e (blockInnerIR es stackInfo))
  ]

  paramsStackInfo = fun (params offset) => [
    match params with
    ()       => ()
    (p . ps) => (cons (list `Param p offset) (paramsStackInfo ps [offset + 4]))
  ]

  functionIR = fun ((params block)) =>
    let stackInfo = (paramsStackInfo params 0)
    in (blockInnerIR block stackInfo)

in [begin
  (define blockInnerIR blockInnerIR)
  (define functionIR functionIR)
]



