import 'dart:html';

import 'package:basic_stock_app/StockPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

class IndexPage extends StatefulWidget {
  final String indexName;
  final String indexCode;

  IndexPage(this.indexName, this.indexCode);

  @override
  _IndexPageState createState() => _IndexPageState(indexCode);
}

class _IndexPageState extends State<IndexPage> {
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
    final title = 'Constituents';
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
                List<String> stockList = List.from(stocks.values.first);
                stockList.sort();

                return ListView.builder(
                    itemCount: stockList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StockPage(stockList[index])));
                          },
                          title: Text('${stockList[index]}'));
                    });
              } else if (snapshot.hasError) {
                return Text('error');
              }
              return CircularProgressIndicator();
            }));
  }
}

Future<String> _loadRemoteIndex(String index) async {
  final token = 'c3q4f9qad3i8q4a5858g';

  final response = await (http.get(Uri.parse(
      'https://finnhub.io/api/v1/index/constituents?symbol=^${index}&token=${token}')));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('Http Error: ${response.statusCode}!');
    throw Exception('Invalid data source.');
  }
}
