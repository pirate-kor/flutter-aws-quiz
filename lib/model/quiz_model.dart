class Quiz {
   String _question = '';
   List<String> _candidates = List.empty();
   List<String> _answers = List.empty();

  Quiz.fromJson(dynamic json) {
    if (json['question'] != null) {
      print(json['question']);
    }
    _question = json['question'];
    _candidates =
        json['candidates'] != null ? json['candidates'].cast<String>() : [];
    _answers = json['answer'] != null ? json['answer'].cast<String>() : [];
  }

  String get question => _question;

  List<String> get candidates => _candidates;

  List<int> get answers => _answers.map((e) => int.parse(e)).toList();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = _question;
    map['candidates'] = _candidates;
    map['answer'] = _answers;
    return map;
  }
}

