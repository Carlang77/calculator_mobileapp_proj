import 'package:flutter/material.dart';
import 'package:calculator_mobileapp_proj/database_helper.dart'; // Ensure this import is correct

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error: ${snapshot.error}')); // Display error message
          }

          // Check for data
          if (snapshot.hasData) {
            // Check if the list is empty
            if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                      'No history found')); // Display message if list is empty
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      snapshot.data![index][DatabaseHelper.columnCalculation]),
                  subtitle: Text(
                      snapshot.data![index][DatabaseHelper.columnTimestamp]),
                );
              },
            );
          } else {
            return Center(
                child: Text('No history found')); // Display message if no data
          }
        },
      ),
    );
  }
}
