import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final String apiUrl = "http://192.168.1.2:8000/api";
  // final Map<String, String> headers;

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$apiUrl$endpoint'));
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(Uri.parse('$apiUrl$endpoint'),body: jsonEncode(body));
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(Uri.parse('$apiUrl$endpoint'),body: jsonEncode(body));
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$apiUrl$endpoint'));
    return response;
  }

  Future<Map<String, dynamic>> getJson(String endpoint) async {
    final response = await get(endpoint);
    final jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  Future<Map<String, dynamic>> getListJson(String endpoint) async {
    final response = await get(endpoint);
    final jsonBody = json.decode(response.body);
    final jsonArray = jsonBody as Map<String, dynamic>;
    // final list = jsonArray.map((item) => item as Map<String, dynamic>).toList();
    return jsonArray;
  }

  Future<Map<String, dynamic>> postJson(String endpoint, Map<String, dynamic> body) async {
    final response = await post(endpoint, body);
    final jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  Future<Map<String, dynamic>> putJson(String endpoint, Map<String, dynamic> body) async {
    final response = await put(endpoint, body);
    final jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  Future register(String email, String password, String role, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      body: {
        'email': email,
        'password': password,
        'role': role,
        'status': status,
      },
    );

    if (response.statusCode == 200) {
      prefs.setBool('loggedIn', true);
      final json = jsonDecode(response.body);
      final user = json['user'];
      final token = json['token'];

      if (user != null && token != null) {
        return response.statusCode;
      }
    }
    throw Exception('Failed to register');
  }

  Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);
      print("login success");
      final json = jsonDecode(response.body);
      final user = json['user'];
      final token = json['token'];

      if (user != null && token != null) {
        return response.statusCode;
      }
    }
    throw Exception('Failed to login API');
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$apiUrl/logout'));

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', false);
      print("successfully cleared shared preferences");
    }
    throw Exception('Failed to logout');
  }

  Future<void> deleteJson(String endpoint) async {
    await delete(endpoint);
  }
}
// var jsonResponse;
// var itemInside;
// if (response.statusCode == 200) {
//   jsonResponse = json.decode(response.body) as Map<String, dynamic>;
//   itemInside = jsonResponse['post'][0];
//   print(itemInside);
//   print('Email: ${itemInside['email']}');
// } else {
//   print('Request failed with status: ${response.statusCode}.');
// }