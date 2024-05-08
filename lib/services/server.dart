import 'dart:async';

import 'package:swifty_companion/services/session.dart';
import 'package:dio/dio.dart';


class Server {
  static final Server _instance = Server._(); // Ensure singleton pattern
  late final Dio dio;

  factory Server() {
    return _instance;
  }

  Server._() {
    _init();
  }

  void _init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.intra.42.fr',
        connectTimeout: const Duration(seconds: 10), // 10 seconds
        receiveTimeout: const Duration(seconds: 10), // 10 seconds
        headers: {
          'Content-Type': 'application/json', // Default to JSON
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(SessionInterceptor()); // Session management

    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }

  Future<Response> getRequest(String endpoint) async {
    try {
      return await dio.get(endpoint);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
