import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NoteValidator {
  static String validateTitle(String value) =>
      value.isEmpty ? 'Required' : null;
}

class NoteDetail extends StatefulWidget {
  final Note _note;
  NoteDetail(this._note);

  @override
  _NoteDetailState createState() => _NoteDetailState(_note);
}

class _NoteDetailState extends State<NoteDetail> {
  Note _note;
  _NoteDetailState(this._note);
  String _currentSelected = '';
  var _priorities = ['Low', 'High'];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    if (_note != null) {
      _titleController.text = _note.title;
      _descriptionController.text = _note.description;
      _currentSelected = _note.priority;
    } else {
      _currentSelected = _priorities[0];
    }
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_left),
          //   onPressed: _goBack,
          // ),
          title: Text('${_note == null ? 'Add' : 'Edit'} Note')),
      body: Padding(
        padding: EdgeInsets.only(top: 20, right: 10, left: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton<String>(
                  style: textStyle,
                  items: _priorities.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  value: _currentSelected,
                  onChanged: (String newVal) {
                    setState(() {
                      _currentSelected = newVal;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  // Separate validation logic for unit testing
                  validator: NoteValidator.validateTitle,
                  controller: this._titleController,
                  decoration: InputDecoration(
                      labelText: 'title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: this._descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Note _editedNote = Note(
                                _titleController.text,
                                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                _currentSelected,
                                _descriptionController.text);
                            if (_note == null) {
                              DatabaseHelper().insertNote(_editedNote);
                            } else {
                              _editedNote.id = _note.id;
                              DatabaseHelper()
                                  .updateNote(_editedNote)
                                  .then((onValue) {
                                print(onValue.toString());
                              });
                            }
                            _goBack();
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (_note != null) DatabaseHelper().deleteNote(_note);
                          _goBack();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }
}
