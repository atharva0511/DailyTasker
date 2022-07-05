

import 'dart:convert';

class Task{
  String desc;
  bool done = false;
  int date = 0;
  bool everyday = false;

  Task({this.desc = 'deafault',this.everyday = false,date1 = 0,this.done = false}){
    this.date = date1==0?this.date:date1;
  }

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      desc: json['de'],
      done: json['do'],
      date1: json['da'],
      everyday: json['ev']
    );
  }
      
  static Map<String, dynamic> toMap(Task task) => {
        'de':task.desc,
        'do':task.done,
        'da':task.date,
        'ev':task.everyday,
      };

  Map<String, dynamic> toJson() {
    return {
      'de':desc,
      'do':done,
      'da':date,
      'ev':everyday,
    };
  }

  static String encodeTasks(List<Task> musics) => jsonEncode(
        musics
            .map<Map<String, dynamic>>((music) => Task.toMap(music))
            .toList(),
      );


  static List<Task> decodeTasks(String musics) =>
      (jsonDecode(musics) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();
}

// class TaskList{
//   List<Task> tasks;

//   TaskList({this.tasks});

//   factory TaskList.fromJson(List<dynamic> parsedJson) {

//     List<Task> tasks = new List<Task>();
//     //tasks = parsedJson.map((i)=>Task.fromJson(i)).toList();

//     return new TaskList(
//        tasks: tasks,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'ta' : tasks,
//     };
//   }
// }

