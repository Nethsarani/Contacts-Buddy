import 'package:sqflite/sqflite.dart' as sql;

class SQL {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE contact (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    number TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("contacts.db", version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        });
  }


  static Future<int> createData(String name, String? number) async {
    final db = await SQL.db();
    final data = {'name': name, 'number': number};
    final id = await db.insert('contact', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }



  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db=await SQL.db();
    return db.query('contact',orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async{
    final db=await SQL.db();
    return db.query('contact',where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int? id, String name, String? contactNumber) async{
    final db = await SQL.db();
    final data = {
      'name': name,
      'number': contactNumber,
      'createdAt': DateTime.now().toString()
    };
    final result=
    await db.update('contact',data,where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async{
    final db=await SQL.db();
    try{
      await db.delete('contact',where: "id=?", whereArgs: [id]);
    }
    catch (e){
      print("error");
    }
  }

}


