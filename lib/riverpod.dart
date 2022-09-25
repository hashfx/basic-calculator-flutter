import 'package:calculator_flutter/model/calculator.dart';
import 'package:calculator_flutter/utils.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator_flutter/model/calculator.dart';

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator> {
  CalculatorNotifier() : super(Calculator());

  // after press '=': input new equation instead of appending to previous equation
  void resetResult() {
    final equation = state.result; // current result and put it to equation

    // update state
    state = state.copy(
      equation: equation,
      shouldAppend: false, // do not append any further characters to equation
    );
  }

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
      } else if (state.shouldAppend) {
        // append to current equation
        return state.equation == '0' ? buttonText : state.equation + buttonText;
      } else {
        // if we don't want char to be appended
        return Utils.isOperator(buttonText) // check if next text is an operator
            ? state.equation +
                buttonText // if operator: append text after equation
            : buttonText; // if !operator: replace while equation with new number
      }
      // } else {
      //   // append current text to new text
      //   // if screen has 0, replace 0 by new text
      //   return state.equation == '0' ? buttonText : state.equation + buttonText;
      // }
      // change equation on input area and override with new value
    }();
    state = state.copy(equation: equation);
  }

  // = button
  void equals() {
    calculate(); // evaluate expression
    resetResult(); // input as new equation instead of appending to previous equation
  }

  // delete text
  void delete() {
    final equation = state.equation; // get equation
    // if equation is empty, no need to delete anything 😄
    if (equation.isNotEmpty) {
      // all text except last character
      final newEquation = equation.substring(0, equation.length - 1);

      if (newEquation.isEmpty) {
        // if there is no number
        reset(); // reset the screen [0 on equation and result]
      } else {
        // update current equation
        state = state.copy(equation: newEquation);
        // update and calculate result along with equation
        calculate();
      }
    }
  }

  void reset() {
    // set equation and result to 0
    final equation = '0';
    final result = '0';
    // new (updated) state object
    state = state.copy(equation: equation, result: result);
  }

  void calculate() {
    // replace (x, ÷) to (*, /)
    final expression = state.equation.replaceAll('x', '*').replaceAll('÷', '/');
    try {
      // parse expression
      final exp = Parser().parse(expression);
      final model = ContextModel();

      // evaluate expression and get result
      final result = '${exp.evaluate(EvaluationType.REAL, model)}';
      // override state of result member from model/calculator.dart to our current state
      state = state.copy(result: result);
    } catch (e) {}
  }
}
