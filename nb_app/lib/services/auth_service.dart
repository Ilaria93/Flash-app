import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nome,
    required String cognome,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ricette/auth/register/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'nome': nome,
          'cognome': cognome,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['error'] ?? 'Errore durante la registrazione');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ricette/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Credenziali non valide');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
