import 'package:projeto_final_flutter/core/storage/local_storage.dart';

class ApiClient {
  final baseUrl = Uri.parse('htt://localhost:8000/api');

  Future<Map<String, String>> getHeaders() async {
    final String? token = await LocalStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return headers;
  }
}
