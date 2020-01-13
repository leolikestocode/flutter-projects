import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=3c44a372";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar, euro;

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void updateReal(String text) {
    if (text.isEmpty) _clearAll();
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void updateDolar(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void updateEuro(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Converter \$"),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _clearAll,
            )
          ],
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text("Carregando dados...",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.amber)))
                    ]);
              }

              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 80.0,
                          semanticLabel: 'Money icon',
                        ),
                      ),
                    ),
                    inputTextField("Reais", "R\$ ", realController, updateReal),
                    Divider(),
                    inputTextField(
                        "Doláres", "US\$ ", dolarController, updateDolar),
                    Divider(),
                    inputTextField("Euros", "€ ", euroController, updateEuro),
                  ],
                ),
              );
            }));
  }
}

Widget inputTextField(
    String lab, String pre, TextEditingController c, Function f) {
  return TextField(
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.amber, fontSize: 22.0),
    controller: c,
    onChanged: f,
    decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: new BorderSide(color: Colors.amber)),
        labelText: lab,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
        prefixText: pre,
        prefixStyle: TextStyle(color: Colors.amber, fontSize: 18.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ), //colocar essa pra borda mudar cor na seleção
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.amber,
        ))),
  );
}
