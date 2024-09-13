import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiRoute {
  static const String baseUrl = 'http://192.168.29.111:3000/api/';

  // if you are using emulator or physical device, use the below baseUrl
  // static const String baseUrl = 'http://your_ip_address:3000/api/';

  static const String item = 'items';
}

class ApiResponse {
  final int statusCode;
  final dynamic response;

  ApiResponse({required this.statusCode, required this.response});
}

class ApiCall {
  Future<ApiResponse> getReq({required String url}) async {
    if (kDebugMode) {
      print('Requesting GET: $url');
    }
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 10));

      final resJson = jsonDecode(response.body);
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } on SocketException {
      return ApiResponse(statusCode: 503, response: {
        "message": "No internet connection. Please check your network."
      });
    } on TimeoutException {
      return ApiResponse(
          statusCode: 408,
          response: {"message": "Request timed out. Please try again later."});
    } on HttpException {
      return ApiResponse(statusCode: 404, response: {
        "message":
            "Could not reach the server. Please check your URL or server status."
      });
    } catch (e) {
      return ApiResponse(
          statusCode: 500,
          response: {"message": "Something went wrong: ${e.toString()}"});
    }
  }

  Future<ApiResponse> postReq(
      {required String url, required Map<String, dynamic> body}) async {
    if (kDebugMode) {
      print('Requesting POST: $url');
    }
    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      final resJson = jsonDecode(response.body);
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } on SocketException {
      return ApiResponse(statusCode: 503, response: {
        "message": "No internet connection. Please check your network."
      });
    } on TimeoutException {
      return ApiResponse(
          statusCode: 408,
          response: {"message": "Request timed out. Please try again later."});
    } on HttpException {
      return ApiResponse(statusCode: 404, response: {
        "message":
            "Could not reach the server. Please check your URL or server status."
      });
    } catch (e) {
      return ApiResponse(
          statusCode: 500,
          response: {"message": "Something went wrong: ${e.toString()}"});
    }
  }

  Future<ApiResponse> deleteReq({required String url}) async {
    if (kDebugMode) {
      print('Requesting DELETE: $url');
    }
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 10));

      final resJson = jsonDecode(response.body);
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } on SocketException {
      return ApiResponse(statusCode: 503, response: {
        "message": "No internet connection. Please check your network."
      });
    } on TimeoutException {
      return ApiResponse(
          statusCode: 408,
          response: {"message": "Request timed out. Please try again later."});
    } on HttpException {
      return ApiResponse(statusCode: 404, response: {
        "message":
            "Could not reach the server. Please check your URL or server status."
      });
    } catch (e) {
      return ApiResponse(
          statusCode: 500,
          response: {"message": "Something went wrong: ${e.toString()}"});
    }
  }

  Future<ApiResponse> getItems() async {
    const url = '${ApiRoute.baseUrl}${ApiRoute.item}';
    final response = await ApiCall().getReq(url: url);
    return response;
  }

  Future<ApiResponse> addItem({required Map<String, dynamic> body}) async {
    const url = '${ApiRoute.baseUrl}${ApiRoute.item}';
    final response = await ApiCall().postReq(url: url, body: body);
    return response;
  }

  Future<ApiResponse> deleteItem({required int itemId}) async {
    final url = '${ApiRoute.baseUrl}${ApiRoute.item}/$itemId';
    final response = await ApiCall().deleteReq(url: url);
    return response;
  }
}
