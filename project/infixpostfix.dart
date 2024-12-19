import 'dart:io';
import 'dart:math';

class ExpressionConverter {
  bool isOperator(String c) {
    return c == '+' || c == '-' || c == '*' || c == '/' || c == '^';
  }

  bool isOperand(String c) {
    return RegExp(r'^[a-zA-Z0-9]').hasMatch(c);
  }

  int precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    if (op == '^') return 3;
    return 0;
  }

  String infixToPostfix(String infix) {
    List<String> stack = [];
    String postfix = '';
    for (int i = 0; i < infix.length; i++) {
      String c = infix[i];

      if (c == ' ') continue;

      if (c == '-' && (i == 0 || infix[i - 1] == '(')) {
        postfix += '~';
        continue;
      }

      if (isOperand(c)) {
        postfix += c;
      } else if (c == '(') {
        stack.add(c);
      } else if (c == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          postfix += stack.removeLast();
        }
        stack.removeLast();
      } else if (isOperator(c)) {
        while (stack.isNotEmpty &&
            precedence(stack.last) >= precedence(c) &&
            stack.last != '(') {
          postfix += stack.removeLast();
        }
        stack.add(c);
      }
    }

    while (stack.isNotEmpty) {
      postfix += stack.removeLast();
    }

    return postfix;
  }

  // String infixToPrefix(String infix) {
  //   String reversed = infix.split('').reversed.join();
  //   reversed =
  //       reversed.replaceAll('(', '#').replaceAll(')', '(').replaceAll('#', ')');
  //   String reversedPostfix = infixToPostfix(reversed);
  //   return reversedPostfix.split('').reversed.join();
  // }
  String infixToPrefix(String infix) {
    List<String> stack = [];
    List<String> output = [];

    for (int i = infix.length - 1; i >= 0; i--) {
      String c = infix[i];

      if (c == ' ') continue;

      if (c == '-' && (i == 0 || infix[i - 1] == ')')) {
        output.add('~');
        continue;
      }

      if (isOperand(c)) {
        output.add(c);
      } else if (c == ')') {
        stack.add(c);
      } else if (c == '(') {
        while (stack.isNotEmpty && stack.last != ')') {
          output.add(stack.removeLast());
        }
        stack.removeLast();
      } else if (isOperator(c)) {
        while (stack.isNotEmpty &&
            precedence(stack.last) > precedence(c) &&
            stack.last != ')') {
          output.add(stack.removeLast());
        }
        stack.add(c);
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return output.reversed.join();
  }


  num evaluatePostfix(String postfix) {
    List<num> stack = [];
    for (int i = 0; i < postfix.length; i++) {
      String c = postfix[i];

      if (isOperand(c)) {
        stack.add(num.parse(c));
      } else if (c == '~') {
        stack.add(-stack.removeLast());
      } else if (isOperator(c)) {
        num b = stack.removeLast();
        num a = stack.removeLast();
        switch (c) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
          case '^':
            stack.add(pow(a, b));
            break;
        }
      }
    }
    return stack.last;
  }
}

void main() {
  ExpressionConverter converter = ExpressionConverter();

  print('Enter the infix expression:');
  String infix = stdin.readLineSync()!.replaceAll(' ', '');

  bool hasVariables = infix.contains(RegExp(r'[a-zA-Z]'));

  try {
    String postfix = converter.infixToPostfix(infix);
    String prefix = converter.infixToPrefix(infix);

    print('Postfix: $postfix');
    print('Prefix: $prefix');

    if (!hasVariables) {
      num result = converter.evaluatePostfix(postfix);
      print('Result: $result');
    }
  } catch (e) {
    print('Error processing the expression: $e');
  }
}
