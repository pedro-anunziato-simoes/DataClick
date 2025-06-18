import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/repository/bloc/recrutador_bloc.dart';
import 'package:mobile/api/services/recrutador_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/models/campo.dart';
import 'package:mobile/screens/preencher_formulario_screen.dart';
import 'package:mobile/api/models/formulario.dart' as form_model;
import 'package:mobile/api/services/formulario_service.dart';

class RecruiterDashboardScreen extends StatefulWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen> {
  List<Evento>? eventosCache;
  Map<String, List<form_model.Formulario>> formulariosPreenchidosPorEvento = {};

  @override
  void initState() {
    super.initState();
    _loadEventosFromCache();
  }

  Future<void> _loadEventosFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final eventosJson = prefs.getString('eventos_recrutador');
    if (eventosJson != null) {
      final List<dynamic> decoded = json.decode(eventosJson);
      setState(() {
        eventosCache =
            decoded.map((e) {
              final evento = Evento.fromJson(e);
              return evento;
            }).toList();
      });
    }
  }

  Future<void> _saveEventosToCache(List<Evento> eventos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'eventos_recrutador',
      json.encode(eventos.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _loadFormulariosPreenchidos(String eventoId) async {
    final service = FormularioService(RepositoryProvider.of(context));
    final preenchidos = await service.getFormulariosPreenchidos(eventoId);
    setState(() {
      formulariosPreenchidosPorEvento[eventoId] = preenchidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => RecrutadorBloc(
            recrutadorService: RecrutadorService(
              RepositoryProvider.of(context),
            ),
          )..add(CarregarRecrutadorLogado()),
      child: BlocBuilder<RecrutadorBloc, RecrutadorState>(
        builder: (context, state) {
          if (state is RecrutadorLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is RecrutadorError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF26A69A),
                title: const Text('Dashboard do Recrutador'),
              ),
              body: Center(child: Text(state.message)),
            );
          }
          if (state is RecrutadorLoaded) {
            final recrutador = state.recrutador;
            final nomeRecrutador = recrutador.nome;
            List<Evento> eventos = recrutador.eventos ?? [];
            if (eventos.isNotEmpty) {
              _saveEventosToCache(eventos);
            } else if (eventosCache != null && eventosCache!.isNotEmpty) {
              eventos = eventosCache!;
            }
            return Scaffold(
              backgroundColor: const Color(0xFF26A69A),
              appBar: AppBar(
                backgroundColor: const Color(0xFF26A69A),
                title: const Text('Dashboard do Recrutador'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: const Color(0xFF26A69A),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Color(0xFF26A69A)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Bem-vindo, $nomeRecrutador!',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (eventos.isEmpty)
                    const Center(
                      child: Text(
                        'Nenhum evento encontrado.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ...eventos.map(
                    (evento) => Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.event, color: Color(0xFF26A69A)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    evento.eventoTitulo,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF26A69A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              evento.descricao,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: Color(0xFF80CBC4),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Início: ${DateFormat('dd/MM/yyyy').format(evento.dataInicio)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                  color: Color(0xFF80CBC4),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Fim: ${DateFormat('dd/MM/yyyy').format(evento.dataFim)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  size: 18,
                                  color: Color(0xFF80CBC4),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  evento.local,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: Color(0xFF80CBC4),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  evento.status,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const Divider(height: 28),
                            const Text(
                              'Formulários Associados',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF26A69A),
                              ),
                            ),
                            if (evento.formulariosAssociados.isNotEmpty)
                              ...evento.formulariosAssociados.map(
                                (form) => Card(
                                  color: const Color(0xFFE0F2F1),
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.description,
                                              color: Color(0xFF26A69A),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                form.formularioTitulo,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF26A69A),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  0xFF26A69A,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Campos: ${form.campos.length}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF26A69A),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_document,
                                                color: Color(0xFF26A69A),
                                              ),
                                              tooltip: 'Preencher Formulário',
                                              onPressed: () async {
                                                final formCompleto = form_model.Formulario(
                                                  id: form.formId,
                                                  titulo: form.formularioTitulo,
                                                  adminId: form.formAdminId,
                                                  campos:
                                                      form.campos
                                                          .map(
                                                            (c) =>
                                                                c is Campo
                                                                    ? c
                                                                    : Campo.fromJson(
                                                                      Map<
                                                                        String,
                                                                        dynamic
                                                                      >.from(c),
                                                                    ),
                                                          )
                                                          .toList(),
                                                  descricao: null,
                                                  dataCriacao: null,
                                                  eventoId:
                                                      form.formularioEventoId,
                                                );
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            PreencherFormularioScreen(
                                                              formulario:
                                                                  formCompleto,
                                                            ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  // Recarrega eventos do recrutador do backend
                                                  if (mounted) {
                                                    BlocProvider.of<
                                                      RecrutadorBloc
                                                    >(context).add(
                                                      CarregarRecrutadorLogado(),
                                                    );
                                                  }
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Formulário preenchido com sucesso!',
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        if (form.campos.isNotEmpty)
                                          ...form.campos.map((c) {
                                            final camposConvertidos =
                                                c is Map
                                                    ? Campo.fromJson(
                                                      Map<String, dynamic>.from(
                                                        c,
                                                      ),
                                                    )
                                                    : c;
                                            return Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.short_text,
                                                  color: Color(0xFF26A69A),
                                                ),
                                                title: Text(
                                                  camposConvertidos.titulo,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Tipo: ${camposConvertidos.tipo}',
                                                ),
                                              ),
                                            );
                                          }),
                                        if (form.campos.isEmpty)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              'Nenhum campo neste formulário.',
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (evento.formulariosAssociados.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Nenhum formulário associado.'),
                              ),
                            FutureBuilder<List<form_model.Formulario>>(
                              future: FormularioService(
                                RepositoryProvider.of(context),
                              ).getFormulariosPreenchidos(evento.eventoId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Erro ao carregar respostas preenchidas.',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                final preenchidos = snapshot.data ?? [];
                                if (preenchidos.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Respostas Preenchidas:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF26A69A),
                                      ),
                                    ),
                                    ...preenchidos.map(
                                      (form) => Card(
                                        color: const Color(0xFFE0F2F1),
                                        elevation: 1,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                form.titulo,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              ...form.campos.map(
                                                (campo) => Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                      ),
                                                  child: Text(
                                                    '${campo.titulo}: ${campo.resposta ?? "-"}',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
