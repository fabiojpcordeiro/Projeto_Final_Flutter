import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/core/widgets/job_application_confirmation.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';
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
  bool _hasApplied = false;
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

    final job = _job;
    final company = job!['company'];
    final dates = List<String>.from(job['dates'] ?? []);
    final screen = MediaQuery.of(context).size;

    return BaseLayout(
      title: 'Detalhes da vaga',
      showDrawer: true,
      child: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: screen.height * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(company['logo']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    company['name'],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    job['city'],
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Wrap(
                    spacing: 5,
                    children: [
                      Chip(
                        label: Text(
                          'Inscrição disponível até: ${job['open_until']}',
                        ),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    ],
                  ),
                  Divider(height: 10),
                  Padding(
                    padding: EdgeInsetsGeometry.all(4),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      width: screen.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                      ),
                      child: Column(
                        children: [
                          Text(
                            job['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            job['description'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Chip(
                            label: Text('Remuneração/dia: ${job['salary']}'),
                            backgroundColor: Colors.blue.shade50,
                          ),
                          Text('Data(s) do trabalho:'),
                          Wrap(
                            spacing: 5,
                            children: dates.map((date) {
                              return Chip(
                                label: Text(
                                  date,
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.blue.shade50,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!_hasApplied)
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.extended(
                    label: Text(
                      'Quero me candidatar a essa vaga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (await LocalStorage.getToken() == null) {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: ((context) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'Voce precisa de uma conta para se candidatar a vaga.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            context.push('/register'),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(120, 20),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        child: Text(
                                          'Cadastrar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => context.push('/login'),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(120, 20),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        child: Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return JobApplicationConfirmation(
                              jobId: widget.jobId,
                              onApplied: () {
                                setState(() => _hasApplied = true);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
