class BigNumber {
  List<int> _digits = [];
  bool _isNegative = false;

  BigNumber() {
    _digits = [0];
  }

  BigNumber.fromString(String number) {
    _digits = [];
    if (number.startsWith('-')) {
      _isNegative = true;
      number = number.substring(1);
    }
    for (int i = 0; i < number.length; i++) {
      _digits.add(int.parse(number[i]));
    }
  }

  BigNumber.fromInt(int number) {
    _digits = [];
    if (number < 0) {
      _isNegative = true;
      number = -number;
    }
    String numStr = number.toString();
    for (int i = 0; i < numStr.length; i++) {
      _digits.add(int.parse(numStr[i]));
    }
  }

  BigNumber.fromList(List<int> digits, {bool isNegative = false}) {
    if (digits.isEmpty) {
      _digits = [0];
      _isNegative = false;
    } else {
      _digits = List.from(digits);
      _isNegative = isNegative;
    }
  }

  BigNumber add(BigNumber other) {
    if (_isNegative == other._isNegative) {
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

      return BigNumber.fromList(result, isNegative: _isNegative);
    } else {
      BigNumber positive = _isNegative ? other : this;
      BigNumber negative = _isNegative ? this : other;
      return positive.subtract(negative.negate());
    }
  }

  BigNumber subtract(BigNumber other) {
    if (_isNegative != other._isNegative) {
      return add(other.negate());
    }

    bool resultNegative = false;
    List<int> num1 = _digits;
    List<int> num2 = other._digits;

    if (_compareMagnitude(other) < 0) {
      resultNegative = !_isNegative;
      num1 = other._digits;
      num2 = _digits;
    }

    List<int> result = [];
    int borrow = 0;
    int len1 = num1.length;
    int len2 = num2.length;

    for (int i = 0; i < len1; i++) {
      int digit1 = num1[len1 - 1 - i];
      int digit2 = i < len2 ? num2[len2 - 1 - i] : 0;

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

    return BigNumber.fromList(result, isNegative: resultNegative);
  }

  BigNumber multiply(BigNumber other) {
    int len1 = _digits.length;
    int len2 = other._digits.length;

    List<int> result = List.generate(len1 + len2, (_) => 0);

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

    return BigNumber.fromList(result,
        isNegative: _isNegative != other._isNegative);
  }

  BigNumber karatsubaMultiply(BigNumber other) {
    int len1 = _digits.length;
    int len2 = other._digits.length;

    if (len1 == 1 || len2 == 1) {
      return multiply(other);
    }

    int maxLength = len1 > len2 ? len1 : len2;
    while (_digits.length < maxLength) _digits.insert(0, 0);
    while (other._digits.length < maxLength) other._digits.insert(0, 0);

    int mid = maxLength ~/ 2;
    List<int> a = _digits.sublist(0, mid);
    List<int> b = _digits.sublist(mid);
    List<int> c = other._digits.sublist(0, mid);
    List<int> d = other._digits.sublist(mid);

    BigNumber A = BigNumber.fromList(a);
    BigNumber B = BigNumber.fromList(b);
    BigNumber C = BigNumber.fromList(c);
    BigNumber D = BigNumber.fromList(d);

    BigNumber ac = A.karatsubaMultiply(C);
    BigNumber bd = B.karatsubaMultiply(D);
    BigNumber ab_cd = (A.add(B)).karatsubaMultiply(C.add(D));
    BigNumber ad_bc = ab_cd.subtract(ac).subtract(bd);

    ac.shift(2 * (maxLength - mid));
    ad_bc.shift(maxLength - mid);

    BigNumber result = ac.add(ad_bc).add(bd);
    result._isNegative = _isNegative != other._isNegative;
    return result;
  }

  BigNumber divide(BigNumber other) {
    if (other.isZero()) {
      throw ArgumentError("Division by zero");
    }

    BigNumber dividend = BigNumber.fromList(_digits, isNegative: false);
    BigNumber divisor = BigNumber.fromList(other._digits, isNegative: false);

    BigNumber quotient = BigNumber.fromInt(0);
    BigNumber remainder = BigNumber.fromInt(0);

    for (int digit in _digits) {
      remainder = remainder.shift(1).add(BigNumber.fromInt(digit));
      int count = 0;
      while (remainder._compareMagnitude(divisor) >= 0) {
        remainder = remainder.subtract(divisor);
        count++;
      }
      quotient = quotient.shift(1).add(BigNumber.fromInt(count));
    }

    quotient._isNegative = _isNegative != other._isNegative;
    return quotient;
  }

  bool isZero() => _digits.length == 1 && _digits[0] == 0;

  BigNumber shift(int positions) {
    if (positions > 0) {
      for (int i = 0; i < positions; i++) {
        _digits.add(0);
      }
    } else if (positions < 0) {
      positions = -positions;
      for (int i = 0; i < positions; i++) {
        if (_digits.length > 1) {
          _digits.removeLast();
        } else {
          _digits[0] = 0;
        }
      }
    }
    return this;
  }

  BigNumber shifted(int positions) {
    BigNumber copy = BigNumber.fromList(_digits, isNegative: _isNegative);
    return copy.shift(positions);
  }

  int _compareMagnitude(BigNumber other) {
    if (_digits.length != other._digits.length) {
      return _digits.length - other._digits.length;
    }
    for (int i = 0; i < _digits.length; i++) {
      if (_digits[i] != other._digits[i]) {
        return _digits[i] - other._digits[i];
      }
    }
    return 0;
  }

  BigNumber negate() {
    return BigNumber.fromList(_digits, isNegative: !_isNegative);
  }

  String toString() {
    String sign = _isNegative ? "-" : "";
    return sign + _digits.join("");
  }
}

void main() {
  BigNumber num1 = BigNumber.fromString("-123456");
  BigNumber num2 = BigNumber.fromString("789");

  print("Number 1: ${num1}");
  print("Number 2: ${num2}");

  BigNumber sum = num1.add(num2);
  print("Addition: ${sum}");

  BigNumber diff = num1.subtract(num2);
  print("Subtraction: ${diff}");

  BigNumber product = num1.karatsubaMultiply(num2);
  print("Karatsuba Multiplication: ${product}");

  BigNumber product2 = num1.multiply(num2);

  print("Multiplication (normal): ${product2}");

  try {
    BigNumber quotient = num1.divide(num2);
    print("Division: ${quotient}");
  } catch (e) {
    print("Division Error: $e");
  }
}
