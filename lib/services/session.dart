import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SessionInterceptor extends Interceptor {
  static const String _tokenKey = "token";
  static const String _tokenExpireAtKey = "token_expire_at";

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final String? token = await getToken();
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  Future<String?> revokeToken() async {
    const storage = FlutterSecureStorage();

    String? token;
    String? clientId = dotenv.env['CLIENT_ID'];
    String? clientSecret = dotenv.env['CLIENT_SECRET'];

    print("Generating token");
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final Map<String, String> body = {
      'grant_type': 'client_credentials',
      'client_id': clientId ?? "",
      'client_secret': clientSecret ?? "",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse("https://api.intra.42.fr/oauth/token"),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await storage.write(key: _tokenKey, value: responseData['access_token']);
        await storage.write(key: _tokenExpireAtKey, value: DateTime.fromMillisecondsSinceEpoch(responseData['secret_valid_until']).toString());
        token = responseData['access_token'];
      } else {
        print('Failed to get token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return token;
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();

    String? value = await storage.read(key: _tokenKey);
    String? createdAt = await storage.read(key: _tokenExpireAtKey);

    if (value == null) {
      return await revokeToken();
    } else {
      DateTime expireAtDateTime = DateTime.parse(createdAt!);

      if (expireAtDateTime.isBefore(DateTime.now())) {
        return await revokeToken();
      }
      return value;
    }
  }

}
