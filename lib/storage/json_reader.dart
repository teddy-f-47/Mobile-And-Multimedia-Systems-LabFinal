import 'dart:convert';
import 'package:flutter/services.dart';

class JSONReader {
  static Future<List> readFile(String fileName) async {
    final String response = await rootBundle.loadString('assets/' + fileName);
    final data = await json.decode(response);
    return data;
  }
}
