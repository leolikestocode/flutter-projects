import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController altura = new TextEditingController();
  TextEditingController peso = new TextEditingController();

  String _infoData = "Informe os dados";

  void resetData() {
    altura.text = "";
    peso.text = "";
    setState(() {
      _infoData = "Informe os dados";
    });
  }

  void _changeData() {
    double we = double.parse(peso.text);
    double he = double.parse(altura.text) / 100;
    double imc = we / (he * he);

    setState(() {
      if (imc < 22) {
        _infoData = "Abaixo do peso";
      } else if (imc < 28) {
        _infoData = "Normal";
      } else {
        _infoData = "Acima do peso";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Calculadora de IMC'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: resetData,
            )
          ]),
      body: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.person_outline,
              color: Colors.green,
              size: 70.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: peso,
              decoration: const InputDecoration(
                hintText: 'Peso (kg)',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Digite seu peso';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: altura,
              decoration: const InputDecoration(
                hintText: 'Altura (cm)',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Digite sua altura';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _changeData();
                  }
                },
                child: Text(
                  'Calcular'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text(_infoData,
                  style: TextStyle(color: Colors.green, fontSize: 24.0)))
        ]),
      ),
    );
  }
}
