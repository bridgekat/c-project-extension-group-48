
setPixel:
push { r4 }
push { r3 }
push { r2 }
push { r1 }
add r1, sp, #28
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movge r1, #1
tst r1, r1
beq l9
add r1, sp, #28
ldr r1, [r1]
add r2, sp, #20
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l8
add r1, sp, #32
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movge r1, #1
tst r1, r1
beq l7
add r1, sp, #32
ldr r1, [r1]
add r2, sp, #24
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l6
add r1, sp, #36
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l0
add r1, sp, #36
ldr r2, =0
str r2, [r1]
l0:
add r1, sp, #36
ldr r1, [r1]
ldr r2, =255
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l1
add r1, sp, #36
ldr r2, =255
str r2, [r1]
l1:
add r1, sp, #40
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l2
add r1, sp, #40
ldr r2, =0
str r2, [r1]
l2:
add r1, sp, #40
ldr r1, [r1]
ldr r2, =255
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l3
add r1, sp, #40
ldr r2, =255
str r2, [r1]
l3:
add r1, sp, #44
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l4
add r1, sp, #44
ldr r2, =0
str r2, [r1]
l4:
add r1, sp, #44
ldr r1, [r1]
ldr r2, =255
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l5
add r1, sp, #44
ldr r2, =255
str r2, [r1]
l5:
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #32
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
mul r2, r2, r3
add r3, sp, #28
ldr r3, [r3]
add r2, r2, r3
add r1, r1, r2, lsl #2
add r2, sp, #36
ldr r2, [r2]
add r3, sp, #40
ldr r3, [r3]
ldr r4, =8
mov r3, r3, lsl r4
add r2, r2, r3
add r3, sp, #44
ldr r3, [r3]
ldr r4, =16
mov r3, r3, lsl r4
add r2, r2, r3
str r2, [r1]
l6:
l7:
l8:
l9:
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { r4 }
bx lr


