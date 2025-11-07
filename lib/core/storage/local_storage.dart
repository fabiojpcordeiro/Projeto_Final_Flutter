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
}
