import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  TextEditingController inputController = TextEditingController();

  void _addToList() {
    setState(() {
      _todoList.add({"title": inputController.text, "checked": false});
      inputController.text = "";
    });
    print(_todoList);
  }

  void _removeFromList(index) {
    setState(() {
      _todoList.removeAt(index);
    });
    print(_todoList);
  }

  void _changeChecked(bool newValue, int i) {
    setState(() {
      _todoList[i]["checked"] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(hintText: "Digite a tarefa"),
                    controller: inputController,
                  )),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("ADD"),
                    onPressed: _addToList,
                  )
                ],
              ),
              list(),
            ],
          ),
        ),
      ),
    );
  }

  Widget list() {
    List<Widget> allWidgets = new List<Widget>();

    if (_todoList.length == 0) {
      return Container();
    } else {
      for (int i = 0; i < _todoList.length; i++) {
        allWidgets.add(Dismissible(
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          onDismissed: (direction) {
            _removeFromList(i);
          },
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment(-0.9, 0.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          direction: DismissDirection.startToEnd,
          child: CheckboxListTile(
            title: Text(_todoList[i]["title"]),
            value: _todoList[i]["checked"],
            secondary: Icon(Icons.check),
            activeColor: Colors.blueAccent,
            onChanged: (bool val) {
              _changeChecked(val, i);
            },
          ),
        ));
      }

      return Column(
        children: allWidgets,
      );
    }
  }
}