trace:
push { lr }
push { r3 }
push { r2 }
push { r1 }
ldr r1, =1
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #48
ldr r1, [r1]
push { r1 }
bl normalise
mov r1, r0
add sp, sp, #4
l16:
add r1, sp, #8
ldr r1, [r1]
add r2, sp, #32
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l17
sub sp, sp, #12
add r1, sp, #0
push { r1 }
add r1, sp, #52
ldr r1, [r1]
add r2, sp, #24
ldr r2, [r2]
ldr r3, =4
mul r2, r2, r3
add r1, r1, r2
push { r1 }
add r1, sp, #64
ldr r1, [r1]
push { r1 }
bl vsub
mov r1, r0
add sp, sp, #12
ldr r1, =65536
push { r1 }
add r1, sp, #64
ldr r1, [r1]
push { r1 }
add r1, sp, #8
push { r1 }
bl vdot
mov r1, r0
add sp, sp, #8
ldr r2, =1
mov r1, r1, lsl r2
push { r1 }
add r1, sp, #8
push { r1 }
add r1, sp, #12
push { r1 }
bl vdot
mov r1, r0
add sp, sp, #8
ldr r2, =65536
sub r1, r1, r2
push { r1 }
add r1, sp, #4
ldr r1, [r1]
push { r1 }
add r1, sp, #8
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
add r2, sp, #0
ldr r2, [r2]
ldr r3, =2
mov r2, r2, lsl r3
sub r1, r1, r2
push { r1 }
add r1, sp, #0
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movge r1, #1
tst r1, r1
beq l15
add r1, sp, #0
add r2, sp, #0
ldr r2, [r2]
push { r2 }
bl fsqrt
mov r2, r0
add sp, sp, #4
str r2, [r1]
add r1, sp, #8
ldr r1, [r1]
rsb r1, r1, #0
add r2, sp, #0
ldr r2, [r2]
sub r1, r1, r2
ldr r2, =1
mov r1, r1, asr r2
push { r1 }
add r1, sp, #12
ldr r1, [r1]
rsb r1, r1, #0
add r2, sp, #4
ldr r2, [r2]
add r1, r1, r2
ldr r2, =1
mov r1, r1, asr r2
push { r1 }
add r1, sp, #4
ldr r1, [r1]
push { r1 }
add r1, sp, #0
ldr r1, [r1]
ldr r2, =64
cmp r1, r2
mov r1, #0
movle r1, #1
tst r1, r1
beq l10
add r1, sp, #0
add r2, sp, #4
ldr r2, [r2]
str r2, [r1]
l10:
add r1, sp, #0
ldr r1, [r1]
ldr r2, =64
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l14
add r1, sp, #52
ldr r1, [r1]
tst r1, r1
beq l12
add r1, sp, #52
ldr r2, =0
str r2, [r1]
add r1, sp, #44
add r2, sp, #0
ldr r2, [r2]
str r2, [r1]
add r1, sp, #40
add r2, sp, #48
ldr r2, [r2]
str r2, [r1]
b l13
l12:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #44
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l11
add r1, sp, #44
add r2, sp, #0
ldr r2, [r2]
str r2, [r1]
add r1, sp, #40
add r2, sp, #48
ldr r2, [r2]
str r2, [r1]
l11:
l13:
l14:
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
l15:
add r1, sp, #36
add r2, sp, #36
ldr r2, [r2]
ldr r3, =3
add r2, r2, r3
str r2, [r1]
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
add sp, sp, #12
b l16
l17:
add r1, sp, #12
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
moveq r1, #1
tst r1, r1
beq l25
add r1, sp, #52
ldr r1, [r1]
push { r1 }
add r1, sp, #44
ldr r1, [r1]
add r2, sp, #4
ldr r2, [r2]
ldr r3, =4
mul r2, r2, r3
add r1, r1, r2
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl vmul
mov r1, r0
add sp, sp, #12
add r1, sp, #56
ldr r1, [r1]
ldr r2, =8
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l24
add r1, sp, #44
ldr r1, [r1]
push { r1 }
add r1, sp, #48
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
sub sp, sp, #12
add r1, sp, #0
push { r1 }
add r1, sp, #52
ldr r1, [r1]
add r2, sp, #16
ldr r2, [r2]
ldr r3, =4
mul r2, r2, r3
add r1, r1, r2
push { r1 }
add r1, sp, #64
ldr r1, [r1]
push { r1 }
bl vsub
mov r1, r0
add sp, sp, #12
add r1, sp, #0
push { r1 }
bl normalise
mov r1, r0
add sp, sp, #4
add r1, sp, #0
push { r1 }
add r1, sp, #64
ldr r1, [r1]
push { r1 }
bl vdot
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #16
ldr r1, [r1]
ldr r2, =1
and r1, r1, r2
tst r1, r1
beq l22
ldr r1, =65536
add r2, sp, #0
ldr r2, [r2]
push { r2 }
add r2, sp, #4
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
sub r1, r1, r2
push { r1 }
bl fsqrt
mov r1, r0
add sp, sp, #4
push { r1 }
add r1, sp, #4
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l20
ldr r1, =147456
push { r1 }
bl finv
mov r1, r0
add sp, sp, #4
push { r1 }
add r1, sp, #4
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
ldr r1, =65536
add r2, sp, #0
ldr r2, [r2]
push { r2 }
add r2, sp, #4
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
sub r1, r1, r2
push { r1 }
bl fsqrt
mov r1, r0
add sp, sp, #4
push { r1 }
sub sp, sp, #12
add r1, sp, #0
push { r1 }
add r1, sp, #92
ldr r1, [r1]
push { r1 }
add r1, sp, #36
push { r1 }
add r1, sp, #36
ldr r1, [r1]
rsb r1, r1, #0
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add r1, sp, #0
push { r1 }
bl normalise
mov r1, r0
add sp, sp, #4
add r1, sp, #88
ldr r1, [r1]
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #24
ldr r1, [r1]
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
add r1, sp, #88
ldr r1, [r1]
push { r1 }
add r1, sp, #92
ldr r1, [r1]
push { r1 }
add r1, sp, #36
push { r1 }
add r1, sp, #24
ldr r1, [r1]
rsb r1, r1, #0
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add sp, sp, #12
add sp, sp, #4
add sp, sp, #4
b l21
l20:
ldr r1, =147456
push { r1 }
add r1, sp, #4
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #0
ldr r1, [r1]
ldr r2, =65536
cmp r1, r2
mov r1, #0
movle r1, #1
tst r1, r1
beq l18
ldr r1, =65536
add r2, sp, #0
ldr r2, [r2]
push { r2 }
add r2, sp, #4
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
sub r1, r1, r2
push { r1 }
bl fsqrt
mov r1, r0
add sp, sp, #4
push { r1 }
sub sp, sp, #12
add r1, sp, #0
push { r1 }
add r1, sp, #92
ldr r1, [r1]
push { r1 }
add r1, sp, #36
push { r1 }
add r1, sp, #36
ldr r1, [r1]
rsb r1, r1, #0
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add r1, sp, #0
push { r1 }
bl normalise
mov r1, r0
add sp, sp, #4
add r1, sp, #88
ldr r1, [r1]
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #24
ldr r1, [r1]
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
add r1, sp, #88
ldr r1, [r1]
push { r1 }
add r1, sp, #92
ldr r1, [r1]
push { r1 }
add r1, sp, #36
push { r1 }
add r1, sp, #24
ldr r1, [r1]
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add sp, sp, #12
add sp, sp, #4
b l19
l18:
add r1, sp, #12
push { r1 }
add r1, sp, #16
push { r1 }
add r1, sp, #16
ldr r1, [r1]
rsb r1, r1, #0
ldr r2, =1
mov r1, r1, lsl r2
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #16
push { r1 }
add r1, sp, #80
ldr r1, [r1]
push { r1 }
bl vadd
mov r1, r0
add sp, sp, #12
l19:
add sp, sp, #4
l21:
add sp, sp, #4
b l23
l22:
add r1, sp, #4
push { r1 }
add r1, sp, #8
push { r1 }
add r1, sp, #8
ldr r1, [r1]
rsb r1, r1, #0
ldr r2, =1
mov r1, r1, lsl r2
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
add r1, sp, #64
ldr r1, [r1]
push { r1 }
add r1, sp, #8
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
bl vadd
mov r1, r0
add sp, sp, #12
l23:
add r1, sp, #72
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
add r1, sp, #72
ldr r1, [r1]
push { r1 }
bl trace
mov r1, r0
add sp, sp, #28
add sp, sp, #4
add sp, sp, #12
l24:
l25:
add r1, sp, #12
ldr r1, [r1]
tst r1, r1
beq l34
add r1, sp, #48
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l33
add r1, sp, #48
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r1, [r1]
rsb r1, r1, #0
push { r1 }
bl finv
mov r1, r0
add sp, sp, #4
push { r1 }
add r1, sp, #48
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #48
ldr r1, [r1]
push { r1 }
add r1, sp, #52
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add r1, sp, #48
ldr r1, [r1]
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =327680
rsb r2, r2, #0
cmp r1, r2
mov r1, #0
movge r1, #1
tst r1, r1
beq l32
add r1, sp, #48
ldr r1, [r1]
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =327680
cmp r1, r2
mov r1, #0
movle r1, #1
tst r1, r1
beq l31
add r1, sp, #48
ldr r1, [r1]
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =327680
rsb r2, r2, #0
cmp r1, r2
mov r1, #0
movge r1, #1
tst r1, r1
beq l30
add r1, sp, #48
ldr r1, [r1]
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =327680
cmp r1, r2
mov r1, #0
movle r1, #1
tst r1, r1
beq l29
add r1, sp, #16
ldr r2, =0
str r2, [r1]
add r1, sp, #48
ldr r1, [r1]
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =65536
and r1, r1, r2
add r2, sp, #48
ldr r2, [r2]
ldr r3, =2
add r2, r2, r3, lsl #2
ldr r2, [r2]
ldr r3, =65536
and r2, r2, r3
eor r1, r1, r2
tst r1, r1
beq l26
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
ldr r1, =32768
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
b l27
l26:
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
ldr r1, =16384
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
l27:
add r1, sp, #60
ldr r1, [r1]
ldr r2, =8
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l28
add r1, sp, #52
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2, lsl #2
add r2, sp, #52
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3, lsl #2
ldr r2, [r2]
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #60
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl trace
mov r1, r0
add sp, sp, #28
l28:
l29:
l30:
l31:
l32:
add sp, sp, #4
l33:
l34:
add r1, sp, #12
ldr r1, [r1]
tst r1, r1
beq l35
ldr r1, =20480
push { r1 }
add r1, sp, #52
ldr r1, [r1]
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =65536
add r1, r1, r2
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
ldr r2, =12288
add r1, r1, r2
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #8
ldr r1, [r1]
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
add r1, sp, #16
ldr r2, =0
str r2, [r1]
add sp, sp, #4
l35:
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { lr }
bx lr


