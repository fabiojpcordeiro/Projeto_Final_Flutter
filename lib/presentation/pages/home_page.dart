import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/presentation/pages/job_details_page.dart';
import 'package:projeto_final_flutter/services/job_service.dart';

class HomePage extends StatefulWidget {
  final String? city;
  const HomePage({super.key, this.city});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final JobService _jobService = JobService();
  List<dynamic> _jobs = [];
  bool _isLoading = true;
  String? _error;
  String? _city;

  @override
  void initState() {
    super.initState();
    _city = widget.city;
    _loadJobs(_city);
  }

  Future<void> _loadJobs(String? city) async {
    try {
      final jobs = await _jobService.getjobsByCity(city ?? '');
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Confira algumas vagas.',
      showDrawer: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _city == null || _city!.isEmpty
                        ? 'Digite sua cidade para procurar vagas próximas a voce!'
                        : 'Mostrando vagas para $_city',
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Sua cidade',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await LocalStorage.saveCity(value);
                        setState(() {
                          _city = value;
                        });
                        await _loadJobs(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Text(
            widget.city == null || widget.city!.isEmpty
                ? 'Exibindo todas as vagas'
                : 'Exibindo vagas para $_city',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(job['title']),
                    subtitle: Text(job['city']),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      final id = job['id'];
                      context.push('/job-details/$id');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
