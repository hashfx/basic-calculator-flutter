import 'package:calculator_flutter/model/calculator.dart';
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
      // append current text to new text
      // if screen has 0, replace 0 by new text
      return state.equation == '0' ? buttonText : state.equation + buttonText;
    }();
    // change equation on input area and override with new value
    state = state.copy(equation: equation);
  }
}
