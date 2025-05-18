import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/data/models/quote_model.dart';
import 'package:quote_cast_app/data/models/user_model.dart';
import 'package:quote_cast_app/data/models/weather_model.dart';

import '../../core/constants/string_const.dart';
import '../models/api_exception.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
});

class ApiService {
  final Ref ref;
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  static const baseUrl = 'https://j63vr81n-3000.inc1.devtunnels.ms/api';

  ApiService(this.ref) {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken =
            await _storage.read(key: StringConst.accessTokenKey);
        if (accessToken != null && _isProtectedRoute(options.path)) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final retryRequest = error.requestOptions;
            final accessToken =
                await _storage.read(key: StringConst.accessTokenKey);
            retryRequest.headers['Authorization'] = 'Bearer $accessToken';
            final response = await _dio.fetch(retryRequest);
            return handler.resolve(response);
          }
        }
        return handler.next(error);
      },
    ));
  }

  bool _isProtectedRoute(String path) {
    return [
      '/quote',
      '/weather',
      '/generate-text',
    ].any(path.contains);
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final res = await _dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      final data = res.data;
      log("Register response: $data");
      await _storage.write(
          key: StringConst.accessTokenKey, value: data['accessToken']);
      await _storage.write(
        key: StringConst.refreshTokenKey,
        value: data['refreshToken'],
      );
      await _storage.write(
        key: StringConst.userDataKey,
        value: jsonEncode(data['user']),
      );
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = res.data;
      log("Login response: $data");
      await _storage.write(
          key: StringConst.accessTokenKey, value: data['accessToken']);
      await _storage.write(
        key: StringConst.refreshTokenKey,
        value: data['refreshToken'],
      );

      await _storage.write(
        key: StringConst.userDataKey,
        value: jsonEncode(data['user']),
      );
    } on DioException catch (e) {
      log("Login error: ${e.message}");
      throw ApiException(_handleDioError(e));
    } on Exception catch (e, st) {
      log("Error: $e", stackTrace: st);
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken =
          await _storage.read(key: StringConst.refreshTokenKey);
      if (refreshToken == null) return;
      await _dio.post('/auth/logout', data: {
        'refreshToken': refreshToken,
      });
      await _storage.deleteAll();
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.read(key: StringConst.refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final res = await _dio.post('/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });

      await _storage.write(
          key: StringConst.accessTokenKey, value: res.data['accessToken']);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteAll();
      }
      return false;
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<QuoteModel> getQuote() async {
    try {
      final res = await _dio.get('/quote');
      final data = res.data;
      final quoteModel = QuoteModel.fromJson(data);
      return quoteModel;
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<WeatherModel> getWeather(String city) async {
    try {
      final res = await _dio.get('/weather?city=$city');
      final data = res.data;
      log("Weather response: ${data.runtimeType} status: ${res.statusCode} accessToken: ${await _storage.read(key: StringConst.accessTokenKey)}");
      final weatherModel = WeatherModel.fromJson(data);
      return weatherModel;
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<String> getAffirmation(WeatherModel weather, QuoteModel quote) async {
    try {
      final res = await _dio.get('/generate-text', data: {
        "weather": weather.toJson(),
        "quote": "${quote.content} By ${quote.author}",
      });
      return res.data["generatedText"];
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final res = await _dio.get('/get-all-users');
      final data = res.data;
      final List<UserModel> users = [];
      for (var user in data) {
        users.add(UserModel.fromJson(user));
      }
      return users;
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } on Exception catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Connection timed out. Please try again.";
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 400 || statusCode == 401) {
        if (data["message"] case String msg) {
          return msg;
        }
        return "Invalid credentials.";
      } else if (statusCode == 500) {
        return "Server error. Please try again later.";
      } else if (statusCode == 404) {
        return "Resource not found.";
      } else {
        if (data["message"] case String msg) {
          return msg;
        } else {
          return "An unknown error occurred.";
        }
      }
    } else if (e.type == DioExceptionType.unknown) {
      return "No Internet connection.";
    } else {
      log("Dio error: ${e.message} ${e.type} ${e.response?.statusCode}");
      return "An unknown error occurred.";
    }
  }
}