fsqrt:
push { lr }
push { r3 }
push { r2 }
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #20
ldr r1, [r1]
ldr r2, =0
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l40
ldr r1, =0
push { r1 }
ldr r1, =0
push { r1 }
l36:
add r1, sp, #28
ldr r1, [r1]
ldr r2, =32768
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l37
add r1, sp, #28
add r2, sp, #28
ldr r2, [r2]
ldr r3, =2
mov r2, r2, lsl r3
str r2, [r1]
add r1, sp, #4
add r2, sp, #4
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
b l36
l37:
l38:
add r1, sp, #28
ldr r1, [r1]
ldr r2, =131072
cmp r1, r2
mov r1, #0
movgt r1, #1
tst r1, r1
beq l39
add r1, sp, #28
add r2, sp, #28
ldr r2, [r2]
ldr r3, =2
mov r2, r2, asr r3
str r2, [r1]
add r1, sp, #0
add r2, sp, #0
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
b l38
l39:
add r1, sp, #8
add r2, sp, #28
ldr r2, [r2]
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
add r3, sp, #8
ldr r3, [r3]
push { r3 }
bl finv
mov r3, r0
add sp, sp, #4
push { r3 }
add r3, sp, #32
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
add r2, r2, r3
ldr r3, =1
mov r2, r2, asr r3
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
add r3, sp, #8
ldr r3, [r3]
push { r3 }
bl finv
mov r3, r0
add sp, sp, #4
push { r3 }
add r3, sp, #32
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
add r2, r2, r3
ldr r3, =1
mov r2, r2, asr r3
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
add r3, sp, #8
ldr r3, [r3]
push { r3 }
bl finv
mov r3, r0
add sp, sp, #4
push { r3 }
add r3, sp, #32
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
add r2, r2, r3
ldr r3, =1
mov r2, r2, asr r3
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
add r3, sp, #0
ldr r3, [r3]
mov r2, r2, lsl r3
add r3, sp, #4
ldr r3, [r3]
mov r2, r2, asr r3
str r2, [r1]
add sp, sp, #4
add sp, sp, #4
l40:
add r1, sp, #0
add sp, sp, #4
ldr r1, [r1]
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { lr }
bx lr


