//1
// int divide(int a, int b) {
//   if (a < b) {
//     return 0;
//   }
//   return 1 + divide(a - b, b);
// }

//2
// double averageArray(List<int> array, int n) {
//   if (n == 0) {
//     return 0;
//   }
//   return (array[n - 1] + averageArray(array, n - 1) * (n - 1)) / n;
// }

// void main() {
//   List<int> array = [1, 2, 3, 4, 5];
//   int n = array.length;
//   print("Average: ${averageArray(array, n)}");
// }
//3
// List<int> reverseArray(List<int> array, int n) {
//   if (n == 0) {
//     return [];
//   }
//   return [array[n - 1]] + reverseArray(array, n - 1);
// }

//4
// String binaryMaker(int n) {
//   if (n < 2) {
//     return n.toString();
//   }
//   return binaryMaker(n ~/ 2) + (n % 2).toString();
// }

//5

// int Max(List<int> array, int n) {
//   if (n == 1) {
//     return array[0];
//   }

//   int maxOfRest = Max(array, n - 1);

//   return (array[n - 1] > maxOfRest) ? array[n - 1] : maxOfRest;
// }

//6

// int multiply(int a, int b) {
//   if (b == 0) {
//     return 0;
//   }
//   return a + multiply(a, b - 1);
// }

//7

// int GCD(int a, int b) {
//   if (b > a) GCD(b, a);
//   if (b == 0) return a;
//   return GCD(b, a % b);
// }

//8

//9

// double SumFact(int n) {
//   if (n == 1)
//     return 1;
//   else {
//     return fact(n) + SumFact(n - 1);
//   }
// }

// double fact(int n) {
//   if (n == 0 || n == 1)
//     return 1;
//   else {
//     return n * fact(n - 1);
//   }
// }

//10

// double SumSeries(int n) {
//   if (n == 1) {
//     return 1.0;
//   } else {
//     return 1 / fact(n) + SumSeries(n - 1);
//   }
// }

// double fact(int n) {
//   if (n == 0 || n == 1) {
//     return 1;
//   } else {
//     return n * fact(n - 1);
//   }
// }

//11
//12

//13
// void hanoi(int n, String s, String d, String a) {
//   if (n == 1) {
//     print('$s -> $d');
//   } else {
//     hanoi(n - 1, s, a, d);
//     print('$s -> $d');
//     hanoi(n - 1, a, d, s);
//   }
// }

//14

// void hanoi(int n, String s, String d, String a) {
//   if (n == 1) {
//     print('$s -> $a');
//     print('$a -> $d');
//   } else {
//     hanoi(n - 1, s, d, a);
//     print('$s -> $a');
//     hanoi(n - 1, d, s, a);
//     print('$a -> $d');
//     hanoi(n - 1, s, d, a);
//   }
// }

//15

// void Queen(List<int> loc, int num) {
//   if (num == 8) {
//     for (int i = 0; i < 8; i++) {
//       print(loc[i].toString() + (i == 7 ? '---' : ''));
//     }
//   } else {
//     for (int i = 0; i < 8; i++) {
//       bool isFound = true;
//       for (int j = 0; j < num; j++) {
//         if (i == loc[j] || i == loc[j] - num || i == loc[j] + num) {
//           isFound = false;
//           break;
//         }
//       }
//       if (isFound) {
//         loc[num] = i;
//         Queen(loc, num + 1);
//       }
//     }
//   }
// }

//16

// void sub(List<int> data, int i, String result) {
//   print(result);

//   if (data.length != i) {
//     sub(data, i + 1, result);
//     sub(data, i + 1,
//         result + (result.isNotEmpty ? ',' : '') + data[i].toString());
//   }
// }

//17
//18,19
// bool hasDuplicate(String str, int index) {
//   if (index == str.length) {
//     return false;
//   }

//   for (int j = index + 1; j < str.length; j++) {
//     if (str[index] == str[j]) {
//       return true;
//     }
//   }

//   return hasDuplicate(str, index + 1);
// }

//20

// ACK(0,x) = x+1 ,, ACK(1,x) = ACK(1,x-1)+1 = ACK(1, x-x) = x+2

// ACK(2,x) = ACK(1,ACK(2,x-1)) = ACK(2,x-1) + 2 = ACK(2,x-x) + 2x = 2x+3

// ACK(3,2) = ACK(2,ACK(3,1)) = 2ACK(3,1) +3 = 2ACK(2,ACK(3,0)) + 3 = 4ACK(3,0) +9 = 4ACK(2,1) +9 = 29;;;