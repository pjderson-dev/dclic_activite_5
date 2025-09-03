import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Modele/redacteur.dart';

class DatabaseManager {
  late Database _database;

  // Initialisation de la base de données
  Future<void> initialisation() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'redacteurs_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE redacteurs(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, prenom TEXT, email TEXT)',
        );
      },
      version: 1,
    );
  }

  // Récupérer tous les rédacteurs (Read)
  Future<List<Redacteur>> getAllRedacteurs() async {
    final List<Map<String, dynamic>> maps = await _database.query('redacteurs');
    return List.generate(maps.length, (i) {
      return Redacteur(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        prenom: maps[i]['prenom'],
        email: maps[i]['email'],
      );
    });
  }

  // Ajouter un rédacteur (Create)
  Future<void> insertRedacteur(Redacteur redacteur) async {
    await _database.insert('redacteurs', redacteur.toMap());
  }

  // Mettre à jour un rédacteur (Update)
  Future<void> updateRedacteur(Redacteur redacteur) async {
    await _database.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // Supprimer un rédacteur (Delete)
  Future<void> deleteRedacteur(int id) async {
    await _database.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}