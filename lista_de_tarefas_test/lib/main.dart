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

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

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
      body: Container(
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
                ElevatedButton(
                  // color: Colors.blueAccent,
                  child: Text("ADD"),
                  onPressed: _addToList,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: buildItem,
                itemCount: _todoList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["checked"],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["checked"] ? Icons.check : Icons.error),
        ),
        onChanged: (bool? newValue) {
          setState(() {
            _todoList[index]["checked"] = newValue;
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _todoList.insert(_lastRemovedPos, _lastRemoved);
                  });
                }),
            duration: Duration(seconds: 3),
          );

          Scaffold.of(context).hideCurrentSnackBar(snack);
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
