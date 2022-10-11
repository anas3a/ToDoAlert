import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/task.dart';
import '../Models/data_provider.dart';
import '../Services/notification.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  late Task task;
  late DataProvider dataProvider;
  var taskTitleEmpty = true;

  @override
  void initState() {
    super.initState();
    dateInput.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    timeInput.text = DateFormat().add_jm().format(DateTime.now()).toString();
    dataProvider = DataProvider();
    task = Task(
        isDone: 0,
        date: _date.toIso8601String(),
        time: timeInput.text.toString());
    NotificationHelper.init(initScheduled: true);
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        timeInput.text = _time.format(context);
        task.time = _time.format(context).toString();
      });
    }
  }

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2122, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
        dateInput.text = DateFormat('dd-MM-yyyy').format(_date).toString();
        task.date = _date.toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.add_task), onPressed: () {}),
        title: const Text('Add Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 25),
            TextFormField(
              onChanged: (text) {
                setState(() {
                  task.title = text.toString().trim();
                  taskTitleEmpty = text.trim().isEmpty;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.task_alt_rounded,
                ),
              ),
            ),
            const SizedBox(height: 60),
            TextFormField(
              controller: dateInput,
              onTap: () async {
                _selectDate();
              },
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
                controller: timeInput,
                onTap: () async {
                  _selectTime();
                },
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.watch_later_outlined),
                )),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: taskTitleEmpty
                    ? null
                    : () async {
                        var returnId = await dataProvider.addTask(task);
                        DateTime scheduledDate = DateTime(_date.year,
                            _date.month, _date.day, _time.hour, _time.minute);
                        NotificationHelper.showScheduledNotification(
                          id: returnId,
                          title: task.title,
                          body: 'Complete the Task ASAP!',
                          scheduledDate: scheduledDate,
                        );
                        Navigator.pop(context);
                        setState(() {});
                      },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: const Text('Create Task'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
