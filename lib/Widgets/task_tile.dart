import 'package:flutter/material.dart';
import '../Models/data_provider.dart';

class TaskTile extends StatefulWidget {
  bool isChecked;
  final int taskId;
  final String taskTitle;
  final String taskDate;
  final String taskTime;
  final Function checkboxCallback;
  final VoidCallback deleteCallback;

  TaskTile({
    Key? key,
    required this.taskId,
    required this.isChecked,
    required this.taskTitle,
    required this.taskDate,
    required this.taskTime,
    required this.checkboxCallback,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  DataProvider dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.taskTitle,
        style: TextStyle(
          fontWeight: widget.isChecked ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text('${widget.taskTime}   ${widget.taskDate}'),
      leading: Checkbox(
          value: widget.isChecked,
          onChanged: (bool? value) {
            widget.checkboxCallback(value);
            setState(() {
              widget.isChecked = value!;
            });
          }),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever_rounded),
        onPressed: widget.deleteCallback,
      ),
    );
  }
}
