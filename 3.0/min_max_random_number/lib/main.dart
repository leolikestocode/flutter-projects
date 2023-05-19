import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? todoItems = prefs.getStringList('todoItems');
  runApp(TodoApp(todoItems: todoItems));
}

class TodoApp extends StatefulWidget {
  final List<String>? todoItems;
  const TodoApp({Key? key, this.todoItems}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<TodoItem> _todoItems = [];

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todoItems != null) {
      for (String item in widget.todoItems!) {
        _todoItems.add(TodoItem(text: item, isChecked: false));
      }
    }
  }

  void _addTodoItem(String task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems.add(TodoItem(text: task, isChecked: false));
      prefs.setStringList(
          'todoItems', _todoItems.map((item) => item.text).toList());
      _textFieldController.clear();
    });
  }

  void _removeTodoItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems.removeAt(index);
      prefs.setStringList(
          'todoItems', _todoItems.map((item) => item.text).toList());
    });
  }

  void _toggleTodoItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems[index].isChecked = !_todoItems[index].isChecked;
      prefs.setStringList(
          'todoItems', _todoItems.map((item) => item.text).toList());
    });
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return Dismissible(
            key: Key(_todoItems[index].text),
            onDismissed: (direction) {
              _removeTodoItem(index);
            },
            background: Container(color: Colors.red),
            child: _buildTodoItem(_todoItems[index], index),
          );
        }
        return null;
      },
    );
  }

  Widget _buildTodoItem(TodoItem todoItem, int index) {
    return ListTile(
      leading: Checkbox(
        value: todoItem.isChecked,
        onChanged: (newValue) {
          _toggleTodoItem(index);
        },
      ),
      title: Text(
        todoItem.text,
        style: todoItem.isChecked
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeTodoItem(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildTodoList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: _textFieldController,
                      onSubmitted: (task) => _addTodoItem(task),
                      decoration: const InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTodoItem(_textFieldController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  final String text;
  bool isChecked;

  TodoItem({required this.text, required this.isChecked});
}
