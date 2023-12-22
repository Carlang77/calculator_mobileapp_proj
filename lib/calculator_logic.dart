import 'package:flutter/material.dart';
import 'converter_screen.dart';
import 'database_helper.dart';

import 'button_value.dart';

class CalculatorLogic {
  String input1 = "";
  String operation = "";
  String input2 = "";

  void onBtnTap(String btnValue) {
    if (btnValue == Btn.del) {
      delete();
    } else if (btnValue == Btn.clr) {
      clearAll();
    } else if (btnValue == Btn.per) {
      convertToPercentage();
    } else if (btnValue == Btn.calculate) {
      performCalculation();
    } else {
      appendValue(btnValue);
    }
  }

  void appendValue(String btnValue) {
    if (btnValue != Btn.dot && int.tryParse(btnValue) == null) {
      if (operation.isNotEmpty && input2.isNotEmpty) {
        performCalculation();
      }
      operation = btnValue;
    } else if (input1.isEmpty || operation.isEmpty) {
      if (btnValue == Btn.dot && input1.contains(Btn.dot)) return;
      if (btnValue == Btn.dot && (input1.isEmpty || input1 == Btn.n0)) {
        btnValue = "0.";
      }
      input1 += btnValue;
    } else if (input2.isEmpty || operation.isNotEmpty) {
      if (btnValue == Btn.dot && input2.contains(Btn.dot)) return;
      if (btnValue == Btn.dot && (input2.isEmpty || input2 == Btn.n0)) {
        btnValue = "0.";
      }
      input2 += btnValue;
    }
  }

  void performCalculation() {
    if (input1.isEmpty || operation.isEmpty || input2.isEmpty) return;

    final double num1 = double.parse(input1);
    final double num2 = double.parse(input2);
    var result = 0.0;

    switch (operation) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
        break;
    }

    // Formatting the result based on its size
    String formattedResult;
    if (result.abs() < 1000000) {
      formattedResult = result.toStringAsFixed(2); // 2 decimal places
      //
      formattedResult =
          formattedResult.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
    } else {
      // For very large numbers, use exponential notation
      formattedResult = result.toStringAsExponential(2);
    }

    input1 = formattedResult;

    // Save the calculation to history
    final now = DateTime.now();
    final timestamp =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
    final historyItem = {
      DatabaseHelper.columnCalculation: "$input1 $operation $input2 = $result",
      DatabaseHelper.columnTimestamp: timestamp
    };

    DatabaseHelper.instance.insert(historyItem);

    // Reset the operation and input2 for the next calculation
    operation = "";
    input2 = "";
  }

  void convertToPercentage() {
    if (input1.isNotEmpty && operation.isNotEmpty && input2.isNotEmpty) {
      performCalculation();
    }

    if (operation.isNotEmpty) {
      return;
    }

    final number = double.parse(input1);
    input1 = "${(number / 100)}";
    operation = "";
    input2 = "";
  }

  void clearAll() {
    input1 = "";
    operation = "";
    input2 = "";
  }

  void delete() {
    if (input2.isNotEmpty) {
      input2 = input2.substring(0, input2.length - 1);
    } else if (operation.isNotEmpty) {
      operation = "";
    } else if (input1.isNotEmpty) {
      input1 = input1.substring(0, input1.length - 1);
    }
  }
}
