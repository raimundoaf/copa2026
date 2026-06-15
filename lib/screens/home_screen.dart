import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/jogo.dart';
import 'jogo_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper();
  List<Jogo> jogos = [];

  @override
  void initState() {
    super.initState();
    _carregarJogos();
  }

  Future<void> _carregarJogos() async {
    final lista = await db.buscarTodos();
    setState(() => jogos = lista);
  }

  Future<void> _deletarJogo(int id) async {
    await db.deletarJogo(id);
    _carregarJogos();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removido')),
    );
  }

  void _confirmarDelecao(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Jogo'),
        content: const Text('Tem certeza que deseja excluir este jogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletarJogo(id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _placar(Jogo jogo) {
    if (jogo.golsCasa == null || jogo.golsVisitante == null) return 'Sem placar';
    return '${jogo.golsCasa} x ${jogo.golsVisitante}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copa do Mundo 2026'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: jogos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum jogo cadastrado.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[700],
                      child: const Icon(Icons.sports_soccer, color: Colors.white),
                    ),
                    title: Text(
                      '${jogo.timeCasa} x ${jogo.timeVisitante}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${jogo.data} • ${jogo.estadio}\nPlacar: ${_placar(jogo)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => JogoFormScreen(jogo: jogo)),
                            ).then((_) => _carregarJogos());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarDelecao(jogo.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JogoFormScreen()),
          ).then((_) => _carregarJogos());
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}