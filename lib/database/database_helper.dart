import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jogo.dart';

class DatabaseHelper {
  static Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) return _banco!;
    _banco = await _iniciarBanco();
    return _banco!;
  }

  Future<Database> _iniciarBanco() async {
    final caminho = await getDatabasesPath();
    return await openDatabase(
      join(caminho, 'copa2026.db'),
      version: 1,
      onCreate: (db, versao) async {
        await db.execute('''
          CREATE TABLE jogos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timeCasa TEXT NOT NULL,
            timeVisitante TEXT NOT NULL,
            data TEXT NOT NULL,
            estadio TEXT NOT NULL,
            golsCasa INTEGER,
            golsVisitante INTEGER
          )
        ''');
      },
    );
  }

  Future<int> inserirJogo(Jogo jogo) async {
    final db = await banco;
    return await db.insert('jogos', jogo.toMap());
  }

  Future<List<Jogo>> buscarTodos() async {
    final db = await banco;
    final resultado = await db.query('jogos');
    return resultado.map((mapa) => Jogo.fromMap(mapa)).toList();
  }

  Future<int> atualizarJogo(Jogo jogo) async {
    final db = await banco;
    return await db.update(
      'jogos',
      jogo.toMap(),
      where: 'id = ?',
      whereArgs: [jogo.id],
    );
  }

  Future<int> deletarJogo(int id) async {
    final db = await banco;
    return await db.delete('jogos', where: 'id = ?', whereArgs: [id]);
  }
}