normalise:
push { lr }
push { r1 }
add r1, sp, #8
ldr r1, [r1]
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #20
ldr r1, [r1]
push { r1 }
bl vdot
mov r1, r0
add sp, sp, #8
push { r1 }
bl fsqrt
mov r1, r0
add sp, sp, #4
push { r1 }
bl finv
mov r1, r0
add sp, sp, #4
push { r1 }
bl svmul
mov r1, r0
add sp, sp, #12
mov r0, r1
pop { r1 }
pop { lr }
bx lr


testPlot:
push { lr }
push { r3 }
push { r2 }
push { r1 }
add r1, sp, #20
ldr r1, [r1]
ldr r2, =1
mov r1, r1, asr r2
push { r1 }
add r1, sp, #28
ldr r1, [r1]
ldr r2, =1
mov r1, r1, asr r2
push { r1 }
ldr r1, =0
push { r1 }
l47:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #32
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l48
ldr r1, =0
push { r1 }
l45:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #40
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l46
add r1, sp, #8
ldr r1, [r1]
add r2, sp, #0
ldr r2, [r2]
sub r1, r1, r2
ldr r2, =31
and r1, r1, r2
ldr r2, =0
cmp r1, r2
mov r1, #0
moveq r1, #1
tst r1, r1
beq l41
ldr r1, =128
push { r1 }
ldr r1, =128
push { r1 }
ldr r1, =128
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
add r1, sp, #20
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
l41:
add r1, sp, #4
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
sub r1, r1, r2
ldr r2, =31
and r1, r1, r2
ldr r2, =0
cmp r1, r2
mov r1, #0
moveq r1, #1
tst r1, r1
beq l42
ldr r1, =128
push { r1 }
ldr r1, =128
push { r1 }
ldr r1, =128
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
add r1, sp, #20
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
l42:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #8
ldr r2, [r2]
cmp r1, r2
mov r1, #0
moveq r1, #1
tst r1, r1
beq l43
ldr r1, =255
push { r1 }
ldr r1, =255
push { r1 }
ldr r1, =255
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
add r1, sp, #20
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
l43:
add r1, sp, #4
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
cmp r1, r2
mov r1, #0
moveq r1, #1
tst r1, r1
beq l44
ldr r1, =255
push { r1 }
ldr r1, =255
push { r1 }
ldr r1, =255
push { r1 }
add r1, sp, #12
ldr r1, [r1]
push { r1 }
add r1, sp, #20
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
add r1, sp, #60
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
l44:
add r1, sp, #0
add r2, sp, #0
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
b l45
l46:
add r1, sp, #4
add r2, sp, #4
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
add sp, sp, #4
b l47
l48:
add r1, sp, #0
ldr r2, =0
str r2, [r1]
l49:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #32
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l50
ldr r1, =0
push { r1 }
ldr r1, =255
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
sub r2, r2, r3
ldr r3, =11
mov r2, r2, lsl r3
push { r2 }
bl finv
mov r2, r0
add sp, sp, #4
ldr r3, =11
mov r2, r2, asr r3
sub r1, r1, r2
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
ldr r1, =0
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =255
push { r1 }
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
sub r2, r2, r3
ldr r3, =11
mov r2, r2, lsl r3
push { r2 }
bl fsin
mov r2, r0
add sp, sp, #4
ldr r3, =11
mov r2, r2, asr r3
sub r1, r1, r2
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
ldr r1, =255
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
sub r2, r2, r3
ldr r3, =11
mov r2, r2, lsl r3
push { r2 }
bl fcos
mov r2, r0
add sp, sp, #4
ldr r3, =11
mov r2, r2, asr r3
sub r1, r1, r2
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
ldr r1, =255
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =255
push { r1 }
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
sub r2, r2, r3
ldr r3, =11
mov r2, r2, lsl r3
push { r2 }
bl fsqrt
mov r2, r0
add sp, sp, #4
ldr r3, =11
mov r2, r2, asr r3
sub r1, r1, r2
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
ldr r1, =255
push { r1 }
ldr r1, =0
push { r1 }
ldr r1, =255
push { r1 }
add r1, sp, #16
ldr r1, [r1]
add r2, sp, #12
ldr r2, [r2]
add r3, sp, #20
ldr r3, [r3]
sub r2, r2, r3
ldr r3, =11
mov r2, r2, lsl r3
push { r2 }
bl fsqrt
mov r2, r0
add sp, sp, #4
push { r2 }
bl finv
mov r2, r0
add sp, sp, #4
ldr r3, =11
mov r2, r2, asr r3
sub r1, r1, r2
push { r1 }
add r1, sp, #16
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
add r1, sp, #0
add r2, sp, #0
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
b l49
l50:
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { lr }
bx lr


