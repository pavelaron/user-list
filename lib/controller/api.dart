import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';

class Api {
  static const String _base = 'assessment-users-backend.herokuapp.com';
  static Map<String,String> headers = {
    'Content-type': 'application/json', 
    'Accept': 'application/json',
  };

  static Future<List<User>> fetchUsers() async {
    final Uri url = Uri.https(_base, '/users');
    final response = await http.get(url, headers: headers);
    if (response.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    List<dynamic> jsonData = convert.jsonDecode(response.body);
    List<User> users = jsonData
      .map((model) => User.fromJson(model))
      .toList()
      ..sort(((a, b) => b.createdAt.compareTo(a.createdAt)));

    return users;
  }

  static Future<User?> createUser(String firstName, String lastName, Status status) async {
    final String payload = convert.jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'status': status.name,
    });

    final Uri url = Uri.https(_base, '/users');
    final response = await http.post(url, headers: headers, body: payload);
    
    if (response.statusCode != HttpStatus.created) {
      return null;
    }

    return User.fromJson(convert.jsonDecode(response.body));
  }

  static Future<bool> updateStatus(int userId, Status status) async {
    final String payload = convert.jsonEncode({
      'status': status.name,
    });

    final Uri url = Uri.https(_base, '/users/$userId');
    final response = await http.put(
      url, 
      headers: headers,
      body: payload,
    );

    return response.statusCode == HttpStatus.noContent;
  }

  static Future<bool> updateUser(int userId, String firstName, String lastName) async {
    final String payload = convert.jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
    });

    final Uri url = Uri.https(_base, '/users/$userId');
    final response = await http.put(
      url, 
      headers: headers,
      body: payload,
    );

    return response.statusCode == HttpStatus.noContent;
  }
}
