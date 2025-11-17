import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:projeto_final_flutter/core/storage/local_storage.dart';
import 'package:projeto_final_flutter/models/candidate.dart';
import 'package:projeto_final_flutter/services/api_client.dart';

class ProfileService {
  final apiClient = ApiClient();
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  Future<Candidate?> fetchProfile() async {
    Candidate candidate;
    final token = await LocalStorage.getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/candidate/me');
    final response = await http.get(url, headers: await apiClient.getHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      candidate = Candidate.fromJson(data['data']);
      LocalStorage.saveCandidate(candidate);

      if (candidate.profilePhotoUrl != null) {
        final url = Uri.parse('$baseUrl/get-photo${candidate.profilePhotoUrl}');
        final photoResponse = await http.get(
          url,
          headers: await apiClient.getHeaders(),
        );
        if (photoResponse.statusCode == 200) {
          final photo = photoResponse.bodyBytes;
          candidate.photo = photo;
        }
      }
      return candidate;
    } else {
      throw 'Falha ao carregar perfil. Cód: ${response.statusCode}';
    }
  }

  Future<void> uploadPhoto(Uint8List imageBytes) async {
    final mimeType =
        lookupMimeType('', headerBytes: imageBytes) ??
        'application/octet-stream';
    final mime = mimeType.split('/');
    final token = await LocalStorage.getToken();
    final url = Uri.parse('$baseUrl/set-photo/');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'profile_photo',
          imageBytes,
          filename: 'photo.${mime.last}',
          contentType: MediaType(mime.first, mime.last),
        ),
      );
    final response = await request.send();
  }

  Future<void> updateProfile({
    required int candidateId,
    required String name,
    required String email,
    required String phone,
    String? bio,
    String? birthdate,
    required int state,
    required int city,
  }) async {
    //Birth date conversion
    String? isoBirthdate;
    if (birthdate != null && birthdate.contains('/')) {
      final parts = birthdate.split('/');
      if (parts.length == 3) {
        isoBirthdate = "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    }
    final url = Uri.parse('$baseUrl/candidate/$candidateId');
    final response = await http.put(
      url,
      headers: await apiClient.getHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'state_id': state,
        'city_id': city,
        'bio': bio,
        'birthdate': isoBirthdate,
        'state': state,
        'city': city,
      }),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
    }
    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar perfil: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> uploadResume(Uint8List pdfBytes) async {
    final url = Uri.parse('$baseUrl/set-resume');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(await apiClient.getHeaders())
      ..files.add(
        http.MultipartFile.fromBytes(
          'resume',
          pdfBytes,
          filename: 'resume.pdf',
        ),
      );

    final response = await request.send();
    if (response.statusCode != 200) {
      throw 'Erro ao enviar currículo: ${response.statusCode} ';
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/candidate/change-password');
    final response = await http.post(
      url,
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
      headers: await apiClient.getHeaders(),
    );
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ?? response.body;
      throw 'Não foi possível alterar a senha: $error';
    }
  }
}
