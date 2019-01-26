import 'package:flutter/material.dart';
import 'package:flutter_note/model/note.dart';
import 'package:flutter_note/util/db_helper.dart';

class EditNotePage extends StatelessWidget {
  Note note;

  EditNotePage(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Note"), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.done,
            color: Colors.white,
          ),
          tooltip: 'Update',
          onPressed: () {
            _updateNote(context);
          },
        ),
      ]),
      body: TextField(
        maxLines: 999,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: note.content,
            selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: note.content.length),
            ),
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          hintText: "Please input...",
        ),
        onChanged: (String content) {
          note.content = content;
        },
      ),
    );
  }

  void _updateNote(BuildContext context) async {
    if (note.content == null || note.content.isEmpty) {
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("Content cannot be empty."),
//      ));
      return;
    }

    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    note.updateTime = new DateTime.now().millisecondsSinceEpoch;
    await noteProvider.update(note);
    await noteProvider.close().then((onValue) {
      Navigator.pop(context, true);
    });
  }
}
