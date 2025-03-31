import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'api/api_client.dart';
import 'api/services/formulario_service.dart';
import 'api/services/administrador_service.dart';
import 'api/services/campo_service.dart';
import 'api/services/recrutador_service.dart';
import 'api/services/resposta_service.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/forms_screen.dart';
import 'screens/form_create_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<ApiClient>(
          create: (context) => ApiClient(context.read<http.Client>()),
        ),
        ProxyProvider<ApiClient, AdministradorService>(
          update: (_, apiClient, __) => AdministradorService(apiClient),
        ),
        ProxyProvider<ApiClient, FormularioService>(
          update: (_, apiClient, __) => FormularioService(apiClient),
        ),
        ProxyProvider<ApiClient, CampoService>(
          update: (_, apiClient, __) => CampoService(apiClient),
        ),
        ProxyProvider<ApiClient, RecrutadorService>(
          update: (_, apiClient, __) => RecrutadorService(apiClient),
        ),
        ProxyProvider<ApiClient, RespostaService>(
          update: (_, apiClient, __) => RespostaService(apiClient),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Click',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      initialRoute: '/login',
      routes: _buildAppRoutes(),
      onUnknownRoute:
          (settings) =>
              MaterialPageRoute(builder: (context) => const LoginScreen()),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/login': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/forms': (context) => const FormsScreen(),
      '/create-form': (context) => const CreateFormScreen(),
      '/settings': (context) => const SettingsScreen(),
    };
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF26A69A),
      scaffoldBackgroundColor: const Color(0xFF26A69A),
      fontFamily: 'SfProDisplay',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF26A69A),
        brightness: Brightness.light,
        secondary: const Color(0xFF00796B),
        error: const Color(0xFFC5032B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF26A69A),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'SfProDisplay',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.lerp(Colors.white, Colors.transparent, 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black38),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF26A69A),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentTextStyle: const TextStyle(fontFamily: 'SfProDisplay'),
        backgroundColor: const Color(0xFF333333),
        actionTextColor: const Color(0xFF26A69A),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
