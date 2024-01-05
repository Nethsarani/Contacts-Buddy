import 'package:sqflite/sqflite.dart' as sql;

class SQL{
  static Future<void> createTables(sql.Database database) async{
    await database.execute(sql)
  }

}
