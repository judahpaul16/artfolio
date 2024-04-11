import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import '../models/artwork.dart';
import '../utils/settings.dart';
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
  String colFullName = 'fullname';
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
        version: 5, onUpgrade: _onUpgrade, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $userTable($colUserId INTEGER PRIMARY KEY AUTOINCREMENT, $colFullName TEXT, $colUsername TEXT, $colPassword TEXT)',
    );
    await db.execute(
      'CREATE TABLE $artworksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colImageUrl TEXT, $colArtistName TEXT, $colDescription TEXT)',
    );
    _insertDefaultUser(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS $userTable($colUserId INTEGER PRIMARY KEY AUTOINCREMENT, $colFullName TEXT, $colUsername TEXT, $colPassword TEXT)',
      );
      await db.execute(
        'CREATE TABLE IF NOT EXISTS $artworksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colImageUrl TEXT, $colArtistName TEXT, $colDescription TEXT)',
      );
    }
    _insertDefaultUser(db);
  }

  Future<void> _insertDefaultUser(Database db) async {
    final List<Map<String, dynamic>> users = await db.query(userTable,
        where: '$colUsername = ?', whereArgs: [AppStrings.username]);
    if (users.isEmpty) {
      await createUser(
          AppStrings.fullname, AppStrings.username, AppStrings.password);
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> createUser(
      String fullname, String username, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);
    return await db.insert(userTable, {
      colFullName: fullname,
      colUsername: username,
      colPassword: hashedPassword,
    });
  }

  Future<int> updateUser(
      String fullname, String username, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);
    return await db.update(
      userTable,
      {colPassword: hashedPassword, colFullName: fullname},
      where: '$colUsername = ?',
      whereArgs: [username],
    );
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

  Future<void> clearDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/artfolio.db';
    await deleteDatabase(path);
  }
}
