import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_card.dart';
import '../api/repository/viewmodel/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFF26A69A),
        elevation: 0,
        title: const Text(
          'DataClick',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed:
                () => _showMenuOptions(context, isDarkMode, authViewModel),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(isDarkMode, authViewModel),
          const Placeholder(),
          const Placeholder(),
          const Placeholder(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  Widget _buildHomeContent(bool isDarkMode, AuthViewModel authViewModel) {
    return Column(
      children: [
        const SizedBox(height: 30),
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
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
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
            color: isDarkMode ? Colors.white70 : Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24.0),
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
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: [
                      MenuCard(
                        title: 'Eventos',
                        subtitle: 'Gerenciar eventos',
                        icon: Icons.event,
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.pushNamed(context, '/eventos');
                        },
                      ),
                      MenuCard(
                        title: 'Perfil',
                        subtitle: 'Gerencie suas informações',
                        icon: Icons.person,
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
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
                        title: 'Sair',
                        subtitle: 'Encerrar sessão',
                        icon: Icons.exit_to_app,
                        color: Colors.redAccent,
                        onTap: () {
                          _showLogoutDialog(context, authViewModel);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
              _buildNavBarItem(
                Icons.home,
                'Home',
                _currentIndex == 0,
                isDarkMode,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _buildNavBarItem(
                Icons.event,
                'Eventos',
                _currentIndex == 1,
                isDarkMode,
                onTap: () {
                  setState(() => _currentIndex = 1);
                  Navigator.pushNamed(context, '/eventos');
                },
              ),
              _buildNavBarItem(
                Icons.settings,
                'Configurações',
                _currentIndex == 2,
                isDarkMode,
                onTap: () {
                  setState(() => _currentIndex = 2);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              _buildNavBarItem(
                Icons.person,
                'Perfil',
                _currentIndex == 3,
                isDarkMode,
                onTap: () {
                  setState(() => _currentIndex = 3);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
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
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
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

  void _showMenuOptions(
    BuildContext context,
    bool isDarkMode,
    AuthViewModel authViewModel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF26A69A),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                context,
                Icons.event,
                'Eventos',
                '/eventos',
                isDarkMode: isDarkMode,
              ),
              _buildMenuOption(
                context,
                Icons.person,
                'Perfil',
                '/profile',
                isDarkMode: isDarkMode,
              ),
              _buildMenuOption(
                context,
                Icons.settings,
                'Configurações',
                '/settings',
                isDarkMode: isDarkMode,
              ),
              _buildMenuOption(
                context,
                Icons.exit_to_app,
                'Sair',
                '/login',
                isLogout: true,
                isDarkMode: isDarkMode,
                authViewModel: authViewModel,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    bool isLogout = false,
    bool isDarkMode = false,
    AuthViewModel? authViewModel,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isLogout
                ? Colors.red
                : isDarkMode
                ? Colors.white70
                : const Color(0xFF26A69A),
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isLogout
                  ? Colors.red
                  : isDarkMode
                  ? Colors.white
                  : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _showLogoutDialog(context, authViewModel!);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do aplicativo'),
          content: const Text('Tem certeza que deseja encerrar sua sessão?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                authViewModel.logout();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sim, sair'),
            ),
          ],
        );
      },
    );
  }
}
