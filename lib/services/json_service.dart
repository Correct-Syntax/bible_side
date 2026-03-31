import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';

const String basePath = 'assets/bibles';

class JsonService {
  Set<String>? _availableAssets;

  Future<void> _ensureManifestLoaded() async {
    if (_availableAssets != null) return;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _availableAssets = manifest.listAssets().toSet();
    } catch (e) {
      try {
        final manifestJson = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestJson);
        _availableAssets = manifestMap.keys.toSet();
      } catch (e) {
        _availableAssets = {};
      }
    }
  }

  Future<bool> bookExists(String bibleCode, String bookCode) async {
    await _ensureManifestLoaded();
    final path = '$basePath/$bibleCode/$bookCode.json';
    return _availableAssets!.contains(path);
  }

  Future<Map<String, dynamic>> loadBookJson(
      String bibleCode, String bookCode) async {
    return loadJsonFromAssets('$basePath/$bibleCode/$bookCode.json');
  }

  Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final String data = await rootBundle.loadString(path);
    return await Isolate.run<Map<String, dynamic>>(() {
      return json.decode(data);
    });
  }
}
