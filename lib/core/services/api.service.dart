import 'dart:io';

import 'package:dio/dio.dart';

class ApiServices {
  final Dio _dio;

  ApiServices(this._dio) {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      // connectTimeout: const Duration(seconds: 10),
      // receiveTimeout: const Duration(seconds: 7),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
    );
    // dio.interceptors.clear(); // Clear any existing interceptors
    // dio.interceptors.add(LogInterceptor()); // Add interceptors if needed
  }

  Future<Map<String, dynamic>> postData(
    String url,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      _dio.options.headers.remove("Authorization");
    }
    var response = await _dio.post(url, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> getData(
    String url, {
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      _dio.options.headers.remove("Authorization");
    }
    var response = await _dio.get(url);
    return response.data;
  }

  Future<Map<String, dynamic>> postWithImage(
    String url,
    Map<String, dynamic> data,
    File image, {
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      _dio.options.headers.remove("Authorization");
    }

    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      ...data,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
    });

    var response = await _dio.post(url, data: formData);
    return response.data;
  }
}
