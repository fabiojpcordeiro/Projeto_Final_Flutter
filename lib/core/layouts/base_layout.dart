import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showDrawer;
  final bool isAuthenticated;

  const BaseLayout({
    super.key,
    required this.title,
    required this.child,
    required this.showDrawer,
    this.isAuthenticated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: showDrawer ? _buildDrawer(context) : null,
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Bem vindo'),
          ),

          if (isAuthenticated) ...[
            ListTile(
              title: Text('Minhas candidaturas'),
              onTap: () => Navigator.pushNamed(context, 'teste'),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () => Navigator.pushNamed(context, 'teste'),
            ),
          ] else ...[
            ListTile(
              title: const Text('Login'),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            ListTile(
              title: const Text('Registrar-se'),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ],
      ),
    );
  }
}
