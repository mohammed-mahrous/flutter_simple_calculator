import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

List<Widget> history = [];
var userInput = '';
var answer = '';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Homestate();
}

class _Homestate extends State<Home> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(bottom: 20, left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: history,
                        ),
                        Text(
                          userInput,
                          style: TextStyle(color: Colors.white, fontSize: 60),
                          maxLines: 3,
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          answer,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 30),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myContainer(buttonText: 'AC'),
                  myContainer(buttonText: 'C'),
                  myContainer(buttonText: '%'),
                  myContainer(buttonText: '/'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myContainer(buttonText: '9'),
                  myContainer(buttonText: '8'),
                  myContainer(buttonText: '7'),
                  myContainer(buttonText: 'x'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myContainer(buttonText: '6'),
                  myContainer(buttonText: '5'),
                  myContainer(buttonText: '4'),
                  myContainer(buttonText: '-'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myContainer(buttonText: '3'),
                  myContainer(buttonText: '2'),
                  myContainer(buttonText: '1'),
                  myContainer(buttonText: '+'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myContainer(buttonText: '0'),
                  myContainer(buttonText: '.'),
                  myContainer(buttonText: '='),
                ],
              ),
            ],
          ),
        ),
      );

  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.round().toString();
    generatehistoryWidgets(userInput + ' = ' + answer);
    userInput = answer;
  }

  void generatehistoryWidgets(String text) {
    if (history.length == 5) {
      history.removeAt(0);
    }
    Widget newText = Text(
      text,
      style: TextStyle(color: Colors.grey[700], fontSize: 20),
      maxLines: 1,
      textAlign: TextAlign.right,
    );
    history.add(newText);
  }

  Widget myContainer({required String buttonText}) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(top: 2),
      child: builder(buttonText),
    );
  }

  Widget builder(txtbtn) {
    if (txtbtn == 'AC') {
      return MyButton(
        buttontapped: () {
          setState(() {
            userInput = '';
            answer = '0';
            history.clear();
          });
        },
        buttonText: txtbtn,
        color: Colors.grey[600],
        textColor: Colors.white,
      );
    }

    // +/- button
    else if (txtbtn == '+/-') {
      return MyButton(
        buttonText: txtbtn,
        color: Colors.grey[600],
        textColor: Colors.white,
      );
    }
    // % Button
    else if (txtbtn == '%') {
      return MyButton(
        buttontapped: () {
          setState(() {
            userInput += txtbtn;
          });
        },
        buttonText: txtbtn,
        color: Colors.grey[600],
        textColor: Colors.white,
      );
    }
    // Delete Button
    else if (txtbtn == 'C') {
      return MyButton(
        buttontapped: () {
          setState(() {
            userInput = userInput.substring(0, userInput.length - 1);
          });
        },
        buttonText: txtbtn,
        color: Colors.grey[600],
        textColor: Colors.white,
      );
    }
    // Equal_to Button
    else if (txtbtn == '=') {
      return MyButton(
        buttontapped: () {
          setState(() {
            equalPressed();
          });
        },
        buttonText: txtbtn,
        color: Colors.orange[700],
        textColor: Colors.white,
      );
    } else if (txtbtn == '0') {
      return MyButton(
        buttontapped: () {
          setState(() {
            userInput += txtbtn;
          });
        },
        buttonText: txtbtn,
        width: 130,
        color: Colors.grey,
        textColor: Colors.black,
      );
    }

    // other buttons
    else {
      return MyButton(
        buttontapped: () {
          if (isOperator(txtbtn)) {
            var b = userInput.split(RegExp(r"[\\+-x\\/*]"));
            debugPrint((b).toString());
            if (b.length >= 2) {
              String finaluserinput = userInput;
              finaluserinput = userInput.replaceAll('x', '*');

              Parser p = Parser();
              Expression exp = p.parse(finaluserinput);
              ContextModel cm = ContextModel();
              double eval = exp.evaluate(EvaluationType.REAL, cm);
              answer = eval.round().toString();
              debugPrint(answer);
            }
          }

          setState(() {
            userInput += txtbtn;
          });
        },
        buttonText: txtbtn,
        color: isOperator(txtbtn) ? Colors.orange[700] : Colors.grey,
        textColor: isOperator(txtbtn) ? Colors.white : Colors.black,
      );
    }
  }

  bool isOperator(txtbtn) {
    if (txtbtn == '+' || txtbtn == '-' || txtbtn == 'x' || txtbtn == '/') {
      return true;
    }
    return false;
  }
}

class MyButton extends StatelessWidget {
  // declaring variables
  final color;
  final textColor;
  final buttonText;
  final buttontapped;
  final double? width;
  final double? height;

  //Constructor
  MyButton(
      {this.color,
      this.width,
      this.height,
      this.textColor,
      this.buttonText,
      this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: width ?? 50,
            height: height ?? 50,
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
