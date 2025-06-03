import 'package:flutter/material.dart';
import 'package:mobile/screens/criareventos.dart';
import 'package:mobile/screens/eventos_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_client.dart';
import 'api/services/formulario_service.dart';
import 'api/services/administrador_service.dart';
import 'api/services/campo_service.dart';
import 'api/services/recrutador_service.dart';
import 'api/services/auth_service.dart';
import 'api/services/event_service.dart';

import 'api/repository/viewmodel/forms_viewmodel.dart';
import 'api/repository/viewmodel/auth_viewmodel.dart';
import 'api/repository/viewmodel/recrutador_viewmodel.dart';
import 'api/repository/viewmodel/event_viewmodel.dart';
import 'api/repository/forms_repository.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/forms_screen.dart';
import 'screens/form_create_screen.dart';
import 'screens/recrutadorregisterscreen.dart';
import 'screens/settings_screen.dart';
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
      create: (context) => ApiClient(httpClient, sharedPreferences),
    ),
    ProxyProvider<ApiClient, AuthService>(
      update: (_, apiClient, __) => AuthService(apiClient, sharedPreferences),
    ),
    ProxyProvider<ApiClient, FormularioService>(
      update: (_, apiClient, __) => FormularioService(apiClient),
    ),
    ProxyProvider<ApiClient, AdministradorService>(
      update: (_, apiClient, __) => AdministradorService(apiClient),
    ),
    ProxyProvider<ApiClient, CampoService>(
      update: (_, apiClient, __) => CampoService(apiClient),
    ),
    ProxyProvider<ApiClient, RecrutadorService>(
      update: (_, apiClient, __) => RecrutadorService(apiClient),
    ),
    ProxyProvider<ApiClient, EventService>(
      update: (_, apiClient, __) => EventService(apiClient),
    ),
    ProxyProvider<FormularioService, FormularioRepository>(
      update: (_, service, __) => FormularioRepository(service),
    ),
    ChangeNotifierProxyProvider2<AuthService, RecrutadorService, AuthViewModel>(
      create:
          (context) => AuthViewModel(
            authService: context.read<AuthService>(),
            recrutadorService: context.read<RecrutadorService>(),
          ),
      update:
          (context, authService, recrutadorService, authViewModel) =>
              authViewModel ??
              AuthViewModel(
                authService: authService,
                recrutadorService: recrutadorService,
              ),
    ),
    ChangeNotifierProxyProvider<RecrutadorService, RecrutadorViewModel>(
      create:
          (context) => RecrutadorViewModel(context.read<RecrutadorService>()),
      update: (_, service, __) => RecrutadorViewModel(service),
    ),
    ChangeNotifierProxyProvider<FormularioRepository, FormViewModel>(
      create: (context) => FormViewModel(context.read<FormularioRepository>()),
      update: (_, repo, __) => FormViewModel(repo),
    ),
    ChangeNotifierProxyProvider2<EventService, AuthViewModel, EventViewModel>(
      create:
          (context) => EventViewModel(
            context.read<EventService>(),
            context.read<AuthViewModel>(),
          ),
      update:
          (context, eventService, authViewModel, eventViewModel) =>
              eventViewModel ?? EventViewModel(eventService, authViewModel),
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
        '/eventos': (context) => const EventosScreen(),
        '/criar-evento': (context) => const CriarEventoScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/recrutador/register': (context) => const RecrutadorRegisterScreen(),
        '/forms':
            (context) => FormsScreen(
              formularioService: context.read<FormularioService>(),
              campoService: context.read<CampoService>(),
              isAdmin:
                  context.read<AuthViewModel>().currentUser?.tipo == 'admin',
              eventoId: '',
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create-form') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder:
                (context) => FormularioScreen(
                  formularioExistente: args?['formularioExistente'],
                  formularioService: context.read<FormularioService>(),
                  campoService: context.read<CampoService>(),
                  eventoId: args?['eventoId'] ?? '',
                ),
          );
        }

        if (settings.name == '/add-campo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => FormularioScreen(
                  formIdForAddCampo: args['formId'],
                  campoService: context.read<CampoService>(),
                  formularioService: context.read<FormularioService>(),
                  isEditingCampo: false,
                  eventoId: args['eventoId'] ?? '',
                ),
          );
        }

        if (settings.name == '/edit-campo') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => FormularioScreen(
                  campoToEdit: args['campo'],
                  formIdForAddCampo: args['formId'],
                  campoService: context.read<CampoService>(),
                  formularioService: context.read<FormularioService>(),
                  isEditingCampo: true,
                  eventoId: args['eventoId'] ?? '',
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
        fillColor: Colors.white.withAlpha(
          229,
        ), // Equivalent to withOpacity(0.9)
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
