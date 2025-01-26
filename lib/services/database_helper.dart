import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/dog_model.dart';
import '../models/saved_jorney.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    await deleteDatabase(dbPath);

    return await openDatabase(
      join(dbPath, 'totApp.db'),
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed_group TEXT,
        size TEXT,
        lifespan TEXT,
        origin TEXT,
        temperament TEXT,
        colors TEXT,
        description TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE journeys(
        id INTEGER PRIMARY KEY,
        source_lat TEXT,
        source_lng TEXT,
        destination_lat TEXT,
        destination_lng TEXT,
        distance REAL,
        duration INTEGER,
        date TEXT
      )
    ''');
  }

  Future<void> insertDog(Dog dog) async {
    log("${dog.toMap()}");
    final db = await database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> getFavoriteDogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'] as int,
        name: maps[i]['name'],
        breedGroup: maps[i]['breed_group'],
        size: maps[i]['size'],
        lifespan: maps[i]['lifespan'],
        origin: maps[i]['origin'],
        temperament: maps[i]['temperament'],
        colors: List<String>.from(jsonDecode(maps[i]['colors'] ?? '[]')),
        description: maps[i]['description'],
        image: maps[i]['image'],
      );
    });
  }

  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertJourney(Map<String, dynamic> journey) async {
    final db = await database;
    return await db.insert('journeys', journey);
  }

  Future<List<SavedJourney>> fetchAllJourneys() async {
    final db = await database;
    final result = await db.query('journeys');

    return result.map((map) => SavedJourney.fromMap(map)).toList();
  }

  deleteJourney(int id) async {
    final db = await database;
    await db.delete(
      'journeys',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
