;; # Test program (a simple ray tracer)

;; Calling convention: last argument pushed first (i.e. on the highest address), caller clean-up,
;; r1-r12 and lr are "callee-saved registers" (i.e. their values are preserved by all functions).

;; Fixed-point format: 1 bit sign + 15 bit integer part + 16 bit fractional part.
;; Fixed-point addition and subtraction are the same as signed integers.

__entry:

  ;; The following arguments must be provided through the stack:
  ;; [sp+0]: pointer (unsigned 32-bit integer representing a memory location in bytes) to the framebuffer;
  ;; [sp+4]: width of the framebuffer, in pixels;
  ;; [sp+8]: height of the framebuffer, in pixels;
  ;; ... either before the program starts, or alternatively, use hard-coded values like:

  ;ldr sp, =524288
  ;ldr r0, =524288
  ;ldr r1, =640
  ;ldr r2, =480
  ;push { r0, r1, r2 }

  ;; Call the main routine defined in "raytracer.s". It will receive the arguments described above.
  bl main
  ;; Halt
  andeq r0, r0, r0

;; Hand-optimised fixed-point arithmetic routines
;include "fixed_fast.s"
include "fixed_precise.s"

;; Compiled routines
include "raytracer.s"
