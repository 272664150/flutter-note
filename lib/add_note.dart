import 'package:flutter/material.dart';
import 'package:flutter_note_demo/db_helper.dart';
import 'package:flutter_note_demo/note.dart';

class AddPage extends StatelessWidget {
  String noteContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note"), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          tooltip: 'Save',
          onPressed: () {
            saveNote(context);
          },
        ),
      ]),
      body: TextField(
        maxLines: 999,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          hintText: "Please input...",
        ),
        onChanged: (String content) {
          noteContent = content;
        },
      ),
    );
  }

  saveNote(context) async {
    if (noteContent == null || noteContent.isEmpty) {
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("Please input content."),
//      ));
      return;
    }

    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    Note note = new Note();
    note.content = noteContent;
    var date = new DateTime.now();
    note.createTime = date.millisecondsSinceEpoch;
    note.updateTime = date.millisecondsSinceEpoch;
    await noteProvider.insert(note);
    await noteProvider.close();

//    Scaffold.of(context).showSnackBar(new SnackBar(
//      content: new Text("Save successfully."),
//    ));
    Navigator.pop(context);
  }
}
