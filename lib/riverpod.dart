import 'package:calculator_flutter/model/calculator.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator_flutter/model/calculator.dart';

final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator> {
  CalculatorNotifier() : super(Calculator());
}
