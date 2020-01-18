import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
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
  int _person = 0;

  void addPerson(value) {
    setState(() {
      _person += value;
    });
    updateMessage();
  }

  void updateMessage() {
    if (_person > 5) {
      _message = "Lotado";
    } else if (_person >= 0) {
      _message = "Pode entrar";
    } else {
      _message = "Está certo disso?";
    }
  }

  String _message = "Pode entrar";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Pessoas: ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30.0,
                          decoration: TextDecoration.none)),
                  Text(_person.toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30.0,
                          decoration: TextDecoration.none))
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                      onPressed: () {
                        addPerson(1);
                      },
                      child: Text("+1",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 30.0,
                              decoration: TextDecoration.none))),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                      onPressed: () {
                        addPerson(-1);
                      },
                      child: Text("-1",
                          style:
                              TextStyle(color: Colors.blue, fontSize: 30.0))),
                ),
              ],
            ),
            Text(_message,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30.0,
                    decoration: TextDecoration.none))
          ],
        )
      ],
    );
  }
}
