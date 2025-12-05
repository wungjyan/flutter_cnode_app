import 'package:dio/dio.dart';
import 'package:flutter_cnode_app/constants/index.dart';

class HttpUtils {
  final Dio _dio = Dio();

  HttpUtils() {
    _dio.options
      ..baseUrl = HttpConstants.baseUrl
      ..connectTimeout = Duration(seconds: 5)
      ..sendTimeout = Duration(seconds: 5)
      ..receiveTimeout = Duration(seconds: 5);

    _addInterceptor();
  }

  _addInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            return handler.next(response);
          }
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              message: response.data["msg"] ?? '',
            ),
          );
        },
        onError: (e, handler) {
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              message: e.response?.data["msg"] ?? '',
            ),
          );
        },
      ),
    );
  }

  get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response<dynamic> response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      return e.toString();
    }
  }
}

final HttpUtils requestUtil = HttpUtils();
