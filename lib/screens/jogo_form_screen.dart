import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/jogo.dart';

class JogoFormScreen extends StatefulWidget {
  final Jogo? jogo;

  const JogoFormScreen({super.key, this.jogo});

  @override
  State<JogoFormScreen> createState() => _JogoFormScreenState();
}

class _JogoFormScreenState extends State<JogoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  final _timeCasaCtrl = TextEditingController();
  final _timeVisitanteCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _estadioCtrl = TextEditingController();
  final _golsCasaCtrl = TextEditingController();
  final _golsVisitanteCtrl = TextEditingController();

  bool get _editando => widget.jogo != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      final j = widget.jogo!;
      _timeCasaCtrl.text = j.timeCasa;
      _timeVisitanteCtrl.text = j.timeVisitante;
      _dataCtrl.text = j.data;
      _estadioCtrl.text = j.estadio;
      _golsCasaCtrl.text = j.golsCasa?.toString() ?? '';
      _golsVisitanteCtrl.text = j.golsVisitante?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _timeCasaCtrl.dispose();
    _timeVisitanteCtrl.dispose();
    _dataCtrl.dispose();
    _estadioCtrl.dispose();
    _golsCasaCtrl.dispose();
    _golsVisitanteCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    try {
      final jogo = Jogo(
        id: widget.jogo?.id,
        timeCasa: _timeCasaCtrl.text.trim(),
        timeVisitante: _timeVisitanteCtrl.text.trim(),
        data: _dataCtrl.text.trim(),
        estadio: _estadioCtrl.text.trim(),
        golsCasa: _golsCasaCtrl.text.isEmpty
            ? null
            : int.parse(_golsCasaCtrl.text),
        golsVisitante: _golsVisitanteCtrl.text.isEmpty
            ? null
            : int.parse(_golsVisitanteCtrl.text),
      );

      if (_editando) {
        await db.atualizarJogo(jogo);
      } else {
        await db.inserirJogo(jogo);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editando ? 'Jogo atualizado!' : 'Jogo cadastrado!'),
            backgroundColor: Colors.green[700],
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Jogo' : 'Novo Jogo'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Informações do Jogo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeCasaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time da Casa',
                  hintText: 'Ex: Brasil',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeVisitanteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time Visitante',
                  hintText: 'Ex: Argentina',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataCtrl,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  hintText: 'Ex: 15/06/2026',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estadioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Estádio',
                  hintText: 'Ex: MetLife Stadium',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Placar (opcional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _golsCasaCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Gols Casa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _golsVisitanteCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Gols Visitante',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: Text(_editando ? 'Atualizar' : 'Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}