import 'package:flutter_note_demo/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteProvider {
  Database db;

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbNote);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableNote ( 
  $columnId integer primary key autoincrement, 
  $columnContent text not null,
  $columnCreateTime integer not null,
  $columnUpdateTime integer not null)
''');
    });
  }

  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableNote, note.toMap());
    return note;
  }

  Future<Note> getNote(int id) async {
    List<Map> maps = await db.query(tableNote,
        columns: [columnId, columnContent, columnCreateTime, columnUpdateTime],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await db.update(tableNote, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<List<Map<String, dynamic>>> query() async {
    return db.query(tableNote);
  }

  Future close() async => db.close();
}
