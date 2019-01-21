import 'package:flutter/material.dart';
import 'package:flutter_note_demo/add_note.dart';
import 'package:flutter_note_demo/db_helper.dart';
import 'package:flutter_note_demo/edit_note.dart';
import 'package:flutter_note_demo/note.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainAppPage(),
    );
  }
}

class MainAppPage extends StatefulWidget {
  MainAppPage({Key key}) : super(key: key);

  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  List<Map<String, dynamic>> notes;

  @override
  void initState() {
    super.initState();
    queryNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Note"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: notes == null ? 0 : notes.length,
          itemBuilder: (BuildContext context, int index) {
            Note item = Note.fromMap(notes[index]);
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
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => EditPage(item)),
                );
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
                            deleteNote(item);
                            Navigator.of(context).pop();
                            return;
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
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
      ),
    );
  }

  queryNotes() async {
    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    await noteProvider.query().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
    await noteProvider.close();
  }

  deleteNote(Note note) async {
    NoteProvider noteProvider = NoteProvider();
    await noteProvider.open();
    await noteProvider.delete(note.id).then((onValue) {
      setState(() {});
    });
    await noteProvider.close();
  }
}
