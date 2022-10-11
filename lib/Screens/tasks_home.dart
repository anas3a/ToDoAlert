import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../Models/data_provider.dart';
import '../Widgets/task_list.dart';
import '../Services/notification.dart';

class TasksHome extends StatefulWidget {
  const TasksHome({Key? key}) : super(key: key);

  @override
  State<TasksHome> createState() => _TasksHomeState();
}

class _TasksHomeState extends State<TasksHome> {
  DataProvider dataProvider = DataProvider();
  int? all = 0;  int? done = 0;
  double? percent = 1;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    NotificationHelper.init(initScheduled: true);
  }

  void calculate() async {
    all = await dataProvider.calculateAll();
    done = await dataProvider.calculateDone();
    percent = (all == 0) ? 1 : (done! / all!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    calculate();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.add_task), onPressed: () {}),
        title: const Text('ToDoAlert'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: screenSize.height * 0.17,
              decoration: const BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$done of $all tasks completed!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        width: MediaQuery.of(context).size.width - 75,
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 1000,
                        percent: percent!,
                        center: Text("${(percent! * 100).toStringAsFixed(1)}%"),
                        barRadius: const Radius.circular(36),
                        progressColor: Colors.tealAccent),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TaskList(
                selectedButton: _currentIndex,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'All Task',
            icon: Icon(Icons.all_inclusive_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Completed Task',
            icon: Icon(Icons.done_all_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Incomplete Task',
            icon: Icon(Icons.browser_not_supported_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add_task');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
