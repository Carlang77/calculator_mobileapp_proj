import 'package:flutter/material.dart';
import 'calculator_logic.dart';
import 'button_value.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorLogic _logic = CalculatorLogic();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Calculator output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "${_logic.input1}${_logic.operation}${_logic.input2}"
                            .isEmpty
                        ? "0"
                        : "${_logic.input1}${_logic.operation}${_logic.input2}",
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String btnValue) {
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
          onTap: () => setState(() {
            _logic.onBtnTap(btnValue);
          }),
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

  Color getBtnColor(String btnValue) {
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
