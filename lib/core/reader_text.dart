import 'dart:convert';
import 'package:flutter/services.dart';


class ReaderText {
  ReaderText(this.bibleCode, this.versionCode, this.bookCode);

  String bibleCode;
  String versionCode;
  String bookCode;


  void setBibleCode(String code) {
    bibleCode = bibleCode;
  }

  void setVersionCode(String code) {
    versionCode = versionCode;
  }

  void setBookCode(String code) {
    bookCode = bookCode;
  }


  Future<Map<String, dynamic>> loadJson() async {
    String path = 'assets/$bibleCode/$versionCode/$bookCode.json';
    return await loadJsonFromPath(path);
  }


  Future<Map<String, dynamic>> loadJsonFromPath(String path) async {
    final String data = await rootBundle.loadString(path);
    return json.decode(data);
  }


}
