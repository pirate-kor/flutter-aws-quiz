import 'dart:convert';

import 'package:awsweb/model/quiz_model.dart';

List<Quiz> parse(String responseBody) {
  List<dynamic> list = jsonDecode(responseBody);

  return list.map((e) => Quiz.fromJson(e)).toList();
}