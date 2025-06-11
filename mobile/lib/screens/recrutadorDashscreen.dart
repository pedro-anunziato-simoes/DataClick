import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/forms_viewmodel.dart'
    as forms_vm;
import 'package:mobile/api/repository/viewmodel/recrutador_viewmodel.dart'
    as recruiter_vm;
import 'package:mobile/api/models/formulario.dart';
import 'package:mobile/api/models/evento.dart' as evento_model;
import 'preencher_formulario_screen.dart';

class RecruiterDashboardScreen extends StatefulWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    final recruiterViewModel = Provider.of<recruiter_vm.RecrutadorViewModel>(
      context,
      listen: false,
    );
    final formViewModel = Provider.of<forms_vm.FormViewModel>(
      context,
      listen: false,
    );

    try {
      final email =
          Provider.of<AuthViewModel>(context, listen: false).currentUser?.email;
      if (email != null) {
        print('Debug - Carregando dados para o email: $email');

        // Carregar recrutador
        await recruiterViewModel.carregarRecrutadorLogado();
        print(
          'Debug - Recrutador carregado: ${recruiterViewModel.recrutador?.nome}',
        );
        print('Debug - Estado do recrutador: ${recruiterViewModel.state}');

        if (recruiterViewModel.recrutador == null) {
          throw Exception('Não foi possível carregar os dados do recrutador');
        }

        final eventos = recruiterViewModel.recrutador?.eventos ?? [];
        print('Debug - Número de eventos do recrutador: ${eventos.length}');
        if (eventos.isNotEmpty) {
          print('Debug - Detalhes dos eventos:');
          eventos.forEach((evento) {
            print(
              'Debug - Evento: ${evento.eventoTitulo} (ID: ${evento.eventoId})',
            );
            print('Debug - Descrição: ${evento.descricao}');
            print('Debug - Data Início: ${evento.dataInicio}');
            print('Debug - Data Fim: ${evento.dataFim}');
            print(
              'Debug - Formulários associados: ${evento.formulariosAssociados.length}',
            );
            evento.formulariosAssociados.forEach((form) {
              print(
                'Debug - Formulário: ${form.formularioTitulo} (ID: ${form.formId})',
              );
            });
          });
        }

        for (var evento in eventos) {
          if (evento.eventoId == null || evento.eventoId.isEmpty) {
            print('Debug - Evento sem ID válido: ${evento.eventoTitulo}');
            continue;
          }

          print(
            'Debug - Carregando formulários para o evento: ${evento.eventoTitulo} (ID: ${evento.eventoId})',
          );
          try {
            await formViewModel.carregarFormulariosPorEvento(evento.eventoId);
            print(
              'Debug - Estado dos formulários: ${formViewModel.formulariosState}',
            );

            if (formViewModel.formulariosState is forms_vm.SuccessState) {
              final formularios =
                  (formViewModel.formulariosState
                          as forms_vm.SuccessState<List<Formulario>>)
                      .data;
              print(
                'Debug - Formulários carregados para o evento ${evento.eventoTitulo}: ${formularios.length}',
              );
            } else if (formViewModel.formulariosState is forms_vm.ErrorState) {
              final error =
                  (formViewModel.formulariosState as forms_vm.ErrorState)
                      .message;
              print(
                'Debug - Erro ao carregar formulários para o evento ${evento.eventoTitulo}: $error',
              );
            }
          } catch (e) {
            print(
              'Debug - Erro ao carregar formulários para o evento ${evento.eventoTitulo}: $e',
            );
          }
        }

        if (eventos.isEmpty) {
          print('Debug - Nenhum evento encontrado para o recrutador');
        }
      } else {
        print('Debug - Email do usuário é null');
        throw Exception('Email do usuário não encontrado');
      }

      _animationController.forward();
    } catch (e) {
      print('Debug - Erro ao carregar dados: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Erro ao carregar dados: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final recruiterViewModel = Provider.of<recruiter_vm.RecrutadorViewModel>(
      context,
    );
    final formViewModel = Provider.of<forms_vm.FormViewModel>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(authViewModel, theme),
      body:
          _isLoading
              ? _buildLoadingIndicator()
              : FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBody(recruiterViewModel, formViewModel),
              ),
      bottomNavigationBar: _buildBottomNavigationBar(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(
    AuthViewModel authViewModel,
    ThemeData theme,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      title: const Text(
        'Dashboard',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _isLoading ? null : _loadData,
          tooltip: 'Atualizar dados',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) async {
            if (value == 'logout') {
              await _showLogoutDialog(authViewModel);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Sair'),
                    ],
                  ),
                ),
              ],
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando dados...'),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Visão Geral',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Formulários',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_rounded),
            label: 'Eventos',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    recruiter_vm.RecrutadorViewModel recruiterViewModel,
    forms_vm.FormViewModel formViewModel,
  ) {
    switch (_currentIndex) {
      case 0:
        return _OverviewTab(
          recruiterViewModel: recruiterViewModel,
          formViewModel: formViewModel,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        );
      case 1:
        return _FormsTab(formViewModel: formViewModel);
      case 2:
        return _EventsTab(recruiterViewModel: recruiterViewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _showLogoutDialog(AuthViewModel authViewModel) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sair da conta'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authViewModel.logout();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final recruiter_vm.RecrutadorViewModel recruiterViewModel;
  final forms_vm.FormViewModel formViewModel;
  final Function(int) onTabChange;

  const _OverviewTab({
    required this.recruiterViewModel,
    required this.formViewModel,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recruiter = recruiterViewModel.recrutador;
    final forms =
        formViewModel.formulariosState
                is forms_vm.SuccessState<List<Formulario>>
            ? (formViewModel.formulariosState
                    as forms_vm.SuccessState<List<Formulario>>)
                .data
            : <Formulario>[];

    print('Debug - Número de formulários: ${forms.length}');
    print('Debug - Número de eventos: ${recruiter?.eventos?.length ?? 0}');
    if (recruiter?.eventos != null) {
      print('Debug - Eventos disponíveis:');
      recruiter!.eventos!.forEach((evento) {
        print(
          'Debug - Evento: ${evento.eventoTitulo} (ID: ${evento.eventoId})',
        );
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(recruiter?.nome, theme),
          const SizedBox(height: 24),
          _buildStatsSection(forms, recruiter?.eventos?.length ?? 0, theme),
          const SizedBox(height: 32),
          _buildSection(
            title: 'Formulários Recentes',
            theme: theme,
            child: _buildFormsList(forms, theme),
          ),
          const SizedBox(height: 32),
          _buildSection(
            title: 'Eventos Ativos',
            theme: theme,
            child: _buildEventsList(recruiter?.eventos ?? [], theme),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String? name, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bem-vindo!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name ?? 'Recrutador',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    List<Formulario> forms,
    int eventsCount,
    ThemeData theme,
  ) {
    // Calcular total de formulários
    final totalForms = forms.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.assignment_rounded,
                value: totalForms,
                label: 'Formulários',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.event_rounded,
                value: eventsCount,
                label: 'Eventos',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required ThemeData theme,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildFormsList(List<Formulario> forms, ThemeData theme) {
    if (forms.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_rounded,
        message: 'Nenhum formulário encontrado',
        theme: theme,
      );
    }

    // Ordenar formulários por data de criação (mais recentes primeiro)
    final sortedForms = List<Formulario>.from(forms)
      ..sort((a, b) => (b.id ?? '').compareTo(a.id ?? ''));

    // Pegar apenas os 3 formulários mais recentes
    final recentForms = sortedForms.take(3).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentForms.length,
            itemBuilder: (context, index) {
              final form = recentForms[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index == recentForms.length - 1 ? 0 : 16,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onTabChange(1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.assignment_rounded,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            form.titulo ?? 'Formulário sem título',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${form.campos?.length ?? 0} campos',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            onPressed: () => onTabChange(1),
            icon: const Icon(Icons.assignment_rounded),
            label: const Text('Ver todos os formulários'),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(List<evento_model.Evento> eventos, ThemeData theme) {
    if (eventos.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_rounded,
        message: 'Nenhum evento encontrado',
        theme: theme,
      );
    }

    // Remover eventos duplicados baseado no ID
    final eventosUnicos = eventos.toSet().toList();
    print('Debug - Número de eventos únicos: ${eventosUnicos.length}');

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: eventosUnicos.length,
          itemBuilder: (context, index) {
            final evento = eventosUnicos[index];
            print(
              'Debug - Construindo card para evento: ${evento.eventoTitulo} (ID: ${evento.eventoId})',
            );
            print(
              'Debug - Número de formulários associados: ${evento.formulariosAssociados.length}',
            );

            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onTabChange(2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.event_rounded,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evento.eventoTitulo,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              evento.descricao,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_formatDate(evento.dataInicio)} - ${_formatDate(evento.dataFim)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.assignment_rounded,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${evento.formulariosAssociados.length} formulário${evento.formulariosAssociados.length != 1 ? 's' : ''}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            onPressed: () => onTabChange(2),
            icon: const Icon(Icons.event_rounded),
            label: const Text('Ver todos os eventos'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required ThemeData theme,
  }) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
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
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormsTab extends StatelessWidget {
  final forms_vm.FormViewModel formViewModel;

  const _FormsTab({required this.formViewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final forms =
        formViewModel.formulariosState
                is forms_vm.SuccessState<List<Formulario>>
            ? (formViewModel.formulariosState
                    as forms_vm.SuccessState<List<Formulario>>)
                .data
            : <Formulario>[];

    if (formViewModel.formulariosState is forms_vm.LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (formViewModel.formulariosState is forms_vm.ErrorState) {
      return _buildErrorState(theme);
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Meus Formulários',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child:
              forms.isEmpty
                  ? _buildEmptyFormsState(theme)
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: forms.length,
                    itemBuilder: (context, index) {
                      final form = forms[index];
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            final formViewModel =
                                Provider.of<forms_vm.FormViewModel>(
                                  context,
                                  listen: false,
                                );
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );
                            await formViewModel.obterFormularioPorId(form.id);
                            Navigator.of(context).pop(); // fecha o loading

                            if (formViewModel.formularioAtualState
                                is forms_vm.SuccessState<Formulario?>) {
                              final formularioCompleto =
                                  (formViewModel.formularioAtualState
                                          as forms_vm.SuccessState<Formulario?>)
                                      .data;
                              if (formularioCompleto != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PreencherFormularioScreen(
                                          formulario: formularioCompleto,
                                        ),
                                  ),
                                );
                              }
                            } else if (formViewModel.formularioAtualState
                                is forms_vm.ErrorState) {
                              final error =
                                  (formViewModel.formularioAtualState
                                          as forms_vm.ErrorState)
                                      .message;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Erro ao carregar formulário: $error',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.assignment_rounded,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        form.titulo ?? 'Formulário sem título',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              theme
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '${form.campos?.length ?? 0} campos',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar eventos',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.red.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {}, // Adicionar retry
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFormsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum formulário encontrado',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie seu primeiro formulário para começar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {}, // Adicionar navegação para criar formulário
            icon: const Icon(Icons.add_rounded),
            label: const Text('Criar Formulário'),
          ),
        ],
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  final recruiter_vm.RecrutadorViewModel recruiterViewModel;

  const _EventsTab({required this.recruiterViewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventos = recruiterViewModel.recrutador?.eventos ?? [];

    if (recruiterViewModel.state is recruiter_vm.LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recruiterViewModel.state is recruiter_vm.ErrorState) {
      return _buildErrorState(theme);
    }

    // Remover eventos duplicados baseado no ID
    final eventosUnicos = eventos.toSet().toList();
    print(
      'Debug - Número de eventos únicos na aba Eventos: ${eventosUnicos.length}',
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Meus Eventos',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child:
              eventosUnicos.isEmpty
                  ? _buildEmptyEventsState(theme)
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: eventosUnicos.length,
                    itemBuilder: (context, index) {
                      final evento = eventosUnicos[index];
                      print(
                        'Debug - Construindo card para evento na aba Eventos: ${evento.eventoTitulo} (ID: ${evento.eventoId})',
                      );
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            // Navegar para a aba de formulários
                            final formViewModel =
                                Provider.of<forms_vm.FormViewModel>(
                                  context,
                                  listen: false,
                                );

                            // Mostrar loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );

                            try {
                              // Carregar formulários do evento
                              await formViewModel.carregarFormulariosPorEvento(
                                evento.eventoId,
                              );
                              Navigator.of(context).pop(); // Fecha o loading

                              // Navegar para a aba de formulários
                              if (context.mounted) {
                                // Encontrar o widget pai RecruiterDashboardScreen
                                final recruiterDashboard =
                                    context
                                        .findAncestorStateOfType<
                                          _RecruiterDashboardScreenState
                                        >();
                                if (recruiterDashboard != null) {
                                  recruiterDashboard.setState(() {
                                    recruiterDashboard._currentIndex =
                                        1; // Muda para a aba de formulários
                                  });
                                }
                              }
                            } catch (e) {
                              Navigator.of(context).pop(); // Fecha o loading
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao carregar formulários: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.event_rounded,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        evento.eventoTitulo,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        evento.descricao,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${_formatDate(evento.dataInicio)} - ${_formatDate(evento.dataFim)}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              theme
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '${evento.formulariosAssociados.length} formulário${evento.formulariosAssociados.length != 1 ? 's' : ''}',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar eventos',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.red.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {}, // Adicionar retry
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEventsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum evento encontrado',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie seu primeiro evento para começar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {}, // Adicionar navegação para criar evento
            icon: const Icon(Icons.add_rounded),
            label: const Text('Criar Evento'),
          ),
        ],
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
}
