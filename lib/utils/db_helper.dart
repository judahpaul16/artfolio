import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import '../models/artwork.dart';
import '../utils/strings.dart';
import 'dart:convert';
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

  String userTable = 'userTable';
  String colUserId = 'userId';
  String colUsername = 'username';
  String colPassword = 'password';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/artfolio.db';
    return await openDatabase(path,
        version: 3, onUpgrade: _onUpgrade, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $artworksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colImageUrl TEXT, $colArtistName TEXT, $colDescription TEXT)',
    );
    await db.execute(
      'CREATE TABLE $userTable($colUserId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT UNIQUE, $colPassword TEXT)',
    );
    _insertDefaultUser(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS $userTable($colUserId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT UNIQUE, $colPassword TEXT)',
      );
    }
    _insertDefaultUser(db);
  }

  Future<void> _insertDefaultUser(Database db) async {
    final List<Map<String, dynamic>> users = await db
        .query(userTable, where: '$colUsername = ?', whereArgs: [str_username]);
    if (users.isEmpty) {
      await createUser(str_name, str_username, str_password);
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> createUser(String name, String username, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);
    return await db.insert(userTable, {
      colArtistName: name,
      colUsername: username,
      colPassword: hashedPassword,
    });
  }

  Future<bool> authenticateUser(String username, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);
    final List<Map<String, dynamic>> result = await db.query(userTable,
        where: '$colUsername = ? AND $colPassword = ?',
        whereArgs: [username, hashedPassword]);
    return result.isNotEmpty;
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
