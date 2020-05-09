import 'package:flutter/material.dart';
import 'package:TodoCtive/database.dart';


class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  var myItems = List();
  final texteditingcontroller = TextEditingController();
  String errortext="";
  bool validated = true;
  List<Widget> children = new List<Widget>();
  String todovalue = "";

  void addtodb() async{
    Map<String,dynamic> row = {
      Databasehelper.columnName : todovalue,
    };
    final id = await database.insert(row);
    print(id);
    Navigator.pop(context);
  }

  Future<bool> query() async{
    myItems=[];
    children=[];
    var allrows = await database.queryall();
    allrows.forEach((row) {
      myItems.add(row.toString());
      children.add(
      Card(
        margin: EdgeInsets.symmetric(horizontal:10.0,vertical:5.0,),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(row['todo']),
            onLongPress:() {
          database.deletedata(row['id']);
          setState(() {});
        },
          ),        
        ),        
      ));
     });
           return Future.value(true);

  }

  final database = Databasehelper.instance;
  void showalertdialog() {
    texteditingcontroller.text= "";
    showDialog(
    context: context,
    builder : (context) {
      return StatefulBuilder(builder:(context,setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            TextField(
              controller: texteditingcontroller,
              autofocus: true,
              onChanged: (_val){
                todovalue=_val;
              },
              decoration: InputDecoration(
                errorText: validated ? null : errortext, 
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0,),
            
            child : Row(
              children: <Widget>[
              RaisedButton(
                color: Colors.purple[500],
                onPressed: () {
                  if(texteditingcontroller.text.isEmpty){
                    errortext="field is empty";
                    validated=false;
                  }else if(texteditingcontroller.text.length>400){
                    errortext="too many characters";
                    validated = false;
                  }else{addtodb();}
                },
                child: Text("Add", style: TextStyle(fontSize: 18.0)),
               )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context,snap) {
        if (snap.hasData==null) {
          return Center(child: Text("todoctive"),);
        }else{
        if (myItems==null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text("My Tasks",style: TextStyle(fontWeight: FontWeight.bold ),),
              centerTitle: true,
              backgroundColor: Colors.purple[500] ,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purple[500],
              child: Icon(Icons.add,color: Colors.white,),
              onPressed: showalertdialog,
            ),
            body: Center(
              child: Text("No Tasks Availble"), 
            ),
          );
        }else{
          return Scaffold(
            backgroundColor: Colors.black ,
            appBar: AppBar(backgroundColor: Colors.purple[500],
            title: Text("My Tasks",style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(onPressed: showalertdialog,
            backgroundColor: Colors.purple[500],
            child: Icon(Icons.add,color: Colors.white,),),
            body: SingleChildScrollView(
              child: Column(
                children: children,
              ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}
