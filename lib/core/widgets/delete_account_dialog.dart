import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Digite sua senha para confirmar a exclusão da conta. '
            'Essa ação é irreversível.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: loading
              ? null
              : () async {
                  setState(() => loading = true);

                  try {
                    await AuthService().deleteAccount(
                      
                      _passwordController.text,
                    );

                    // Deslogar + enviar pra tela de login
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    if (mounted) setState(() => loading = false);
                  }
                },
          child: loading
              ? const CircularProgressIndicator()
              : const Text('Apagar conta'),
        ),
      ],
    );
  }
}
