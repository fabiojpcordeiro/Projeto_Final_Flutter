import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/widgets/candidate_form.dart';
import 'package:projeto_final_flutter/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _profileService = ProfileService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  final _birthdateController = TextEditingController();

  late int _candidateId;
  int? _selectedStateId;
  int? _selectedCityId;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final candidate = await _profileService.fetchProfile();
    if (candidate != null) {
      setState(() {
        _candidateId = candidate.id;
        _nameController.text = candidate.name;
        _emailController.text = candidate.email;
        _phoneController.text = candidate.phone;
        _bioController.text = candidate.bio ?? '';
        _birthdateController.text = candidate.birthdate ?? '';
        _stateController.text = candidate.stateName ?? '';
        _cityController.text = candidate.cityName ?? '';
        _selectedStateId = candidate.stateId;
        _selectedCityId = candidate.cityId;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _profileService.updateProfile(
        candidateId: _candidateId,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
        birthdate: _birthdateController.text,
        state: _selectedStateId!,
        city: _selectedCityId!,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
      }
      context.go('/profile');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
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
      title: 'Editar perfil',
      showDrawer: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 600, maxWidth: 400),
            child: CandidateForm(
              mode: CandidateFormMode.edit,
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              stateController: _stateController,
              cityController: _cityController,
              bioController: _bioController,
              birthdateController: _birthdateController,
              selectedStateId: _selectedStateId,
              selectedCityId: _selectedCityId,
              isLoading: _isLoading,
              onSubmit: _updateUserData,
              onStateSelected: (id, name) {
                setState(() {
                  _selectedStateId = id;
                  _stateController.text = name;
                  _selectedCityId = null;
                  _cityController.clear();
                });
              },
              onCitySelected: (id, name) {
                _selectedCityId = id;
                _cityController.text = name;
              },
            ),
          ),
        ),
      ),
    );
  }
}
