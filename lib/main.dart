import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:route_training/database_helper.dart';
import 'package:route_training/detail_screen.dart';
import 'package:route_training/noteadd_screen.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => const SplashScreen(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 21, 3, 71),
        child: const Center(
          child: Text("My Notes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "";
  bool isChanged = true;
  int crossAxisCount = 1;
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<List<Notes>> getNote() async {
    noteList = await databaseHelper.retrieveNotes();
    return noteList;
  }
  List<Notes> noteList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 3, 71),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 3, 71),
        elevation: 0,
        centerTitle: true,
        title: const Text("Notes",style: TextStyle(fontSize: 30),),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (isChanged) {
                    isChanged = false;
                    crossAxisCount = 2;
                  } else {
                    isChanged = true;
                    crossAxisCount = 1;
                  }
                });
              },
              icon: isChanged
                  ? const Icon(Icons.format_align_center_outlined)
                  : const Icon(Icons.apps))
        ],
      ),
      body: FutureBuilder<List<Notes>>(
          future: getNote(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Notes>> asyncSnapshot) {
            return noteList.isEmpty
                ? const Center(
                    child: Text("No Note",style: TextStyle(color: Colors.white),),
                  )
                : SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      children: [
                        for (Notes notes in noteList)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailScreen(id:notes.id!.toInt(),))).then((value) {
                                setState(() {
                                  
                                });
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  color: Color(notes.color)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                          child: Text(
                                            notes.title,
                                            style:  TextStyle(
                                              decoration: notes.status==0
                                               ? TextDecoration.none
                                               : TextDecoration.lineThrough,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                       const SizedBox(
                                          height: 20,
                                        ),
                                    SizedBox(
                                      child: Text(
                                        notes.body,
                                        style:  TextStyle(
                                           decoration: notes.status==0
                                               ? TextDecoration.none
                                               : TextDecoration.lineThrough,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),          
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(notes.date.substring(0, 10)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteAddScreen( isEdit: false),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        splashColor: const Color.fromARGB(255, 7, 214, 255),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class Notes {
  int? id;
  String title;
  String body;
  int color;
  String date;
  String priority;
  int status;

  Notes(
      {this.id,
      required this.title,
      required this.body,
      required this.color,
      required this.priority,
      required this.date,
      required this.status});
  Notes.fromMap(Map<String, dynamic> note)
      : id = note["id"],
        title = note["title"],
        body = note["body"],
        date = note["date"],
        color = note["changeColor"],
        status = note["status"],
        priority = note["priority"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "date": date,
      "changeColor": color,
       "status" : status,
      "priority": priority,
    };
  }
}
