import 'package:flutter/material.dart';
import 'package:mobile/screens/criarEventos.dart';
import 'package:mobile/screens/forms_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/event_viewmodel.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/services/formulario_service.dart';
import 'package:mobile/api/services/campo_service.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).carregarEventos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final eventViewModel = Provider.of<EventViewModel>(context);
    final bool isAdmin = authViewModel.currentUser?.tipo == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        title: const Text(
          'Eventos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              eventViewModel.carregarEventos();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: _buildBody(eventViewModel, isAdmin),
        ),
      ),
      floatingActionButton:
          isAdmin
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CriarEventoScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Color(0xFF26A69A)),
              )
              : null,
    );
  }

  Widget _buildBody(EventViewModel eventViewModel, bool isAdmin) {
    if (eventViewModel.eventos is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (eventViewModel.eventos is ErrorState) {
      return _buildErrorState(eventViewModel);
    }

    if (eventViewModel.eventos is SuccessState<List<Evento>>) {
      final events =
          (eventViewModel.eventos as SuccessState<List<Evento>>).data;
      if (events.isEmpty) {
        return _buildEmptyState(isAdmin);
      }
      return _buildEventsList(events, isAdmin);
    }

    return _buildEmptyState(isAdmin);
  }

  Widget _buildErrorState(EventViewModel eventViewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar eventos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              (eventViewModel.eventos as ErrorState).error,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => eventViewModel.carregarEventos(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Tentar Novamente',
                style: TextStyle(color: Color(0xFF26A69A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(List<Evento> events, bool isAdmin) {
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index], isAdmin, context);
      },
    );
  }

  Widget _buildEventCard(Evento event, bool isAdmin, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => FormsScreen(
                    isAdmin: isAdmin,
                    formularioService: Provider.of<FormularioService>(
                      context,
                      listen: false,
                    ),
                    campoService: Provider.of<CampoService>(
                      context,
                      listen: false,
                    ),
                    eventoId: event.id,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26A69A),
                      ),
                    ),
                  ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF26A69A)),
                      onPressed: () {
                        _showNotImplementedSnackbar(context, 'Editar evento');
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildEventInfoRow(
                Icons.calendar_today,
                '${_formatDate(event.dataInicio)} - ${_formatDate(event.dataFim)}',
              ),
              const SizedBox(height: 4),
              _buildEventInfoRow(Icons.location_on, event.local),
              const SizedBox(height: 8),
              _buildStatusIndicator(event.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'agendado':
        statusColor = Colors.blue;
        statusIcon = Icons.event_available;
        break;
      case 'em andamento':
        statusColor = Colors.green;
        statusIcon = Icons.directions_run;
        break;
      case 'finalizado':
        statusColor = Colors.grey;
        statusIcon = Icons.event_busy;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.event;
    }

    return Row(
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isAdmin) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Nenhum evento encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isAdmin
                  ? 'Clique no botão + para criar um novo evento'
                  : 'Ainda não há eventos disponíveis',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showNotImplementedSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message (A Implementar)'),
        backgroundColor: const Color(0xFF26A69A),
      ),
    );
  }
}
