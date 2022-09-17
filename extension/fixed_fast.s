;; Fixed-point multiplication
;; Params: [sp+0] lhs, [sp+4] rhs
;; Returns: lhs * rhs
fmul:
  push { r1 }
  ldr r0, [sp, #4]
  ldr r1, [sp, #8]
  mov r0, r0, asr #8
  mov r1, r1, asr #8
  mul r0, r0, r1
  ;; Return
  pop { r1 }
  bx lr

;; Fixed-point inverse (from compiled assembly, then optimised by hand)
;; Params: [sp+0] x
;; Returns: 1 / x
finv:
  push { r1, r2, r3, r4, r5, r6, r7, lr }
  mov r0, #0
  ldr r1, [sp, #32]
  cmp r1, #0
  beq finv_zero
    mov r7, #0
    bge finv_nonnegative
      rsb r1, r1, #0
      mov r7, #1
    finv_nonnegative:
    mov r5, #0
    mov r6, #0

    ;; Mid:
    ;; r0 = res, r1 = x
    ;; r5 = i, r6 = j, r7 = sign

    ;; Normalisation
    ;; (See the "C" implementation for details)
    cmp r1, #65536
    bge finv_gequal
      cmp r1, #256
      movlt r1, r1, lsl #8
      addlt r5, r5, #8
      cmp r1, #4096
      movlt r1, r1, lsl #4
      addlt r5, r5, #4
      cmp r1, #16384
      movlt r1, r1, lsl #2
      addlt r5, r5, #2
      cmp r1, #32768
      movlt r1, r1, lsl #1
      addlt r5, r5, #1
    b finv_less
    finv_gequal:
      cmp r1, #8388608
      movge r1, r1, asr #8
      addge r6, r6, #8
      cmp r1, #524288
      movge r1, r1, asr #4
      addge r6, r6, #4
      cmp r1, #131072
      movge r1, r1, asr #2
      addge r6, r6, #2
      cmp r1, #65536
      movge r1, r1, asr #1
      addge r6, r6, #1
    finv_less:

    ;; Newton's method (3 iterations)
    ;; (See the "C" implementation for details)
    mov r0, #65536
    mov r4, #65536
    mov r1, r1, asr #8
    rsb r1, r1, #0

    mov r3, r0, asr #8
    mla r2, r3, r1, r4
    mov r2, r2, asr #8
    mla r0, r3, r2, r0

    mov r3, r0, asr #8
    mla r2, r3, r1, r4
    mov r2, r2, asr #8
    mla r0, r3, r2, r0

    mov r3, r0, asr #8
    mla r2, r3, r1, r4
    mov r2, r2, asr #8
    mla r0, r3, r2, r0

    ;mov r3, r0, asr #8
    ;mla r2, r3, r1, r4
    ;mov r2, r2, asr #8
    ;mla r0, r3, r2, r0

    mov r0, r0, lsl r5
    mov r0, r0, asr r6
    tst r7, r7
    rsbne r0, r0, #0
  finv_zero:
  pop { r1, r2, r3, r4, r5, r6, r7, lr }
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
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #16]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply b
  ldr r0, [sp, #20]
  ldr r4, [r0]
  mov r1, r1, asr #8
  mov r4, r4, asr #8
  mul r1, r1, r4
  ldr r4, [r0, #4]
  mov r2, r2, asr #8
  mov r4, r4, asr #8
  mul r2, r2, r4
  ldr r4, [r0, #8]
  mov r3, r3, asr #8
  mov r4, r4, asr #8
  mul r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #24]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point scalar-vector multiplication
;; Params: [sp+0] scalar k, [sp+4] pointer to vector a, [sp+8] pointer to vector res
;; Returns: none (res = k * a)
svmul:
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #20]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply k
  ldr r4, [sp, #16]
  mov r4, r4, asr #8
  mov r1, r1, asr #8
  mul r1, r1, r4
  mov r2, r2, asr #8
  mul r2, r2, r4
  mov r3, r3, asr #8
  mul r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #24]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point scalar-vector multiply-and-add
;; Params: [sp+0] scalar k, [sp+4] pointer to vector a, [sp+8] pointer to vector b, [sp+12] pointer to vector res
;; Returns: none (res = k * a + b)
svmla:
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #20]
  ldr r1, [r0]
  ldr r2, [r0, #4]
  ldr r3, [r0, #8]
  ;; Multiply k
  ldr r4, [sp, #16]
  mov r4, r4, asr #8
  mov r1, r1, asr #8
  mul r1, r1, r4
  mov r2, r2, asr #8
  mul r2, r2, r4
  mov r3, r3, asr #8
  mul r3, r3, r4
  ;; Add b
  ldr r0, [sp, #24]
  ldr r4, [r0]
  add r1, r1, r4
  ldr r4, [r0, #4]
  add r2, r2, r4
  ldr r4, [r0, #8]
  add r3, r3, r4
  ;; Save to res
  ldr r0, [sp, #28]
  str r1, [r0]
  str r2, [r0, #4]
  str r3, [r0, #8]
  ;; Return
  pop { r1, r2, r3, r4 }
  bx lr

;; Fixed-point vector-vector dot product
;; Params: [sp+0] pointer to vector a, [sp+4] pointer to vector b
;; Returns: dot(a, b)
vdot:
  push { r1, r2, r3, r4 }
  ;; Load a
  ldr r0, [sp, #16]
  ldr r1, [r0]
  mov r1, r1, asr #8
  ldr r2, [r0, #4]
  mov r2, r2, asr #8
  ldr r3, [r0, #8]
  mov r3, r3, asr #8
  ;; Multiply b
  ldr r0, [sp, #20]
  ldr r4, [r0]
  mov r4, r4, asr #8
  mul r1, r1, r4
  ldr r4, [r0, #4]
  mov r4, r4, asr #8
  mla r1, r2, r4, r1
  ldr r4, [r0, #8]
  mov r4, r4, asr #8
  mla r1, r3, r4, r1
  ;; Return
  mov r0, r1
  pop { r1, r2, r3, r4 }
  bx lr
