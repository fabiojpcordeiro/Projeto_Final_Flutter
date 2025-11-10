import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/services/auth_service.dart';
import 'package:projeto_final_flutter/services/location_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  int? _selectedCityId;
  int? _selectedStateId;
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('As senhas não correspondem!')));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.register(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        city: _selectedCityId!,
        state: _selectedStateId!,
      );

      final token = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
      await LocalStorage.saveToken(token);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso')),
        );
      }
      context.go('/home');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao registrar: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Registrar',
      showDrawer: true,
      child: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o seu nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Seu email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Email inválido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Seu telefone'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v != null && v.length > 7 ? null : 'Telefone Inválido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Digite uma senha',
                ),
                obscureText: true,
                validator: (v) => v != null && v.length > 7
                    ? null
                    : 'A senha precisa ter no mínimo 8 caracteres.',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirme a senha',
                ),
                obscureText: true,
                validator: (v) => v != null && v.isNotEmpty
                    ? null
                    : 'As senhas não são iguais',
              ),
              const SizedBox(height: 12),

              //State selection input
              TypeAheadField<Map<String, dynamic>>(
                debounceDuration: const Duration(milliseconds: 200),
                controller: _stateController,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Estado'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe seu estado'
                        : null,
                  );
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion['name']!));
                },
                onSelected: (suggestion) {
                  setState(() {
                    _stateController.text = suggestion['name'];
                    _selectedStateId = suggestion['id'];
                    _selectedCityId = null;
                    _cityController.clear();
                  });
                },
                suggestionsCallback: (pattern) async {
                  return await LocationService.getStates(pattern);
                },
              ),

              const SizedBox(height: 12),

              //City selection input
              TypeAheadField<Map<String, dynamic>>(
                debounceDuration: const Duration(milliseconds: 200),
                controller: _cityController,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Cidade'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe sua cidade'
                        : null,
                  );
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion['name']!));
                },
                onSelected: (suggestion) {
                  setState(() {
                    _cityController.text = suggestion['name'];
                    _selectedCityId = suggestion['id'];
                  });
                },
                suggestionsCallback: (pattern) async {
                  if (_selectedStateId == null) return [];
                  return await LocationService.getCities(
                    pattern,
                    _selectedStateId,
                  );
                },
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Cadastrar'),
              ),

              TextButton(
                onPressed: () {
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                child: const Text('Já tem uma conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
