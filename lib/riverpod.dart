import 'package:calculator_flutter/model/calculator.dart';
import 'package:calculator_flutter/utils.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator_flutter/model/calculator.dart';

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator> {
  CalculatorNotifier() : super(Calculator());

  // executes every time user click buttons
  void append(String buttonText) {
    // get equation
    final equation = () {
      // allow only one operator input
      if (Utils.isOperator(buttonText) &&
          Utils.isOperatorAtEnd(state.equation)) {
        // newEquation as old equation except last character which is an operator
        final newEquation =
            state.equation.substring(0, state.equation.length - 1);

        return newEquation + buttonText;
      } else {}

      // append current text to new text
      // if screen has 0, replace 0 by new text
      return state.equation == '0' ? buttonText : state.equation + buttonText;
    }();
    // change equation on input area and override with new value
    state = state.copy(equation: equation);
  }

  // = button
  void equals() {
    calculate();
  }

  void calculate() {
    // replace (x, ÷) to (*, /)
    final expression = state.equation.replaceAll('x', '*').replaceAll('÷', '/');
    // parse expression
    final exp = Parser().parse(expression);
    final model = ContextModel();

    // evaluate expression and get result
    final result = '${exp.evaluate(EvaluationType.REAL, model)}';
  }
}
