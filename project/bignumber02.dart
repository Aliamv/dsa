class BigNumber {
  List<int> _digits = [];

  BigNumber() {
    _digits = [0];
  }

  BigNumber.fromString(String number) {
    _digits = [];
    for (int i = 0; i < number.length; i++) {
      _digits.add(int.parse(number[i]));
    }
  }

  BigNumber.fromInt(int number) {
    _digits = [];
    String numStr = number.toString();
    for (int i = 0; i < numStr.length; i++) {
      _digits.add(int.parse(numStr[i]));
    }
  }

  BigNumber.fromList(List<int> digits) {
    if (digits.isEmpty) {
      _digits = [0];
    } else {
      _digits = List.from(digits);
    }
  }

  BigNumber add(BigNumber other) {
    List<int> result = [];
    int carry = 0;
    int len1 = _digits.length;
    int len2 = other._digits.length;
    int maxLength = len1 > len2 ? len1 : len2;

    for (int i = 0; i < maxLength; i++) {
      int digit1 = i < len1 ? _digits[len1 - 1 - i] : 0;
      int digit2 = i < len2 ? other._digits[len2 - 1 - i] : 0;

      int sum = digit1 + digit2 + carry;
      result.insert(0, sum % 10);
      carry = sum ~/ 10;
    }

    if (carry > 0) {
      result.insert(0, carry);
    }

    return BigNumber.fromList(result);
  }

  BigNumber subtract(BigNumber other) {
    List<int> result = [];
    int borrow = 0;
    int len1 = _digits.length;
    int len2 = other._digits.length;

    for (int i = 0; i < len1; i++) {
      int digit1 = _digits[len1 - 1 - i];
      int digit2 = i < len2 ? other._digits[len2 - 1 - i] : 0;

      int diff = digit1 - digit2 - borrow;
      if (diff < 0) {
        diff += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
      result.insert(0, diff);
    }

    while (result.length > 1 && result[0] == 0) {
      result.removeAt(0);
    }

    return BigNumber.fromList(result);
  }

  BigNumber shift(int positions) {
    if (positions > 0) {
      for (int i = 0; i < positions; i++) {
        _digits.add(0);
      }
    } else if (positions < 0) {
      positions = -positions;
      for (int i = 0; i < positions && _digits.length > 1; i++) {
        _digits.removeLast();
      }
    }
    return this;
  }

  String toString() {
    String result = '';
    for (int i = 0; i < _digits.length; i++) {
      result += _digits[i].toString();
    }
    return result;
  }

  BigNumber multiply(BigNumber other) {
    int len1 = _digits.length;
    int len2 = other._digits.length;
    List<int> result = List.filled(len1 + len2, 0).toList();

    for (int i = len1 - 1; i >= 0; i--) {
      for (int j = len2 - 1; j >= 0; j--) {
        int product = _digits[i] * other._digits[j];
        int sum = result[i + j + 1] + product;
        result[i + j + 1] = sum % 10;
        result[i + j] += sum ~/ 10;
      }
    }

    while (result.length > 1 && result[0] == 0) {
      result.removeAt(0);
    }

    return BigNumber.fromList(result);
  }

  BigNumber karatsubaMultiply(BigNumber other) {
    int len1 = _digits.length;
    int len2 = other._digits.length;

    if (len1 == 1 || len2 == 1) {
      return multiply(other);
    }

    int mid = len1 ~/ 2;
    List<int> a = _digits.sublist(0, mid);
    List<int> b = _digits.sublist(mid);
    List<int> c = other._digits.sublist(0, len2 ~/ 2);
    List<int> d = other._digits.sublist(len2 ~/ 2);

    BigNumber A = BigNumber.fromList(a);
    BigNumber B = BigNumber.fromList(b);
    BigNumber C = BigNumber.fromList(c);
    BigNumber D = BigNumber.fromList(d);

    BigNumber ac = A.karatsubaMultiply(C);
    BigNumber bd = B.karatsubaMultiply(D);
    BigNumber ab_cd = (A.add(B)).karatsubaMultiply(C.add(D));
    BigNumber ad_bc = ab_cd.subtract(ac).subtract(bd);

    ac.shift(2 * (len1 - mid));
    ad_bc.shift(len1 - mid);
    return ac.add(ad_bc).add(bd);
  }

  BigNumber power(int exponent) {
    if (exponent == 0) {
      return BigNumber.fromInt(1);
    }
    if (exponent == 1) {
      return this;
    }

    BigNumber halfPower = power(exponent ~/ 2);

    if (exponent % 2 == 0) {
      return halfPower.multiply(halfPower);
    } else {
      return halfPower.multiply(halfPower).multiply(this);
    }
  }

  static BigNumber factorial(int n) {
    BigNumber result = BigNumber.fromInt(1);
    for (int i = 2; i <= n; i++) {
      result = result.multiply(BigNumber.fromInt(i));
    }
    return result;
  }
}

void main() {
  BigNumber num1 = BigNumber.fromString("12345");
  BigNumber num2 = BigNumber.fromString("6789");
  BigNumber result = num1.multiply(num2);
  print("Multiplication Result: ${result.toString()}");

  BigNumber num3 = BigNumber.fromString("12345");
  BigNumber num4 = BigNumber.fromString("6789");
  BigNumber karatsubaResult = num3.karatsubaMultiply(num4);
  print("Karatsuba Multiplication Result: ${karatsubaResult.toString()}");

  BigNumber num5 = BigNumber.fromString("2");
  BigNumber powerResult = num5.power(10);
  print("Power Result (2^10): ${powerResult.toString()}");

  BigNumber factorialResult = BigNumber.factorial(100);
  print("Factorial Result (100!): ${factorialResult.toString()}");
}
