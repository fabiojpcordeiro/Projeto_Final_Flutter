import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:projeto_final_flutter/core/layouts/base_layout.dart';
import 'package:projeto_final_flutter/core/widgets/change_password_modal.dart';
import 'package:projeto_final_flutter/models/candidate.dart';
import 'package:projeto_final_flutter/services/profile_service.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileService = ProfileService();
  Uint8List? _profilePhoto;
  Uint8List? _selectedResume;
  String? _selectedResumeName;
  Candidate? candidate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _selectImage() async {
    final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() {
        _isLoading = false;
        _profilePhoto = pickedFile;
      });
    }
    try {
      profileService.uploadPhoto(_profilePhoto!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      });
    }
  }

  Future<Candidate?> _loadProfile() async {
    try {
      final data = await profileService.fetchProfile();
      setState(() {
        candidate = data;
        _profilePhoto = candidate!.photo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil. $e')));
      });
    }
    return candidate;
  }

  Future<void> _selectResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.bytes == null) {
      await Future.delayed(Duration(milliseconds: 100));
      return;
    }
    setState(() {
      _selectedResume = result.files.single.bytes!;
      _selectedResumeName = result.files.single.name;
    });
  }

  Future<void> _uploadResume() async {
    if (_selectedResume == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await profileService.uploadResume(_selectedResume!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Currículo enviado com sucesso!')),
      );
      setState(() {
        _selectedResume = null;
        _selectedResumeName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar currículo: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return BaseLayout(
      title: 'Meu Perfil',
      showDrawer: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : candidate == null
          ? const Center(child: Text('Erro ao carregar os dados do perfil'))
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.shade50,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screen.height * 0.9,
                  maxWidth: screen.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 15,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _profilePhoto != null
                                ? MemoryImage(_profilePhoto!)
                                : null,
                            child: _profilePhoto == null
                                ? const Icon(Icons.person, size: 60)
                                : null,
                          ),
                        ),
                        TextButton(
                          onPressed: _selectImage,
                          child: Text('Mudar foto de perfil'),
                        ),
                        Text(candidate!.name, style: _infoStyle),

                        Divider(height: 15, thickness: 2),

                        Text(candidate!.email, style: _infoStyle),

                        Text(
                          'Telefone: ${candidate!.phone}',
                          style: _infoStyle,
                        ),

                        Text(
                          '${candidate!.cityName}/${candidate!.stateName}',
                          style: _infoStyle,
                        ),
                        Text(candidate!.bio ?? '', style: _infoStyle),
                        TextButton(
                          onPressed: () => context.go('/edit-profile'),
                          child: Text('Alterar meus dados'),
                        ),

                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ChangePasswordDialog(
                                profileService: profileService,
                              ),
                            );
                          },
                          child: const Text('Alterar senha'),
                        ),

                        Divider(height: 20),

                        TextButton(
                          onPressed: _selectResume,
                          child: Text('Enviar/Atualizar Currículo (PDF)'),
                        ),
                        if (_selectedResume != null) ...[
                          Text('Arquivo selecionado: $_selectedResumeName'),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _uploadResume,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('Confirmar envio'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  TextStyle get _infoStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
}
