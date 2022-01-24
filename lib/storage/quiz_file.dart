import 'package:flutter/services.dart';

class FileStorage {
  Future<String> read(String type) async {
    return await rootBundle.loadString('assets/questions/$type.json');
  }
}
