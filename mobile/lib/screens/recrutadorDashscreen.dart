import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/api/repository/viewmodel/auth_viewmodel.dart';
import 'package:mobile/api/repository/viewmodel/forms_viewmodel.dart';
import 'package:mobile/api/models/formulario.dart';

const Color corPrimariaPreto = Color(0xFF131515);
const Color corPrimariaBrancoGelo = Color(0xFFFFFAFB);
const Color corNeutraCinzaEscuro = Color(0xFF2B2C28);
const Color corNeutraVerdeAguaEscuro = Color(0xFF339989);
const Color corSemanticaAzul = Color(0xFF7DE2D1);

class RecruiterDashboardScreen extends StatefulWidget {
  final String eventoId;
  const RecruiterDashboardScreen({super.key, required this.eventoId});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FormViewModel>(
          context,
          listen: false,
        ).carregarFormulariosPorEvento(widget.eventoId);
      }
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final formViewModel = Provider.of<FormViewModel>(context);
    final screenSize = MediaQuery.of(context).size;

    final List<Widget> screens = [
      buildHomeScreen(formViewModel, authViewModel, screenSize),
      const CandidatesTab(key: Key('candidates_tab')),
      const JobsTab(key: Key('jobs_tab')),
      const ProfileTab(key: Key('profile_tab')),
    ];

    return Scaffold(
      backgroundColor: corPrimariaBrancoGelo,
      appBar: AppBar(
        backgroundColor: corNeutraVerdeAguaEscuro,
        elevation: 2,
        title: Text(
          'Dashboard do Recrutador',
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            color: corPrimariaBrancoGelo,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          if (selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh, color: corPrimariaBrancoGelo),
              onPressed:
                  () => formViewModel.carregarFormulariosPorEvento(
                    widget.eventoId,
                  ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: corPrimariaBrancoGelo),
            onPressed: () async {
              await authViewModel.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: selectedIndex, children: screens),
      floatingActionButton:
          selectedIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () => showNotImplementedMessage(context),
                backgroundColor: corSemanticaAzul,
                icon: const Icon(Icons.add, color: corPrimariaPreto),
                label: Text(
                  'Novo Formulário',
                  style: TextStyle(
                    fontFamily: 'SfProDisplay',
                    color: corPrimariaPreto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: corNeutraVerdeAguaEscuro,
        unselectedItemColor: corNeutraCinzaEscuro,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Candidatos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Vagas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget buildHomeScreen(
    FormViewModel formViewModel,
    AuthViewModel authViewModel,
    Size screenSize,
  ) {
    if (formViewModel.formularios is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: corSemanticaAzul),
      );
    }

    if (formViewModel.formularios is ErrorState) {
      final error = formViewModel.formularios as ErrorState;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: screenSize.width * 0.15,
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Erro ao carregar formulários',
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: corPrimariaPreto,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                error.message,
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  fontSize: screenSize.width * 0.04,
                  color: corNeutraCinzaEscuro,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenSize.height * 0.03),
              ElevatedButton(
                onPressed:
                    () => formViewModel.carregarFormulariosPorEvento(
                      widget.eventoId,
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: corNeutraVerdeAguaEscuro,
                  foregroundColor: corPrimariaBrancoGelo,
                ),
                child: const Text(
                  'Tentar Novamente',
                  style: TextStyle(fontFamily: 'SfProDisplay'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (formViewModel.formularios is SuccessState<List<Formulario>>) {
      final forms =
          (formViewModel.formularios as SuccessState<List<Formulario>>).data;
      return SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWelcomeHeader(authViewModel, screenSize.width),
            SizedBox(height: screenSize.height * 0.03),
            buildQuickStats(forms, screenSize),
            SizedBox(height: screenSize.height * 0.03),
            Text(
              'Meus Formulários',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.055,
                fontWeight: FontWeight.bold,
                color: corPrimariaPreto,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            forms.isEmpty
                ? buildEmptyStateForms(screenSize)
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: forms.length,
                  itemBuilder: (context, index) {
                    return buildFormCard(forms[index], screenSize);
                  },
                ),
            SizedBox(height: screenSize.height * 0.03),
            buildTasksSection(screenSize),
            SizedBox(height: screenSize.height * 0.03),
            buildCandidatesSection(screenSize),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        'Nenhum formulário para exibir.',
        style: TextStyle(
          fontFamily: 'SfProDisplay',
          fontSize: screenSize.width * 0.04,
          color: corNeutraCinzaEscuro,
        ),
      ),
    );
  }

  Widget buildWelcomeHeader(AuthViewModel authViewModel, double screenWidth) {
    final userName = authViewModel.currentUser?.nome ?? 'Recrutador';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo(a) de volta,',
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: screenWidth * 0.045,
            color: corNeutraCinzaEscuro,
          ),
        ),
        Text(
          userName,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            color: corNeutraVerdeAguaEscuro,
          ),
        ),
      ],
    );
  }

  Widget buildQuickStats(List<Formulario> forms, Size screenSize) {
    final totalForms = forms.length;
    final activeForms = forms.length;
    final formsWithResponses = forms.length;

    return Row(
      children: [
        buildStatCard(
          'Total',
          totalForms.toString(),
          Icons.list_alt,
          corNeutraVerdeAguaEscuro,
          screenSize,
        ),
        SizedBox(width: screenSize.width * 0.03),
        buildStatCard(
          'Ativos',
          activeForms.toString(),
          Icons.play_circle_outline,
          corSemanticaAzul,
          screenSize,
        ),
        SizedBox(width: screenSize.width * 0.03),
        buildStatCard(
          'Com Respostas',
          formsWithResponses.toString(),
          Icons.question_answer_outlined,
          Colors.orangeAccent,
          screenSize,
        ),
      ],
    );
  }

  Widget buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Size screenSize,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color.alphaBlend(color.withAlpha(30), Colors.white),
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: screenSize.width * 0.07, color: color),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: screenSize.height * 0.005),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  fontSize: screenSize.width * 0.03,
                  color: corNeutraCinzaEscuro,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormCard(Formulario form, Size screenSize) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: screenSize.height * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01,
          horizontal: screenSize.width * 0.04,
        ),
        leading: CircleAvatar(
          backgroundColor: Color.alphaBlend(
            corNeutraCinzaEscuro.withAlpha(38),
            Colors.white,
          ),
          child: Icon(
            Icons.description_outlined,
            color: corNeutraCinzaEscuro,
            size: screenSize.width * 0.06,
          ),
        ),
        title: Text(
          form.titulo ?? 'Formulário Sem Título',
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.04,
            color: corPrimariaPreto,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenSize.height * 0.005),
            Text(
              'ID: ${form.id}',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.032,
                color: corNeutraCinzaEscuro,
              ),
            ),
            Text(
              'Campos: ${form.campos?.length ?? 0}',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.032,
                color: corNeutraCinzaEscuro,
              ),
            ),
            if (form.dataCriacao != null)
              Text(
                'Criado em: ${form.dataCriacao!.toLocal().toString().substring(0, 10)}',
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  fontSize: screenSize.width * 0.032,
                  color: corNeutraCinzaEscuro,
                ),
              ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: corNeutraVerdeAguaEscuro,
          size: screenSize.width * 0.06,
        ),
        onTap: () => showNotImplementedMessage(context),
      ),
    );
  }

  Widget buildEmptyStateForms(Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: screenSize.width * 0.2,
              color: Color.alphaBlend(
                corNeutraCinzaEscuro.withAlpha(127),
                Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Text(
              'Nenhum formulário encontrado',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.045,
                color: Color.alphaBlend(
                  corNeutraCinzaEscuro.withAlpha(204),
                  Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              'Parece que você ainda não tem formulários associados',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.035,
                color: Color.alphaBlend(
                  corNeutraCinzaEscuro.withAlpha(153),
                  Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTasksSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tarefas Pendentes',
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: screenSize.width * 0.055,
            fontWeight: FontWeight.bold,
            color: corPrimariaPreto,
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
        TaskCard(
          title: 'Revisar currículos',
          description: '8 novos currículos para análise',
          dueDate: 'Hoje',
          onTap: () => showNotImplementedMessage(context),
        ),
        TaskCard(
          title: 'Agendar entrevista',
          description: 'Entrevista técnica para 3 candidatos',
          dueDate: 'Amanhã',
          onTap: () => showNotImplementedMessage(context),
        ),
        TaskCard(
          title: 'Feedback da reunião',
          description: 'Registrar feedback dos candidatos entrevistados',
          dueDate: '26/04',
          onTap: () => showNotImplementedMessage(context),
        ),
      ],
    );
  }

  Widget buildCandidatesSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Candidatos Recentes',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.055,
                fontWeight: FontWeight.bold,
                color: corPrimariaPreto,
              ),
            ),
            TextButton(
              onPressed: () => showNotImplementedMessage(context),
              child: Text(
                'Ver todos',
                style: TextStyle(
                  fontFamily: 'SfProDisplay',
                  color: corNeutraVerdeAguaEscuro,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.height * 0.02),
        CandidateCard(
          name: 'Rafael Silva',
          position: 'Desenvolvedor Flutter',
          matchPercentage: 92,
          onTap: () => showNotImplementedMessage(context),
        ),
        CandidateCard(
          name: 'Ana Costa',
          position: 'UX Designer',
          matchPercentage: 88,
          onTap: () => showNotImplementedMessage(context),
        ),
        CandidateCard(
          name: 'Carlos Eduardo',
          position: 'Gerente de Projetos',
          matchPercentage: 75,
          onTap: () => showNotImplementedMessage(context),
        ),
      ],
    );
  }

  void showNotImplementedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Funcionalidade em desenvolvimento',
          style: TextStyle(fontFamily: 'SfProDisplay'),
        ),
        backgroundColor: corSemanticaAzul,
      ),
    );
  }
}

