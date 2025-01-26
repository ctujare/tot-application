import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tot_app/models/dog_model.dart';

import '../utils/api_exception.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Dog>> fetchDogs() async {
    try {
      Uri url = Uri.parse('$baseUrl/dogs');
      log("$url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dog) => Dog.fromJson(dog)).toList();
      } else {
        throw ApiException("An error occurred: ${response.statusCode}");
      }
    } catch (e) {
      throw ApiException("An error occurred $e");
    }
  }
}
