import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final String title = job['title'] ?? 'Vaga sem título';
    final String company = job['company']?['name'] ?? 'Empresa não informada';
    final String city = job['city'] ?? 'Cidade não informada';
    final List<String> dates = job['dates'] ?? 'Datas não informadas';
    final String salary =
        job['salary'] != null && job['salary'].toString().isNotEmpty
        ? 'R\$ ${job['salary']}'
        : 'A combinar';
    final String logoUrl = job['company']?['logo'];

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(logoUrl)),
            Text(
              company,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              city,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              salary,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Datas do trabalho:',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Wrap(
              spacing: 5,
              children: dates.map((date) {
                return Chip(
                  label: Text(date, style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.blue.shade50,
                );
              }).toList(),
            ),

            const Divider(height: 20),

            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  final id = job['id'];
                  context.push('/job-details/$id');
                },
                child: const Text('Ver detalhes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
