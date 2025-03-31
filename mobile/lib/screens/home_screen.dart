import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        title: const Text(
          'DataClick',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showMenuOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Hero(
            tag: 'logo',
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
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                children: [
                  MenuCard(
                    title: 'Perfil',
                    icon: Icons.person,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  MenuCard(
                    title: 'Formulários',
                    icon: Icons.list_alt,
                    color: Colors.greenAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/forms');
                    },
                  ),
                  MenuCard(
                    title: 'Configurações',
                    icon: Icons.settings,
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/settings',
                      ); // Corrigido aqui
                    },
                  ),
                  MenuCard(
                    title: 'Sair',
                    icon: Icons.exit_to_app,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/login',
                      ); // Melhor para '/login'
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26A69A),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(context, Icons.person, 'Perfil', '/profile'),
              _buildMenuOption(
                context,
                Icons.list_alt,
                'Formulários',
                '/forms',
              ),
              _buildMenuOption(
                context,
                Icons.settings,
                'Configurações',
                '/settings', // Corrigido aqui
              ),
              _buildMenuOption(
                context,
                Icons.exit_to_app,
                'Sair',
                '/login', // Melhor para '/login'
                isLogout: true,
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
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : const Color(0xFF26A69A),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
