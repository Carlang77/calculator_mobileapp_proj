import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  TextEditingController _kilometerController = TextEditingController();
  double _mileResult = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kilometer to Mile Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _kilometerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Kilometers'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Perform the conversion logic
                  double kilometers = double.parse(_kilometerController.text);
                  _mileResult = kilometers * 0.621371;
                });
              },
              child: Text('Convert'),
            ),
            SizedBox(height: 16.0),
            Text('Miles: $_mileResult'),
          ],
        ),
      ),
    );
  }
}
