import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showDrawer;

  const BaseLayout({
    super.key,
    required this.title,
    required this.child,
    required this.showDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = context.canPop();
    Widget? leadingWidget;

    if (canPop) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: true,
        leading: leadingWidget,
      ),
      drawer: showDrawer ? _buildDrawer(context) : null,
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthService.isLogged,
      builder: (context, logged, _) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Bem vindo'),
              ),

              if (logged) ...[
                ListTile(
                  title: const Text('Minhas candidaturas'),
                  onTap: () => print('teste'),
                ),
                ListTile(
                  title: const Text('Meu Perfil'),
                  onTap: () => context.push('/profile'),
                ),
                ListTile(
                  title: const Text('Sair'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await AuthService.logout();
                      if (context.mounted) context.push('/home');
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao executar o logout'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ] else ...[
                ListTile(
                  title: const Text('Login'),
                  onTap: () => context.push('/login'),
                ),
                ListTile(
                  title: const Text('Registrar-se'),
                  onTap: () => context.push('/register'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
