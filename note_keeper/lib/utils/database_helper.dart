// import 'package:flutter/cupertino.dart';
// import 'dart:async' as prefix0;

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singlton
  static Database _database;
  static const String noteTable = 'note_table';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colDate = 'date';
  static const String colPriority = 'priority';
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await _initializeDatabase();
    return _database;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    print('Insert');
    Database db = await this.database;
    return await db.insert(noteTable, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    print('Update');
    Database db = await this.database;
    int result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    print('Delete');
    Database db = await this.database;
    return await db
        .delete(noteTable, where: '$colId = ?', whereArgs: [note.id]);
  }

  Future<int> getCount(Note note) async {
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    List<Map<String, dynamic>> count =
        await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    return Sqflite.firstIntValue(count);
  }

  Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';
    print(path);
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return noteDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, $colDescription TEXT, $colPriority TEXT, $colDate TEXT)');
  }
}
