import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/services/auth_service.dart';

class LocationService {
  static String get baseUrl => AuthService.baseUrl;

  static Future<List<Map<String, dynamic>>> getStates(String query) async {
    final url = Uri.parse('$baseUrl/states?query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
        'Erro ao buscar os estados. Status:${response.statusCode}',
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getCities(
    String query,
    int? stateId,
  ) async {
    final url = Uri.parse('$baseUrl/cities?query=$query&state_id=$stateId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
        'Falha ao carregar as cidades. Status: ${response.statusCode}',
      );
    }
  }
}
