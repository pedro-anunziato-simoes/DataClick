import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_client.dart';
import 'api/services/formulario_service.dart';
import 'api/services/administrador_service.dart';
import 'api/services/campo_service.dart';
import 'api/services/recrutador_service.dart';
import 'api/services/auth_service.dart';

import 'api/repository/viewmodel/forms_viewmodel.dart';
import 'api/repository/viewmodel/auth_viewmodel.dart';
import 'api/repository/forms_repository.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/forms_screen.dart';
import 'screens/form_create_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_campo_screen.dart';
import 'screens/edit_campo_screen.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  runApp(
    MultiProvider(
      providers: _buildProviders(sharedPreferences, httpClient),
      child: const MyApp(),
    ),
  );
}

List<SingleChildWidget> _buildProviders(
  SharedPreferences sharedPreferences,
  http.Client httpClient,
) {
  return [
    Provider<SharedPreferences>.value(value: sharedPreferences),
    Provider<http.Client>.value(value: httpClient),

    Provider<ApiClient>(
      create:
          (context) => ApiClient(
            context.read<http.Client>(),
            context.read<SharedPreferences>(),
          ),
    ),

    ProxyProvider2<ApiClient, SharedPreferences, AuthService>(
      update:
          (_, apiClient, sharedPrefs, __) =>
              AuthService(apiClient, sharedPrefs),
    ),
    ProxyProvider<ApiClient, AdministradorService>(
      update: (_, apiClient, __) => AdministradorService(apiClient),
    ),
    // Corrigido para ProxyProvider2 para incluir AuthService como segundo argumento
    ProxyProvider2<ApiClient, AuthService, FormularioService>(
      update:
          (_, apiClient, authService, __) =>
              FormularioService(apiClient, authService),
    ),
    ProxyProvider<ApiClient, CampoService>(
      update: (_, apiClient, __) => CampoService(apiClient),
    ),
    ProxyProvider<ApiClient, RecrutadorService>(
      update: (_, apiClient, __) => RecrutadorService(apiClient),
    ),

    ProxyProvider<FormularioService, FormularioRepository>(
      update: (_, service, __) => FormularioRepository(service),
    ),

    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(context.read<AuthService>()),
    ),

    ChangeNotifierProxyProvider<FormularioRepository, FormViewModel>(
      create: (context) => FormViewModel(context.read<FormularioRepository>()),
      update: (_, repo, __) => FormViewModel(repo),
    ),
  ];
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
        '/settings': (context) => const SettingsScreen(),
        '/forms':
            (context) => FormsScreen(
              formularioService: context.read<FormularioService>(),
              campoService: context.read<CampoService>(),
              isAdmin: context.read<AuthViewModel>().currentUser != null,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create-form') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder:
                (context) => CreateFormScreen(
                  formularioExistente: args?['formularioExistente'],
                  formularioService: context.read<FormularioService>(),
                ),
          );
        }

        if (settings.name == '/add-campo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => AddCampoScreen(
                  formId: args['formId'],
                  campoService: context.read<CampoService>(),
                ),
          );
        }

        if (settings.name == '/edit-campo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => EditCampoScreen(
                  campo: args['campo'],
                  formId: args['formId'],
                  campoService: context.read<CampoService>(),
                ),
          );
        }

        return null;
      },
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
