import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/core/widgets/menu_tile.dart';
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        centerTitle: true,
        title: Container(
          height: 45,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
        ),
        automaticallyImplyLeading: showDrawer,
      ),
      drawer: showDrawer ? _buildDrawer(context) : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                // Back button
                SizedBox(
                  width: 48,
                  child: canPop
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        )
                      : const SizedBox(), // mantém o alinhamento mesmo sem botão
                ),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                //Back Button counterwheight
                const SizedBox(
                  width: 48,
                  child: Opacity(opacity: 0, child: Icon(Icons.arrow_back)),
                ),
              ],
            ),

            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authService = AuthService();
    return ValueListenableBuilder(
      valueListenable: AuthService.isLogged,
      builder: (context, logged, _) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Container(
                  height: 45,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ListTile(
                title: Text(
                  'Seja bem vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 15, thickness: 3),
              MenuTile(
                title: 'HOME',
                onTap: () => context.go('/home'),
                icon: Icons.home,
              ),

              if (logged) ...[
                SizedBox(height: 8),
                MenuTile(
                  title: 'Minhas candidaturas',
                  onTap: () => context.push('/applications'),
                  icon: Icons.file_copy_outlined,
                ),
                MenuTile(
                  title: 'Meu Perfil',
                  onTap: () => context.push('/profile'),
                  icon: Icons.person_2_rounded,
                ),
                MenuTile(
                  title: 'Sair',
                  icon: Icons.power_settings_new,
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await authService.logout();
                      await LocalStorage.clearCandidate();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout efetuado com sucesso.'),
                        ),
                      );
                      context.go('/home');
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
                SizedBox(height: 8),
                MenuTile(
                  title: 'Login',
                  onTap: () => context.go('/login'),
                  icon: Icons.person_2_outlined,
                ),
                MenuTile(
                  title: 'Registrar-se',
                  onTap: () => context.go('/register'),
                  icon: Icons.playlist_add_check_rounded,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
