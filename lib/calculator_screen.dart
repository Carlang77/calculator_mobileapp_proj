import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'converter_screen.dart'; //
import 'button_value.dart'; //
import 'database_helper.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    expression.isEmpty ? "0" : expression,
                    style: const TextStyle(
                        fontSize: 68, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: [
                for (var value in Btn.buttonValues)
                  SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width / 4
                        : (screenSize.width / 4),
                    height: screenSize.width / 5,
                    child: buildButton(value),
                  ),
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
        elevation: 2,
        shadowColor: Colors.grey,
        child: InkWell(
          onTap: () => onBtnTap(btnValue),
          child: Center(
            child: Text(
              btnValue,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

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
    setState(() {
      expression += btnValue;
    });
  }

  void performCalculation() {
    try {
      Parser p = Parser();
      Expression exp =
          p.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      String result = eval.toString();

      // Save the original expression along with the result
      String historyEntry = expression + ' = ' + result;

      setState(() {
        expression = result;
      });

      saveCalculationToHistory(historyEntry);
    } catch (e) {
      // Error handling can be added here
    }
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

  void convertToPercentage() {
    if (expression.isNotEmpty) {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm) / 100;
      setState(() {
        expression = eval.toString();
      });
    }
  }

  void clearAll() {
    setState(() {
      expression = "";
    });
  }

  void delete() {
    if (expression.isNotEmpty) {
      setState(() {
        expression = expression.substring(0, expression.length - 1);
      });
    }
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
