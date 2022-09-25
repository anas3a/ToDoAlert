class Task {
  int? id;
  int? isDone = 0;
  String? title;
  String? date;
  String? time;
  static const tableName = 'tasks';

  Task({
    this.id,
    this.isDone,
    this.title,
    this.date,
    this.time,
  });

  static Task fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      isDone: json['done'],
      title: json['title'].toString(),
      date: json['date'].toString(),
      time: json['time'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'done': isDone,
      'title': title,
      'date': date,
      'time': time,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