fsin:
push { lr }
push { r3 }
push { r2 }
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #20
ldr r2, =20861
push { r2 }
add r2, sp, #24
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
ldr r3, =32768
add r2, r2, r3
str r2, [r1]
add r1, sp, #20
ldr r1, [r1]
ldr r2, =65536
and r1, r1, r2
tst r1, r1
beq l51
add r1, sp, #0
ldr r2, =1
str r2, [r1]
l51:
add r1, sp, #20
add r2, sp, #20
ldr r2, [r2]
ldr r3, =65535
and r2, r2, r3
str r2, [r1]
add r1, sp, #20
ldr r2, =205887
push { r2 }
add r2, sp, #24
ldr r2, [r2]
ldr r3, =32768
sub r2, r2, r3
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
str r2, [r1]
add r1, sp, #20
ldr r1, [r1]
push { r1 }
add r1, sp, #24
ldr r1, [r1]
push { r1 }
add r1, sp, #28
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #0
ldr r1, [r1]
push { r1 }
add r1, sp, #32
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
ldr r3, =10923
push { r3 }
add r3, sp, #4
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
sub r2, r2, r3
str r2, [r1]
add r1, sp, #0
add r2, sp, #4
ldr r2, [r2]
push { r2 }
add r2, sp, #4
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
ldr r3, =546
push { r3 }
add r3, sp, #4
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
add r2, r2, r3
str r2, [r1]
add r1, sp, #12
ldr r1, [r1]
tst r1, r1
beq l52
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
rsb r2, r2, #0
str r2, [r1]
l52:
add r1, sp, #8
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
ldr r1, [r1]
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { lr }
bx lr


