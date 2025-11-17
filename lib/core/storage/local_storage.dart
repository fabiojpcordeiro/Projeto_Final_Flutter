import 'dart:convert';

import 'package:projeto_final_flutter/models/candidate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveCity(String city) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString('city', city);
  }

  static Future<String?> getCity() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString('city');
  }

  static Future<void> saveToken(String token) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString('authToken', token);
  }

  static Future<String?> getToken() async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString('authToken');
  }

  static Future<void> clearToken() async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove('authToken');
  }

  static Future saveCandidate(Candidate candidate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('candidate', jsonEncode(candidate));
  }

  static Future<Map<String, dynamic>?> getCandidate() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('candidate');
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
  static Future<void> clearCandidate() async{
    final preference = await SharedPreferences.getInstance();
    await preference.remove('candidate');
  }
}
