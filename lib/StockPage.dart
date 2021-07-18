import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

class StockPage extends StatefulWidget {
  final String indexCode;

  StockPage(this.indexCode);

  @override
  _IndexPageState createState() => _IndexPageState(indexCode);
}

class _IndexPageState extends State<StockPage> {
  String indexCode;

  _IndexPageState(this.indexCode);

  late Future<String> jsonString;

  @override
  void initState() {
    super.initState();
    jsonString = _loadRemoteIndex(indexCode);
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Stock info';
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: FutureBuilder<String>(
            future: jsonString,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> stocks =
                    jsonDecode(snapshot.data!.characters.string);

                return Column(children: [
                  Text('Name:  ${stocks['country']}'),
                  Text('Country:  ${stocks['name']}'),
                  Text('Currency:  ${stocks['currency']}'),
                  Text('Exchange:  ${stocks['exchange']}'),
                  Text('IPO:  ${stocks['ipo']}'),
                  Text('Webpage:  ${stocks['weburl']}'),
                  Text('Ticker:  ${stocks['ticker']}')
                ]);
              } else if (snapshot.hasError) {
                return Text('error');
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}

Future<String> _loadRemoteIndex(String index) async {
  final token = 'c3q4f9qad3i8q4a5858g';

  final response = await (http.get(Uri.parse(
      'https://finnhub.io/api/v1/stock/profile2?symbol=${index}&token=${token}')));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('Http Error: ${response.statusCode}!');
    throw Exception('Invalid data source.');
  }
}
