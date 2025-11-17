import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final job = application['job_offer'];
    final title = job['title'];
    final city = job['city'];
    final salary = job['salary'];
    final status = application['status'];
    final dates = (job['dates'] as List).map((d) => d['work_date']).join(', ');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Cidade: $city"),
            Text("Salário: R\$ $salary"),
            Text("Status: $status"),
            const SizedBox(height: 8),
            Text("Datas: $dates"),
          ],
        ),
      ),
    );
  }
}
