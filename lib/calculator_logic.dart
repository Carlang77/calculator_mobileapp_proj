// import 'package:flutter/material.dart';
// import 'package:expressions/expressions.dart';
// import 'database_helper.dart';

// class CalculatorLogic {
//   String currentExpression = "";

//   void appendValue(String value) {
//     currentExpression += value;
//   }

//   void clearAll() {
//     currentExpression = "";
//   }

//   void delete() {
//     if (currentExpression.isNotEmpty) {
//       currentExpression =
//           currentExpression.substring(0, currentExpression.length - 1);
//     }
//   }

//   String performCalculation() {
//     try {
//       final exp = Expression.parse(currentExpression);
//       const evaluator = const ExpressionEvaluator();
//       var result = evaluator.eval(exp, {});

//       storeResultInHistory(currentExpression, result);

//       return formatResult(result);
//     } catch (e) {
//       return "Error";
//     }
//   }

//   void storeResultInHistory(String expression, num result) {
//     final now = DateTime.now();
//     final timestamp =
//         "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
//     final historyItem = {
//       DatabaseHelper.columnCalculation: "$expression = $result",
//       DatabaseHelper.columnTimestamp: timestamp
//     };

//     print("Storing in history: $historyItem"); // Debug print
//     DatabaseHelper.instance.insert(historyItem);
//   }

//   String formatResult(num result) {
//     if (result.abs() < 1000000) {
//       return result
//           .toStringAsFixed(2)
//           .replaceAll(RegExp(r"\.0*$"), ""); // Updated regular expression
//     } else {
//       return result.toStringAsExponential(2);
//     }
//   }
// }
