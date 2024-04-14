import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tde1/model/person.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  static const table = 'persons';
  static const idColumn = 'id';
  static const nameColumn = 'name';
  static const ageColumn = 'age';

  static late Database _db;

  initDB() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    _db = await openDatabase(path,
        version: arquivoDoBancoDeDadosVersao,
        onCreate: createDB,
        onUpgrade: upgradeDB,
        onDowngrade: downgradeDB);
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT NOT NULL,
          $ageColumn INTEGER NOT NULL
        )
      ''');
  }

  Future upgradeDB(Database db, int oldVersion, int newVersion) async {}

  Future downgradeDB(Database db, int oldVersion, int newVersion) async {}

  Future<int> insert(Map<String, dynamic> row) async {
    await initDB();
    if (row.containsKey(idColumn)) {
      List matchingList =
          await _db.query(table, where: "$idColumn == ${row[idColumn]}");
      if (matchingList.isNotEmpty) {
        return _db.update(table, row, where: "$idColumn == ${row[idColumn]}");
      }
    }
    return await _db.insert(table, row);
  }

  Future<int> deleteAll() async {
    await initDB();
    return _db.delete(table);
  }

  Future<int> delete(int id) async {
    await initDB();
    return _db.delete(table, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<List<Person>> findAll() async {
    await initDB();

    final List<Map<String, Object?>> allPersons = await _db.query(table);

    return [
      for (final {
            idColumn: pId as int,
            nameColumn: pName as String,
            ageColumn: pAge as int,
          } in allPersons)
        Person(id: pId, name: pName, age: pAge),
    ];
  }

  Future<void> edit(Person regPerson) async {
    await initDB();

    await _db.update(
      table,
      regPerson.toMap(),
      where: '$idColumn = ?',
      whereArgs: [regPerson.id],
    );
  }
}
