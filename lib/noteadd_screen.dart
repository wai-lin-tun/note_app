
import 'package:flutter/material.dart';
import 'package:route_training/database_helper.dart';
import 'package:route_training/main.dart';

enum PriorityStatus { low, medium, high }

// ignore: must_be_immutable
class NoteAddScreen extends StatefulWidget {
  final bool isEdit;
  Notes? edit;
  NoteAddScreen({Key? key, required this.isEdit,this.edit}) : super(key: key);
  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}
dynamic selectedIndex;
class _NoteAddScreenState extends State<NoteAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  Color changeColor = Colors.white;
  List<Color> myColors = const [
    Color(0xff001D6E),
    Color(0xff00FFAB),
    Color(0xff7FB5FF),
    Color(0xff7882A4),
    Color(0xff54BAB9), 
    Color(0xffFF9F45),
    Color(0xffC3DBD9),
    Color(0xffF66B0E),
    Color(0xff40DFEF),
    Color(0xffD3ECA7),
    Color(0xffFFADF0),
    Color(0xffC1DEAE),
    Color(0xff7897AB),
    Color(0xffCC9544),
    Color(0xff827397),
    Color(0xffC1A3A3),
    Color(0xffFFE162),
    Color(0xffFDD7AA),
    Color(0xffE60965),
    Color(0xffCDDEFF),
    Color(0xff35589A),
    Color(0xff06FF00),
    Color(0xff781D42),
    Color(0xff84DFFF),
    Color(0xff98BAE7),
    Color(0xffFFC4E1),
    Color(0xff66806A),
    Color(0xffB91646),
    Color.fromARGB(255, 144, 85, 1)
  ];
  String priority = "medium";
  PriorityStatus priorityStatus = PriorityStatus.medium;
  addNote() {
    databaseHelper.insertNote(
      Notes(
          title: titleController.text,
          body: bodyController.text,
          date: DateTime.now().toString(),
          color: changeColor.value,
          priority: priority,
          status: 0,
          ),
    );
  }
  update(Notes notes)async{
    await databaseHelper.updateData(notes);
  }
  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    databaseHelper.initializeDB();
    if(widget.edit != null){
      setState(() {
        titleController.text = widget.edit!.title;
        bodyController.text = widget.edit!.body;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 3, 71),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 21, 3, 71),
          title: const Text("Add Notes"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          priorityStatus = PriorityStatus.low;
                          priority = "low";
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: priorityStatus == PriorityStatus.low
                              ? const Color.fromARGB(255, 244, 162, 54)
                              : Colors.transparent,
                          border: Border.all(color: changeColor, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            "Low",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          priorityStatus = PriorityStatus.medium;
                          priority = "medium";
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: priorityStatus == PriorityStatus.medium
                              ? const Color.fromARGB(255, 54, 244, 171)
                              : Colors.transparent,
                          border: Border.all(color: changeColor, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            "Medium",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priorityStatus = PriorityStatus.high;
                            priority = "high";
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: priorityStatus == PriorityStatus.high
                                ? const Color.fromARGB(255, 244, 54, 92)
                                : Colors.transparent,
                            border: Border.all(color: changeColor, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              "High",
                              style: TextStyle(color: Colors.white),
                            ),
                         ),
                        ),
                     ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myColors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              changeColor = myColors[index];
                              selectedIndex = myColors[index];
                            });
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: selectedIndex == myColors[index]
                                ? myColors[index]
                                : Colors.white,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: myColors[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Note Title",
                    style: TextStyle(
                        color: changeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Commontextfield(
                control: titleController,
                line: 1,
                color: changeColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Note Body",
                    style: TextStyle(
                        color: changeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Commontextfield(
                color: changeColor,
                control: bodyController,
                line: 4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            splashColor: const Color.fromARGB(255, 54, 244, 197),
            backgroundColor: Colors.white,
            onPressed: () {
              if(_formKey.currentState!.validate()){
                if(widget.edit !=null){
                  if(widget.isEdit==true){
                   update (Notes(
                          id: widget.edit!.id,
                          title: titleController.text,
                          body: bodyController.text,
                          color: changeColor.value,
                          status:0,
                          priority: priority,
                          date: DateTime.now().toString()
                            ),
                          );
                          Navigator.pop(context);
                          }
                        }
                else{
                    addNote();
                    Navigator.pop(context);
                  }
              }
              titleController.clear();
              bodyController.clear();
              },
            child: widget.isEdit
                ? const Icon(
                    Icons.edit,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.black,
                  )),
      ),
    );
  }
}
class Commontextfield extends StatelessWidget {
  final int line;
  final  control;
  final Color color;
  const Commontextfield(
      {Key? key,
      required this.line,
      required this.control,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the value";
        }
        return null;
      },
      controller: control,
      maxLines: line,
      cursorColor: color,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: color),
          )),
    );
  }
}
