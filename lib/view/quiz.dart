import 'package:awsweb/model/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AwsQuizView extends StatefulWidget {
  List<Quiz> quizzes;

  AwsQuizView({Key? key, required this.quizzes}) : super(key: key);

  @override
  _AwsQuizViewState createState() => _AwsQuizViewState();
}

class _AwsQuizViewState extends State<AwsQuizView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'AWS Quiz',
            style: TextStyle(fontFamily: 'JuaRegular', fontSize: 30.0),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
            child: Swiper(
          loop: false,
          itemCount: widget.quizzes.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildQuizCard(widget.quizzes[index]);
          },
        )));
  }

  Widget _buildQuizCard(Quiz quiz) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.indigo, width: 2.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quiz.question,
                style:
                    const TextStyle(fontSize: 30.0, fontFamily: 'JuaRegular'),
              ),
            ),
            Column(
              children: _buildCandidates(quiz.candidates, quiz.answers),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCandidates(List<String> candidates, List<int> answers) {
//    List<Widget> _children = [];
    List<Color> _candidatesStatus = [];
    List<Widget> listButtons = List.generate(candidates.length, (index) {
      _candidatesStatus.add(Colors.black);
      return Container(
        width: double.maxFinite,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            if (answers.contains(index + 1)) {
              showToast('정답입니다', Colors.blueAccent);
              _candidatesStatus[index] = Colors.blueAccent;
            } else {
              showToast('틀렸습니다', Colors.redAccent);
              _candidatesStatus[index] = Colors.redAccent;
            }
          },
          child: Container(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              candidates[index],
              style: const TextStyle(
                  fontFamily: 'JuaRegular', color: Colors.white, fontSize: 20.0),
            ),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return _candidatesStatus[index];
            }),
          ),
        ),
      );
    });
    return listButtons;
  }
}

void showToast(String message, Color color) {
  Fluttertoast.showToast(
      webPosition: "center",
      webBgColor: "black",
      timeInSecForIosWeb: 1,
      msg: message,
      backgroundColor: color,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM);
}