fcos:
push { lr }
push { r3 }
push { r2 }
push { r1 }
ldr r1, =0
push { r1 }
add r1, sp, #20
ldr r2, =20861
push { r2 }
add r2, sp, #24
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
ldr r3, =32768
add r2, r2, r3
str r2, [r1]
add r1, sp, #20
ldr r1, [r1]
ldr r2, =65536
and r1, r1, r2
tst r1, r1
beq l53
add r1, sp, #0
ldr r2, =1
str r2, [r1]
l53:
add r1, sp, #20
add r2, sp, #20
ldr r2, [r2]
ldr r3, =65535
and r2, r2, r3
str r2, [r1]
add r1, sp, #20
ldr r2, =205887
push { r2 }
add r2, sp, #24
ldr r2, [r2]
ldr r3, =32768
sub r2, r2, r3
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
str r2, [r1]
ldr r1, =65536
push { r1 }
add r1, sp, #24
ldr r1, [r1]
push { r1 }
add r1, sp, #28
ldr r1, [r1]
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
add r1, sp, #0
ldr r1, [r1]
push { r1 }
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
ldr r3, =32768
push { r3 }
add r3, sp, #4
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
sub r2, r2, r3
str r2, [r1]
add r1, sp, #0
add r2, sp, #4
ldr r2, [r2]
push { r2 }
add r2, sp, #4
ldr r2, [r2]
push { r2 }
bl fmul
mov r2, r0
add sp, sp, #8
str r2, [r1]
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
ldr r3, =2731
push { r3 }
add r3, sp, #4
ldr r3, [r3]
push { r3 }
bl fmul
mov r3, r0
add sp, sp, #8
add r2, r2, r3
str r2, [r1]
add r1, sp, #12
ldr r1, [r1]
tst r1, r1
beq l54
add r1, sp, #8
add r2, sp, #8
ldr r2, [r2]
rsb r2, r2, #0
str r2, [r1]
l54:
add r1, sp, #8
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
add sp, sp, #4
ldr r1, [r1]
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { lr }
bx lr


