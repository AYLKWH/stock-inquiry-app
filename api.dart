import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class Api {
  static Future<Map<String, dynamic>> lookup(String keyword) async {
    final uri = Uri.parse('${Config.apiBase}/api/item/${Uri.encodeComponent(keyword)}');
    final res = await http.get(uri, headers: {'x-api-key': Config.apiKey});
    if (res.statusCode == 404) throw ApiException('Item not found');
    if (res.statusCode == 401) throw ApiException('Unauthorized (check API key)');
    if (res.statusCode != 200) throw ApiException('Server error ${res.statusCode}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
