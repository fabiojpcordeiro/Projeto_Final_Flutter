import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JobService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  Future<List<dynamic>> getjobsByCity(String city) async {
    final url = Uri.parse('$baseUrl/job-offers/search?query=$city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('data')) {
        return data['data'];
      }
      if (data is List) return data;
      throw Exception('Formato inesperado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getJobById(String id) async {
    final url = Uri.parse('$baseUrl/job-offers/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('data')) {
        return data['data'];
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      throw Exception('Formato inesperado');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }
}
