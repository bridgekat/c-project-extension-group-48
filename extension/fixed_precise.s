;; Fixed-point multiplication
;; Params: [sp+0] lhs, [sp+4] rhs
;; Returns: lhs * rhs
fmul:
  push { r1, r2, r3, r4 }
  ldr r1, [sp, #16]
  ldr r2, [sp, #20]
  mov r3, r1, asr #8
  sub r1, r1, r3, lsl #8
  mov r4, r2, asr #8
  sub r2, r2, r4, lsl #8
  mul r0, r1, r4
  mla r0, r2, r3, r0
  mov r0, r0, asr #8
  mla r0, r3, r4, r0
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point inverse (TODO: fix when input = epsilon)
;; Params: [sp+0] x
;; Returns: 1 / x
finv:
  push { r1, r2, r3, r4, r5, lr }
  mov r0, #0
  ldr r1, [sp, #24]
  cmp r1, #0
  beq finv_zero
    mov r5, #0
    bge finv_nonnegative
      rsb r1, r1, #0
      mov r5, #1
    finv_nonnegative:
    ;; Mid: r1 = x, r1 > 0, r5 = sign bit

    ;; Count leading zeros
    mov r3, #0
    mov r4, r1
    mov r2, r4, lsr #16
    tst r2, r2
    addne r3, r3, #16
    movne r4, r2
    mov r2, r4, lsr #8
    tst r2, r2
    addne r3, r3, #8
    movne r4, r2
    mov r2, r4, lsr #4
    tst r2, r2
    addne r3, r3, #4
    movne r4, r2
    mov r2, r4, lsr #2
    tst r2, r2
    addne r3, r3, #2
    movne r4, r2
    mov r2, r4, lsr #1
    tst r2, r2
    addne r3, r3, #1
    movne r4, r2
    ;; Mid: r3 = 31 - clz(x), 0 <= r3 <= 30
    rsb r4, r3, #31
    ;; Mid: r4 = clz(x)

    ;; First subtraction (as if we are subtracting from 2^32)
    mov r2, #0
    sub r2, r2, r1, lsl r4
    mov r0, #1
    mov r0, r0, lsl r4
    ;; r2 = current remainder, r0 = current quotient

    ;; Subsequent subtractions
    ;; See: https://edstem.org/us/courses/14690/discussion/1583047?answer=3569291
    mov r4, #12
    mul r3, r3, r4
    add pc, pc, r3

    andeq r0, r0, r0 ;; Unreachable

    cmp r2, r1, lsl #31
    subcs r2, r2, r1, lsl #31
    addcs r0, r0, #0x80000000
    cmp r2, r1, lsl #30
    subcs r2, r2, r1, lsl #30
    addcs r0, r0, #0x40000000
    cmp r2, r1, lsl #29
    subcs r2, r2, r1, lsl #29
    addcs r0, r0, #0x20000000
    cmp r2, r1, lsl #28
    subcs r2, r2, r1, lsl #28
    addcs r0, r0, #0x10000000
    cmp r2, r1, lsl #27
    subcs r2, r2, r1, lsl #27
    addcs r0, r0, #0x8000000
    cmp r2, r1, lsl #26
    subcs r2, r2, r1, lsl #26
    addcs r0, r0, #0x4000000
    cmp r2, r1, lsl #25
    subcs r2, r2, r1, lsl #25
    addcs r0, r0, #0x2000000
    cmp r2, r1, lsl #24
    subcs r2, r2, r1, lsl #24
    addcs r0, r0, #0x1000000
    cmp r2, r1, lsl #23
    subcs r2, r2, r1, lsl #23
    addcs r0, r0, #0x800000
    cmp r2, r1, lsl #22
    subcs r2, r2, r1, lsl #22
    addcs r0, r0, #0x400000
    cmp r2, r1, lsl #21
    subcs r2, r2, r1, lsl #21
    addcs r0, r0, #0x200000
    cmp r2, r1, lsl #20
    subcs r2, r2, r1, lsl #20
    addcs r0, r0, #0x100000
    cmp r2, r1, lsl #19
    subcs r2, r2, r1, lsl #19
    addcs r0, r0, #0x80000
    cmp r2, r1, lsl #18
    subcs r2, r2, r1, lsl #18
    addcs r0, r0, #0x40000
    cmp r2, r1, lsl #17
    subcs r2, r2, r1, lsl #17
    addcs r0, r0, #0x20000
    cmp r2, r1, lsl #16
    subcs r2, r2, r1, lsl #16
    addcs r0, r0, #0x10000
    cmp r2, r1, lsl #15
    subcs r2, r2, r1, lsl #15
    addcs r0, r0, #0x8000
    cmp r2, r1, lsl #14
    subcs r2, r2, r1, lsl #14
    addcs r0, r0, #0x4000
    cmp r2, r1, lsl #13
    subcs r2, r2, r1, lsl #13
    addcs r0, r0, #0x2000
    cmp r2, r1, lsl #12
    subcs r2, r2, r1, lsl #12
    addcs r0, r0, #0x1000
    cmp r2, r1, lsl #11
    subcs r2, r2, r1, lsl #11
    addcs r0, r0, #0x800
    cmp r2, r1, lsl #10
    subcs r2, r2, r1, lsl #10
    addcs r0, r0, #0x400
    cmp r2, r1, lsl #9
    subcs r2, r2, r1, lsl #9
    addcs r0, r0, #0x200
    cmp r2, r1, lsl #8
    subcs r2, r2, r1, lsl #8
    addcs r0, r0, #0x100
    cmp r2, r1, lsl #7
    subcs r2, r2, r1, lsl #7
    addcs r0, r0, #0x80
    cmp r2, r1, lsl #6
    subcs r2, r2, r1, lsl #6
    addcs r0, r0, #0x40
    cmp r2, r1, lsl #5
    subcs r2, r2, r1, lsl #5
    addcs r0, r0, #0x20
    cmp r2, r1, lsl #4
    subcs r2, r2, r1, lsl #4
    addcs r0, r0, #0x10
    cmp r2, r1, lsl #3
    subcs r2, r2, r1, lsl #3
    addcs r0, r0, #0x8
    cmp r2, r1, lsl #2
    subcs r2, r2, r1, lsl #2
    addcs r0, r0, #0x4
    cmp r2, r1, lsl #1
    subcs r2, r2, r1, lsl #1
    addcs r0, r0, #0x2
    cmp r2, r1
    subcs r2, r2, r1
    addcs r0, r0, #1

    ;; Restore sign
    tst r5, r5
    rsbne r0, r0, #0
  finv_zero:
  pop { r1, r2, r3, r4, r5, lr }
  bx lr

;; Fixed-point vector addition
;; Params: [sp+0] pointer to vector a, [sp+4] pointer to vector b, [sp+8] pointer to vector res
;; Returns: none (res = a + b)
vadd:
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #16]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Add b
  ldr r0, [sp, #20]
  ldr r4, [r0]
  add r1, r1, r4
  ldr r4, [r0, #4]
  add r2, r2, r4
  ldr r4, [r0, #8]
  add r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #24]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point vector subtraction
;; Params: [sp+0] pointer to vector a, [sp+4] pointer to vector b, [sp+8] pointer to vector res
;; Returns: none (res = a - b)
vsub:
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #16]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Subtract b
  ldr r0, [sp, #20]
  ldr r4, [r0]
  sub r1, r1, r4
  ldr r4, [r0, #4]
  sub r2, r2, r4
  ldr r4, [r0, #8]
  sub r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #24]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point vector component-wise multiplication
;; Params: [sp+0] pointer to vector a, [sp+4] pointer to vector b, [sp+8] pointer to vector res
;; Returns: none (res = a .* b)
vmul:
  push { r1, r2, r3, r4, lr }
  ;; Load a
  ldr r0, [sp, #20]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply b
  ldr r4, [sp, #24]
  ldr r0, [r4]
  push { r0, r1 }
  bl fmul ; add sp, sp, #8
  mov r1, r0
  ldr r0, [r4, #4]
  push { r0, r2 }
  bl fmul ; add sp, sp, #8
  mov r2, r0
  ldr r0, [r4, #8]
  push { r0, r3 }
  bl fmul ; add sp, sp, #8
  mov r3, r0
  add sp, sp, #24 ;; Combined
  ;; Save to res
  ldr r0, [sp, #28]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4, lr }
  bx lr

;; Fixed-point scalar-vector multiplication
;; Params: [sp+0] scalar k, [sp+4] pointer to vector a, [sp+8] pointer to vector res
;; Returns: none (res = k * a)
svmul:
  push { r1, r2, r3, r4, lr }
  ;; Load a
  ldr r0, [sp, #24]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply k
  ldr r4, [sp, #20]
  push { r4, r1 }
  bl fmul ; add sp, sp, #8
  mov r1, r0
  push { r4, r2 }
  bl fmul ; add sp, sp, #8
  mov r2, r0
  push { r4, r3 }
  bl fmul ; add sp, sp, #8
  mov r3, r0
  add sp, sp, #24 ;; Combined
  ;; Save to res
  ldr r0, [sp, #28]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4, lr }
  bx lr

;; Fixed-point scalar-vector multiply-and-add
;; Params: [sp+0] scalar k, [sp+4] pointer to vector a, [sp+8] pointer to vector b, [sp+12] pointer to vector res
;; Returns: none (res = k * a + b)
svmla:
  push { r1, r2, r3, r4, lr }
  ;; Load a
  ldr r0, [sp, #24]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply k
  ldr r4, [sp, #20]
  push { r4, r1 }
  bl fmul ; add sp, sp, #8
  mov r1, r0
  push { r4, r2 }
  bl fmul ; add sp, sp, #8
  mov r2, r0
  push { r4, r3 }
  bl fmul ; add sp, sp, #8
  mov r3, r0
  add sp, sp, #24 ;; Combined
  ;; Add b
  ldr r0, [sp, #28]
  ldr r4, [r0]
  add r1, r1, r4
  ldr r4, [r0, #4]
  add r2, r2, r4
  ldr r4, [r0, #8]
  add r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #32]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4, lr }
  bx lr

;; Fixed-point vector-vector dot product
;; Params: [sp+0] pointer to vector a, [sp+4] pointer to vector b
;; Returns: dot(a, b)
vdot:
  push { r1, r2, r3, r4, r5, lr }
  ;; Load a
  ldr r0, [sp, #24]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply b
  ldr r5, [sp, #28]
  ldr r4, [r5]
  push { r4, r1 }
  bl fmul ; add sp, sp, #8
  mov r1, r0
  ldr r4, [r5, #4]
  push { r4, r2 }
  bl fmul ; add sp, sp, #8
  add r1, r1, r0
  ldr r4, [r5, #8]
  push { r4, r3 }
  bl fmul ; add sp, sp, #8
  add r1, r1, r0
  add sp, sp, #24 ;; Combined
  ;; Return
  mov r0, r1
  pop { r1, r2, r3, r4, r5, lr }
  bx lr
