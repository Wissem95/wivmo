import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'lifecompanion.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des données environnementales
    await db.execute('''
      CREATE TABLE environmental_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        temperature REAL,
        humidity REAL,
        pressure REAL,
        co2 REAL,
        timestamp TEXT,
        sync_status INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table des activités
    await db.execute('''
      CREATE TABLE activity_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_type TEXT,
        confidence REAL,
        duration INTEGER,
        timestamp TEXT,
        sync_status INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table des notifications locales
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        message TEXT,
        type TEXT,
        read_status INTEGER DEFAULT 0,
        timestamp TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> initialize() async {
    await database; // Initialiser la base de données
  }

  // Données environnementales
  Future<void> insertEnvironmentalData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('environmental_data', {
      'temperature': data['temperature'],
      'humidity': data['humidity'],
      'pressure': data['pressure'],
      'co2': data['co2'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getLatestEnvironmentalData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'environmental_data',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<List<Map<String, dynamic>>> getEnvironmentalDataRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await database;
    return await db.query(
      'environmental_data',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
  }

  // Données d'activité
  Future<void> insertActivityData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('activity_data', {
      'activity_type': data['activity_type'],
      'confidence': data['confidence'],
      'duration': data['duration'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getLatestActivityData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity_data',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    
    return maps.isNotEmpty ? maps.first : null;
  }

  // Synchronisation
  Future<List<Map<String, dynamic>>> getUnsyncedData() async {
    final db = await database;
    final environmental = await db.query(
      'environmental_data',
      where: 'sync_status = 0',
    );
    final activity = await db.query(
      'activity_data',
      where: 'sync_status = 0',
    );
    
    return [...environmental, ...activity];
  }

  Future<void> markDataAsSynced(List<String> ids) async {
    final db = await database;
    final batch = db.batch();
    
    for (final id in ids) {
      batch.update(
        'environmental_data',
        {'sync_status': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
      batch.update(
        'activity_data',
        {'sync_status': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    
    await batch.commit();
  }
}