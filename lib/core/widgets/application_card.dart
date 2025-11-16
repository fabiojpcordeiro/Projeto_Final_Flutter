import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/services/application_service.dart';

class ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final Function(int)? onDeleted;

  const ApplicationCard({super.key, required this.application, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    final job = application['job_offer'];
    final company = job['company']['name'];
    final title = job['title'];
    final city = job['city'];
    final salary = job['salary'];
    final status = application['status_label'];
    final message = application['company_message'] ?? 'Nenhuma mensagem';
    final dates = (job['dates'] as List).map((d) => d['work_date']).join(', ');
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(company),
            const SizedBox(height: 8),
            Text("Cidade: $city"),
            Text("Salário: R\$ $salary"),
            Text("Status: $status"),
            const SizedBox(height: 8),
            Text("Datas: $dates"),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _confirmDelete(context),
                  child: Text('Desistir da vaga'),
                ),
                if (status == 'Aprovado')
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Mensagem da empresa"),
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Fechar"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Ver mensagem"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final applicationService = ApplicationService();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text(
            "Tem certeza que deseja desistir desta vaga? Esta ação não pode ser desfeita.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await applicationService.deleteApplication(application['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Candidatura removida com sucesso"),
                    ),
                  );
                  onDeleted?.call(application['id']);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao remover candidatura: $e")),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Desistir"),
            ),
          ],
        );
      },
    );
  }
}
