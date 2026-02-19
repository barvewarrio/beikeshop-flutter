import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';

class ApiClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Accept-Language': 'zh-CN',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('auth_token');
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
            onResponse: (response, handler) {
              debugPrint(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
              );
              return handler.next(response);
            },
            onError: (DioException e, handler) {
              debugPrint(
                'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
              );
              return handler.next(e);
            },
          ),
        );

  static Dio get instance => _dio;
}
