import 'package:flutter/material.dart';
import 'package:flutter_note/model/note.dart';
import 'package:flutter_note/ui/add_note.dart';
import 'package:flutter_note/ui/edit_note.dart';
import 'package:flutter_note/util/db_helper.dart';

class NoteHomePage extends StatefulWidget {
  NoteHomePage({Key key}) : super(key: key);

  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<Note> items = new List();

  @override
  void initState() {
    super.initState();
    _queryNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Note"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            Note item = items[index];
            return new ListTile(
              title: new Text(
                item.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: new Text(
                  new DateTime.fromMillisecondsSinceEpoch(item.updateTime)
                      .toString()),
              onTap: () {
                _editNote(item);
              },
              onLongPress: () {
                showDialog<Null>(
                  context: context,
                  builder: (BuildContext context) {
                    return new SimpleDialog(
                      children: <Widget>[
                        new SimpleDialogOption(
                          child: new Text('Delete'),
                          onPressed: () {
                            _deleteNote(item, index);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add note",
        onPressed: () {
          _addNote();
        },
      ),
    );
  }

  void _queryNotes() async {
    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    await noteProvider.query().then((notes) {
      setState(() {
        items.clear();
        notes.forEach((note) {
          items.add(Note.fromMap(note));
        });
      });
    });
    await noteProvider.close();
  }

  void _addNote() async {
    bool result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddNotePage()),
    );

    if (result) {
      _queryNotes();
    }
  }

  void _editNote(Note note) async {
    bool result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => EditNotePage(note)),
    );

    if (result) {
      _queryNotes();
    }
  }

  void _deleteNote(Note note, int index) async {
    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    await noteProvider.delete(note.id).then((onValue) {
      setState(() {
        items.removeAt(index);
      });
    });
    await noteProvider.close().then((onValue) {
      Navigator.of(context).pop();
    });
  }
}
