class Calculator {
  final bool shouldAppend;
  // parameters
  final String equation;
  final String result;

  const Calculator({
    // default values
    this.shouldAppend = true,
    this.equation = '0',
    this.result = '0',
  });

  // second instance of Calculator to modify fields
  Calculator copy({
    bool? shouldAppend,
    String? equation,
    String? result,
  }) =>
      Calculator(
        shouldAppend: shouldAppend ?? this.shouldAppend,
        equation: equation ?? this.equation,
        result: result ?? this.result,
      );
}
