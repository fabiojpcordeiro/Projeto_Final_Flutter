import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _StateLoginPage();
}

class _StateLoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
      await LocalStorage.saveToken(token);
      AuthService.isLogged.value = true;
      if (!mounted) return;
      final city = await LocalStorage.getCity();
      context.go('/home', extra: {'city': city});
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Login',
      showDrawer: true,
      child: Align(
        alignment: Alignment(0, -0.5),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Card(
                color: Colors.blue.shade50,
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    Text(
                      'Realize seu login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Digite seu email' : null,
                    ),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Digite sua senha' : null,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                      ),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Entrar",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),

                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text('Ainda não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
