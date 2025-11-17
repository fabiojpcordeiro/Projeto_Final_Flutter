import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/services/api_client.dart';

class ApplicationService {
  final apiClient = ApiClient();
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
}
