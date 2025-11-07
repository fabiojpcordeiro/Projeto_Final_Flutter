import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/services/job_service.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;
  const JobDetailsPage({super.key, required this.jobId});
  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final JobService _jobService = JobService();
  Map<String, dynamic>? _job;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    try {
      final job = await _jobService.getJobById(widget.jobId);
      setState(() {
        _job = job;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro:')),
        body: Center(child: Text(_error!)),
      );
    }
    return BaseLayout(
      title: 'Detalhes da vaga',
      showDrawer: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _job!['title'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _job!['description'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
