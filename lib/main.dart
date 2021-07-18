import 'package:basic_stock_app/indexPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final title = 'Basic stock app';

  List<IndexData> indices = [
    new IndexData('Dow Jones Industrial Average', 'DJI'),
    new IndexData('S&P 500', 'GSPC'),
    new IndexData('Nasdaq 100', 'NDX')
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: indices.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${indices[index].name} (${indices[index].code})'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndexPage(
                            indices[index].name, indices[index].code)));
              },
            );
          },
        ),
      ),
    );
  }
}

class IndexData {
  late String name;
  late String code;

  IndexData(String name, String code) {
    this.name = name;
    this.code = code;
  }
}
