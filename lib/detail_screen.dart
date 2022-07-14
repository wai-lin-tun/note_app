import 'package:flutter/material.dart';
import 'package:route_training/database_helper.dart';
import 'package:route_training/floatingactionbutton.dart';
import 'package:route_training/main.dart';
import 'package:route_training/noteadd_screen.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  int id;
  DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isDone = true;
   List<Notes> list = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<List<Notes>> myNoteId(int id) async {
       list = await databaseHelper.myId(id);
    return list;
  }
  noteDelete(int id) async {
    await databaseHelper.deleteNote(id);
  }

  update(Notes notes) async {
    await databaseHelper.updateData(notes);
  }

  showMyDialog(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete !"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      noteDelete(id);
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
       return  Scaffold(
      backgroundColor:const Color(0xffCDF0EA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:Color(widget.id),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30
            ),
        ),
      ),
      body: FutureBuilder(
          future: myNoteId(widget.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Notes>> asyncSnapshot) {
            return  Column(
                    children: [
                      for (Notes notes in list)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const Text("Title",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 141, 139, 139),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      notes.title,
                                      style: TextStyle(
                                          decoration:notes.status == 0
                                              ? TextDecoration.none
                                              : TextDecoration.lineThrough,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                   const Text("Body",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 141, 139, 139),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    const SizedBox(
                                    height: 20,
                                  ),
                                  for (Notes notes in list)
                                    SizedBox(
                                      child: Text(
                                        notes.body,
                                        style: TextStyle(
                                            decoration: notes.status == 0
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ])),
                    ],
                  );
          }),
      floatingActionButton:ExpandableFab( 
        distance:100,
        children: [
          ActionButton(
           onPressed: () {
              setState(() {             
           if(isDone){
             isDone=false;
              for (Notes notes in list) {
                update (Notes(
               id:notes.id,
               title: notes.title,
               body: notes.body,
               color: notes.color,
               priority: notes.priority,
               date: notes.date,
               status:1));
              }
           }else{
             isDone=true;
              for (Notes notes in list) {
                update (Notes(
               id: notes.id,
               title: notes.title,
               body: notes.body,
               color: notes.color,
               priority: notes.priority,
               date: notes.date,
               status:0));
              }
           }
          });
           },
           icon: const Icon(Icons.check),
         ),
         ActionButton(
           onPressed: () {
             showMyDialog(widget.id.toInt());
           },
           icon: const Icon(Icons.delete),
         ),
         ActionButton(
           onPressed: () {
          for (Notes notes in list) {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteAddScreen(
                      isEdit: true,edit:notes
                    ),
                  ),
                ).then((value) {
                  setState(() {});
                });
                 }
           },
           icon: const Icon(Icons.edit),
         ),
       ]
       ),
    );
     }
  }

