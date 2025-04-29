import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final screenSize = mediaQuery.size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isSmallScreen = screenSize.width < 360;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFF26A69A),
      appBar: _buildAppBar(context, isDarkMode),
      drawer: _buildDrawer(context, isDarkMode, authViewModel),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildHeader(isDarkMode),
          const SizedBox(height: 24),
          _buildSearchBar(isDarkMode),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 24.0,
                vertical: 24.0,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Principal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child:
                        _isSearching && _searchController.text.isNotEmpty
                            ? _buildSearchResults(
                              isDarkMode,
                              isPortrait,
                              isSmallScreen,
                            )
                            : _buildMenuGrid(
                              isDarkMode,
                              isPortrait,
                              isSmallScreen,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text(
        'DataClick',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _showNotifications(context),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Hero(
            tag: 'logo',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/Logo DataClick.jpg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bem-vindo ao DataClick',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'O que você deseja fazer hoje?',
            style: TextStyle(
              fontSize: 14,
              color:
                  isDarkMode ? Colors.white70 : Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _isSearching = value.isNotEmpty;
            });
          },
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: 'Pesquisar...',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.grey[400] : const Color(0xFF26A69A),
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _isSearching = false;
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(bool isDarkMode, bool isPortrait, bool isSmallScreen) {
    final crossAxisCount = isPortrait ? (isSmallScreen ? 1 : 2) : 3;

    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      childAspectRatio: isSmallScreen ? 2.5 : 1.3,
      children: [
        MenuCard(
          title: 'Perfil',
          subtitle: 'Gerencie suas informações',
          icon: Icons.person,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        MenuCard(
          title: 'Formulários',
          subtitle: 'Acesse seus dados',
          icon: Icons.list_alt,
          color: Colors.greenAccent,
          onTap: () {
            Navigator.pushNamed(context, '/forms');
          },
        ),
        MenuCard(
          title: 'Estatísticas',
          subtitle: 'Visualize seus dados',
          icon: Icons.bar_chart,
          color: Colors.purpleAccent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
            );
          },
        ),
        MenuCard(
          title: 'Configurações',
          subtitle: 'Personalize o app',
          icon: Icons.settings,
          color: Colors.orangeAccent,
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        MenuCard(
          title: 'Ajuda',
          subtitle: 'Tire suas dúvidas',
          icon: Icons.help_outline,
          color: Colors.tealAccent,
          onTap: () {
            Navigator.pushNamed(context, '/help');
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults(
    bool isDarkMode,
    bool isPortrait,
    bool isSmallScreen,
  ) {
    final String searchTerm = _searchController.text.toLowerCase();
    final List<Map<String, dynamic>> allItems = [
      {
        'title': 'Perfil',
        'subtitle': 'Gerencie suas informações',
        'icon': Icons.person,
        'color': Colors.blueAccent,
        'route': '/profile',
      },
      {
        'title': 'Formulários',
        'subtitle': 'Acesse seus dados',
        'icon': Icons.list_alt,
        'color': Colors.greenAccent,
        'route': '/forms',
      },
      {
        'title': 'Estatísticas',
        'subtitle': 'Visualize seus dados',
        'icon': Icons.bar_chart,
        'color': Colors.purpleAccent,
        'route': '/statistics',
      },
      {
        'title': 'Configurações',
        'subtitle': 'Personalize o app',
        'icon': Icons.settings,
        'color': Colors.orangeAccent,
        'route': '/settings',
      },
      {
        'title': 'Ajuda',
        'subtitle': 'Tire suas dúvidas',
        'icon': Icons.help_outline,
        'color': Colors.tealAccent,
        'route': '/help',
      },
    ];

    final List<Map<String, dynamic>> filteredItems =
        allItems
            .where(
              (item) =>
                  item['title'].toLowerCase().contains(searchTerm) ||
                  item['subtitle'].toLowerCase().contains(searchTerm),
            )
            .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final crossAxisCount = isPortrait ? (isSmallScreen ? 1 : 2) : 3;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: isSmallScreen ? 2.5 : 1.3,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return MenuCard(
          title: item['title'],
          subtitle: item['subtitle'],
          icon: item['icon'],
          color: item['color'],
          onTap: () {
            Navigator.pushNamed(context, item['route']);
          },
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    bool isDarkMode,
    AuthViewModel authViewModel,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Drawer(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF26A69A),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF26A69A),
                  ),
                ),
                accountName: Text(
                  authViewModel.currentUser?.nome ?? 'Usuário DataClick',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  authViewModel.currentUser?.email ?? 'usuario@dataclick.com',
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF26A69A),
                ),
                title: Text(
                  'Perfil',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF26A69A),
                ),
                title: Text(
                  'Formulários',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/forms');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.bar_chart,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF26A69A),
                ),
                title: Text(
                  'Estatísticas',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF26A69A),
                ),
                title: Text(
                  'Configurações',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF26A69A),
                ),
                title: Text(
                  'Ajuda',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/help');
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: isDarkMode ? Colors.redAccent : Colors.redAccent,
                ),
                title: Text(
                  'Sair',
                  style: TextStyle(
                    color: isDarkMode ? Colors.redAccent : Colors.redAccent,
                  ),
                ),
                onTap: () {
                  authViewModel.logout();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(Icons.home, 'Home', true, isDarkMode),
              _buildNavBarItem(
                Icons.list_alt,
                'Formulários',
                false,
                isDarkMode,
              ),
              _buildNavBarItem(
                Icons.bar_chart,
                'Estatísticas',
                false,
                isDarkMode,
              ),
              _buildNavBarItem(Icons.person, 'Perfil', false, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
    IconData icon,
    String label,
    bool isSelected,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () {
        if (label != 'Home') {
          final route =
              label == 'Perfil'
                  ? '/profile'
                  : label == 'Formulários'
                  ? '/forms'
                  : '/statistics';
          if (route == '/statistics') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
            );
          } else {
            Navigator.pushNamed(context, route);
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? const Color(0xFF26A69A)
                    : isDarkMode
                    ? Colors.grey[600]
                    : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isSelected
                      ? const Color(0xFF26A69A)
                      : isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notificações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(child: _buildNotificationsList(isDarkMode)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList(bool isDarkMode) {
    List<Map<String, dynamic>> notifications = [
      {
        'title': 'Novo formulário disponível',
        'message': 'Um novo formulário de pesquisa foi adicionado.',
        'time': '10 min atrás',
        'icon': Icons.description,
        'color': Colors.blue,
        'read': false,
      },
      {
        'title': 'Atualização de perfil',
        'message': 'Suas informações de perfil foram atualizadas com sucesso.',
        'time': '1 hora atrás',
        'icon': Icons.person,
        'color': Colors.green,
        'read': true,
      },
      {
        'title': 'Lembrete',
        'message': 'Não se esqueça de completar o formulário pendente.',
        'time': '3 horas atrás',
        'icon': Icons.alarm,
        'color': Colors.orange,
        'read': false,
      },
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 48,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma notificação',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: notification['color'].withOpacity(0.2),
            child: Icon(notification['icon'], color: notification['color']),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight:
                  notification['read'] ? FontWeight.normal : FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification['message'],
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing:
              !notification['read']
                  ? Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF26A69A),
                      shape: BoxShape.circle,
                    ),
                  )
                  : null,
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: const Color(0xFF26A69A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.work,
                    color: Colors.blue,
                    title: 'Formulários',
                    value: '12',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.person_search,
                    color: Colors.orange,
                    title: 'Respostas',
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
                    title: 'Completos',
                    value: '36',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.flag,
                    color: Colors.purple,
                    title: 'Pendentes',
                    value: '12',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Atividade Recente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Gráfico de Atividades',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Formulários Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _FormCard(
              title: 'Pesquisa de Satisfação',
              description: '25 respostas coletadas',
              date: 'Hoje',
              onTap: () {},
            ),
            _FormCard(
              title: 'Avaliação de Desempenho',
              description: '15 respostas coletadas',
              date: 'Ontem',
              onTap: () {},
            ),
            _FormCard(
              title: 'Feedback do Produto',
              description: '8 respostas coletadas',
              date: '26/04',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

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

class _FormCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final VoidCallback onTap;

  const _FormCard({
    required this.title,
    required this.description,
    required this.date,
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
          child: const Icon(Icons.list_alt, color: Color(0xFF26A69A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              'Última atualização: $date',
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
