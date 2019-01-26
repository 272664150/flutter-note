import 'package:flutter_note/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String dbName = 'note.db';
final String tableName = 'tb_note';
final String columnId = 'id';
final String columnContent = 'content';
final String columnCreateTime = 'create_time';
final String columnUpdateTime = 'update_time';

class NoteProvider {
  Database db;

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName ( 
  $columnId integer primary key autoincrement, 
  $columnContent text not null,
  $columnCreateTime integer not null,
  $columnUpdateTime integer not null)
''');
    });
  }

  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableName, note.toMap());
    return note;
  }

  Future<Note> getNote(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnContent, columnCreateTime, columnUpdateTime],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await db.update(tableName, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<List<Map<String, dynamic>>> query() async {
    return db.query(tableName);
  }

  Future close() async => db.close();
}
