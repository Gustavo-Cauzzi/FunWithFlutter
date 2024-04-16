import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tde1/model/food.dart';
import 'package:tde1/model/person.dart';
import 'package:tde1/model/pet.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD.db';
  static const arquivoDoBancoDeDadosVersao = 2;

  static const table = 'persons';
  static const tableFood = 'foods';
  static const tablePet = 'pets';
  static const idColumn = 'id';
  static const nameColumn = 'name';
  static const ageColumn = 'age';
  static const weightColumn = 'weight';
  static const typeColumn = 'type';

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

  Future upgradeDB(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
        CREATE TABLE $tableFood (
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT NOT NULL,
          $weightColumn NUMERIC (19, 4) NOT NULL
        )
      ''');

    await db.execute('''
        CREATE TABLE $tablePet (
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT NOT NULL,
          $typeColumn TEXT NOT NULL
        )
      ''');
  }

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

  // Comidas

  Future<int> insertFood(Map<String, dynamic> row) async {
    await initDB();
    if (row.containsKey(idColumn)) {
      List matchingList =
          await _db.query(tableFood, where: "$idColumn == ${row[idColumn]}");
      if (matchingList.isNotEmpty) {
        return _db.update(tableFood, row,
            where: "$idColumn == ${row[idColumn]}");
      }
    }
    return await _db.insert(tableFood, row);
  }

  Future<int> deleteAllFoods() async {
    await initDB();
    return _db.delete(tableFood);
  }

  Future<int> deleteFood(int id) async {
    await initDB();
    return _db.delete(tableFood, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<List<Food>> findAllFoods() async {
    await initDB();

    final List<Map<String, Object?>> allFoods = await _db.query(tableFood);

    return [
      for (final {
            idColumn: pId as int,
            nameColumn: pName as String,
            weightColumn: pWeight as int,
          } in allFoods)
        Food(id: pId, name: pName, weight: pWeight),
    ];
  }

  Future<void> editFood(Food regFood) async {
    await initDB();

    await _db.update(
      tableFood,
      regFood.toMap(),
      where: '$idColumn = ?',
      whereArgs: [regFood.id],
    );
  }

  // Pets

  Future<int> insertPet(Map<String, dynamic> row) async {
    await initDB();
    if (row.containsKey(idColumn)) {
      List matchingList =
          await _db.query(tablePet, where: "$idColumn == ${row[idColumn]}");
      if (matchingList.isNotEmpty) {
        return _db.update(tablePet, row,
            where: "$idColumn == ${row[idColumn]}");
      }
    }
    return await _db.insert(tablePet, row);
  }

  Future<int> deleteAllPets() async {
    await initDB();
    return _db.delete(tablePet);
  }

  Future<int> deletePet(int id) async {
    await initDB();
    return _db.delete(tablePet, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<List<Pet>> findAllPets() async {
    await initDB();

    final List<Map<String, Object?>> allPets = await _db.query(tablePet);

    return [
      for (final {
            idColumn: pId as int,
            nameColumn: pName as String,
            typeColumn: pType as String,
          } in allPets)
        Pet(id: pId, name: pName, type: pType),
    ];
  }

  Future<void> editPet(Pet regPet) async {
    await initDB();

    await _db.update(
      tablePet,
      regPet.toMap(),
      where: '$idColumn = ?',
      whereArgs: [regPet.id],
    );
  }
}
