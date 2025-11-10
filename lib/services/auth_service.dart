import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/core/storage/local_storage.dart';

class AuthService {
  static String? token;
  static ValueNotifier<bool> isLogged = ValueNotifier(false);
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  static Future<String> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/candidate/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']?['token'];
      if (token != null) {
        isLogged.value = true;
        return token;
      } else {
        throw Exception('Token não encontrado');
      }
    } else {
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  static Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int city,
    required int state,
  }) async {
    final url = Uri.parse('$baseUrl/candidate/register');
    final response = await http.post(
      url,
      headers: {'Content-type': 'aplicattion/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'city_id': city,
        'state_id': state,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(
        body['message'] ?? 'Não foi possível realizar o registro.',
      );
    }
  }

  static Future<void> logout() async {
    final token = await LocalStorage.getToken();
    if (token == null || token.isEmpty) return;

    final url = Uri.parse('$baseUrl/candidate/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    ;
    if (response.statusCode == 200) {
      await LocalStorage.clearToken();
      isLogged.value = false;
    } else {
      throw Exception('Falha no logout');
    }
  }
}
