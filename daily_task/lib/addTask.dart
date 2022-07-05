
import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  Map args2;
  TaskDetails({Map args1}){
    args2 = args1;
  }
  @override
  _TaskDetailsState createState() => _TaskDetailsState(args2);
}

class _TaskDetailsState extends State<TaskDetails> {

  Map args;
  _TaskDetailsState(Map args2){
    args = args2;
  }
  String txt;
  bool everyday = false;
  bool altered = false;
  List<String> months = ['January','February','March','April','May','June','July','August','September','October','November','December'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    everyday = args['ev'];
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(args['edit']?'Edit Task':'New Task',style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic ),),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[700],
      body: Column(
          children: [
            SizedBox(height:30),
            Row(
              children: [
                Expanded(child: SizedBox(width: 5,)),
                Icon(Icons.today,color: Colors.blue[200],size: 30,),
                SizedBox(width: 10,),
                Text(_getDayString(),style: TextStyle(color: Colors.blue[200],fontSize: 26),),
                Expanded(child: SizedBox(width: 5,)),
              ],
            ),
            Divider(height:40),
            Card(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [ 
                SizedBox(height:10),
                Align(child: Text('Task Description :'),alignment: Alignment.centerLeft,),
                SizedBox(height:20),
                TextFormField(
                  initialValue: args['desc'],
                  onChanged:(String str){
                    txt = str;
                  }
                ),
                SizedBox(height:40),
                Row(children: [
                  Text('Everyday task : '),
                  FlatButton(child: Checkbox(value: everyday, onChanged: null,checkColor: Colors.green[800],),
           onPressed: (){setState(() {
                   everyday = !everyday;
                   altered =!altered;
           }); },),
                ]),
                SizedBox(height:40),
                ]),
              ),
            ),
            
            Center(
              child: RaisedButton(
                child:Text(args['edit']?'Confirm':'Add Task',style:TextStyle(fontWeight:FontWeight.bold,fontSize: 20,fontStyle: FontStyle.italic )),
                onPressed: (){
                  print(altered);
                  Navigator.pop(context,{'desc':txt,'everyday':altered?!args['ev']:args['ev']});
              }),
            ),
          ],
        )
      );
    
  }

  String _getDayString() => DateTime.now().day.toString() + ' ' + months[DateTime.now().month-1] + ' ' + DateTime.now().year.toString();
}