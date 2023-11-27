import 'package:flutter/material.dart';

import 'button_value.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //calcutor output
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(30),
                  child: const Text(
                    "0",
                    style: TextStyle(fontSize: 68, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //Buttons section
            Wrap(
              children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width:
                        height:
                        child: buildButton(value)),
                    )
                    .toList()
              ),
            

          ],
        ),
      ),
    );
  }


  Widget buildButton(value){
    return Text(value);

  }

  
}
