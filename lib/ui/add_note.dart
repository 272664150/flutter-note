import 'package:flutter/material.dart';
import 'package:flutter_note/model/note.dart';
import 'package:flutter_note/util/db_helper.dart';

class AddNotePage extends StatelessWidget {
  String description;

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
            _saveNote(context);
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
          description = content;
        },
      ),
    );
  }

  void _saveNote(BuildContext context) async {
    if (description == null || description.isEmpty) {
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("Please input content."),
//      ));
      return;
    }

    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    Note note = new Note();
    note.content = description;
    var date = new DateTime.now();
    note.createTime = date.millisecondsSinceEpoch;
    note.updateTime = date.millisecondsSinceEpoch;
    await noteProvider.insert(note);
    await noteProvider.close().then((onValue) {
      Navigator.pop(context, true);
    });
  }
}
