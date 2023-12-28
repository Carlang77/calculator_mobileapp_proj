import 'package:flutter/material.dart';
import 'package:calculator_mobileapp_proj/database_helper.dart'; // Import DatabaseHelper

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
                convertAndSave();
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

  void convertAndSave() {
    setState(() {
      double kilometers = double.tryParse(_kilometerController.text) ?? 0.0;
      _mileResult = kilometers * 0.621371;
      saveConversionToHistory(
          '$kilometers km = ${_mileResult.toStringAsFixed(2)} miles');
    });
  }

  void saveConversionToHistory(String conversionResult) {
    var now = DateTime.now();
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    DatabaseHelper.instance.insert({
      DatabaseHelper.columnCalculation: conversionResult,
      DatabaseHelper.columnTimestamp: formattedDate,
    });
  }
}
