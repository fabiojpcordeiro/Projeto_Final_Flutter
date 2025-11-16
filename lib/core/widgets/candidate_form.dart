import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final_flutter/services/location_service.dart';

enum CandidateFormMode { create, edit }

class CandidateForm extends StatelessWidget {
  final CandidateFormMode mode;
  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final int? selectedStateId;
  final int? selectedCityId;
  final Function(int id, String name) onStateSelected;
  final Function(int id, String name) onCitySelected;

  // create mode only
  final TextEditingController? passwordController;
  final TextEditingController? passwordConfirmationController;

  // edit mode only
  final TextEditingController? bioController;
  final TextEditingController? birthdateController;

  final bool isLoading;
  final VoidCallback onSubmit;

  const CandidateForm({
    super.key,
    required this.mode,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    this.passwordController,
    this.passwordConfirmationController,
    this.bioController,
    this.birthdateController,
    required this.stateController,
    required this.cityController,
    required this.selectedStateId,
    required this.selectedCityId,
    required this.isLoading,
    required this.onSubmit,
    required this.onStateSelected,
    required this.onCitySelected,
  });

  bool get isCreate => mode == CandidateFormMode.create;
  bool get isEdit => mode == CandidateFormMode.edit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o seu nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Seu email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Email inválido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Seu telefone'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v != null && v.length > 7 ? null : 'Telefone Inválido',
              ),
              const SizedBox(height: 12),

              //Password fields CREATE only
              if (isCreate) ...[
                TextFormField(
                  controller: passwordController,
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
                  controller: passwordConfirmationController,
                  decoration: const InputDecoration(
                    labelText: 'Confirme a senha',
                  ),
                  obscureText: true,
                  validator: (v) => v != null && v.isNotEmpty
                      ? null
                      : 'As senhas não são iguais',
                ),
              ],

              //State selection input
              TypeAheadField<Map<String, dynamic>>(
                debounceDuration: const Duration(milliseconds: 200),
                controller: stateController,
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
                suggestionsCallback: (pattern) async {
                  return await LocationService.getStates(pattern);
                },
                onSelected: (suggestion) {
                  onStateSelected(suggestion['id'], suggestion['name']);
                },
              ),

              const SizedBox(height: 12),

              //City selection input
              TypeAheadField<Map<String, dynamic>>(
                debounceDuration: const Duration(milliseconds: 200),
                controller: cityController,
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
                  onCitySelected(suggestion['id'], suggestion['name']);
                },
                suggestionsCallback: (pattern) async {
                  if (selectedStateId == null) return [];
                  return await LocationService.getCities(
                    pattern,
                    selectedStateId,
                  );
                },
              ),
              const SizedBox(height: 12),
              if (isEdit) ...[
                TextFormField(
                  controller: bioController!,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: birthdateController!,
                  decoration: const InputDecoration(
                    labelText: 'Data de nascimento',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      birthdateController!.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(picked);
                    }
                  },
                ),
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isCreate ? "Cadastrar" : "Salvar alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
