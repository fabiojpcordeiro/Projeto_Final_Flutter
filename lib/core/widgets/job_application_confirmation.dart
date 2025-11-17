import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/services/application_service.dart';

class JobApplicationConfirmation extends StatefulWidget {
  final VoidCallback onApplied;
  final String jobId;
  const JobApplicationConfirmation({
    super.key,
    required this.jobId,
    required this.onApplied,
  });

  @override
  State<JobApplicationConfirmation> createState() =>
      _JobApplicationConfirmation();
}

class _JobApplicationConfirmation extends State<JobApplicationConfirmation> {
  final TextEditingController _messageController = TextEditingController();
  final ApplicationService _applicationService = ApplicationService();

  bool _isLoading = false;
  String? _error;

  Future<void> _sendApplication() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _applicationService.sendApplication(
        jobId: widget.jobId,
        message: _messageController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Candidatura enviada com sucesso!')),
        );
        widget.onApplied();
      }
    } catch (e) {
      setState(() {
        _error = "Erro ao enviar candidatura: $e";
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Confirmar candidatura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 15),
            Text(
              'Envie uma mensagem para o recrutador:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                label: Text('Sua mensagem'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (_error != null)
              Padding(padding: const EdgeInsets.all(8), child: Text(_error!)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendApplication,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Candidatar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
