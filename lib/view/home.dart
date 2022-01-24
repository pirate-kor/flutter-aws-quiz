import 'dart:math';

import 'package:awsweb/adapter/adapter.dart';
import 'package:awsweb/model/quiz_model.dart';
import 'package:awsweb/storage/quiz_file.dart';
import 'package:awsweb/view/quiz.dart';
import 'package:flutter/material.dart';

class AwsHomeView extends StatefulWidget {
  const AwsHomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AwsHomeViewState();
  }
}

class _AwsHomeViewState extends State<AwsHomeView> {
  List<Quiz> quiz = [];
  Map<String, List<Quiz>> quizzes = {};
  String _type = 'concept';
  FileStorage fileStorage = FileStorage();

  @override
  void initState() {
    super.initState();
    _getQuizzes();
  }

//  _getQuiz() async {
//    var url = Uri.http('localhost:8080', '/quiz');
//    final response = await http.get(url);
//    if (response.statusCode == 200) {
//      setState(() {
//        quiz = parse(utf8.decode(response.bodyBytes));
//      });
//    }
//  }
  _getQuiz() async {
    quiz = quizzes[_type] ?? List.empty();
    if (quiz.isEmpty) {
      var future = fileStorage.read(_type);
      future.whenComplete(() =>
          future.then((value) => quiz = parse(value))
      );
    }
  }

  _getQuizzes() async {
    _getDropdownItems().forEach((element) {
      var future = fileStorage.read(element.value!);
      future.whenComplete(() =>
        future.then((value) => quizzes[element.value!] = parse(value))
      );
    });
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    return [
      const DropdownMenuItem(
        child: Text('개념문제'),
        value: 'concept',
      ),
      const DropdownMenuItem(
        child: Text('책 속 예제문제'),
        value: 'example',
      ),
      const DropdownMenuItem(
        child: Text('실전문제'),
        value: 'dump',
      ),
    ];
  }

  List<Quiz> generateQuiz() {
    Set<Quiz> quizSets = {};
    while (quizSets.length < 10) {
      quizSets.add(quiz[Random().nextInt(quiz.length)]);
    }

    return quizSets.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'AWS Quiz',
          style: TextStyle(fontFamily: 'JuaRegular', fontSize: 30.0),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                height: max(700, constraints.maxHeight)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/images/SA02.png',
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 3,
                        ),
                        color: Colors.white),
                    child: DropdownButton(
                      value: _type,
                      items: _getDropdownItems(),
                      style: const TextStyle(
                        fontFamily: 'JuaRegular',
                        fontSize: 18.0,
                      ),
                      isDense: true,
                      isExpanded: true,
                      onChanged: (String? value) {
                        setState(() {
                          _type = value!;
                          _getQuiz();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text(
                              '문제 풀기 !!',
                              style: TextStyle(
                                fontFamily: 'JuaRegular',
                                fontSize: 20.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.indigo,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      content: Row(
                                        children: const [
                                          CircularProgressIndicator(),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          Text('문제 생성 중..'),
                                        ],
                                      )));
                              _getQuiz().whenComplete(() {
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AwsQuizView(
                                              quizzes: generateQuiz(),
                                            )));
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
