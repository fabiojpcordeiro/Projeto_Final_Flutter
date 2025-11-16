import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/services/api_client.dart';

class ApplicationService {
  final apiClient = ApiClient();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  Future<void> sendApplication({
    required String jobId,
    required String message,
  }) async {
    final url = Uri.parse('http://localhost:8000/api/application/');
    final response = await http.post(
      url,
      headers: await apiClient.getHeaders(),
      body: jsonEncode({'job_offer_id': jobId, 'message': message}),
    );
    final body = jsonDecode(response.body);
    final errors = body['errors'] ?? body['message'];
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw errors;
    }
  }

  Future<List<Map<String, dynamic>>> getMyApplications() async {
    final url = Uri.parse('$baseUrl/application');
    final response = await http.get(url, headers: await apiClient.getHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['data'] as List<dynamic>;
      return list.map((e) => e as Map<String, dynamic>).toList();
    }
    throw 'Ocorreu um erro ao carregar candidaturas';
  }
}
