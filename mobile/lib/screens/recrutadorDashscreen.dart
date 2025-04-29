import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';

class RecruiterDashboardScreen extends StatefulWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RecruiterHomeTab(),
    const CandidatesTab(),
    const JobsTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        title: const Text('Área do Recrutador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navegar para notificações
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Fazer logout
              final authViewModel = Provider.of<AuthViewModel>(
                context,
                listen: false,
              );
              authViewModel.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF26A69A),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Candidatos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Vagas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Tab Início
class RecruiterHomeTab extends StatelessWidget {
  const RecruiterHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo de volta!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26A69A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Resumo da sua atividade recente',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Widgets de estatísticas
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.work,
                    color: Colors.blue,
                    title: 'Vagas Abertas',
                    value: '5',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.person_search,
                    color: Colors.orange,
                    title: 'Candidatos',
                    value: '48',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.check_circle,
                    color: Colors.green,
                    title: 'Entrevistas',
                    value: '12',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.flag,
                    color: Colors.purple,
                    title: 'Contratações',
                    value: '3',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Lista de tarefas
            const Text(
              'Tarefas Pendentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _TaskCard(
              title: 'Revisar currículos',
              description: '8 novos currículos para análise',
              dueDate: 'Hoje',
              onTap: () {},
            ),
            _TaskCard(
              title: 'Agendar entrevista',
              description: 'Entrevista técnica para 3 candidatos',
              dueDate: 'Amanhã',
              onTap: () {},
            ),
            _TaskCard(
              title: 'Feedback da reunião',
              description: 'Registrar feedback dos candidatos entrevistados',
              dueDate: '26/04',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Candidatos recentes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Candidatos Recentes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(color: Color(0xFF26A69A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CandidateCard(
              name: 'Rafael Silva',
              position: 'Desenvolvedor Flutter',
              matchPercentage: 92,
              onTap: () {},
            ),
            _CandidateCard(
              name: 'Ana Costa',
              position: 'UX Designer',
              matchPercentage: 88,
              onTap: () {},
            ),
            _CandidateCard(
              name: 'Carlos Eduardo',
              position: 'Gerente de Projetos',
              matchPercentage: 75,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// Tab de Candidatos
class CandidatesTab extends StatelessWidget {
  const CandidatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar candidatos',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    String.fromCharCode(65 + (index % 26)),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                title: Text('Candidato ${index + 1}'),
                subtitle: Text('Posição ${(index % 5) + 1}'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

// Tab de Vagas
class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar vagas',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF26A69A),
                child: const Icon(Icons.add),
                onPressed: () {
                  // Adicionar nova vaga
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vaga ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index % 3 == 0)
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (index % 3 == 0) ? 'Ativa' : 'Em análise',
                              style: TextStyle(
                                color:
                                    (index % 3 == 0)
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Localização: São Paulo, SP',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tipo: ${(index % 2 == 0) ? 'Tempo integral' : 'Meio período'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Candidatos: ${(index + 1) * 3}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Editar'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Ver candidatos'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Tab de Perfil
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF26A69A),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Maria Oliveira',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Recrutadora Senior',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Text(
            'XYZ Recursos Humanos',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _ProfileMenuCard(
            icon: Icons.person_outline,
            title: 'Editar dados pessoais',
            onTap: () {},
          ),
          _ProfileMenuCard(
            icon: Icons.business,
            title: 'Informações da empresa',
            onTap: () {},
          ),
          _ProfileMenuCard(
            icon: Icons.lock_outline,
            title: 'Alterar senha',
            onTap: () {},
          ),
          _ProfileMenuCard(
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            onTap: () {},
          ),
          _ProfileMenuCard(
            icon: Icons.help_outline,
            title: 'Ajuda e suporte',
            onTap: () {},
          ),
          _ProfileMenuCard(
            icon: Icons.info_outline,
            title: 'Sobre o aplicativo',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Fazer logout
                final authViewModel = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                authViewModel.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sair da conta'),
            ),
          ),
        ],
      ),
    );
  }
}

// Widgets auxiliares

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _StatisticCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String dueDate;
  final VoidCallback onTap;

  const _TaskCard({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF26A69A).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.task, color: Color(0xFF26A69A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              'Prazo: $dueDate',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final String name;
  final String position;
  final int matchPercentage;
  final VoidCallback onTap;

  const _CandidateCard({
    required this.name,
    required this.position,
    required this.matchPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            name.substring(0, 1),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(position),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$matchPercentage%',
              style: TextStyle(
                color:
                    matchPercentage > 85
                        ? Colors.green
                        : matchPercentage > 70
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Match',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF26A69A)),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
