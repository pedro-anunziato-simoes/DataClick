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

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient(http.Client())),
        Provider<AdministradorService>(
          create: (context) => AdministradorService(context.read<ApiClient>()),
        ),
        Provider<FormularioService>(
          create: (context) => FormularioService(context.read<ApiClient>()),
        ),
        Provider<CampoService>(
          create: (context) => CampoService(context.read<ApiClient>()),
        ),
        Provider<RecrutadorService>(
          create: (context) => RecrutadorService(context.read<ApiClient>()),
        ),
        Provider<RespostaService>(
          create: (context) => RespostaService(context.read<ApiClient>()),
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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/forms': (context) => const FormsScreen(),
        '/create-form': (context) => const CreateFormScreen(),
      },
      builder: (context, child) {
        return child!;
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF26A69A),
      scaffoldBackgroundColor: const Color(0xFF26A69A),
      fontFamily: 'SfProDisplay',
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
        secondary: const Color(0xFF00796B),
        error: const Color(0xFFC5032B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF26A69A),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SfProDisplay',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        errorStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF26A69A),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
