import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/models/user.dart';
import 'package:mobile/api/models/administrador.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/administrador_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/request_state.dart';

const Color corPrimariaPreto = Color(0xFF131515);
const Color corPrimariaBrancoGelo = Color(0xFFFFFAFB);
const Color corNeutraCinzaEscuro = Color(0xFF2B2C28);
const Color corNeutraVerdeAguaEscuro = Color(0xFF339989);
const Color corSemanticaAzul = Color(0xFF7DE2D1);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;
  late TextEditingController cnpjController;

  bool isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController.forward();

    nomeController = TextEditingController();
    emailController = TextEditingController();
    telefoneController = TextEditingController();
    cnpjController = TextEditingController();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAdministradorInfo();
      });
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    cnpjController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final administradorViewModel = Provider.of<AdministradorViewModel>(
      context,
      listen: false,
    );
    if (administradorViewModel.administrador == null) {
      administradorViewModel.carregarAdministradorInfo();
    }
  }

  Future<void> _loadAdministradorInfo() async {
    final administradorViewModel = Provider.of<AdministradorViewModel>(
      context,
      listen: false,
    );
    await administradorViewModel.carregarAdministradorInfo();
    final administrador = administradorViewModel.administrador;
    if (administrador != null && mounted) {
      setState(() {
        nomeController.text = administrador.nome;
        emailController.text = administrador.email;
        telefoneController.text = administrador.telefone;
        cnpjController.text = administrador.cnpj;
      });
    }
  }

  Future<void> saveProfile() async {
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      final administradorViewModel = Provider.of<AdministradorViewModel>(
        context,
        listen: false,
      );
      final success = await administradorViewModel.atualizarPerfil(
        nome: nomeController.text,
        email: emailController.text,
        telefone: telefoneController.text,
        cnpj: cnpjController.text,
      );
      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(child: Text('Perfil atualizado com sucesso!')),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        setState(() {
          isEditing = false;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    administradorViewModel.state is ErrorState
                        ? (administradorViewModel.state as ErrorState).message
                        : 'Erro ao atualizar perfil',
                  ),
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
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Excluir Conta',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Funcionalidade em desenvolvimento'),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final administradorViewModel = Provider.of<AdministradorViewModel>(context);
    final administrador = administradorViewModel.administrador;
    final state = administradorViewModel.state;

    // Atualiza os controllers sempre que o admin for carregado
    if (administrador != null) {
      nomeController.text = administrador.nome;
      emailController.text = administrador.email;
      telefoneController.text = administrador.telefone;
      cnpjController.text = administrador.cnpj;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
            ),
          ),
        ),
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'edit':
                  setState(() => isEditing = !isEditing);
                  break;
                case 'logout':
                  final authViewModel = Provider.of<AuthViewModel>(
                    context,
                    listen: false,
                  );
                  await authViewModel.logout();
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                  break;
                case 'delete':
                  _showDeleteAccountDialog();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          isEditing ? Icons.save_rounded : Icons.edit_rounded,
                          size: 20,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEditing ? 'Salvar' : 'Editar',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Sair',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        const Text(
                          'Excluir Conta',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: () {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(
              child: Text(
                (state as ErrorState).message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else if (administrador == null || nomeController.text.isEmpty) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileHeaderModern(administrador),
                  const SizedBox(height: 24),
                  _buildProfileFormModern(),
                ],
              ),
            );
          }
        }(),
      ),
    );
  }

  Widget _buildProfileHeaderModern(Administrador? administrador) {
    final displayName = administrador?.nome ?? 'Administrador';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/images/Logo DataClick.jpg',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF26A69A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFormModern() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildProfileTextField(
              controller: nomeController,
              label: 'Nome',
              icon: Icons.person,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            _buildProfileTextField(
              controller: emailController,
              label: 'E-mail',
              icon: Icons.email,
              enabled: false,
            ),
            const SizedBox(height: 16),
            _buildProfileTextField(
              controller: telefoneController,
              label: 'Telefone',
              icon: Icons.phone,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            _buildProfileTextField(
              controller: cnpjController,
              label: 'CNPJ',
              icon: Icons.badge,
              enabled: isEditing,
            ),
            const SizedBox(height: 24),
            if (isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Salvar Alterações'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF26A69A)),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (label == 'Nome' && (value == null || value.isEmpty)) {
          return 'Informe seu nome';
        }
        if (label == 'Telefone' && (value == null || value.isEmpty)) {
          return 'Informe seu telefone';
        }
        if (label == 'CNPJ' && (value == null || value.isEmpty)) {
          return 'Informe seu CNPJ';
        }
        return null;
      },
    );
  }
}
