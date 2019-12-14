import 'package:flutter/material.dart';

import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:note_keeper/views/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _navigateToNoteDetail(null),
      ),
    );
  }

  Widget getListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getNoteMapList(),
      builder: (context, data) {
        if (data.hasData)
          return ListView.builder(
            itemCount: data.data.length,
            itemBuilder: (BuildContext context, int i) {
              Note note = Note.fromMap(data.data[i]);

              return Card(
                elevation: 3.0,
                child: ListTile(
                  leading: getPriorityLeadingIcon(note.priority),
                  title: Text(
                    note.title,
                    softWrap: false,
                    style: textStyle,
                  ),
                  subtitle: Text(
                    note.description,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  trailing: SizedBox(
                    width: 123,
                    child: Row(
                      children: <Widget>[
                        Text(note.date),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _onDeleteClicked(note);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () => _navigateToNoteDetail(note),
                ),
              );
            },
          );
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  void _navigateToNoteDetail(Note note) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetail(note)));
    // bool result = await Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => NoteDetail(note)));
    // if (result) {
    //   setState(() {});
    // }
  }

  void _onDeleteClicked(Note note) {
    setState(() {
      DatabaseHelper().deleteNote(note);
    });
  }

  Widget getPriorityLeadingIcon(String priority) {
    return CircleAvatar(
      backgroundColor: (priority == 'Low') ? Colors.yellow : Colors.red,
      child: Icon(Icons.keyboard_arrow_right),
    );
  }
}
