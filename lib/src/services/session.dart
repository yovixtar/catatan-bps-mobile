import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String responseDataKey = 'responseData';

  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(responseDataKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(responseDataKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }

  // static Future<bool> saveData(Map<String, dynamic> payload) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return await prefs.setString(responseDataKey, json.encode(payload));
  // }

  static Future<Map<String, dynamic>?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await getToken();
    if (token != null) {
      var decodedPayload = JwtDecoder.decode(token);
      return decodedPayload;
    } else {
      return null;
    }
  }

  static Future<bool> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(responseDataKey);
  }

  static Future<String?> getBearerToken() async {
    try {
      String? token = await getToken();
      // if (token != null) {
      //   Map<String, dynamic> tokenData = jsonDecode(token);
      //   String bearerToken = tokenData['token'];
      //   return bearerToken;
      // }
      return token;
    } catch (e) {
      return null;
    }
  }
}
