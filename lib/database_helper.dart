import 'package:route_training/main.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colBody = 'body';
  String colDate = 'date';
  String colColor = 'changeColor';
  String colPriority = 'priority';
   String colStatus = 'status';
  Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  return openDatabase(
  (path + 'note.db'),
   onCreate: (db, version) {
   db.execute(
   'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT NOT NULL,$colDate TEXT NOT NULL, $colBody TEXT NOT NULL,$colColor INTEGER NOT NULL,$colPriority TEXT NOT NULL,$colStatus INTEGER NOT NULL)');},
      version: 1
    );
  }
  Future<int>insertNote(Notes notes)async {
    int result=0;
  final Database db=await initializeDB();
  result =await db.insert(noteTable,notes.toMap());
  return  result;
  }
  Future<List<Notes>>retrieveNotes()async{
    final Database db=await initializeDB();
    final List<Map<String,Object?>>queryResuelt=await db.query(noteTable);
     
    return queryResuelt.map((e) => Notes.fromMap(e)).toList();
  }
   Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
   }
   Future<int> updateData( Notes notes) async {
    final db =await initializeDB();
       var result= await db.update(
          noteTable,
          notes.toMap(),
         where: '$colId = ?',
          whereArgs: [notes.id]);
       return result;
  }
  Future<List<Notes>>myId(int id)async{
  final Database db=await initializeDB();
  final List<Map<String,Object?>>queryResuelt=
  await db.query(
    noteTable,
     where: '$colId = ?',
          whereArgs: [id]
  );
   return queryResuelt.map((e) => Notes.fromMap(e)).toList();
  }
  }

