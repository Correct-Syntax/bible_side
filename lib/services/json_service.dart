import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';

const String basePath = 'assets/bibles';

class JsonService {
  Future<Map<String, dynamic>> loadBookJson(String bibleCode, String bookCode) async {
    return loadJsonFromAssets('$basePath/$bibleCode/$bookCode.json');
  }

  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final String data = await rootBundle.loadString(path);
    return await Isolate.run<Map<String, dynamic>>(() {
      return json.decode(data);
    });
  }
}
