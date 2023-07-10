import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _baseUrl = "http://stantapp.pejuang-subuh.com/api/getProvince";
  late String? _valProvince = "null";
  List<dynamic> _dataProvince = [];
  void getProvince() async {
    final respose = await http
        .get((_baseUrl) as Uri); //untuk melakukan request ke webservice
    var listData = jsonDecode(respose.body); //lalu kita decode hasil datanya
    setState(() {
      _dataProvince = listData; // dan kita set kedalam variable _dataProvince
    });
    print("data : $listData");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvince(); //Ketika pertama kali membuka home screen makan method ini dijalankan untuk pertama kalinya juga
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
