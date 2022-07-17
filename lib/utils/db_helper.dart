// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:today/models/card_model.dart';
//
// class DBHelper {
//   static final DBHelper _instance = DBHelper.internal();
//   factory DBHelper() => _instance;
//   DBHelper.internal();
//   static Database? _db;
//
//   Future<Database?> createDatabase() async {
//     if (_db != null) return _db;
//
//     try {
//       var databasesPath = await getDatabasesPath();
//       String path = join(databasesPath, 'identity_card_ocr.db');
//       // await deleteDatabase(path);
//       _db = await openDatabase(
//         path,
//         version: 1,
//         onCreate: (db, v) async {
//           //create tables
//           await db.execute('CREATE TABLE identity_card(id INTEGER PRIMARY KEY AUTOINCREMENT, image_path VARCHAR(255))');
//         },
//       );
//       return _db;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   Future<int> addCard(IdentityCard card) async {
//     Database? db = await createDatabase();
//     return db!.insert('identity_card', card.toMap());
//   }
//
//   Future<List> allCards() async {
//     Database? db = await createDatabase();
//     return db!.query('identity_card');
//   }
//
//   Future<int> deleteCard(int id) async {
//     Database? db = await createDatabase();
//     return db!.delete('identity_card', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<int> updateCard(IdentityCard card) async {
//     Database? db = await createDatabase();
//     return await db!.update('identity_card', card.toMap(), where: 'id = ?', whereArgs: [card.id]);
//   }
// }
