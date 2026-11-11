import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: TestPage(),
    ));

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String _baseUrl = "https://mystantapp.siuinsa.com/api/getProvince";
  late String? _valProvince = "null";
  List<dynamic> _dataProvince = [];
  void getProvince() async {
    final respose = await http
        .get((_baseUrl) as Uri); // make a request to the web service
    var listData = jsonDecode(respose.body); // then we decode the resulting data
    setState(() {
      _dataProvince = listData; // and assign it to the _dataProvince variable
    });
    print("data : $listData");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvince(); // When the home screen is first opened, this method also runs for the first time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dropdown Menu Button JSON")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton(
              hint: Text("Select Province"),
              value: _valProvince,
              items: _dataProvince.map((item) {
                return DropdownMenuItem(
                  child: Text(item['province_name']),
                  value: item['province_name'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valProvince = value;
                });
              },
            ),
            Text(
              "Kamu memilih provinsi $_valProvince",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
