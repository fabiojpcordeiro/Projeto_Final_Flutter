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

  Future<List<Map<String, dynamic>>> getjobsByCity(String city) async {
    final url = Uri.parse('$baseUrl/job-offers/search?query=$city');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final jobs = List<Map<String, dynamic>>.from(data['data']);
    for (var job in jobs) {
      final List<dynamic> datesData = job['dates'] ?? [];
      final List<String> formattedDates = datesData
          .map((dateObject) => dateObject['work_date'] as String)
          .toList();
      job['dates'] = formattedDates;
    }
    return jobs;
  }

  Future<Map<String, dynamic>> getJobById(String id) async {
    final url = Uri.parse('$baseUrl/job-offers/$id');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Erro: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    final job = data['data'] as Map<String, dynamic>;
    final List<dynamic> datesData = job['dates'] ?? [];
    final List<String> formattedDates = datesData
        .map((dateObj) => dateObj['work_date'] as String)
        .toList();
    job['dates'] = formattedDates;
    return job;
  }
}
