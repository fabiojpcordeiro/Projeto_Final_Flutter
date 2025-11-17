import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/widgets/application_card.dart';
import 'package:projeto_final_flutter/services/application_service.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});
  @override
  State<ApplicationsPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationsPage> {
  final applicationsService = ApplicationService();
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> applications = [];

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  Future<void> loadApplications() async {
    try {
      final result = await applicationsService.getMyApplications();
      setState(() {
        applications = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Minhas candidaturas',
      showDrawer: true,
      child: buildContent(),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (hasError) {
      return const Center(
        child: Text(
          'Erro ao carregar candidaturas.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    if (applications.isEmpty) {
      return const Center(
        child: Text('Você ainda não se candidatou a nenhuma vaga.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        return ApplicationCard(
          onDeleted: (id) {
            print(id);
            setState(() {
              applications.removeWhere((item) => item['id'] == id);
            });
          },
          application: applications[index],
        );
      },
    );
  }
}