main:
push { lr }
push { r4 }
push { r3 }
push { r2 }
push { r1 }
add r1, sp, #28
ldr r1, [r1]
ldr r2, =16
mov r1, r1, lsl r2
ldr r2, =1
mov r1, r1, asr r2
push { r1 }
bl finv
mov r1, r0
add sp, sp, #4
push { r1 }
sub sp, sp, #36
sub sp, sp, #36
add r1, sp, #36
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =98304
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #36
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =71680
str r2, [r1]
add r1, sp, #36
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =98304
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #36
ldr r2, =3
add r1, r1, r2, lsl #2
ldr r2, =98304
str r2, [r1]
add r1, sp, #36
ldr r2, =4
add r1, r1, r2, lsl #2
ldr r2, =71680
str r2, [r1]
add r1, sp, #36
ldr r2, =5
add r1, r1, r2, lsl #2
ldr r2, =32768
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #36
ldr r2, =6
add r1, r1, r2, lsl #2
ldr r2, =65536
str r2, [r1]
add r1, sp, #36
ldr r2, =7
add r1, r1, r2, lsl #2
ldr r2, =71680
str r2, [r1]
add r1, sp, #36
ldr r2, =8
add r1, r1, r2, lsl #2
ldr r2, =196608
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #0
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =32768
str r2, [r1]
add r1, sp, #0
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =45875
str r2, [r1]
add r1, sp, #0
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =65536
str r2, [r1]
add r1, sp, #0
ldr r2, =3
add r1, r1, r2, lsl #2
ldr r2, =65536
str r2, [r1]
add r1, sp, #0
ldr r2, =4
add r1, r1, r2, lsl #2
ldr r2, =45875
str r2, [r1]
add r1, sp, #0
ldr r2, =5
add r1, r1, r2, lsl #2
ldr r2, =32768
str r2, [r1]
add r1, sp, #0
ldr r2, =6
add r1, r1, r2, lsl #2
ldr r2, =45875
str r2, [r1]
add r1, sp, #0
ldr r2, =7
add r1, r1, r2, lsl #2
ldr r2, =65536
str r2, [r1]
add r1, sp, #0
ldr r2, =8
add r1, r1, r2, lsl #2
ldr r2, =32768
str r2, [r1]
sub sp, sp, #12
sub sp, sp, #12
sub sp, sp, #12
add r1, sp, #24
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =65536
str r2, [r1]
add r1, sp, #24
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =0
str r2, [r1]
add r1, sp, #24
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =0
str r2, [r1]
add r1, sp, #12
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =0
str r2, [r1]
add r1, sp, #12
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =16384
rsb r2, r2, #0
push { r2 }
bl fcos
mov r2, r0
add sp, sp, #4
str r2, [r1]
add r1, sp, #12
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =16384
rsb r2, r2, #0
push { r2 }
bl fsin
mov r2, r0
add sp, sp, #4
str r2, [r1]
add r1, sp, #0
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =0
str r2, [r1]
add r1, sp, #0
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =16384
rsb r2, r2, #0
push { r2 }
bl fsin
mov r2, r0
add sp, sp, #4
rsb r2, r2, #0
str r2, [r1]
add r1, sp, #0
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =16384
rsb r2, r2, #0
push { r2 }
bl fcos
mov r2, r0
add sp, sp, #4
str r2, [r1]
ldr r1, =0
push { r1 }
l57:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #140
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l58
ldr r1, =0
push { r1 }
l55:
add r1, sp, #0
ldr r1, [r1]
add r2, sp, #148
ldr r2, [r2]
cmp r1, r2
mov r1, #0
movlt r1, #1
tst r1, r1
beq l56
sub sp, sp, #12
add r1, sp, #0
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r2, =0
str r2, [r1]
add r1, sp, #0
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r2, =163840
str r2, [r1]
add r1, sp, #0
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r2, =196608
str r2, [r1]
sub sp, sp, #12
add r1, sp, #0
ldr r2, =0
add r1, r1, r2, lsl #2
add r2, sp, #0
ldr r3, =1
add r2, r2, r3, lsl #2
add r3, sp, #0
ldr r4, =2
add r3, r3, r4, lsl #2
ldr r4, =0
str r4, [r3]
ldr r3, [r3]
str r3, [r2]
ldr r2, [r2]
str r2, [r1]
add r1, sp, #0
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #64
push { r1 }
add r1, sp, #152
ldr r1, [r1]
push { r1 }
add r1, sp, #44
ldr r1, [r1]
add r2, sp, #184
ldr r2, [r2]
ldr r3, =1
mov r2, r2, asr r3
sub r1, r1, r2
ldr r2, =16
mov r1, r1, lsl r2
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add r1, sp, #0
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #52
push { r1 }
add r1, sp, #152
ldr r1, [r1]
push { r1 }
add r1, sp, #188
ldr r1, [r1]
ldr r2, =1
mov r1, r1, asr r2
add r2, sp, #40
ldr r2, [r2]
sub r1, r1, r2
ldr r2, =16
mov r1, r1, lsl r2
push { r1 }
bl fmul
mov r1, r0
add sp, sp, #8
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
add r1, sp, #0
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #40
push { r1 }
ldr r1, =98304
rsb r1, r1, #0
push { r1 }
bl svmla
mov r1, r0
add sp, sp, #16
sub sp, sp, #12
add r1, sp, #0
ldr r2, =0
add r1, r1, r2, lsl #2
add r2, sp, #0
ldr r3, =1
add r2, r2, r3, lsl #2
add r3, sp, #0
ldr r4, =2
add r3, r3, r4, lsl #2
ldr r4, =98304
str r4, [r3]
ldr r3, [r3]
str r3, [r2]
ldr r2, [r2]
str r2, [r1]
ldr r1, =0
push { r1 }
add r1, sp, #4
push { r1 }
add r1, sp, #20
push { r1 }
add r1, sp, #36
push { r1 }
add r1, sp, #96
push { r1 }
add r1, sp, #136
push { r1 }
ldr r1, =9
push { r1 }
bl trace
mov r1, r0
add sp, sp, #28
add r1, sp, #0
ldr r2, =2
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =8
mov r1, r1, asr r2
push { r1 }
add r1, sp, #4
ldr r2, =1
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =8
mov r1, r1, asr r2
push { r1 }
add r1, sp, #8
ldr r2, =0
add r1, r1, r2, lsl #2
ldr r1, [r1]
ldr r2, =8
mov r1, r1, asr r2
push { r1 }
add r1, sp, #48
ldr r1, [r1]
push { r1 }
add r1, sp, #56
ldr r1, [r1]
push { r1 }
add r1, sp, #204
ldr r1, [r1]
push { r1 }
add r1, sp, #204
ldr r1, [r1]
push { r1 }
add r1, sp, #204
ldr r1, [r1]
push { r1 }
bl setPixel
mov r1, r0
add sp, sp, #32
add r1, sp, #36
add r2, sp, #36
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
add sp, sp, #12
add sp, sp, #12
add sp, sp, #12
b l55
l56:
add r1, sp, #4
add r2, sp, #4
ldr r2, [r2]
ldr r3, =1
add r2, r2, r3
str r2, [r1]
add sp, sp, #4
b l57
l58:
ldr r1, =0
add sp, sp, #4
add sp, sp, #12
add sp, sp, #12
add sp, sp, #12
add sp, sp, #36
add sp, sp, #36
add sp, sp, #4
mov r0, r1
pop { r1 }
pop { r2 }
pop { r3 }
pop { r4 }
pop { lr }
bx lr


