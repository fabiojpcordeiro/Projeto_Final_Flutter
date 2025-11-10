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
}
