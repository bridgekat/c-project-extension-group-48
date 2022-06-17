// =============
// Test programs
// =============

(define all {

  int func1(int x, int y) {
    int z;
    z = y;
    return z * 0x10000 + x * 0x10;
  }

  int func2(int x, int y) {
    int res = x;
    if (y > x) res = y;
    return y;
  }

  int func3(int n) {
    int a = 1;
    int b = 1;
    while (b <= n) {
      int c = a + b;
      a = b;
      b = c;
    }
    return b;
  }

  void func4(int n, int m) {
    int p = 233;
    int i = 0;
    while (i < n) {
      int j = 0;
      while (j < m) {
        p[i * m + j] = 0;
        j = j + 1;
      }
      i = i + 1;
    }
  }

  void func5(int k, int pvec, int pdst) {
    int arr[4];
    arr[0] = fixed_mul(k, *pvec);
    arr[1] = fixed_mul(k, pvec[1]);
    *(arr + 8) = fixed_mul(k, pvec[2]);
    *(arr + 12) = fixed_mul(k, *(pvec + 12));
    int i = 0;
    pdst[i] = arr[i]; i = i + 1;
    pdst[i] = arr[i]; i = i + 1;
    pdst[i] = arr[i]; i = i + 1;
    pdst[i] = arr[i];
  }

  void func6() {
    int pvec[4];
    pvec[0] = 0x10000;
    pvec[1] = 0x20000;
    pvec[2] = 0x30000;
    pvec[3] = 0x40000;
    func5(0x20000, pvec, 0xF000);
  }

})

[begin
  (debug_save_file "compiled.s" (toString (programIR all)));
  (display "");
  (display "==========================================");
  (display "Compilation succeeded!");
  (display "Assembly has been written to \"compiled.s\".");
  (display "==========================================");
  (display "")]