class CandidatesTab extends StatelessWidget {
  const CandidatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar candidatos',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    String.fromCharCode(65 + (index % 26)),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                title: Text(
                  'Candidato ${index + 1}',
                  style: const TextStyle(fontFamily: 'SfProDisplay'),
                ),
                subtitle: Text(
                  'Posição ${(index % 5) + 1}',
                  style: const TextStyle(fontFamily: 'SfProDisplay'),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar vagas',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: corNeutraVerdeAguaEscuro,
                child: const Icon(Icons.add, color: corPrimariaBrancoGelo),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.04,
                  vertical: 8,
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vaga ${index + 1}',
                            style: TextStyle(
                              fontFamily: 'SfProDisplay',
                              fontSize: screenSize.width * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index % 3 == 0)
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (index % 3 == 0) ? 'Ativa' : 'Em análise',
                              style: TextStyle(
                                color:
                                    (index % 3 == 0)
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        'Localização: São Paulo, SP',
                        style: TextStyle(
                          fontFamily: 'SfProDisplay',
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Text(
                        'Tipo: ${(index % 2 == 0) ? 'Tempo integral' : 'Meio período'}',
                        style: TextStyle(
                          fontFamily: 'SfProDisplay',
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        'Candidatos: ${(index + 1) * 3}',
                        style: const TextStyle(
                          fontFamily: 'SfProDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Editar',
                              style: TextStyle(
                                fontFamily: 'SfProDisplay',
                                color: corNeutraVerdeAguaEscuro,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Ver candidatos',
                              style: TextStyle(
                                fontFamily: 'SfProDisplay',
                                color: corNeutraVerdeAguaEscuro,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenSize.height * 0.02),
          CircleAvatar(
            radius: screenSize.width * 0.15,
            backgroundColor: corNeutraVerdeAguaEscuro,
            child: Icon(
              Icons.person,
              size: screenSize.width * 0.15,
              color: corPrimariaBrancoGelo,
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Text(
            authViewModel.currentUser?.nome ?? 'Recrutador',
            style: TextStyle(
              fontFamily: 'SfProDisplay',
              fontSize: screenSize.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Recrutador',
            style: TextStyle(
              fontFamily: 'SfProDisplay',
              fontSize: screenSize.width * 0.04,
              color: corNeutraCinzaEscuro,
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          ProfileMenuCard(
            icon: Icons.person_outline,
            title: 'Editar dados pessoais',
            onTap: () {},
          ),
          ProfileMenuCard(
            icon: Icons.business,
            title: 'Informações da empresa',
            onTap: () {},
          ),
          ProfileMenuCard(
            icon: Icons.lock_outline,
            title: 'Alterar senha',
            onTap: () {},
          ),
          ProfileMenuCard(
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            onTap: () {},
          ),
          ProfileMenuCard(
            icon: Icons.help_outline,
            title: 'Ajuda e suporte',
            onTap: () {},
          ),
          ProfileMenuCard(
            icon: Icons.info_outline,
            title: 'Sobre o aplicativo',
            onTap: () {},
          ),
          SizedBox(height: screenSize.height * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                authViewModel.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Sair da conta',
                style: TextStyle(fontFamily: 'SfProDisplay'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String dueDate;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.01),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.04,
          vertical: screenSize.height * 0.01,
        ),
        leading: Container(
          width: screenSize.width * 0.1,
          height: screenSize.width * 0.1,
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              corNeutraVerdeAguaEscuro.withAlpha(51),
              Colors.white,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.task,
            color: corNeutraVerdeAguaEscuro,
            size: screenSize.width * 0.05,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.04,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                fontSize: screenSize.width * 0.035,
              ),
            ),
            SizedBox(height: screenSize.height * 0.005),
            Text(
              'Prazo: $dueDate',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                color: corNeutraCinzaEscuro,
                fontSize: screenSize.width * 0.03,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: corNeutraVerdeAguaEscuro,
        ),
        onTap: onTap,
      ),
    );
  }
}

class CandidateCard extends StatelessWidget {
  final String name;
  final String position;
  final int matchPercentage;
  final VoidCallback onTap;

  const CandidateCard({
    super.key,
    required this.name,
    required this.position,
    required this.matchPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.01),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.04,
          vertical: screenSize.height * 0.015,
        ),
        leading: CircleAvatar(
          backgroundColor: Color.alphaBlend(
            corNeutraCinzaEscuro.withAlpha(38),
            Colors.white,
          ),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              color: corNeutraCinzaEscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.04,
          ),
        ),
        subtitle: Text(
          position,
          style: TextStyle(
            fontFamily: 'SfProDisplay',
            fontSize: screenSize.width * 0.035,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$matchPercentage%',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                color:
                    matchPercentage > 85
                        ? Colors.green
                        : matchPercentage > 70
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.04,
              ),
            ),
            Text(
              'Match',
              style: TextStyle(
                fontFamily: 'SfProDisplay',
                color: corNeutraCinzaEscuro,
                fontSize: screenSize.width * 0.03,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: ListTile(
        leading: Icon(icon, color: corNeutraVerdeAguaEscuro),
        title: Text(title, style: const TextStyle(fontFamily: 'SfProDisplay')),
        trailing: const Icon(
          Icons.chevron_right,
          color: corNeutraVerdeAguaEscuro,
        ),
        onTap: onTap,
      ),
    );
  }
}
