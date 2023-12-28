import 'package:flutter/material.dart';
import 'converter_screen.dart';
import 'button_value.dart';
import 'package:calculator_mobileapp_proj/database_helper.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input1 = ""; // digits
  String operation = ""; // math operations
  String input2 = ""; // digits

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // calculator output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "$input1$operation$input2".isEmpty
                        ? "0"
                        : "$input1$operation$input2",
                    style: const TextStyle(
                        fontSize: 68, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // Buttons section
            Wrap(
              children: [
                for (var value in Btn.buttonValues)
                  SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width /
                            4 // Set to one-fourth of the screen width for "0"
                        : (screenSize.width / 4),
                    height: screenSize.width / 5,
                    child: buildButton(value),
                  ),
                // Move the "More" button to the end
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(btnValue) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: getBtnColor(btnValue),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2, // Add elevation for the shadow
        shadowColor: Colors.grey, // Set the shadow color
        child: InkWell(
          onTap: () => onBtnTap(btnValue),
          child: Center(
            child: Text(
              btnValue,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

//Set String Value and Functions

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

  // appends value to the end
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

    setState(() {});
  }

  // calculates the result

  // converts output to %
  void convertToPercentage() {
    if (input1.isNotEmpty && operation.isNotEmpty && input2.isNotEmpty) {
      performCalculation();
    }

    if (operation.isNotEmpty) {
      return;
    }

    final number = double.parse(input1);
    setState(() {
      input1 = "${(number / 100)}";
      operation = "";
      input2 = "";
    });
  }

  // clears all output
  void clearAll() {
    setState(() {
      input1 = "";
      operation = "";
      input2 = "";
    });
  }

  // delete one from the end
  void delete() {
    if (input2.isNotEmpty) {
      input2 = input2.substring(0, input2.length - 1);
    } else if (operation.isNotEmpty) {
      operation = "";
    } else if (input1.isNotEmpty) {
      input1 = input1.substring(0, input1.length - 1);
    }

    setState(() {});
  }

  void performCalculation() {
    if (input1.isEmpty) return;
    if (operation.isEmpty) return;
    if (input2.isEmpty) return;

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
    }

    // Prepare the calculation string for the history
    String calculationString = '$num1 $operation $num2 = $result';

    setState(() {
      input1 = result.toStringAsPrecision(3);

      if (input1.endsWith(".0")) {
        input1 = input1.substring(0, input1.length - 2);
      }

      // Reset the operation and input2 for the next calculation
      operation = "";
      input2 = "";

      // Save to history
      saveCalculationToHistory(calculationString);
    });
  }

  void saveCalculationToHistory(String calculationResult) {
    var now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    DatabaseHelper.instance.insert({
      DatabaseHelper.columnCalculation: calculationResult,
      DatabaseHelper.columnTimestamp: formattedDate,
    });
  }

  Color getBtnColor(btnValue) {
    return [Btn.del, Btn.clr].contains(btnValue)
        ? Color.fromARGB(255, 60, 59, 59)
        : btnValue == Btn.more
            ? Color.fromARGB(
                255, 255, 74, 3) // Set the color for the "More" button to green
            : [
                Btn.subtract,
                Btn.divide,
                Btn.per,
                Btn.multiply,
                Btn.add,
                Btn.calculate,
              ].contains(btnValue)
                ? Color.fromARGB(255, 50, 124, 213)
                : const Color.fromARGB(255, 96, 93, 93);
  }
}
