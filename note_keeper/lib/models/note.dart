class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  String _priority;

  Note(this._title, this._date, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);
  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  String get priority => _priority;

  set id(int newId) => this._id = newId;
  set title(String newTitle) => this._title = newTitle;
  set description(String newDescription) => this._description = newDescription;
  set date(String newDate) => this._date = newDate;
  set priority(String newPriority) => this._priority = newPriority;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) map['id'] = _id;

    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    return map;
  }
}
