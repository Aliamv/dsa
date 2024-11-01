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

  @override
  String toString() {
    String result = '';
    for (int i = 0; i < _digits.length; i++) {
      result += _digits[i].toString();
    }
    return result;
  }
}
