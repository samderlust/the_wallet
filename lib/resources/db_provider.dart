import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

import '../model/CardModel.dart';

class DbProvider {
  DbProvider._();
  static const String CARDSTABLE = 'cardstable';

  static final DbProvider db = DbProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await init();
    return _database;
  }

  init() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final path = join(docDir.path, 'the_wallet.db');

    return await openDatabase(
      path,
      version: 6,
      onOpen: (db) {},
      onUpgrade: _onUpgrade,
      onCreate: (Database newDb, int version) async {
        await newDb.execute("""
            CREATE TABLE $CARDSTABLE
            (
              id INTEGER PRIMARY KEY,
              uuid TEXT,
              title TEXT,
              description TEXT,
              code TEXT,
              codeFormat INTEGER
            )
        """);
      },
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS $CARDSTABLE");
      await db.execute("""
            CREATE TABLE $CARDSTABLE
            (
              id INTEGER PRIMARY KEY,
              uuid TEXT,
              title TEXT,
              description TEXT,
              code TEXT,
              codeFormat INTEGER
            )
        """);
    }
  }

  addCard(CardModel card) async {
    final db = await database;
    var query = db.insert(CARDSTABLE, card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<CardModel>> getAllCard() async {
    final db = await database;
    var res = await db.query(CARDSTABLE);
    List<CardModel> list =
        res.isNotEmpty ? res.map((c) => CardModel.fromDb(c)).toList() : [];
    return list;
  }

  clearDatabase() async {
    final db = await database;
    // await db.delete(CARDSTABLE);
    await db.rawDelete("Delete from $CARDSTABLE");
  }

  deleteCard(String uuid) async {
    final db = await database;
    var res = await db.delete(CARDSTABLE, where: "uuid = ?", whereArgs: [uuid]);
    return res;
  }

  findCardByName(String name) async {
    final db = await database;
    var res = await db
        .rawQuery("SELECT * FROM $CARDSTABLE WHERE title LIKE '%$name%'");
    List<CardModel> list =
        res.isNotEmpty ? res.map((c) => CardModel.fromDb(c)).toList() : [];
    return list;
  }

  Future<CardModel> findCardById(String uuid) async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT * FROM $CARDSTABLE WHERE uuid = '$uuid'");
    return res.isNotEmpty ? CardModel.fromDb(res.first) : null;
  }

  updateCard(CardModel card) async {
    final db = await database;
    var res = await db.update(CARDSTABLE, card.toMap(),
        where: "uuid = ?", whereArgs: [card.uuid]);
    return res;
  }

  countNumberOfCards() async {
    final db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) AS total FROM $CARDSTABLE");
    return res;
  }
}
