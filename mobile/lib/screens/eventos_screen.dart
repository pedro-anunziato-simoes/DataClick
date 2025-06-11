import 'package:flutter/material.dart';
import 'package:mobile/screens/criarEventos.dart';
import 'package:mobile/screens/forms_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/event_viewmodel.dart';
import 'package:mobile/api/models/evento.dart';
import 'package:mobile/api/models/user.dart';
import 'package:mobile/api/services/formulario_service.dart';
import 'package:mobile/api/services/campo_service.dart';
import 'package:mobile/api/services/event_service.dart';

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
    final bool isAdmin = authViewModel.currentUser?.role == UserRole.admin;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
            ),
          ),
        ),
        title: const Text(
          'Eventos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                eventViewModel.carregarEventos();
              },
            ),
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
              ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF26A69A).withAlpha(77),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CriarEventoScreen(),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Evento'),
                ),
              )
              : null,
    );
  }

  Widget _buildBody(EventViewModel eventViewModel, bool isAdmin) {
    if (eventViewModel.eventos is LoadingState) {
      return _buildLoadingState();
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFF26A69A),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Carregando eventos...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(EventViewModel eventViewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ops! Algo deu errado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                (eventViewModel.eventos as ErrorState).error,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => eventViewModel.carregarEventos(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Tentar Novamente',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(List<Evento> events, bool isAdmin) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEventCard(events[index], isAdmin, context),
              );
            }, childCount: events.length),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Evento event, bool isAdmin, BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              final eventService = Provider.of<EventService>(
                context,
                listen: false,
              );
              eventService.setEventoAtual(event);

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
                        eventoId: event.eventoId,
                        adminId: event.eventoAdminId ?? '',
                      ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF26A69A).withAlpha(204),
                        const Color(0xFF00796B).withAlpha(229),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              event.eventoTitulo,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isAdmin)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  _showNotImplementedSnackbar(
                                    context,
                                    'Editar evento',
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.descricao,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      _buildStatusIndicator(event.status, isHeader: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildEventInfoRow(
                        Icons.calendar_today,
                        'Data de Início: ${_formatDate(event.dataInicio)}',
                        const Color(0xFF26A69A),
                      ),
                      const SizedBox(height: 8),
                      _buildEventInfoRow(
                        Icons.calendar_today,
                        'Data de Término: ${_formatDate(event.dataFim)}',
                        const Color(0xFF26A69A),
                      ),
                      const SizedBox(height: 12),
                      _buildEventInfoRow(
                        Icons.location_on,
                        event.local,
                        Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26A69A).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.assignment_rounded,
                              color: Color(0xFF26A69A),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${event.formulariosAssociados.length} formulário${event.formulariosAssociados.length != 1 ? 's' : ''} associado${event.formulariosAssociados.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: const Color(0xFF26A69A).withAlpha(204),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status, {bool isHeader = false}) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status.toLowerCase()) {
      case 'agendado':
        statusColor = isHeader ? Colors.white : Colors.blue;
        statusIcon = Icons.event_available;
        statusText = 'Agendado';
        break;
      case 'em andamento':
        statusColor = isHeader ? Colors.white : Colors.green;
        statusIcon = Icons.directions_run;
        statusText = 'Em Andamento';
        break;
      case 'finalizado':
        statusColor = isHeader ? Colors.white70 : Colors.grey;
        statusIcon = Icons.event_busy;
        statusText = 'Finalizado';
        break;
      default:
        statusColor = isHeader ? Colors.white70 : Colors.grey;
        statusIcon = Icons.event;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isHeader ? Colors.white.withAlpha(51) : statusColor.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: isHeader ? null : Border.all(color: statusColor.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 13,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isAdmin) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF26A69A).withAlpha(25),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.event_note,
                  size: 64,
                  color: Color(0xFF26A69A),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nenhum evento encontrado',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isAdmin
                    ? 'Clique no botão "Novo Evento" para criar o primeiro evento'
                    : 'Ainda não há eventos disponíveis no momento',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              if (isAdmin) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CriarEventoScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Criar Primeiro Evento',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const meses = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    return '${date.day} ${meses[date.month - 1]} ${date.year}';
  }

  void _showNotImplementedSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Text('$message (A Implementar)'),
          ],
        ),
        backgroundColor: const Color(0xFF26A69A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
