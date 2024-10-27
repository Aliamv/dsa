//1
// int fibonacci(int n) {
//   if (n <= 0) {
//     throw ArgumentError("Position must be a positive integer.");
//   }

//   if (n == 1 || n == 2) {
//     return 1;
//   }

//   List<int> fib = List.filled(n, 0);
//   fib[0] = 1;
//   fib[1] = 1;

//   for (int i = 2; i < n; i++) {
//     fib[i] = fib[i - 1] + fib[i - 2];
//   }

//   return fib[n - 1];
// }

//2

// int combination(int n, int r) {
//   if (r > n - r) {
//     r = n - r;
//   }

//   List<int> C = List.filled(r + 1, 0);
//   C[0] = 1;

//   for (int i = 1; i <= n; i++) {
//     for (int j = (r < i ? r : i); j > 0; j--) {
//       C[j] += C[j - 1];
//     }
//   }

//   return C[r];
// }

//3 

// 1. دنباله فیبوناچی

// روش بدون بازگشت (آرایه)
// - Time Complexity: O(n) چون فقط یک for loop از 2 تا n داریم و هر مقدار یک بار محاسبه و ذخیره می‌شود.

// روش بازگشتی (Recursive)
// - Time Complexity: O(2^n) به دلیل محاسبات تکراری زیاد که با تعداد n به صورت نمایی افزایش می‌یابد.


// 2. ترکیب (C(n, r))

// روش بدون بازگشت (آرایه)
// - Time Complexity: O(n * r) به دلیل حلقه‌های تو در تو (حلقه بیرونی به تعداد n و حلقه داخلی تا r).

// روش بازگشتی (Recursive)
// - Time Complexity: O(2^r) چون هر فراخوانی دو فراخوانی بازگشتی جدید ایجاد می‌کند.

//4

// BigInt fact(int n) {
//   if (n < 0) {
//     throw ArgumentError("عدد باید مثبت باشد.");
//   }

//   BigInt result = BigInt.one;

//   for (int i = 1; i <= n; i++) {
//     result *= BigInt.from(i);
//   }

//   return result;
// }

//5 

// void changeValue(List<List<int>> a, int n) {
//   for (int i = 0; i < n; i++) {
//     for (int j = 0; j < n; j++) {
//       if (i == j) {
//         a[i][j] += 1;
//       }

//       if (i + j == n - 1) {
//         a[i][j] -= 1;
//       }

//       if (i < j) {
//         a[i][j] += 2;
//       }

//       if (i > j) {
//         a[i][j] -= 2;
//       }

//       if (j < i) {
//         a[i][j] += 3;
//       }

//       if (j > i) {
//         a[i][j] -= 3;
//       }
//     }
//   }
// }



