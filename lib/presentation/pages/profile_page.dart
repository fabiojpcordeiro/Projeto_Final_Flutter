import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/models/candidate.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  Candidate? candidate;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<Candidate?> _loadProfile() async {
    try {
      final data = await _authService.fetchProfile();
      setState(() {
        candidate = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil. $e')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Meu Perfil',
      showDrawer: true,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 45,
                      child: Icon(Icons.person, size: 45),
                    ),
                  ),
                  Text('Nome: ${candidate!.name}', style: _infoStyle),
                  const SizedBox(height: 8),
                  Text('Email: ${candidate!.email}', style: _infoStyle),
                  const SizedBox(height: 8),
                  Text('Telefone: ${candidate!.phone}', style: _infoStyle),
                  const SizedBox(height: 24),
                  Text('Cidade: ${candidate!.cityName}', style: _infoStyle),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  TextStyle get _infoStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
}
