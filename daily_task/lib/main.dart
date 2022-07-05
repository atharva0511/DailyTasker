

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:daily_task/taskCard.dart';
import 'package:flutter/material.dart';
import 'package:daily_task/addTask.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/' :(context)=>MyApp(),
      '/taskDetails':(context)=>TaskDetails(),
    },
  ));
}

 class MyApp extends StatefulWidget {
   @override
   _MyAppState createState() => _MyAppState();
 }
 
 class _MyAppState extends State<MyApp> {

   File jsonFile;
   Directory dir;
   String fileName = "dailtyTasksData.json";
   //List<Task> tasks = [Task(desc: 'atharva vjavf kjafbja fajkf af gfwjebf wfaf aaf wgsdaSfe gfsgaav '),Task(desc: 'task1',everyday: true),Task(desc: 'task2'),Task(desc: 'atharva'),];
   
   List<Task> tasks = [];
   String info = 'default';
   bool fileExists = false;
   List<String> months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
   
   @override
   void initState() { 
     super.initState();
     print("started");
     // Load data
     getApplicationDocumentsDirectory().then((Directory directory){
       dir = directory;
       jsonFile = new File(dir.path + "/" + fileName);
       print('dir-- '+dir.path);
       fileExists = jsonFile.existsSync();
       if(fileExists) this.setState(() {
         print(jsonFile.readAsStringSync());
         tasks = Task.decodeTasks(jsonFile.readAsStringSync());
         tasks = expireTasks(tasks);
         saveToFile();
         print(tasks);
       });
     });
     
     //saveToFile();
   }

   List<Task> expireTasks(List<Task> tasks){
     List<Task> newList = [];
     print('Validating Task Expiry');
     tasks.forEach((t) {if((t.everyday || !t.done) || t.date==DateTime.now().day)newList.add(t);});
     newList.forEach((t) {if(t.date!=DateTime.now().day)t.done = false; });
     return newList;
   }

   void saveToFile(){
     print('saving');
     //TaskList savedTasks = TaskList(tasks: tasks);
     if(fileExists){
       jsonFile.writeAsStringSync(jsonEncode(tasks));
       print(Task.encodeTasks(tasks));
     }
     else{
       File file = new File(dir.path + "/" + fileName);
       file.createSync();
       fileExists = true;
       file.writeAsStringSync(Task.encodeTasks(tasks));
     }
   }

   Widget taskCard(Task task){
     return Card(
       color: task.everyday?Colors.yellow[300]: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,8.0,0,12.0),
              child: Row(
         children:[
           FlatButton(child: Checkbox(value: task.done, onChanged: null,checkColor: Colors.green[800],),
           onPressed: (){setState(() {
               task.done = !task.done;
               saveToFile();
           }); },),
           Expanded(
               child: FlatButton(child: Align(child: Text(task.desc,style: TextStyle(fontSize: 16),),alignment: Alignment.centerLeft,),onPressed: (){
                 setState(() {
                   _editTask(task);
                 });
               },)
           ),
           Align(
               child:IconButton(onPressed: (){
                 setState(() {
                   tasks.remove(task);
                 });
                 saveToFile();
               }, icon: Icon(Icons.delete), ),
               alignment: Alignment.centerRight,
           ),
         ]
       ),
            ),
     );
   }

  void assignDesc(String info1,bool evr){
    setState(() {
      info = info1;
      tasks.add(Task(desc:info,everyday: evr,date1: DateTime.now().day));
    });
    saveToFile();
  }

  void _newTask() async {
     try {
       final info1 = await Navigator.of(context).push(MaterialPageRoute(builder: (context){
       return TaskDetails(args1:{'edit':false,'desc':null,'ev':false});
     }));
     if(info1['desc']!=null && info1['everyday']!=null)
      assignDesc(info1['desc'],info1['everyday']);
     }
     catch(e){
       print(e);
     }
   }

   void _editTask(Task task) async {
     try {
       final info1 = await Navigator.of(context).push(MaterialPageRoute(builder: (context){
       return TaskDetails(args1:{'edit':true,'desc':task.desc,'ev':task.everyday});
       }));
       setState(() {
         if(info1['desc']!=null)
            task.desc = info1['desc'];
         task.everyday = info1['everyday'];
       });
       print(info1);
       saveToFile();
     }
     catch(e){
       print(e);
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.grey[800],
       body: CustomScrollView(
         slivers: [
           SliverAppBar(
             title: Text('Todays Tasks:',style: TextStyle(fontSize:16,color:Colors.redAccent[900],letterSpacing: 0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
             backgroundColor: Colors.indigo[800],
             pinned: true,
             expandedHeight: 240,
             flexibleSpace: FlexibleSpaceBar(
               background:Container(decoration: BoxDecoration(image:DecorationImage(image:AssetImage('assets/woodSurface.jpg'),fit:BoxFit.cover)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children:[SizedBox(height: 40,),
                                        Container(decoration: BoxDecoration(image:DecorationImage(image:AssetImage('assets/pinnedNote.png'),fit:BoxFit.cover)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10,30,10,10),
                                                    child: CircularPercentIndicator(radius: 110,
                                                      lineWidth: 10,
                                                      percent: finishedTasks()/tasks.length,
                                                      center: Column(
                                                        children: [
                                                          SizedBox(height: 30,),
                                                          Icon(Icons.assignment),
                                                          Text(finishedTasks().toString()+ ' / '+tasks.length.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize:18),),
                                                        ],
                                                      ),
                                                      progressColor: Colors.green,
                                                      animation: true,
                                                      animateFromLastPercent: true,
                                                    ),
                                                  ) ,
                                        ),
                                        Expanded(child: SizedBox(height: 8,)),
                                        Row(
                                            children: [
                                              Expanded(child:SizedBox(width: 10,)),
                                              Icon(Icons.today,color: Colors.white,),
                                              SizedBox(width:10),
                                              Text(_getDayString(),style:TextStyle(color:Colors.white,fontSize: 20)),
                                            ],
                                          )
                                          
                                      ]),
                                    ),
               )
             ),
           ),
           SliverList(
             delegate: SliverChildListDelegate(tasks.map((task) => taskCard(task)).toList())
             )
         ],
       ),
           
       floatingActionButton: FloatingActionButton(onPressed: (){
         setState(() {
           _newTask();
           
         });
       },child: Icon(Icons.add),),
     );
   }

   int finishedTasks(){
     int c=0;
     tasks.forEach((element) {if(element.done)c++;});
     return c;
   }
   String _getDayString() => DateTime.now().day.toString() + ' ' + months[DateTime.now().month-1] + ' ' + DateTime.now().year.toString();
 }
