import 'dart:io';

class Stack<T> {
  final List<T> _stack = [];

  void push(T value) => _stack.add(value);

  T pop() {
    if (_stack.isEmpty) throw Exception("Stack underflow");
    return _stack.removeLast();
  }

  T top() {
    if (_stack.isEmpty) throw Exception("Stack is empty");
    return _stack.last;
  }

  bool get isEmpty => _stack.isEmpty;
  bool get isNotEmpty => _stack.isNotEmpty;
}

int precedence(String op) {
  if (op == '+' || op == '-') return 1;
  if (op == '*' || op == '/') return 2;
  return 0;
}

bool isOperator(String token) {
  return ['+', '-', '*', '/'].contains(token);
}

List<String> tokenize(String expr) {
  List<String> tokens = [];
  String current = "";

  for (int i = 0; i < expr.length; i++) {
    String char = expr[i];

    if (char == ' ') continue;

    if (isOperator(char) || char == '(' || char == ')') {
      if (current.isNotEmpty) {
        tokens.add(current);
        current = "";
      }
      tokens.add(char);
    } else if (char.contains(RegExp(r'[a-zA-Z0-9]'))) {
      current += char;
    }
  }

  if (current.isNotEmpty) {
    tokens.add(current);
  }

  return tokens;
}

String infixToPostfix(String expr) {
  List<String> output = [];
  Stack<String> operators = Stack<String>();

  List<String> tokens = tokenize(expr);

  for (var token in tokens) {
    if (RegExp(r'^\d+$').hasMatch(token) || RegExp(r'^[a-zA-Z]+$').hasMatch(token)) {
      output.add(token);
    } else if (token == '(') {
      operators.push(token);
    } else if (token == ')') {
      while (operators.isNotEmpty && operators.top() != '(') {
        output.add(operators.pop());
      }
      operators.pop();
    } else if (isOperator(token)) {
      while (operators.isNotEmpty &&
          precedence(operators.top()) >= precedence(token)) {
        output.add(operators.pop());
      }
      operators.push(token);
    }
  }

 
  while (operators.isNotEmpty) {
    output.add(operators.pop());
  }

  return output.join(' ');
}

String infixToPrefix(String expr) {
  String reversed = expr.split('').reversed.join();
  reversed = reversed.replaceAll('(', '#').replaceAll(')', '(').replaceAll('#', ')');
  String postfix = infixToPostfix(reversed);
  return postfix.split(' ').reversed.join(' ');
}

int evaluatePostfix(String postfix, Map<String, int> variableValues) {
  Stack<int> stack = Stack<int>();
  List<String> tokens = postfix.split(' ');

  for (var token in tokens) {
    if (RegExp(r'^\d+$').hasMatch(token)) {
      stack.push(int.parse(token));
    } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(token)) {
      if (!variableValues.containsKey(token)) {
        throw Exception("Variable '$token' has no assigned value.");
      }
      stack.push(variableValues[token]!);
    } else if (isOperator(token)) {
      int b = stack.pop();
      int a = stack.pop();
      switch (token) {
        case '+':
          stack.push(a + b);
          break;
        case '-':
          stack.push(a - b);
          break;
        case '*':
          stack.push(a * b);
          break;
        case '/':
          stack.push(a ~/ b);
          break;
      }
    }
  }

  return stack.pop();
}

void main() {
  print("Enter an infix expression (e.g., 3 + 5 * (x - y)):");

  String infixExpression = stdin.readLineSync()!;

  String postfix = infixToPostfix(infixExpression);
  String prefix = infixToPrefix(infixExpression);

  print("Infix Expression: $infixExpression");
  print("Postfix Expression: $postfix");
  print("Prefix Expression: $prefix");

  List<String> variables = tokenize(infixExpression)
      .where((token) => token.contains(RegExp(r'^[a-zA-Z]+$')))
      .toList();

  if (variables.isNotEmpty) {
    print("The expression contains variables: ${variables.join(', ')}");
    Map<String, int> variableValues = {};

    for (var variable in variables) {
      print("Enter the value for $variable:");
      variableValues[variable] = int.parse(stdin.readLineSync()!);
    }

    try {
      int result = evaluatePostfix(postfix, variableValues);
      print("Result: $result");
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  } else {
    try {
      int result = evaluatePostfix(postfix, {});
      print("Result: $result");
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }
}
