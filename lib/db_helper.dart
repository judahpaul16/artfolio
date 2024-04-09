import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'artwork.dart';
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

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    var tables = ['artworkTable'];
    for (var table in tables) {
      await db.delete(table);
    }
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + '/artfolio.db';
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $artworksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colImageUrl TEXT, $colArtistName TEXT)',
    );
  }

  Future<int> insertArtwork(Artwork artwork) async {
    Database db = await this.database;
    return await db.insert(artworksTable, artwork.toMap());
  }

  Future<List<Artwork>> getArtworks() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> artworkMapList =
        await db.query(artworksTable);
    final List<Artwork> artworkList = [];
    artworkMapList.forEach((artworkMap) {
      artworkList.add(Artwork.fromMap(artworkMap));
    });
    return artworkList;
  }
}
