import 'package:flutter/material.dart';
import 'package:flutter_note_demo/db_helper.dart';
import 'package:flutter_note_demo/note.dart';

class EditPage extends StatelessWidget {
  Note note;

  EditPage(this.note);

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
            updateData(context);
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

  updateData(context) async {
    if (note.content == null || note.content.isEmpty) {
      return;
    }

    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    note.updateTime = new DateTime.now().millisecondsSinceEpoch;
    await noteProvider.update(note);
    await noteProvider.close();

    Navigator.pop(context);
  }
}
