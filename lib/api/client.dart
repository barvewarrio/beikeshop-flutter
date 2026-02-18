import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';

class ApiClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('auth_token');
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
        );

  static Dio get instance => _dio;
}
