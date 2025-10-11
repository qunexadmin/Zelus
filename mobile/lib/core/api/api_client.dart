import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// API Base URL - change this to your backend URL
const String kApiBaseUrl = 'http://localhost:8000/api/v1';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: kApiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors for logging and auth
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: Add auth token from storage
        // final token = ref.read(authTokenProvider);
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
        return handler.next(error);
      },
    ),
  );

  return dio;
});

