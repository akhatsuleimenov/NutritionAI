// Dart imports:
import 'dart:convert';
import 'dart:io';

import 'package:bites/core/utils/env.dart';
import 'package:http/http.dart' as http;

class FoodvisorService {
  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      final url = Env.foodvisorApiUrl;
      final headers = {"Authorization": "Api-Key ${Env.foodvisorApiKey}"};

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        throw FoodvisorException(
            'Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class FoodvisorException implements Exception {
  final String message;
  FoodvisorException(this.message);
  @override
  String toString() => message;
}
