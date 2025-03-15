import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showMenuOptions(context);
            },
            child: const Text('Menu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          const LogoWidget(),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 3.5,
                mainAxisSpacing: 16.0,
                children: [
                  MenuCard(
                    title: 'Perfil',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  MenuCard(
                    title: 'Formulários',
                    onTap: () {
                      Navigator.pushNamed(context, '/forms');
                    },
                  ),
                  MenuCard(title: 'Configurações', onTap: () {}),
                  MenuCard(
                    title: 'Sair',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
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
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xFF26A69A),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuCard(
                  title: 'Perfil',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                const SizedBox(height: 16),
                MenuCard(
                  title: 'Formulários',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/forms');
                  },
                ),
                const SizedBox(height: 16),
                MenuCard(
                  title: 'Configurações',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                MenuCard(
                  title: 'Sair',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
