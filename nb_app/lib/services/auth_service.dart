import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.105:8001';

  // Variabili temporanee in memoria (senza persistenza per ora)
  static String? _currentToken;
  static Map<String, dynamic>? _currentUser;

  // Salva token e dati utente in memoria
  static void _saveAuthData(String token, Map<String, dynamic> userData) {
    _currentToken = token;
    _currentUser = userData;
  }

  // Recupera token salvato
  static Future<String?> getToken() async {
    return _currentToken;
  }

  // Recupera dati utente salvati
  static Future<Map<String, dynamic>?> getUserData() async {
    return _currentUser;
  }

  // Verifica se l'utente è loggato
  static Future<bool> isLoggedIn() async {
    return _currentToken != null && _currentToken!.isNotEmpty;
  }

  // Logout - rimuove token e dati utente
  static Future<void> logout() async {
    _currentToken = null;
    _currentUser = null;
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nome,
    required String cognome,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register/'),
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
        final result = json.decode(response.body);
        // Salva token e dati utente
        if (result['token'] != null && result['user'] != null) {
          _saveAuthData(result['token'], result['user']);
        }
        return result;
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
        Uri.parse('$baseUrl/api/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Salva token e dati utente
        if (result['token'] != null && result['user'] != null) {
          _saveAuthData(result['token'], result['user']);
        }
        return result;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Credenziali non valide');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
