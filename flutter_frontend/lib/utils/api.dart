import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum Method { get, post, delete }

class ApiRoute {
  static const String baseUrl = 'http://192.168.29.111:3001/api/';
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
      print(url);
    }
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      final resJson = jsonDecode(response.body);
      if (kDebugMode) {
        print(resJson);
      }
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } catch (e) {
      return ApiResponse(
          statusCode: e is HttpResponse ? e.statusCode : 500,
          response: e.toString());
    }
  }

  Future<ApiResponse> postReq(
      {required String url, required Map<String, dynamic> body}) async {
    if (kDebugMode) {
      print(url);
    }
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      final resJson = jsonDecode(response.body);
      if (kDebugMode) {
        print(resJson);
      }
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } catch (e) {
      return ApiResponse(
          statusCode: e is HttpResponse ? e.statusCode : 500,
          response: e.toString());
    }
  }

  Future<ApiResponse> deleteReq({required String url}) async {
    if (kDebugMode) {
      print(url);
    }
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      final resJson = jsonDecode(response.body);
      if (kDebugMode) {
        print(resJson);
      }
      return ApiResponse(statusCode: response.statusCode, response: resJson);
    } catch (e) {
      return ApiResponse(
          statusCode: e is HttpResponse ? e.statusCode : 500,
          response: e.toString());
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
