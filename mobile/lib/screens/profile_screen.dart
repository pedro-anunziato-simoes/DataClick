import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/models/user.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';

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

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final User? currentUser = authViewModel.currentUser;

    nomeController = TextEditingController(text: currentUser?.nome ?? '');
    emailController = TextEditingController(text: currentUser?.email ?? '');
    telefoneController = TextEditingController(
      text: currentUser?.telefone ?? '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    if (!mounted) return;

    if (formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      try {
        await authViewModel.updateProfile(
          nome: nomeController.text,
          email: emailController.text,
          telefone: telefoneController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Perfil atualizado com sucesso!',
              style: TextStyle(fontFamily: 'SfProDisplay'),
            ),
            backgroundColor: corNeutraVerdeAguaEscuro,
          ),
        );

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao atualizar perfil: ${e.toString()}',
              style: const TextStyle(fontFamily: 'SfProDisplay'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUser = authViewModel.currentUser;
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    if (!isEditing) {
      nomeController.text = currentUser?.nome ?? '';
      emailController.text = currentUser?.email ?? '';
      telefoneController.text = currentUser?.telefone ?? '';
    }

    return Scaffold(
      backgroundColor: corNeutraVerdeAguaEscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Meu Perfil',
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            color: corPrimariaBrancoGelo,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: corPrimariaBrancoGelo),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save_outlined, color: corPrimariaBrancoGelo),
              onPressed: saveProfile,
            )
          else
            IconButton(
              icon: Icon(Icons.edit_outlined, color: corPrimariaBrancoGelo),
              onPressed: () => setState(() => isEditing = true),
            ),
          IconButton(
            icon: Icon(Icons.logout_outlined, color: corPrimariaBrancoGelo),
            onPressed: () async {
              await authViewModel.logout();
              // Fix: Check if mounted before accessing context after async call
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.02),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: screenSize.width * 0.15,
                  backgroundColor: corPrimariaBrancoGelo,
                  child: CircleAvatar(
                    radius: screenSize.width * 0.145,
                    backgroundImage: const AssetImage(
                      'assets/images/Logo DataClick.jpg',
                    ),
                  ),
                ),
                if (isEditing)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Trocar foto (A Implementar)',
                              style: TextStyle(fontFamily: 'SfProDisplay'),
                            ),
                          ),
                        );
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: corSemanticaAzul,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: screenSize.width * 0.05,
                          color: corPrimariaPreto,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            currentUser?.nome ?? 'Nome do Usuário',
            style: TextStyle(
              fontFamily: 'SfProDisplay',
              fontSize: screenSize.width * 0.055,
              fontWeight: FontWeight.bold,
              color: corPrimariaBrancoGelo,
            ),
          ),
          Text(
            authViewModel.isAdmin ? 'Administrador' : 'Recrutador',
            style: TextStyle(
              fontFamily: 'SfProDisplay',
              fontSize: screenSize.width * 0.04,
              color: corSemanticaAzul,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenSize.height * 0.03),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.06,
                vertical: screenSize.height * 0.03,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildProfileField(
                        label: 'Nome Completo',
                        controller: nomeController,
                        icon: Icons.person_outline,
                        enabled: isEditing,
                        theme: theme,
                        screenSize: screenSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.025),
                      buildProfileField(
                        label: 'E-mail',
                        controller: emailController,
                        icon: Icons.email_outlined,
                        enabled: isEditing,
                        keyboardType: TextInputType.emailAddress,
                        theme: theme,
                        screenSize: screenSize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu e-mail';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Insira um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.025),
                      buildProfileField(
                        label: 'Telefone',
                        controller: telefoneController,
                        icon: Icons.phone_outlined,
                        enabled: isEditing,
                        keyboardType: TextInputType.phone,
                        theme: theme,
                        screenSize: screenSize,
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      if (isEditing)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corSemanticaAzul,
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Salvar Alterações',
                              style: TextStyle(
                                fontFamily: 'SfProDisplay',
                                color: corPrimariaPreto,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: screenSize.height * 0.02),
                      if (authViewModel.isAdmin)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Excluir conta (A Implementar)',
                                    style: TextStyle(
                                      fontFamily: 'SfProDisplay',
                                    ),
                                  ),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              );
                            },
                            child: Text(
                              'Excluir Minha Conta',
                              style: TextStyle(
                                fontFamily: 'SfProDisplay',
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    required ThemeData theme,
    required Size screenSize,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: screenSize.width * 0.038,
            fontWeight: FontWeight.w600,
            color: Color.alphaBlend(
              theme.colorScheme.onSurface.withAlpha(204),
              Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.008),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            color: enabled ? theme.colorScheme.onSurface : theme.hintColor,
            fontSize: screenSize.width * 0.042,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color:
                  enabled
                      ? theme.colorScheme.primary
                      : Color.alphaBlend(
                        theme.hintColor.withAlpha(179),
                        Colors.white,
                      ),
              size: screenSize.width * 0.055,
            ),
            filled: true,
            fillColor:
                enabled
                    ? theme.cardColor
                    : Color.alphaBlend(
                      theme.disabledColor.withAlpha(12),
                      Colors.white,
                    ),
            contentPadding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.018,
              horizontal: screenSize.width * 0.04,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.alphaBlend(
                  theme.dividerColor.withAlpha(127),
                  Colors.white,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.alphaBlend(
                  theme.dividerColor.withAlpha(127),
                  Colors.white,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
