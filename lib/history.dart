import 'package:flutter/material.dart';
import 'package:calculator_mobileapp_proj/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Map<String, dynamic>>>? historyData;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  void _refreshHistory() {
    setState(() {
      historyData = DatabaseHelper.instance.queryAllRows();
    });
  }

  Future<void> _clearHistory() async {
    await DatabaseHelper.instance.clearHistory();
    _refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:
                _refreshHistory, // Refresh history when this button is pressed
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: historyData,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No history found'));
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
          }
          // Default case: when none of the above conditions are met
          return Center(child: Text('No history found'));
        },
      ),
    );
  }
}
