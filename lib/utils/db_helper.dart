import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/artwork.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._instance();
  DatabaseHelper._instance();

  String artworksTable = 'artworkTable';
  String colId = 'id';
  String colTitle = 'title';
  String colImageUrl = 'imageUrl';
  String colArtistName = 'artistName';
  String colDescription = 'description';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<void> clearDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/artfolio.db';
    await deleteDatabase(path);
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/artfolio.db';
    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $artworksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colImageUrl TEXT, $colArtistName TEXT, $colDescription TEXT)',
    );
  }

  Future<int> insertArtwork(Artwork artwork) async {
    Database db = await database;
    return await db.insert(artworksTable, artwork.toMap());
  }

  Future<int> updateArtwork(Artwork artwork) async {
    Database db = await database;
    return await db.update(
      artworksTable,
      artwork.toMap(),
      where: '$colId = ?',
      whereArgs: [artwork.id],
    );
  }

  Future<int> deleteArtwork(int id) async {
    Database db = await database;
    return await db.delete(
      artworksTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Artwork>> getArtworks() async {
    Database db = await database;
    final List<Map<String, dynamic>> artworkMapList =
        await db.query(artworksTable);
    final List<Artwork> artworkList = [];
    for (var artworkMap in artworkMapList) {
      artworkList.add(Artwork.fromMap(artworkMap));
    }
    return artworkList;
  }
}
