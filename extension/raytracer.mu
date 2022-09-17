// =============
// Test programs
// =============

// Macros (simply use the macro system from the base language)
// Some constants, including framebuffer location and size, are hard-coded for better performance...
(add_pattern [NULL'             <_expr 100> ::= (word "NULL")])
(add_pattern [EXIT_SUCCESS'     <_expr 100> ::= (word "EXIT_SUCCESS")])
(add_pattern [EXIT_FAILURE'     <_expr 100> ::= (word "EXIT_FAILURE")])
(add_pattern [PI'               <_expr 100> ::= (word "PI")])
(add_pattern [PI_INV'           <_expr 100> ::= (word "PI_INV")])
(add_pattern [TRACE_DEPTH'      <_expr 100> ::= (word "TRACE_DEPTH")])
(add_pattern [CAMERA_PITCH'     <_expr 100> ::= (word "CAMERA_PITCH")])
(add_pattern [REFRACTIVE_INDEX' <_expr 100> ::= (word "REFRACTIVE_INDEX")])
(define_macro NULL'             [fun (_) => `(Nat 0)])
(define_macro EXIT_SUCCESS'     [fun (_) => `(Nat 0)])
(define_macro EXIT_FAILURE'     [fun (_) => `(Nat 1)])
(define_macro PI'               [fun (_) => `(Nat 205887)]) // 3.1416
(define_macro PI_INV'           [fun (_) => `(Nat 20861)])  // 1 / 3.1416
(define_macro TRACE_DEPTH'      [fun (_) => `(Nat 8)])
(define_macro CAMERA_PITCH'     [fun (_) => `(Minus (Nat 16384))])  // -0.25 (~15 deg)
(define_macro REFRACTIVE_INDEX' [fun (_) => `(Nat 0x24000)])        // 2.25

(define finv {
  // Fixed-point inverse (deprecated in favour of hand-optimised assembly version)
  // Computed using Newton's method with f(r) := 1/r - x
  int finv(int x) {
    int res = 0;
    if (x != 0) {
      int f = 0;
      if (x < 0) { x = -x; f = 1; }
      // Normalisation (for a better initial position)
      int i = 0;
      int j = 0;
      while (x < 0x08000) { x = x << 1; i = i + 1; }
      while (x > 0x10000) { x = x >> 1; j = j + 1; }
      // Iterations
      res = 0x10000;
      res = res + fmul(res, (0x10000 - fmul(x, res)));
      res = res + fmul(res, (0x10000 - fmul(x, res)));
      res = res + fmul(res, (0x10000 - fmul(x, res)));
//    res = res + fmul(res, (0x10000 - fmul(x, res)));
      res = (res << i) >> j;
      if (f) res = -res;
    }
    return res;
  }
})

(define fsin {
  // Fixed-point sine function
  // Computed using Taylor expansion
  int fsin(int x) {
    int f = 0;
    x = fmul(x, PI_INV) + 0x08000;
    if (x & 0x10000) f = 1; // If integer part is odd then flip sign
    x = x & 0x0FFFF; // Preserves fractional part only (i.e. we put original x into +-pi/2)
    x = fmul(x - 0x08000, PI);
    int res = x;
    int x2 = fmul(x, x);
    int curr = fmul(x, x2); res = res - fmul(curr, 10923); // res -= x^3 / 6.0
    curr = fmul(curr, x2);  res = res + fmul(curr, 546);   // res += x^5 / 120.0
//  curr = fmul(curr, x2);  res = res - fmul(curr, 13);    // res -= x^7 / 5040.0
    if (f) res = -res;
    return res;
  }
})

(define fcos {
  // Fixed-point cosine function
  // Computed using Taylor expansion
  int fcos(int x) {
    int f = 0;
    x = fmul(x, PI_INV) + 0x08000;
    if (x & 0x10000) f = 1; // If integer part is odd then flip sign
    x = x & 0x0FFFF; // Preserves fractional part only (i.e. we put original x into +-pi/2)
    x = fmul(x - 0x08000, PI);
    int res = 0x10000;
    int x2 = fmul(x, x);
    int curr = x2;         res = res - fmul(curr, 32768); // res -= x^2 / 2.0
    curr = fmul(curr, x2); res = res + fmul(curr, 2731);  // res += x^4 / 24.0
//  curr = fmul(curr, x2); res = res - fmul(curr, 91);    // res -= x^6 / 720.0
    if (f) res = -res;
    return res;
  }
})

(define fsqrt {
  // Fixed-point square root
  // Computed using Newton's method with f(r) := r^2 - x
  int fsqrt(int x) {
    int res = 0;
    if (x > 0) {
      // Normalisation (for a better initial position)
      int i = 0;
      int j = 0;
      while (x < 0x08000) { x = x << 2; i = i + 1; }
      while (x > 0x20000) { x = x >> 2; j = j + 1; }
      // Iterations
      res = x;
      res = (res + fmul(x, finv(res))) >> 1;
      res = (res + fmul(x, finv(res))) >> 1;
      res = (res + fmul(x, finv(res))) >> 1;
//    res = (res + fmul(x, finv(res))) >> 1;
      res = (res << j) >> i;
    }
    return res;
  }
})

(define normalise {
  // Normalise a 3-component fixed-point vector
  // (Loses precision! Use only if necessary...)
  void normalise(int vec) {
    svmul(finv(fsqrt(vdot(vec, vec))), vec, vec);
  }
})

(define setPixel {
  // Set a pixel to a given colour.
  // Position will be range-checked, colour will be clamped to [0, 256)
  void setPixel(int frame, int width, int height, int x, int y, int r, int g, int b) {
    if (x >= 0) if (x < width) if (y >= 0) if (y < height) {
      if (r < 0) r = 0; if (r > 255) r = 255;
      if (g < 0) g = 0; if (g > 255) g = 255;
      if (b < 0) b = 0; if (b > 255) b = 255;
      frame[y * width + x] = r + (g << 8) + (b << 16);
    }
  }
})

(define testPlot {
  // Test plotting mathematical functions
  void testPlot(int frame, int width, int height) {
    int halfWidth = width >> 1;
    int halfHeight = height >> 1;
    int j = 0;
    while (j < width) {
      int i = 0;
      while (i < height) {
        if ((halfHeight - i) & 0x1F == 0) setPixel(frame, width, height, j, i, 128, 128, 128);
        if ((j - halfWidth) & 0x1F == 0) setPixel(frame, width, height, j, i, 128, 128, 128);
        if (i == halfHeight) setPixel(frame, width, height, j, i, 255, 255, 255);
        if (j == halfWidth) setPixel(frame, width, height, j, i, 255, 255, 255);
        i = i + 1;
      }
      j = j + 1;
    }
    j = 0;
    while (j < width) {
      setPixel(frame, width, height, j, halfHeight - (finv((j - halfWidth) << 11) >> 11), 0, 255, 0);
      setPixel(frame, width, height, j, halfHeight - (fsin((j - halfWidth) << 11) >> 11), 255, 0, 0);
      setPixel(frame, width, height, j, halfHeight - (fcos((j - halfWidth) << 11) >> 11), 0, 0, 255);
      setPixel(frame, width, height, j, halfHeight - (fsqrt((j - halfWidth) << 11) >> 11), 255, 0, 255);
      setPixel(frame, width, height, j, halfHeight - (finv(fsqrt((j - halfWidth) << 11)) >> 11), 255, 0, 255);
      j = j + 1;
    }
  }
})

(define trace {
  // Recursively traces a ray, max depth = `m`
  // Modifies vectors `org` and `dir`
  // Modifies `col` as colour output
  void trace(int n, int centres, int colours, int org, int dir, int col, int m) {
    int f = 1;
    int i = 0;
    int minK = 0;
    int minKi = 0;
    // Detect ray-sphere intersections
    normalise(dir);
    while (i < n) {
      int d[3];
      vsub(org, centres + i * 4, d);
      // Coefficients for a quadratic equation
      int a = 0x10000;                   // a = vdot(dir, dir) = 1.0
      int b = vdot(d, dir) << 1;         // b = 2 * vdot(d, dir)
      int c = vdot(d, d) - 0x10000;      // c = vdot(d, d) - R^2, where R^2 = 1.0
      int delta = fmul(b, b) - (c << 2); // delta = b^2 - 4ac
      if (delta >= 0) {
        delta = fsqrt(delta);
        int k1 = (-b - delta) >> 1;
        int k2 = (-b + delta) >> 1;
        // Mid: k1 < k2
        int k = k1;
        if (k <= 0x00040) k = k2;
        if (k > 0x00040) {
          // Possibly hit object
          if (f) { f = 0; minK = k; minKi = i; }
          else if (k < minK) { minK = k; minKi = i; }
        }
      }
      i = i + 3;
    }
    if (f == 0) {
      // Hit object
      vmul(col, colours + minKi * 4, col);
      if (m < TRACE_DEPTH) {
        // "Reflection/refraction ray"
        svmla(minK, dir, org, org);
        // Surface normal
        int normal[3];
        vsub(org, centres + minKi * 4, normal);
        normalise(normal);
        // Mid: `dir` and `normal` are normalised
        int proj = vdot(dir, normal);
        if (minKi & 1) {
          // `minKi` odd, assuming translucent material
          int s1 = fsqrt(0x10000 - fmul(proj, proj));
          if (proj < 0) {
            // Incoming ray, refraction
            int s2 = fmul(s1, finv(REFRACTIVE_INDEX));
            int c2 = fsqrt(0x10000 - fmul(s2, s2));
            int tangent[3];
            svmla(-proj, normal, dir, tangent);
            normalise(tangent);
            svmul(s2, tangent, dir);
            svmla(-c2, normal, dir, dir);
          } else {
            // Outgoing ray
            int s2 = fmul(s1, REFRACTIVE_INDEX);
            if (s2 <= 0x10000) {
              // Refraction
              int c2 = fsqrt(0x10000 - fmul(s2, s2));
              int tangent[3];
              svmla(-proj, normal, dir, tangent);
              normalise(tangent);
              svmul(s2, tangent, dir);
              svmla(c2, normal, dir, dir);
            } else {
              // Internal reflection
              svmul((-proj) << 1, normal, normal);
              vadd(dir, normal, dir);
            }
          }
        } else {
          // `minKi` even, assuming reflective material
          svmul((-proj) << 1, normal, normal);
          vadd(dir, normal, dir);
        }
        // Mid: `dir` is normalised
        trace(n, centres, colours, org, dir, col, m + 1);
      }
    }
    if (f) if (dir[1] < 0) {
      // Ground could never be "in front of" any object, so we test it separately
      int k = fmul(org[1], finv(-dir[1]));
      svmla(k, dir, org, org);
      if (org[0] >= -0x50000) if (org[0] <= 0x50000)
        if (org[2] >= -0x50000) if (org[2] <= 0x50000) {
          // Hit ground
          f = 0;
          if ((org[0] & 0x10000) ^ (org[2] & 0x10000)) svmul(0x08000, col, col);
          else svmul(0x04000, col, col);
          if (m < TRACE_DEPTH) {
            // "Reflection ray"
            dir[1] = -dir[1];
            trace(n, centres, colours, org, dir, col, m + 1);
          }
        }
    }
    if (f) {
      // No hit, return sky colour
      int k = fmul(dir[1] + 0x10000, 0x05000) + 0x03000;
      svmul(k, col, col);
      f = 0;
    }
  }
})

(define main {
  // Main drawing subroutine
  int main(int frame, int width, int height) {
    ///*
    int invHalfHeight = finv((height << 16) >> 1);
    // Set up scene
    int centres[9];
    int colours[9];
    centres[0] = -0x18000; // -1.5
    centres[1] =  0x11800; //  1.1
    centres[2] = -0x18000; // -1.5
    centres[3] =  0x18000; //  1.5
    centres[4] =  0x11800; //  1.1
    centres[5] = -0x08000; // -0.5
    centres[6] =  0x10000; //  1.0
    centres[7] =  0x11800; //  1.1
    centres[8] = -0x30000; // -3.0
    colours[0] = 32768; // 0.5
    colours[1] = 45875; // 0.7
    colours[2] = 65536; // 1.0
    colours[3] = 65536; // 1.0
    colours[4] = 45875; // 0.7
    colours[5] = 32768; // 0.5
    colours[6] = 45875; // 0.7
    colours[7] = 65536; // 1.0
    colours[8] = 32768; // 0.5
    // Set up camera
    int cx[3];
    int cy[3];
    int cz[3];
    cx[0] =  0x10000;
    cx[1] =  0x00000;
    cx[2] =  0x00000;
    cy[0] =  0x00000;
    cy[1] =  fcos(CAMERA_PITCH);
    cy[2] =  fsin(CAMERA_PITCH);
    cz[0] =  0x00000;
    cz[1] = -fsin(CAMERA_PITCH);
    cz[2] =  fcos(CAMERA_PITCH);
    // RTX ON! (just kidding, this being only 1 sample per pixel...)
    int j = 0;
    while (j < width) {
      int i = 0;
      while (i < height) {
        // Ray origin
        int org[3];
        org[0] = 0x00000; // 0.0
        org[1] = 0x28000; // 2.5
        org[2] = 0x30000; // 3.0
        // Ray direction
        int dir[3];
        dir[0] = dir[1] = dir[2] = 0x00000;
        svmla(fmul((j - (width >> 1)) << 16, invHalfHeight), cx, dir, dir);
        svmla(fmul(((height >> 1) - i) << 16, invHalfHeight), cy, dir, dir);
        svmla(-0x18000, cz, dir, dir);
        // Trace and set pixel colour
        int col[3];
        col[0] = col[1] = col[2] = 0x18000; // 1.5
        trace(9, centres, colours, org, dir, col, 0);
        setPixel(frame, width, height, j, i, col[0] >> 8, col[1] >> 8, col[2] >> 8);
        i = i + 1;
      }
      j = j + 1;
    }
    //*/
//  testPlot(frame, width, height);
    return EXIT_SUCCESS;
  }
})

(define all "")
[begin
  all = all .++ (toString (programIR setPixel));
  all = all .++ (toString (programIR trace));
  // all = all .++ (toString (programIR finv)); // Deprecated
  all = all .++ (toString (programIR fsqrt));
  all = all .++ (toString (programIR normalise));
  all = all .++ (toString (programIR testPlot));
  all = all .++ (toString (programIR fsin));
  all = all .++ (toString (programIR fcos));
  all = all .++ (toString (programIR main));
  (debug_save_file "raytracer.s" all);
  (display "");
  (display "==========================================");
  (display "Compilation succeeded!");
  (display "Assembly has been written to \"raytracer.s\".");
  (display "==========================================");
  (display "")]
