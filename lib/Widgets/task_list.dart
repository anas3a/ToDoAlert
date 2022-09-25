import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart%20';
import '../Models/data_provider.dart';
import './task_tile.dart';
import 'package:intl/intl.dart';
import '../Models/task.dart';
import '../Services/notification.dart';

class TaskList extends StatefulWidget {
  int selectedButton;

  TaskList({
    Key? key,
    required this.selectedButton,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DataProvider dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    Future<List<Task>> currentFuture;
    if (widget.selectedButton == 0) {
      currentFuture = dataProvider.getTasks();
    } else if (widget.selectedButton == 1) {
      currentFuture = dataProvider.getDoneTasks();
    } else {
      currentFuture = dataProvider.getUndoneTasks();
    }
    return FutureBuilder(
      future: currentFuture,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var list = snapshot.data;
        var length = list!.length;
        if (length == 0) {
          String output;
          if (widget.selectedButton == 0) {
            output = 'No Task!';
          } else if (widget.selectedButton == 1) {
            output = 'No Task Completed!';
          } else {
            output = 'No Incomplete Task!';
          }
          return Center(
            child: Text(
              output,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
                itemCount: length,
                shrinkWrap: true,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) => TaskTile(
                      isChecked: list[i].isDone == 1 ? true : false,
                      taskTitle: list[i].title,
                      taskDate: DateFormat('dd-MMMM-yyyy')
                          .format(DateTime.parse(list[i].date))
                          .toString(),
                      taskId: list[i].id,
                      taskTime: list[i].time,
                      checkboxCallback: (value) async {
                        Task temp = list[i];
                        temp.isDone = value == true ? 1 : 0;
                        await dataProvider.updateTask(temp);
                        if (temp.isDone == 1) {
                          FlutterLocalNotificationsPlugin
                              flutterLocalNotificationsPlugin =
                              FlutterLocalNotificationsPlugin();
                          await flutterLocalNotificationsPlugin
                              .cancel(list[i].id);
                        } else {
                          DateTime tempDate = DateTime.parse(list[i].date);
                          DateTime dateTime =
                              DateFormat("h:mm a").parse(list[i].time);
                          TimeOfDay timeOfDay =
                              TimeOfDay.fromDateTime(dateTime);
                          DateTime scheduledDate = DateTime(
                              tempDate.year,
                              tempDate.month,
                              tempDate.day,
                              timeOfDay.hour,
                              timeOfDay.minute);
                          NotificationHelper.showScheduledNotification(
                            id: list[i].id,
                            title: list[i].title,
                            body: 'Complete the Task ASAP!',
                            scheduledDate: scheduledDate,
                          );
                        }
                      },
                      deleteCallback: () async {
                        await dataProvider.deleteTask(list[i]);
                        FlutterLocalNotificationsPlugin
                            flutterLocalNotificationsPlugin =
                            FlutterLocalNotificationsPlugin();
                        await flutterLocalNotificationsPlugin
                            .cancel(list[i].id);
                        setState(() {});
                      },
                    )),
          );
        }
      },
    );
  }
}
