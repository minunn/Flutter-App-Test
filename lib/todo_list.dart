import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class SubTask {
  String name;
  bool isDone;

  SubTask({required this.name, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }

  static SubTask fromMap(Map<String, dynamic> map) {
    return SubTask(
      name: map['name'],
      isDone: map['isDone'],
    );
  }
}

class _TodoListState extends State<TodoList> {
  List<String> _todoItems = [];
  Map<String, bool> _checkedItems = {};
  Map<String, List<SubTask>> _subTasks = {};
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _subTaskTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  _loadTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems = prefs.getStringList('todoItems') ?? [];
      _checkedItems = {for (var v in _todoItems) v: prefs.getBool(v) ?? false};
      _subTasks = {
        for (var v in _todoItems)
          v: (prefs.getStringList('${v}_subTasks') ?? [])
              .map((e) => SubTask.fromMap(jsonDecode(e)))
              .toList()
      };
    });
  }

  _addTodoItem(String task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems.add(task);
      _checkedItems[task] = false;
      _subTasks[task] = [];
    });
    prefs.setStringList('todoItems', _todoItems);
    prefs.setBool(task, false);
    prefs.setStringList('${task}_subTasks', []);
  }

  _deleteMainTask(String task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems.remove(task);
      _checkedItems.remove(task);
      _subTasks.remove(task);
    });
    prefs.setStringList('todoItems', _todoItems);
    prefs.remove(task);
    prefs.remove('${task}_subTasks');
  }

  _addSubTask(String mainTask, SubTask subTask) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _subTasks[mainTask]!.add(subTask);
    });
    List<String> subTasksString = _subTasks[mainTask]!
        .map((subTask) => jsonEncode(subTask.toMap()))
        .toList();
    prefs.setStringList('${mainTask}_subTasks', subTasksString);
  }

  _deleteSubTask(String mainTask, SubTask subTask) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _subTasks[mainTask]!.remove(subTask);
    });
    List<String> subTasksString = _subTasks[mainTask]!
        .map((subTask) => jsonEncode(subTask.toMap()))
        .toList();
    prefs.setStringList('${mainTask}_subTasks', subTasksString);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Todo List'),
          floating: true,
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration:
                            const InputDecoration(labelText: 'Enter todo item'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        _addTodoItem(_textController.text);
                        _textController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final mainTask = _todoItems[index];
              return ExpansionTile(
                title: Row(
                  children: [
                    Text(mainTask),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteMainTask(mainTask),
                    ),
                  ],
                ),
                children: [
                  ..._subTasks[mainTask]!.asMap().entries.map((entry) {
                    final SubTask subTask = entry.value;
                    return ListTile(
                      title: Row(
                        children: [
                          Text(subTask.name),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteSubTask(mainTask, subTask),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: subTask.isDone,
                        onChanged: (bool? value) {
                          setState(() {
                            subTask.isDone = value!;
                          });
                        },
                      ),
                    );
                  }).toList(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _subTaskTextController,
                          decoration:
                              const InputDecoration(labelText: 'Enter subtask'),
                          onSubmitted: (subTaskName) {
                            _addSubTask(mainTask, SubTask(name: subTaskName));
                            _subTaskTextController.clear();
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Add Subtask'),
                        onPressed: () {
                          _addSubTask(mainTask,
                              SubTask(name: _subTaskTextController.text));
                          _subTaskTextController.clear();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
            childCount: _todoItems.length,
          ),
        ),
      ],
    );
  }
}
