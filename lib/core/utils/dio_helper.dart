import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static String baseUrl = "http://172.16.1.138:9300/api/";
  static void init() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        }
    ),
    );
    /*(dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;*/
  }

  static Future<Response> getData(
      {required url, Map<String, dynamic>? query, Options? options}) async {
    return await dio.get(url, queryParameters: query, options: options);
  }

  static Future<Response> postData(
      {required url, Map<String, dynamic>? query, dynamic data, Options? options}) async {
    return await dio.post(url, queryParameters: query, data: data, options: options);
  }

  static Future<Response> updateData(
      {required url, required Map<String, dynamic> query}) async {
    return await dio.put(url, queryParameters: query);
  }

  static Future<Response> deleteData(
      {required url, Map<String, dynamic>? query, dynamic data, Options? options}) async {
    return await dio.delete(url, queryParameters: query, data: data, options: options);
  }
}
